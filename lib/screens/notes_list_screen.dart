

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/note_tile.dart';
import 'note_edit_screen.dart';
import 'pin_login_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: themeProvider.isDark
              ? [Colors.grey[900]!, Colors.grey[850]!]
              : [Colors.blue[100]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Icon(Icons.sticky_note_2, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                'My Notes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => themeProvider.toggleTheme(),
              tooltip: 'Toggle theme',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout?'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const PinLoginScreen()),
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: notesProvider.notes.isEmpty
            ? _buildEmptyState(context)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: ListView.separated(
                  itemCount: notesProvider.notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _AnimatedNoteCard(
                    child: NoteTile(
                      note: notesProvider.notes[i],
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteEditScreen(
                            note: notesProvider.notes[i],
                            index: i,
                          ),
                        ),
                      ),
                      onDelete: () => _showDeleteConfirmation(context, notesProvider, i),
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditScreen()),
          ),
          icon: const Icon(Icons.add),
          label: const Text('New Note'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 90, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No notes yet!',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the "+" button to add your first note.',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, NotesProvider notesProvider, int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Delete Note?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Text('Are you sure you want to delete this note?'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      notesProvider.deleteNote(index);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AnimatedNoteCard extends StatelessWidget {
  final Widget child;
  const _AnimatedNoteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 350),
      tween: Tween(begin: 0.9, end: 1),
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: child,
      ),
      child: child,
    );
  }
}
