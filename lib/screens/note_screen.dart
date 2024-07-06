import 'package:flutter/material.dart';
import 'package:sq_lite/services/database_helper.dart';

import '../models/note_model.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({
    super.key,
    this.note,
  });

  final Note? note;

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final description = TextEditingController();

    if (note != null) {
      title.text = note!.title;
      description.text = note!.description;
    }

    return Scaffold(
      appBar: AppBar(title: Text(note == null ? 'Add Note' : 'Edit Note')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                label: Text('Title'),
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: description,
              decoration: const InputDecoration(
                label: Text('Description'),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final t = title.text.trim();
                  final d = description.text.trim();

                  final Note model = Note(
                    title: t,
                    description: d,
                    id: note?.id,
                  );

                  if (t.isEmpty || d.isEmpty) return;

                  if (note == null) {
                    await DatabaseHelper.addNote(model);
                  } else {
                    await DatabaseHelper.updateNote(model);
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(note == null ? 'Save' : 'Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
