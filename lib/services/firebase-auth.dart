import "package:cloud_firestore/cloud_firestore.dart";

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> kullaniciKaydet(
      {required String name,
      required int surname,
      required int email,
      required int StudentID,
      required String Password}) async {
    await userCollection.doc().set({
      "name": name,
      "surname": surname,
      "email": email,
      "StudentID": StudentID,
      "Password": Password,
    });
  }
}
