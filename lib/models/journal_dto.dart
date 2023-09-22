class JournalDTO {
  String title;
  String mood;
  String description;

  JournalDTO(
      {required this.title, required this.mood, required this.description});

  factory JournalDTO.from(dynamic doc) => JournalDTO(
      title: doc['title'], mood: doc["mood"], description: doc["description"]);

  Map<String, dynamic> toJson() =>
      {'title': title, 'mood': mood, 'description': description};
}
