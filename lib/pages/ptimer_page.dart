import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PomodoroTimerPage extends StatelessWidget {
  const PomodoroTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PomodoroTimer(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pomodoro Timer')),
        body: const PomodoroTimerWidget(),
      ),
    );
  }
}

class PomodoroTimerWidget extends StatelessWidget {
  const PomodoroTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<PomodoroTimer>(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Timer display
          Text(
            timer.timeLeft,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Timer status
          Text(
            timer.isWorkTime ? 'Work Time' : 'Break Time',
            style: TextStyle(
              fontSize: 24,
              color: timer.isWorkTime ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          // Session count
          Text(
            'Session: ${timer.sessionCount}/4',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 40),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!timer.isRunning)
                ElevatedButton(
                  onPressed: timer.startTimer,
                  child: const Text('Start')),
              if (timer.isRunning)
                ElevatedButton(
                  onPressed: timer.pauseTimer,
                  child: const Text('Pause')),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: timer.resetTimer,
                child: const Text('Reset')),
            ],
          ),
        ],
      ),
    );
  }
}

class PomodoroTimer with ChangeNotifier {
  // Timer settings (in seconds)
  static const int workDuration = 25 * 60; // 25 minutes
  static const int shortBreakDuration = 5 * 60; // 5 minutes
  static const int longBreakDuration = 15 * 60; // 15 minutes
  static const int sessionsBeforeLongBreak = 4;

  // Timer state
  int _secondsLeft = workDuration;
  bool _isRunning = false;
  bool _isWorkTime = true;
  int _sessionCount = 0;
  late Timer _timer;

  String get timeLeft {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get isRunning => _isRunning;
  bool get isWorkTime => _isWorkTime;
  int get sessionCount => _sessionCount;

  void startTimer() {
    if (_isRunning) return;
    
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsLeft--;
      
      if (_secondsLeft <= 0) {
        _timer.cancel();
        _switchPeriod();
      }
      
      notifyListeners();
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer.cancel();
    _isRunning = false;
    _isWorkTime = true;
    _sessionCount = 0;
    _secondsLeft = workDuration;
    notifyListeners();
  }

  void _switchPeriod() {
    if (_isWorkTime) {
      // Work period just ended
      _sessionCount++;
      
      // Determine break duration
      final isLongBreak = _sessionCount % sessionsBeforeLongBreak == 0;
      _secondsLeft = isLongBreak ? longBreakDuration : shortBreakDuration;
    } else {
      // Break period ended, back to work
      _secondsLeft = workDuration;
    }
    
    _isWorkTime = !_isWorkTime;
    _isRunning = false;
    notifyListeners();
    
    // Auto-start next period if not the last session
    if (_sessionCount < sessionsBeforeLongBreak * 2) {
      Future.delayed(const Duration(seconds: 1), startTimer);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}