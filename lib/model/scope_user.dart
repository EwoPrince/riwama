class ScopeUser {
  ScopeUser({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.nationality,
    required this.state,
    required this.lga,
    required this.photoUrl,
    required this.accountLevel,
    this.isOnline,
    required this.uid,
    this.fcmToken,
  });

  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String phone;
  final String dob;
  final String nationality;
  final String state;
  final String lga;
  final String photoUrl;
  final int accountLevel;
  String? fcmToken;
  bool? isOnline;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'dob': dob,
      'nationality': nationality,
      'state': state,
      'lga': lga,
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
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      dob: map['dob'] ?? '',
      nationality: map['nationality'] ?? '',
      state: map['state'] ?? '',
      lga: map['lga'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      accountLevel: map['accountLevel'] ?? 1,
      uid: map['uid'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
    );
  }
}
