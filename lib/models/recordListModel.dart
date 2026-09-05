class RecordList {
  final String id;
  final String title;
  final DateTime date;
  final int duration;
  final String filePath;

  RecordList( {
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.filePath,
});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'duration': duration,
      'filePath': filePath,
    };
  }

  factory RecordList.fromJson(Map<String, dynamic> json) {
    return RecordList(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      filePath: json['filePath'],
    );
  }
}

// Future<List<Recording>> loadRecordings() async {
//   // Load the JSON string from the asset file
//   final String jsonString = await rootBundle.loadString('assets/recordList.json');
//
//   // Decode the JSON string into a List of dynamic objects
//   final List<dynamic> jsonList = json.decode(jsonString);
//
//   // Map the list of dynamic objects to a List of Recording objects
//   return jsonList.map((json) => Recording.fromJson(json)).toList();
// }