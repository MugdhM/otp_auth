import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'Verification.dart';
import 'user_signup.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode = "";
  bool isLoading = false;
  String mobileNumber = '';
  Icon? mobileIcon;
  Map<String, dynamic> jsonData = {};
  final TextEditingController phoneNumberController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState?.validate() == true) {
      print('Mobile Number: $mobileNumber');
    }
  }

  Future<void> verifyPhoneNumber(String phone) async {
    if (!validatePhoneNumber(phone)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await performPhoneVerification(phone);
    } catch (e) {
      handleVerificationError(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool validatePhoneNumber(String phone) {
    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 10-digit phone number.'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> performPhoneVerification(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phone", // Assuming Indian country code for demonstration
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            // Authentication successful, navigate to OTP screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Verification(verificationCode),
              ),
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verificationCode = verificationId;
        });
        // After code is sent, navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(verificationCode),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  void handleVerificationError(dynamic error) {
    String errorMessage = 'An error occurred during phone verification.';

    if (error is FirebaseAuthException) {
      if (error.code == 'invalid-phone-number') {
        errorMessage = 'Invalid phone number. Please check the format.';
      } else if (error.code == 'too-many-requests') {
        errorMessage = 'Too many verification attempts. Please try again later.';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void navigateToVerificationPage() {
    String phoneNumber = phoneNumberController.text;
    verifyPhoneNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 65),
                  child: Text(
                    'Login here',
                    style: TextStyle(
                      color: Color(0xFF1F41BB),
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Welcome back you’ve \n been missed!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Lottie.asset(
                  'assets/images/login.json', // Replace with the correct path
                  width: 260,
                  height: 255,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      IntlPhoneField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(),
                          suffixIcon: mobileIcon,
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          setState(() {
                            mobileNumber = phone.completeNumber;
                            mobileIcon = Icon(
                              Icons.check_circle,
                              color: phone.number.length == 10 ? Colors.green : Colors.transparent,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: isLoading ? null : navigateToVerificationPage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF1F41BB)), // Adjust the color
                  ),
                  child: Container(
                    width: 230,
                    height: 45,
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                    alignment: Alignment.center, // Move alignment here
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don’t have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text("Sign Up", style: TextStyle(color: Color(0xFF1F41BB))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}
