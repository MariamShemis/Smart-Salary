import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_salary/features/auth/data/model/login_request.dart';
import 'package:smart_salary/features/auth/data/model/register_request.dart';
import 'package:smart_salary/features/auth/data/model/user_model.dart';
import 'package:smart_salary/features/firebase/cloudinary_services.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserCredential> register(RegisterRequest request) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: request.email,
      password: request.password,
    );

    UserModel user = UserModel(
      id: credential.user!.uid,
      name: request.name,
      email: request.email,
      phone: request.phone,
    );

    await addUserToFireStore(user);

    return credential;
  }

  static Future<UserCredential> login(LoginRequest request) async {
    return await _auth.signInWithEmailAndPassword(
      email: request.email,
      password: request.password,
    );
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static CollectionReference<UserModel> getUsersCollection() {
    return _firestore
        .collection(UserModel.collectionName)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<void> addUserToFireStore(UserModel user) async {
    await getUsersCollection().doc(user.id).set(user);
  }

  static Future<UserModel?> getUserFromFireStore(String uid) async {
    final doc = await getUsersCollection().doc(uid).get();
    return doc.data();
  }

  static Future<UserModel> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      throw Exception("No user is logged in.");
    }

    UserModel? user = await getUserFromFireStore(firebaseUser.uid);

    if (user == null) {
      throw Exception("User not found.");
    }

    return user;
  }

  static Future<void> updateProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String jobTitle,
    required String birthday,
    required String gender,
    File? image,
  }) async {
    final userDoc = await _firestore
        .collection(UserModel.collectionName)
        .doc(uid)
        .get();

    final data = userDoc.data() ?? {};

    String? imageUrl = data["image"];

    if (image != null) {
      imageUrl = await CloudinaryServices.uploadImage(image);
    }

    await _firestore.collection(UserModel.collectionName).doc(uid).update({
      "name": name,
      "email": email,
      "phone": phone,
      "jobTitle": jobTitle,
      "birthday": birthday,
      "gender": gender,
      "image": imageUrl,
    });
  }

  static Stream<UserModel> profileStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return getUsersCollection()
        .doc(uid)
        .snapshots()
        .map((event) => event.data()!);
  }
}
