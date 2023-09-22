class Journal {
  int id;
  String title;
  String mood;
  String? description;

  Journal(
      {required this.id,
      required this.title,
      required this.mood,
      this.description});

  factory Journal.from(dynamic doc) => Journal(
      id: doc["id"],
      title: doc["title"],
      mood: doc["mood"],
      description: doc["entry"]);

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'mood': mood, 'description': description};
}
