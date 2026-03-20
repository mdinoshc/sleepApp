class RecordList {
  final String id;
  final String title;
  final DateTime date;
  final String duration;
  final String filePath;
  final bool isFavorite;


  RecordList( {
    required this.id, required this.title, required this.date, required this.duration, required this.filePath,
    required this.isFavorite
});

  factory RecordList.fromJson(Map<String, dynamic> json) {
    return RecordList(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      filePath: json['filePath'],
      isFavorite: json['isFavorite']
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