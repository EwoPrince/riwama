import 'PickupRequest_enum.dart';

class PickupRequest {
  final String name;
  final String profImage;
  final String description;
  final String uid;
  final String PickupRequestId;
  final PickupRequestEnum type;
  final DateTime datePublished;
  String? ClearedByUid;
  final bool cleared;
  final String lon;
  final String lat;

  PickupRequest({
    required this.name,
    required this.profImage,
    required this.description,
    required this.uid,
    required this.PickupRequestId,
    required this.type,
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
        "PickupRequestId": PickupRequestId,
        'type': type.type,
        "datePublished": datePublished,
        'cleared': cleared,
        'lon': lon,
        'lat': lat,
        'ClearedByUid':ClearedByUid,
      };

  factory PickupRequest.fromMap(Map<String, dynamic> map) {
    return PickupRequest(
      name: map['name'] ?? '',
      profImage: map['profImage'] ?? '',
      description: map["description"] ?? '',
      uid: map["uid"] ?? '',
      PickupRequestId: map["PickupRequestId"] ?? '',
      type: (map['type'] as String).toPickupEnum(),
      datePublished: map["datePublished"].toDate(),
      cleared: map["cleared"] ?? false,
      lon: map['lon'] ?? '',
      lat: map['lat'] ?? '',
      ClearedByUid: map['ClearedByUid'],
    );
  }
}
