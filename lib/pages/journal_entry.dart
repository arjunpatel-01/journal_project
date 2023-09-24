import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:journal_project/models/journal.dart';
import 'package:journal_project/style/colors.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  maxRadius: 35,
                  child: Text(
                    DateFormat.Md()
                        .format(
                            DateTime.parse('${journal.timestamp}+00').toLocal())
                        .toString(),
                    style: const TextStyle(fontSize: 20),
                  )),
              Text("I'm Feeling ${journal.mood}",
                  style: TextStyle(
                      color: moodColors[journal.mood],
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                DateFormat.jm()
                    .format(DateTime.parse('${journal.timestamp}+00').toLocal())
                    .toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  journal.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    journal.description,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    String? val = await GoRouter.of(context)
                        .pushNamed('createorupdate', extra: journal);
                    if (!context.mounted) return;
                    if (val == 'update') GoRouter.of(context).pop();
                  }),
            ],
          ),
        ]),
      ),
    );
  }
}
