import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_market/resource/authen_method.dart';
import 'package:my_market/screens/login_screen.dart';
import 'package:my_market/screens/mobScreen_layout.dart';
import 'package:my_market/screens/responsive_layout.dart';
import 'package:my_market/screens/webscreen_layout.dart';
import 'package:my_market/util/utils.dart';
import 'package:my_market/widgets/text_field_input.dart';
import 'package:my_market/widgets/powered_by_footer.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});
  static const String id = 'SignupScreen';

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }
    @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }
  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!
        );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobScreenLayout: MobScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: MediaQuery.of(context).size.width > 900
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.fromLTRB(15, 45, 20, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(flex: 1, child: Container()),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const  [
                  Hero(
                    tag: 'logo',
                    child: Image(
                      image: AssetImage("images/stall.png"),
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("My Market",
                      style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Merriweather',
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage("images/user.png"),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: Icon(Icons.add_a_photo_rounded)))
                ],
              ),
              SizedBox(
                height: 25,
              ),
              //username text field
              TextFieldInput(
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  hintText: "Enter your business name"),
              SizedBox(
                height: 5,
              ),
              // email text field
              TextFieldInput(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  hintText: "Enter your email"),
              SizedBox(
                height: 5,
              ),
              //password text field
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
          vertical: 8, horizontal: 15
        ),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: Divider.createBorderSide(context)
        ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: Divider.createBorderSide(context)
        ),
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: Divider.createBorderSide(context)
        ),
        filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                
              ),
              // TextFieldInput(
              //   textInputType: TextInputType.text,
              //   textEditingController: _passwordController,
              //   hintText: "Enter your password",
                
              // ),
              SizedBox(
                height: 5,
              ),
              //bio text field
              TextFieldInput(
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  hintText: 'Enter your bio'
              ),
              SizedBox(
                height: 20,
              ),
      
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: TextButton(
                    onPressed: signUpUser,
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF95D6A4),
                      padding: EdgeInsets.all(15),
                    ),
                    child: !_isLoading
                  ? const Text(
                      "Sign up",
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
                height: 75,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
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
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Text(
                        "Log In.",
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
              ),
              const SizedBox(height: 20),
              const PoweredByFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
