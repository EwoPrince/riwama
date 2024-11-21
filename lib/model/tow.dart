
class TowRequest {
  final String name;
  final String profImage;
  final String description;
  final String uid;
  final String TowRequestId;
  final DateTime datePublished;
  String? ClearedByUid;
  final bool cleared;
  final String lon;
  final String lat;

  TowRequest({
    required this.name,
    required this.profImage,
    required this.description,
    required this.uid,
    required this.TowRequestId,
    required this.datePublished,
    required this.cleared,
    required this.lon,
    required this.lat,
    this.ClearedByUid,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "profImage": profImage,
        "description": description,
        "uid": uid,
        "TowRequestId": TowRequestId,
        "datePublished": datePublished,
        'cleared': cleared,
        'lon': lon,
        'lat': lat,
        'ClearedByUid':ClearedByUid,
      };

  factory TowRequest.fromMap(Map<String, dynamic> map) {
    return TowRequest(
      name: map['name'] ?? '',
      profImage: map['profImage'] ?? '',
      description: map["description"] ?? '',
      uid: map["uid"] ?? '',
      TowRequestId: map["TowRequestId"] ?? '',
      datePublished: map["datePublished"].toDate(),
      cleared: map["cleared"] ?? false,
      lon: map['lon'] ?? '',
      lat: map['lat'] ?? '',
      ClearedByUid: map['ClearedByUid'],
    );
  }
}
