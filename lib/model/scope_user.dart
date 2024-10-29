class ScopeUser {
  ScopeUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.accountLevel,
    this.isOnline,
    required this.uid,
    this.fcmToken,
  });

  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final int accountLevel;
  String? fcmToken;
  bool? isOnline;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'accountLevel': accountLevel,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'fcmToken': fcmToken,
      'uid': uid,
    };
  }

  factory ScopeUser.fromMap(
    Map<String, dynamic> map,
  ) {
    return ScopeUser(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      accountLevel: map['accountLevel'] ?? 1,
      uid: map['uid'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
    );
  }
}
