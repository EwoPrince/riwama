class Slide {
  final String profImage;
  final String uid;
  final String slideId;
  final DateTime datePublished;

  Slide({
    required this.profImage,
    required this.uid,
    required this.slideId,
    required this.datePublished,
  });

  Map<String, dynamic> toMap() => {
        "profImage": profImage,
        "uid": uid,
        "slideId": slideId,
        "datePublished": datePublished,
      };

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
      profImage: map['profImage'] ?? '',
      uid: map["uid"] ?? '',
      slideId: map["slideId"] ?? '',
      datePublished: map["datePublished"].toDate(),
    );
  }
}
