class User {
  User({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.nationality,
    required this.state,
    required this.lga,
    required this.address,
    required this.photoUrl,
    required this.accountLevel,
    required this.purNumber,
    required this.irNumber,
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
  final String address;
  final String photoUrl;
  final int accountLevel;
  final int purNumber;
  final int irNumber;
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
      'address': address,
      'accountLevel': accountLevel,
      'purNumber': purNumber,
      'irNumber': irNumber,
      'isOnline': isOnline,
      'fcmToken': fcmToken,
      'uid': uid,
    };
  }

  factory User.fromMap(
    Map<String, dynamic> map,
  ) {
    return User(
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
      address: map['address'] ?? '',
      accountLevel: map['accountLevel'] ?? 1,
      purNumber: map['purNumber'] ?? 0,
      irNumber: map['irNumber'] ?? 0,
      isOnline: map['isOnline'] ?? true,
      fcmToken: map['fcmToken'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
