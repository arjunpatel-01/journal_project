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
  String _dropdownValue = "Okay"; //necessary initializer
  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.journal == null ? "Okay" : widget.journal!.mood;
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void dropdownCallback(String? value) {
    if (value is String) {
      setState(() {
        _dropdownValue = value;
      });
    }
  }

  // Insert a new journal to the database
  Future<void> _addEntry() async {
    await SQLHelper.createEntry(JournalDTO(
        title: _titleController.text,
        mood: _dropdownValue,
        description: _descriptionController.text));
    await Provider.of<JournalProvider>(context, listen: false).getAllJournals();
  }

  // Update an existing journal
  Future<void> _updateEntry(int id) async {
    await SQLHelper.updateEntry(
        id,
        JournalDTO(
            title: _titleController.text,
            mood: _dropdownValue,
            description: _descriptionController.text));
    await Provider.of<JournalProvider>(context, listen: false).getAllJournals();
  }

  final moods = const [
    DropdownMenuItem(value: "Awesome", child: Text("Awesome")),
    DropdownMenuItem(value: "Good", child: Text("Good")),
    DropdownMenuItem(value: "Okay", child: Text("Okay")),
    DropdownMenuItem(value: "Bad", child: Text("Bad")),
    DropdownMenuItem(value: "Terrible", child: Text("Terrible")),
  ];

  @override
  Widget build(BuildContext context) {
    int? id;
    if (widget.journal != null) {
      id = widget.journal!.id;
      _titleController.text = widget.journal!.title;
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
            DropdownButton(
              items: const [
                DropdownMenuItem(value: "Awesome", child: Text("Awesome")),
                DropdownMenuItem(value: "Good", child: Text("Good")),
                DropdownMenuItem(value: "Okay", child: Text("Okay")),
                DropdownMenuItem(value: "Bad", child: Text("Bad")),
                DropdownMenuItem(value: "Terrible", child: Text("Terrible")),
              ],
              value: _dropdownValue,
              onChanged: dropdownCallback,
              isExpanded: true,
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
                if (id == null) {
                  await _addEntry();
                }

                if (id != null) {
                  await _updateEntry(id);
                }

                // Return to previous page
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                GoRouter.of(context).pop('update');
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ));
  }
}
