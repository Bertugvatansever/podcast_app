import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  Future<String?> signUp(String email, String password) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String? userId = userCredential.user?.uid;
      return userId;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> signIn(String email, String password) async {
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? userId = userCredential.user?.uid;

    return userId;
  }

  Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  String? getcurrentUserId() {
    return auth.FirebaseAuth.instance.currentUser?.uid;
  }
}
