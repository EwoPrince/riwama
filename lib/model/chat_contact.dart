class ChatContact {
  final String chatId;
  final List<String> membersUid;
  final DateTime datePublished;
  final String lastMessage;
  final Map<String, dynamic> profile;
  final bool isSeen;
  final String lastMessageBy;

  List<ChatProfile> get getProfiles => profile.entries.map((data) {
        return ChatProfile(
          username: data.value["username"],
          profilePic: data.value["profilePic"],
          uid: data.value["uid"],
        );
      }).toList();

  ChatContact({
    required this.chatId,
    required this.membersUid,
    required this.datePublished,
    required this.lastMessage,
    required this.profile,
    required this.isSeen,
    required this.lastMessageBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'profile': profile,
      'membersUid': membersUid,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      chatId: map['chatId'] ?? '',
      profile: map['profile'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      datePublished: DateTime.fromMillisecondsSinceEpoch(
          map['datePublished'] ?? map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
      isSeen: map['isSeen'] ?? true,
      lastMessageBy: map['lastMessageBy'] ?? ''
    );
  }
}

class ChatProfile {
  final String uid;
  final String username;
  final String profilePic;

  ChatProfile({
    required this.uid,
    required this.username,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'username': username,
      'profilePic': profilePic,
    };
  }

  factory ChatProfile.fromMap(Map<String, dynamic> map) {
    return ChatProfile(
      uid: map["uid"] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
}
