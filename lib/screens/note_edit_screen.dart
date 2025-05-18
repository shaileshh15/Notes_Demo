
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  final int? index;
  const NoteEditScreen({super.key, this.note, this.index});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          isEditing ? 'Edit Note' : 'New Note',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt, color: Theme.of(context).colorScheme.primary),
            tooltip: 'Save',
            onPressed: _saveNote,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.07),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        prefixIcon: const Icon(Icons.title),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Title required' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _contentController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Content',
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.07),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        prefixIcon: const Icon(Icons.notes),
                      ),
                      maxLines: 8,
                      minLines: 5,
                      validator: (val) => val == null || val.trim().isEmpty ? 'Content required' : null,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(isEditing ? 'Save Changes' : 'Add Note'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _saveNote,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      if (widget.note == null) {
        await notesProvider.addNote(note);
      } else {
        await notesProvider.updateNote(widget.index!, note);
      }
      if (mounted) Navigator.pop(context);
    }
  }
}
