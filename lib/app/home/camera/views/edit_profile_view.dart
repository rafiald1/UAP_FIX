import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../modules/login/controllers/auth_controller.dart';

class EditProfileView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  EditProfileView({Key? key}) : super(key: key) {
    emailController.text = authController.userEmail.value; // Set email default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Enter new email",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Edit Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Enter new password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                authController.updateUserProfile(
                    email: email, password: password);
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
