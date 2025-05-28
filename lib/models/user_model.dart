class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String displayName;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.displayName,
  });

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'email': email,
    'displayName': displayName,
  };
}