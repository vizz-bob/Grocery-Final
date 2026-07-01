import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  String _email = '';
  String _password = '';

  bool isLoading = false;

  /// 👁 Password visibility
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 APP BAR (NO ACCOUNT ICON ON LOGIN)
          BhejduAppBar(
            title: "Login",
            showBack: true,
            showAccountIcon: false, // ✅ FIXED
            onBackTap: () => Navigator.pop(context),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome 👋",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Login to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: BhejduColors.textGrey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// EMAIL
                  _inputField(
                    controller: emailCtrl,
                    hint: "Email",
                    onChanged: (val) => _email = val,
                  ),

                  const SizedBox(height: 20),

                  /// PASSWORD
                  _inputField(
                    controller: passCtrl,
                    hint: "Password",
                    onChanged: (val) => _password = val,
                    obscure: !passwordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: BhejduColors.primaryBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot-password");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: BhejduColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 16),

                  /// SIGN UP LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style:
                        TextStyle(color: BhejduColors.textGrey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: BhejduColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// BROWSE AS GUEST
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/home",
                          (_) => false,
                        );
                      },
                      child: const Text(
                        "Browse as Guest",
                        style: TextStyle(
                          color: BhejduColors.textGrey,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ------------------ INPUT FIELD ------------------
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: false,
        onChanged: onChanged,
        keyboardType: obscure
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  /// ------------------ LOGIN LOGIC ------------------
  Future<void> loginUser() async {
    final email = _email.trim().isNotEmpty ? _email.trim() : emailCtrl.text.trim();
    final password = _password.trim().isNotEmpty ? _password.trim() : passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    // ✅ DEMO ACCOUNT BYPASS — works without server connection
    final _demoAccounts = {
      "test@bhejdu.com":     {"password": "test@1234",  "name": "Test User",    "mobile": "9000000000", "id": 9999},
      "mg3235631@gmail.com": {"password": "Muskaan@123","name": "Muskaan",      "mobile": "",           "id": 9998},
    };
    if (_demoAccounts.containsKey(email)) {
      final demo = _demoAccounts[email]!;
      if (password == demo["password"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("user_id",       demo["id"] as int);
        await prefs.setString("user_name",  demo["name"] as String);
        await prefs.setString("user_email", email);
        await prefs.setString("user_mobile",demo["mobile"] as String);
        await prefs.setBool("is_logged_in", true);
        setState(() => isLoading = false);
        Navigator.pushNamed(context, "/home");
        return;
      }
    }

    final url = Uri.parse(
      "https://darkslategrey-chicken-274271.hostingersite.com/api/login.php",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final result = jsonDecode(response.body);

      setState(() => isLoading = false);

      if (result["status"] == "success") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("user_id", result["user_id"]);
        await prefs.setBool("is_logged_in", true);

        Navigator.pushNamed(context, "/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text(result["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error")),
      );
    }
  }
}
