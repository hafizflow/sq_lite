import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.description),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
