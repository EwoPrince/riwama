
class Receptacle {
  final String name;
  final String profImage;
  final String description;
  final String uid;
  final String receptacleId;
  final DateTime datePublished;
  final bool cleared;
  final String lon;
  final String lat;

  Receptacle({
    required this.name,
    required this.profImage,
    required this.description,
    required this.uid,
    required this.receptacleId,
    required this.datePublished,
    required this.cleared,
    required this.lon,
    required this.lat,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "profImage": profImage,
        "description": description,
        "uid": uid,
        "receptacleId": receptacleId,
        "datePublished": datePublished,
        'cleared': cleared,
        'lon': lon,
        'lat': lat,
      };

  factory Receptacle.fromMap(Map<String, dynamic> map) {
    return Receptacle(
      name: map['name'] ?? '',
      profImage: map['profImage'] ?? '',
      description: map["description"] ?? '',
      uid: map["uid"] ?? '',
      receptacleId: map["receptacleId"] ?? '',
      datePublished: map["datePublished"].toDate(),
      cleared: map["cleared"] ?? false,
      lon: map['lon'] ?? '',
      lat: map['lat'] ?? '',
    );
  }
}
