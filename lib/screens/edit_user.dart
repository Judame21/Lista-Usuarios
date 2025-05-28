import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;

  const EditUserPage({super.key, required this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final UserService _userService = UserService();

  late TextEditingController nombreController;
  late TextEditingController celularController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.user.name);
    celularController = TextEditingController(text: widget.user.phone);
    usernameController = TextEditingController(text: widget.user.displayName);
    passwordController = TextEditingController(); // campo nuevo
  }

  void updateUser() async {
    try {
      final updatedUser = UserModel(
        uid: widget.user.uid,
        name: nombreController.text,
        phone: celularController.text,
        email: widget.user.email,
        displayName: usernameController.text,
      );

      await _userService.updateUser(updatedUser);

      // Solo si se ingresó nueva contraseña
      if (passwordController.text.isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        await currentUser?.updatePassword(passwordController.text);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario actualizado")),
        );
        Navigator.pop(context, true); // devuelve true para actualizar Home
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    celularController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Usuario")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: celularController,
              decoration: const InputDecoration(labelText: "Celular"),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Usuario"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Nueva Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUser,
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
