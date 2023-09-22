import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_project/models/journal.dart';
import 'package:journal_project/models/journal_dto.dart';
import 'package:journal_project/providers/journal_provider.dart';
import 'package:journal_project/services/sql_helper.dart';
import 'package:provider/provider.dart';

class CreateOrUpdatePage extends StatefulWidget {
  final Journal? journal;
  const CreateOrUpdatePage({Key? key, required this.journal}) : super(key: key);

  @override
  CreateOrUpdatePageState createState() => CreateOrUpdatePageState();
}

class CreateOrUpdatePageState extends State<CreateOrUpdatePage> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Insert a new journal to the database
  Future<void> _addEntry() async {
    await SQLHelper.createEntry(JournalDTO(
        title: _titleController.text,
        mood: _moodController.text,
        description: _descriptionController.text));
    await Provider.of<JournalProvider>(context, listen: false).getAllJournals();
  }

  // Update an existing journal
  Future<void> _updateEntry(int id) async {
    await SQLHelper.updateEntry(
        id,
        JournalDTO(
            title: _titleController.text,
            mood: _moodController.text,
            description: _descriptionController.text));
    await Provider.of<JournalProvider>(context, listen: false).getAllJournals();
  }

  @override
  Widget build(BuildContext context) {
    int? id;
    if (widget.journal != null) {
      id = widget.journal!.id;
      _titleController.text = widget.journal!.title;
      _moodController.text = widget.journal!.mood;
      _descriptionController.text = widget.journal!.description;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Journal App'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _moodController,
              decoration: const InputDecoration(hintText: 'Mood'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Save new journal
                if (id == null) {
                  await _addEntry();
                }

                if (id != null) {
                  await _updateEntry(id);
                }

                // Clear the text fields
                _titleController.text = '';
                _moodController.text = '';
                _descriptionController.text = '';

                // Close the bottom sheet
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                GoRouter.of(context).pop();
                // _refreshJournals();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ));
  }
}
