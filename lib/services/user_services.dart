import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:podcast_app/models/user.dart';

class UserService {
  Future<bool> saveRegisterUser(
      String? id, String email, String name, String surName) async {
    if (id != null) {
      CollectionReference userReference =
          FirebaseFirestore.instance.collection("users");
      await userReference.doc(id).set({
        "id": id,
        "email": email,
        "name": name,
        "surname": surName,
        "photo": "",
        "createdtime": DateTime.now().millisecondsSinceEpoch
      });
      return true;
    } else {
      print("Kayıtta hata var ");
      return false;
    }
  }

  Future<User> getcurrentUser(String id) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    // DocumentSnapshot bir adet belge çağırırken kullanılır.
    DocumentSnapshot documentSnapshot = await usersRef.doc(id).get();
    User user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    print(user.name);
    print(user.surName);
    print(user.email);
    print(user.id);
    return user;
  }
}
