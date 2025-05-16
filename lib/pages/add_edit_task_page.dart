import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  String priority = 'Medium';
  String status = 'In Progress';
  final List<String> tags = ['On Track', 'At Risk', 'Meeting'];

  final List<String> priorities = ['Low', 'Medium', 'High'];
  final List<String> statuses = ['In Progress', 'In Review', 'On Hold', 'Completed'];
  List<String> selectedTags = [];


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController = TextEditingController(text: widget.task?.description ?? '');
    dateController = TextEditingController(text: widget.task?.date ?? '');
    priority = widget.task?.priority ?? 'Medium';
    status = widget.task?.status ?? 'In Progress';
    selectedTags = widget.task?.tags ?? [];
  }

  void saveTask() {
  if (_formKey.currentState?.validate() ?? false) {
    final newTask = Task(
      id: widget.task?.id, // Preserve ID if editing
      title: titleController.text,
      description: descriptionController.text,
      date: dateController.text,
      priority: priority,
      tags: selectedTags,
      status: status,
      createdAt: widget.task?.createdAt, // Preserve creation date
    );

    Navigator.pop(context, newTask);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    dateController.text = date.toIso8601String().substring(0, 10);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: priority,
                items: priorities.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (value) => setState(() => priority = value!),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) => setState(() => status = value!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 16),
              const Text('Tags:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: tags.map((tag) {
                  final selected = selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveTask,
                child: const Text('Save Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
