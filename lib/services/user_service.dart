import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    return snapshot.docs.map((doc) {
      return UserModel.fromFirestore(doc.id, doc.data());
    }).toList();
  }

  Future<void> updateUser(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(user.toMap());
  }
}
