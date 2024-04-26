import 'package:flutter/material.dart';
import 'package:my_market/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_market/resource/authen_method.dart';
import 'package:my_market/screens/mobScreen_layout.dart';
import 'package:my_market/screens/signup_screen.dart';
import 'package:my_market/screens/webscreen_layout.dart';
import 'package:my_market/util/utils.dart';
import 'package:my_market/widgets/text_field_input.dart';

import 'responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobScreenLayout: MobScreenLayout(),
              ),
            ),
                (route) => false);

        setState(() {
          _isloading = false;
        });
      }
    } else {
      setState(() {
        _isloading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).size.width > 900
          ? EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 3)
          : const EdgeInsets.symmetric(horizontal: 32),
          //const EdgeInsets.fromLTRB(20, 50, 20, 5),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // Flexible(
          //     flex: 1,
          //     child: Container()),
          Hero(
            tag: 'logo',
            child: Image(
              image: AssetImage("images/stall.png"),
              width: 90,
              height: 90,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("My Market",
              style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Merriweather',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal)),
          const SizedBox(
            height: 64,
          ),
          //email textfield
          TextFieldInput(
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
              hintText: "Enter your email"),

          // SizedBox(
          //   height: 5,
          // ),
          //password textfield
          TextFieldInput(
            textInputType: TextInputType.text,
            textEditingController: _passwordController,
            hintText: "Enter your password",
            isPass: true,
          ),

          SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Forgot password?",
                style: TextStyle(
                  color: Color(0xFF95D6A4),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'NotoSans',
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF95D6A4),
                  minimumSize: Size(177, 53),
                  padding: EdgeInsets.all(15),
                ),
                onPressed: loginUser,
                child: !_isloading
              ? const Text(
                  "Log in",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ) : const CircularProgressIndicator(
                  color: Colors.black,
                ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Divider(
            height: 0,
            thickness: 1,
            color: Colors.black12,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSans',
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignUP(),
                      ),
                  ),
                  child: Text(
                    "Sign Up.",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'NotoSans',
                        color: Color(0xFF95D6A4),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
                )
              ],
            ),
          )

          ],
          ),
        ),
      ),
    );
  }
}
