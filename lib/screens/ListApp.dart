import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _noteController = TextEditingController();
  String? _editingNoteId;
  bool _isLoading = false;
  bool _showNoteForm = false;

  Future<void> _saveNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      if (_editingNoteId != null) {
        // Update note
        await _firestore
            .collection('notes')
            .doc(_editingNoteId)
            .update({'content': text});
      } else {
        // Add new note
        await _firestore.collection('notes').add({
          'content': text,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      _noteController.clear();
      _editingNoteId = null;
      _showNoteForm = false; // Hide form after saving
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startEdit(String id, String content) {
    setState(() {
      _noteController.text = content;
      _editingNoteId = id;
      _showNoteForm = true; // Show form when editing
    });
  }

  Future<void> _deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // You might want to navigate to login screen after logout
      Navigator.of(context).pushNamed("/login");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Logout failed: $e")));
    }
  }

  void _toggleNoteForm() {
    setState(() {
      _showNoteForm = !_showNoteForm;
      if (!_showNoteForm) {
        _noteController.clear();
        _editingNoteId = null;
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesRef =
        _firestore.collection('notes').orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ← This removes the left arrow
        title: const Text('Notes Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Input field (only visible when _showNoteForm is true)
          if (_showNoteForm)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: 'Write a note...',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveNote,
                    child: Text(_editingNoteId != null ? 'Update' : 'Save'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showNoteForm = false;
                        _noteController.clear();
                        _editingNoteId = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          if (_showNoteForm) const Divider(),

          // Notes list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: notesRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notes = snapshot.data?.docs ?? [];

                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.note_add, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Nothing here yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the "+" button to add your first note',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final doc = notes[index];
                    final noteId = doc.id;
                    final content = doc['content'] ?? '';

                    return ListTile(
                      title: Text(content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _startEdit(noteId, content),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(noteId),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleNoteForm,
        child: Icon(_showNoteForm ? Icons.close : Icons.add),
      ),
    );
  }
}