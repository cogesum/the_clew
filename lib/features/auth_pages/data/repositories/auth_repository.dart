import 'package:clew_app/features/auth_pages/domain/usecases/data_base_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      Map<String, dynamic> userInfoMap = {
        "email": email,
        "username": username,
        "points": 0,
      };

      if (userCredential != null) {
        DatabaseMethods()
            .addUserInfoToDB(firebaseAuth.currentUser!.uid, userInfoMap);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw Exception("The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Этот аккаунт уже уществует с такой почтой');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future addUserDetails(String username, String email) async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     //final userId = firebaseAuth.currentUser?.uid;
  //     await FirebaseFirestore.instance.collection('usersData').add({
  //       //"uid": userId,
  //       "username": username,
  //       "email": email,
  //       "points": 0,
  //     });
  //   }
  // }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw Exception("Пользователь не найден");
      } else if (e.code == 'wrong-password') {
        throw Exception("Неверный пароль");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = FirebaseAuth.instance.currentUser!;
      Map<String, dynamic> userInfoMap = {
        "email": user.email,
        "username": user.displayName,
        "points": 0,
      };

      if (credential != null) {
        DatabaseMethods()
            .addUserInfoToDB(firebaseAuth.currentUser!.uid, userInfoMap);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
