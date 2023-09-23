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
    if (!context.mounted) return;
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
    if (!context.mounted) return;
    await Provider.of<JournalProvider>(context, listen: false).getAllJournals();
  }

  final moods = const [
    DropdownMenuItem(
        value: "Awesome",
        child: Text("Awesome", style: TextStyle(color: Colors.green))),
    DropdownMenuItem(
        value: "Good",
        child: Text("Good", style: TextStyle(color: Colors.teal))),
    DropdownMenuItem(
        value: "Okay",
        child: Text("Okay", style: TextStyle(color: Colors.brown))),
    DropdownMenuItem(
        value: "Bad",
        child: Text("Bad", style: TextStyle(color: Colors.orange))),
    DropdownMenuItem(
        value: "Terrible",
        child: Text("Terrible", style: TextStyle(color: Colors.red))),
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                  items: moods,
                  value: _dropdownValue,
                  onChanged: dropdownCallback,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Mood')),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 1,
                maxLines: 10,
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
          ),
        ));
  }
}
