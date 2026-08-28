import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_salary/features/auth/data/model/login_request.dart';
import 'package:smart_salary/features/auth/data/model/register_request.dart';
import 'package:smart_salary/features/auth/data/model/user_model.dart';
import 'package:smart_salary/features/firebase/cloudinary_services.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // static Future<UserCredential> register(RegisterRequest request) async {
  //   UserCredential credential = await _auth.createUserWithEmailAndPassword(
  //     email: request.email,
  //     password: request.password,
  //   );
  //
  //   UserModel user = UserModel(
  //     id: credential.user!.uid,
  //     name: request.name,
  //     email: request.email,
  //     phone: request.phone,
  //   );
  //
  //   await addUserToFireStore(user);
  //
  //   return credential;
  // }
  static Future<UserCredential> register(RegisterRequest request) async {
    final UserCredential credential =
    await _auth.createUserWithEmailAndPassword(
      email: request.email,
      password: request.password,
    );

    final user = UserModel(
      id: credential.user!.uid,
      name: request.name,
      email: request.email,
      phone: request.phone,
    );

    await addUserToFireStore(user);

    // Send verification email immediately after registration
    await credential.user!.sendEmailVerification();

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
    await GoogleSignIn().signOut();
    await _auth.signOut();

    // امسحيهم فقط لو انتي لا تريدين البصمة بعد تسجيل الخروج
    // await SecureStorageService.clear();
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

  static Future<UserModel> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: "google-sign-in-cancelled",
        message: "Google Sign In cancelled",
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    final firebaseUser = userCredential.user!;

    UserModel? user = await getUserFromFireStore(firebaseUser.uid);

    if (user == null) {
      user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        phone: firebaseUser.phoneNumber ?? "",
        image: firebaseUser.photoURL ?? "",
        birthday: "",
        gender: "",
        jobTitle: "",
      );

      await addUserToFireStore(user);
    }

    return user;
  }

  // static Future<void> sendVerificationEmail() async {
  //   try {
  //     final user = _auth.currentUser;
  //
  //     if (user == null) {
  //       throw FirebaseAuthException(
  //         code: "user-not-found",
  //         message: "No user is logged in",
  //       );
  //     }
  //
  //     if (!user.emailVerified) {
  //       await user.sendEmailVerification();
  //     }
  //   } on FirebaseAuthException {
  //     rethrow;
  //   }
  // }

  /// Current Firebase User
  static User? currentFirebaseUser() {
    return _auth.currentUser;
  }

  /// Current UID
  static String? currentUserId() {
    return _auth.currentUser?.uid;
  }

  static Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in.");

    final isGoogle = user.providerData.any((p) => p.providerId == "google.com");

    if (isGoogle) {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: "cancelled",
          message: "Google sign in cancelled",
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
      return;
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  static Future<void> deleteUser(String uid) async {
    await getUsersCollection().doc(uid).delete();
  }

  static Future<void> updateCurrentUserEmail(String email) async {
    final user = _auth.currentUser!;

    await user.verifyBeforeUpdateEmail(email);
  }

  // static Future<void> sendVerificationEmail() async {
  //   final user = _auth.currentUser;
  //
  //   if (user == null) {
  //     throw FirebaseAuthException(
  //       code: "user-not-found",
  //       message: "No user is logged in",
  //     );
  //   }
  //
  //   await user.reload();
  //
  //   final updatedUser = _auth.currentUser!;
  //
  //   final isGoogle = updatedUser.providerData
  //       .any((p) => p.providerId == 'google.com');
  //
  //   if (updatedUser.emailVerified || isGoogle) {
  //     throw FirebaseAuthException(
  //       code: "already-verified",
  //       message: "Your email is already verified.",
  //     );
  //   }
  //   await updatedUser.sendEmailVerification();
  // }

  static Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: "user-not-found",
        message: "No user is logged in",
      );
    }

    await user.reload();

    final updatedUser = _auth.currentUser;

    if (updatedUser == null) {
      throw FirebaseAuthException(
        code: "user-not-found",
        message: "No user is logged in",
      );
    }

    if (updatedUser.emailVerified) {
      throw FirebaseAuthException(
        code: "already-verified",
        message: "Email is already verified.",
      );
    }

    await updatedUser.sendEmailVerification();
  }

  static Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();

    return _auth.currentUser?.emailVerified ?? false;
  }

  // static Future<void> logout() async {
  //   await GoogleSignIn().signOut();
  //   await _auth.signOut();
  // }

  // static Future<void> linkAccountWithGoogle() async {
  //   final user = _auth.currentUser;
  //   if (user == null) throw FirebaseAuthException(code: "user-not-found", message: "No user logged in.");
  //
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   await googleSignIn.signOut();
  //
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   if (googleUser == null) {
  //     throw FirebaseAuthException(
  //       code: "cancelled",
  //       message: "Google sign in was cancelled",
  //     );
  //   }
  //
  //   if (googleUser.email.toLowerCase() != user.email?.toLowerCase()) {
  //     throw FirebaseAuthException(
  //       code: "email-mismatch",
  //       message: "Please select the Google account for ${user.email}",
  //     );
  //   }
  //
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //
  //   await user.linkWithCredential(credential);
  //   await user.reload();
  // }

  static Future<void> setBiometricEnabled(bool enabled) async {
    final uid = currentUserId()!;

    await _firestore
        .collection("users")
        .doc(uid)
        .update({
      "biometricEnabled": enabled,
    });
  }

  static Future<bool> getBiometricEnabled() async {
    final uid = currentUserId()!;

    final doc = await _firestore
        .collection("users")
        .doc(uid)
        .get();

    return doc.data()?["biometricEnabled"] ?? false;
  }

  static Stream<bool> biometricStream() {
    final uid = currentUserId()!;

    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(
          (e) => e.data()?["biometricEnabled"] ?? false,
    );
  }

  // static Future<bool> getAskedBiometric() async {
  //   final uid = currentUserId()!;
  //
  //   final doc = await _firestore
  //       .collection("users")
  //       .doc(uid)
  //       .get();
  //
  //   return doc.data()?["askedBiometric"] ?? false;
  // }
  //
  // static Future<void> setAskedBiometric() async {
  //   final uid = currentUserId()!;
  //
  //   await _firestore
  //       .collection("users")
  //       .doc(uid)
  //       .update({
  //     "askedBiometric": true,
  //   });
  // }

  static Future<bool> shouldUseBiometric() async {
    final uid = currentUserId();

    if (uid == null) return false;

    final doc = await _firestore
        .collection(UserModel.collectionName)
        .doc(uid)
        .get();

    return doc.data()?["biometricEnabled"] ?? false;
  }
}
