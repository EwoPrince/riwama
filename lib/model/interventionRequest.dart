
class Interventionrequest {
  final String name;
  final String profImage;
  final String proofImage;
  final String uid;
  final String InterventionrequestId;
  final DateTime datePublished;
  String? ClearedByUid;
  final bool cleared;
  final String lon;
  final String lat;

  Interventionrequest({
    required this.name,
    required this.profImage,
    required this.proofImage,
    required this.uid,
    required this.InterventionrequestId,
    required this.datePublished,
    required this.cleared,
    required this.lon,
    required this.lat,
    this.ClearedByUid,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "profImage": profImage,
        "proofImage": proofImage,
        "uid": uid,
        "InterventionrequestId": InterventionrequestId,
        "datePublished": datePublished,
        'cleared': cleared,
        'lon': lon,
        'lat': lat,
        'ClearedByUid':ClearedByUid,
      };

  factory Interventionrequest.fromMap(Map<String, dynamic> map) {
    return Interventionrequest(
      name: map['name'] ?? '',
      profImage: map['profImage'] ?? '',
      proofImage: map["proofImage"] ?? '',
      uid: map["uid"] ?? '',
      InterventionrequestId: map["InterventionrequestId"] ?? '',
      datePublished: map["datePublished"].toDate(),
      cleared: map["cleared"] ?? false,
      lon: map['lon'] ?? '',
      lat: map['lat'] ?? '',
      ClearedByUid: map['ClearedByUid'],
    );
  }
}
