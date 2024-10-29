import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as x;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/model/user.dart';

final authProvider =
    ChangeNotifierProvider<AuthProviders>((ref) => AuthProviders());

class AuthProviders extends ChangeNotifier {
  User? _user;
  ScopeUser? _scopeUser;
  bool _isLogin = false;
  Map<String, dynamic> _EPData = {};
  Map<String, dynamic> _FNData = {};

  User? get user => _user;
  ScopeUser? get scopeUser => _scopeUser;
  bool get isLogin => _isLogin;
  Map<String, dynamic> get EPData => _EPData;
  Map<String, dynamic> get FNData => _FNData;
  String? get firebaseCurrentUserId => x.FirebaseAuth.instance.currentUser?.uid;

  void setEmailPass(
    String email,
    String password,
  ) {
    _EPData = {
      "email": email,
      "password": password,
    };
    notifyListeners();
  }

  void setfirstName(String fn) {
    _FNData = {"fullname": fn};
    notifyListeners();
  }

  Future getScopeUserData(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    _scopeUser = ScopeUser.fromMap(snapshot.data() as Map<String, dynamic>);
    return _scopeUser;
  }

  Future registerUser(
    String email,
    String password,
    String firstName,
    String middleName,
    String lastName,
    String phone,
    String dob,
    String nationality,
    String state,
    String lga,
    String address,
  ) async {
    await x.FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .whenComplete(() async {
      await setUpAccount(
        firstName,
        middleName,
        lastName,
        email,
        phone,
        password,
        dob,
        nationality,
        state,
        lga,
        address,
      );
    });
  }

  Future setUpAccount(
    String firstName,
    String middleName,
    String lastName,
    String email,
    String phone,
    String password,
    String dob,
    String nationality,
    String state,
    String lga,
    String address,
  ) async {
    final CurrentId = await x.FirebaseAuth.instance.currentUser!.uid;
    // final referCode = await CodeGenerator.generateCode(CurrentId);
    // final referLink = await DeepLinkService.instance!.createReferLink(referCode);

    await FirebaseFirestore.instance.collection("users").doc(CurrentId).set(
      {
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "password": password,
        "dob": dob,
        "nationality": nationality,
        "state": state,
        "lga": lga,
        "photoUrl":
            'https://firebasestorage.googleapis.com/v0/b/riwama-4d9b4.appspot.com/o/extra%2Ficons8-customer-100.png?alt=media&token=3a5f907c-7866-4230-b4a4-32f56541ef61',
        "address": address,
        "accountLevel": 1,
        'isOnline': true,
        "uid": CurrentId,
      },
    );

    // if (referCode != null && referCode.isNotEmpty) {
    //   await rewardUserFromReferCode(referCode);
    // }
    listenTocurrentUserNotifier(CurrentId);
  }

  Future updateFcmToken(String fcmToken) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseCurrentUserId)
        .update({"fcmToken": fcmToken});
  }

  Future becomeSupervisor() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseCurrentUserId)
        .update({"accountLevel": 2});
  }

  Future becomeSuperSupervisor() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseCurrentUserId)
        .update({"accountLevel": 3});
  }

  Future revertSupervisor() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseCurrentUserId)
        .update({"accountLevel": 1});
  }

  Future loginUser(String email, String password) async {
    await x.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final CurrentId = x.FirebaseAuth.instance.currentUser!.uid;
    final documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(CurrentId)
        .get();
    if (documentSnapshot.exists) {
      _user = User.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    listenTocurrentUserNotifier(CurrentId);
    notifyListeners();
    return user;
  }

  Future getCurrentUser(String uid) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (documentSnapshot.exists) {
      _user = User.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future listenTocurrentUserNotifier(String uid) async {
    final snapshot =
        FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
    snapshot.listen((document) {
      if (document.exists) {
        _user = User.fromMap(document.data() as Map<String, dynamic>);
      }
    });
    notifyListeners();
  }

  Future logoutUser() async {
    await x.FirebaseAuth.instance.signOut();
    final CurrentId = x.FirebaseAuth.instance.currentUser!.uid;
    getCurrentUser(CurrentId);
    notifyListeners();
  }

  Future resetPass(String pass) async {
    x.FirebaseAuth.instance.sendPasswordResetEmail(email: pass);
  }

  Future setUserState(bool isOnline) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(x.FirebaseAuth.instance.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
    notifyListeners();
  }

  Future updateUserLocation(
    String long,
    String latt,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(x.FirebaseAuth.instance.currentUser!.uid)
        .update({
      'lon': long,
      'lat': latt,
    });
    notifyListeners();
  }

  Future DeleteAccount(String email, String password) async {
    final currentId = x.FirebaseAuth.instance.currentUser!.uid;
    final credentials =
        x.EmailAuthProvider.credential(email: email, password: password);

    // Delete user posts
    final postQuerySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: currentId)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    postQuerySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    await batch.commit();

    // Delete user document
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentId)
        .delete();

    // Reauthenticate and delete user account
    await x.FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credentials);
    await x.FirebaseAuth.instance.currentUser!.delete();

    // Clear current user data
    _user = null;
    notifyListeners();
  }
}
