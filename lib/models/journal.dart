class Journal {
  int id;
  String title;
  String mood;
  String description;
  String timestamp;

  Journal(
      {required this.id,
      required this.title,
      required this.mood,
      required this.description,
      required this.timestamp});

  factory Journal.from(dynamic doc) => Journal(
      id: doc["id"],
      title: doc["title"],
      mood: doc["mood"],
      description: doc["description"],
      timestamp: doc['timestamp']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'mood': mood, 'description': description};
}
