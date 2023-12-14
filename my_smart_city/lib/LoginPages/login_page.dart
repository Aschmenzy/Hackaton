import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
;
import 'package:google_fonts/google_fonts.dart';
import 'package:my_smart_city/LoginPages/forgot_paswd.dart';
import 'package:my_smart_city/util/my_button.dart';
import 'package:my_smart_city/util/text_field.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.ontap,
  });
  final Function()? ontap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //bool for checkbox
  bool _isChecked = false;

  //controllers for text
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //sing in function
  void SignIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    //try signing in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display if theres and error while logging in
      displayMessage(e.code);
    }
  }

  //dispaly a message with the error
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message),
              ),
            ));
  }

  //the main frontend code
  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? 'lib/assets/darkBackground.jpg'
                    : 'lib/assets/lightBackground.jpg'),
                fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SIZED BOX
                    SizedBox(height: 50),

                    //TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Sign in",
                            style: GoogleFonts.inter(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Sign in",
                          style: GoogleFonts.inter(
                              fontSize: 17.4,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),

                    //SIZED BOX
                    SizedBox(height: 30),

                    //TEXTFIELDS FOR EMAIL AND PASSWD
                    //email
                    MyTextField(
                      controller: emailTextController,
                      hintText: "Email",
                      obscureText: false,
                    ),

                    //sized box
                    const SizedBox(height: 20),

                    //passwd
                    MyTextField(
                      controller: passwordTextController,
                      hintText: "Password",
                      obscureText: true,
                    ),

                    //sized box
                    const SizedBox(height: 20),

                    //Rem me&forgot passwd - jos treba funkcionalnost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: -5,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value1) {
                                  setState(() {
                                    _isChecked = value1!;
                                  });
                                },
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.inter(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w300),
                              )
                            ]),
                        GestureDetector(
                          child: Text(
                            "Forgot Password",
                            style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswd(),
                              ),
                            );
                          },
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //login button
                    MyButton(
                      buttonText: "Log In",
                      ontap: SignIn,
                      height: 50,
                    ),

                    //sized box
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: Colors.black,
                          thickness: 0.5,
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Or Continue With",
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 0.5,
                          ),
                        )
                      ],
                    ),

                    //TEXT WITH REGISTER PAGE TEXT

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: widget.ontap,
                            child: Text(
                              "Register Now",
                              style: GoogleFonts.inter(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
