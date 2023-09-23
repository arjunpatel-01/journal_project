import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_project/models/journal.dart';

class JournalEntryPage extends StatefulWidget {
  final Journal journal;
  const JournalEntryPage({Key? key, required this.journal}) : super(key: key);

  @override
  JournalEntryPageState createState() => JournalEntryPageState();
}

class JournalEntryPageState extends State<JournalEntryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Journal journal = widget.journal;
    return Scaffold(
      appBar: AppBar(title: const Text('Journal App')),
      body: Column(children: [
        CircleAvatar(
            child: Text(DateFormat.Md()
                .format(DateTime.parse(journal.timestamp))
                .toString())),
        Text(DateFormat.jm()
            .format(DateTime.parse('${journal.timestamp}+00').toLocal())
            .toString()),
        Text(journal.title),
        Text(journal.mood),
        Text(journal.description),
        IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              String? val = await GoRouter.of(context)
                  .pushNamed('createorupdate', extra: journal);
              if (!context.mounted) return;
              if (val == 'update') GoRouter.of(context).pop();
            }),
      ]),
    );
  }
}
