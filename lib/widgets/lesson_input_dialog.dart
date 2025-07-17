import 'package:flutter/material.dart';

class LessonInputDialog extends StatefulWidget {
  final void Function(int lessonId) onSubmit;

  const LessonInputDialog({super.key, required this.onSubmit});

  @override
  State<LessonInputDialog> createState() => _LessonInputDialogState();
}

class _LessonInputDialogState extends State<LessonInputDialog> {
  final _controller = TextEditingController();
  String? _error;

  void _handleSubmit() {
    final input = _controller.text.trim();
    final id = int.tryParse(input);
    if (id == null) {
      setState(() => _error = "Please enter a valid numeric ID.");
    } else {
      widget.onSubmit(id);
      Navigator.of(context).pop(); // Close dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Lesson by ID"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Lesson ID",
          errorText: _error,
        ),
        onSubmitted: (_) => _handleSubmit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text("Add"),
        ),
      ],
    );
  }
}
