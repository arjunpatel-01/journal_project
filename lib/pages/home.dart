import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_project/providers/journal_provider.dart';
import 'package:journal_project/services/sql_helper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<JournalProvider>(context, listen: false).getAllJournals();
    });
  }

  // Delete a journal
  void _deleteEntry(int id) async {
    await SQLHelper.deleteEntry(id);
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    Provider.of<JournalProvider>(context, listen: false).getAllJournals();
  }

  final moodColors = const {
    'Awesome': Colors.green,
    'Good': Colors.teal,
    'Okay': Colors.brown,
    'Bad': Colors.orange,
    'Terrible': Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal App'),
      ),
      body: Consumer<JournalProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final journals = value.journals;
          return ListView.builder(
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final journal = journals[index];
                return Card(
                    color: Colors.white70,
                    child: ListTile(
                        leading: SizedBox(
                          width: 70,
                          child: Column(
                            children: [
                              CircleAvatar(
                                  child: Text(DateFormat.Md()
                                      .format(DateTime.parse(
                                              "${journal.timestamp}+00")
                                          .toLocal())
                                      .toString())),
                              Text(DateFormat.jm()
                                  .format(
                                      DateTime.parse("${journal.timestamp}+00")
                                          .toLocal())
                                  .toString())
                            ],
                          ),
                        ),
                        title: Text(
                          journal.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        subtitle: Text(journal.mood,
                            style: TextStyle(color: moodColors[journal.mood])),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteEntry(journal.id),
                        ),
                        onTap: () => GoRouter.of(context)
                            .pushNamed('journalentry', extra: journal)));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            GoRouter.of(context).pushNamed('createorupdate', extra: null),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Journal App'),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: _journals.length,
//               itemBuilder: (context, index) => Card(
//                 color: Colors.orange[200],
//                 margin: const EdgeInsets.all(15),
//                 child: ListTile(
//                     //TODO: the time is +5 hours --> convert to local timezone
//                     title: Text(DateFormat.yMd()
//                         .add_jm()
//                         .format(DateTime.parse(_journals[index].timestamp))
//                         .toString()),
//                     subtitle: Text(_journals[index].title),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () =>
//                                 _showJournalForm(_journals[index].id),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () => _deleteEntry(_journals[index].id),
//                           ),
//                         ],
//                       ),
//                     )),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _showJournalForm(null),
//       ),
//     );
//   }
}
