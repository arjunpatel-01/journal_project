import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_project/models/journal.dart';
import 'package:journal_project/models/journal_dto.dart';
import 'package:journal_project/services/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getEntries();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the journals when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _moodController.text = existingJournal['mood'];
      _descriptionController.text = existingJournal['description'];
    }

    GoRouter.of(context).pushNamed('createorupdate');

    _refreshJournals();
  }

// Insert a new journal to the database
  Future<void> _addEntry() async {
    await SQLHelper.createEntry(JournalDTO.from({
      'title': _titleController.text,
      'mood': _moodController.text,
      'description': _descriptionController.text
    }));
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateEntry(int id) async {
    await SQLHelper.updateEntry(Journal.from({
      'id': id,
      'title': _titleController.text,
      'mood': _moodController.text,
      'description': _descriptionController.text
    }));
    _refreshJournals();
  }

  // Delete a journal
  void _deleteEntry(int id) async {
    await SQLHelper.deleteEntry(id);
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    //TODO: the time is +4 hours
                    title: Text(DateFormat.yMd()
                        .add_jm()
                        .format(DateTime.parse(_journals[index]['timestamp']))
                        .toString()),
                    subtitle: Text(_journals[index]['title']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_journals[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteEntry(_journals[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
