class Transcation {
  Transcation({
    required this.transcationId,
    this.receiver_username,
    this.sender_username,
    this.receiver_uid,
    this.sender_uid,
    this.receiver_pic,
    this.sender_pic,
    this.river_sent,
    this.river_recived,
    this.sea_sent,
    this.sea_recived,
    required this.date,
  });

  final String transcationId;
  String? receiver_username;
  String? sender_username;
  String? receiver_uid;
  String? sender_uid;
  String? receiver_pic;
  String? sender_pic;
  int? river_sent;
  int? river_recived;
  int? sea_sent;
  int? sea_recived;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'transcationId': transcationId,
      'receiver_username': receiver_username,
      'sender_username': sender_username,
      'receiver_uid': receiver_uid,
      'sender_uid': sender_uid,
      'receiver_pic': receiver_pic,
      'sender_pic': sender_pic,
      'river_sent': river_sent,
      'river_recived': river_recived,
      'sea_sent': sea_sent,
      'sea_recived': sea_recived,
      'date': date,
    };
  }

  factory Transcation.fromMap(
    Map<String, dynamic> map,
  ) {
    return Transcation(
      transcationId: map['transcationId'],
      receiver_username: map['receiver_username'] ?? '',
      sender_username: map['sender_username'] ?? '',
      receiver_uid: map['receiver_uid'] ?? '',
      sender_uid: map['sender_uid'] ?? '',
      receiver_pic: map['receiver_pic'] ?? '',
      sender_pic: map['sender_pic'] ?? '',
      river_sent: map['river_sent'] ?? 0,
      river_recived: map['river_recived'] ?? 0,
      sea_sent: map['sea_sent'] ?? 0,
      sea_recived: map['sea_recived'] ?? 0,
      date: map['date'].toDate(),
    );
  }
}
