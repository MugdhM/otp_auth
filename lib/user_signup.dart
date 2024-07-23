import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'Verification.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.\w{2,4})+$');
  final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]{1,64}$');
  final RegExp mobileRegExp = RegExp(r'^[0-9]{10}$');

  // Added to track whether the SnackBar is currently displayed
  bool _isErrorSnackBarVisible = false;

  // Method to show SnackBar with an error message
  void showErrorSnackBar(String errorMessage) {
    if (!_isErrorSnackBarVisible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
      _isErrorSnackBarVisible = true;

      // Set a timer to hide the SnackBar after a certain duration
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _isErrorSnackBarVisible = false;
        });
      });
    }
  }

  Container buildRoundedInputField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    Icon icon,
  ) {
    return Container(
      width: 357,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none,
          prefixIcon: icon,
        ),
        keyboardType: keyboardType,
        inputFormatters: [
          if (label == 'Username') FilteringTextInputFormatter.allow(nameRegExp),
          if (label == 'Phone Number') LengthLimitingTextInputFormatter(10),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            showErrorSnackBar('$label is required');
            return null;
          } else if (label == 'Username' && !nameRegExp.hasMatch(value)) {
            showErrorSnackBar('$label can only contain alphabets and spaces with a maximum length of 64 characters');
            return null;
          } else if (label == 'Email' && !emailRegExp.hasMatch(value)) {
            showErrorSnackBar('Invalid email format');
            return null;
          } else if (label == 'Phone Number' && (!mobileRegExp.hasMatch(value) || value.length != 10)) {
            showErrorSnackBar('Invalid phone number');
            return null;
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 70),
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Color(0xFF1F41BB),
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),

                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Join us to discover all sustainable usage insights',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 5),

                Lottie.asset(
                  'assets/images/signup.json', // Replace with your Lottie animation file path
                  width: 260,
                  height: 255,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 25),

                buildRoundedInputField(
                  nameController,
                  'Username',
                  TextInputType.text,
                  Icon(Icons.person),
                ),
                SizedBox(height: 26),

                buildRoundedInputField(
                  emailController,
                  'Email',
                  TextInputType.emailAddress,
                  Icon(Icons.email),
                ),
                SizedBox(height: 26),

                buildRoundedInputField(
                  mobileController,
                  'Phone Number',
                  TextInputType.phone,
                  Icon(Icons.phone),
                ),
                SizedBox(height: 45),

                ElevatedButton(
                  onPressed: () {
                    // Validate each field individually
                    if (_formKey.currentState!.validate()) {
                      final name = nameController.text;
                      final email = emailController.text;
                      final mobileNumber = mobileController.text;

                      // Additional checks for specific fields
                      if (!nameRegExp.hasMatch(name)) {
                        showErrorSnackBar('Username can only contain alphabets and spaces with a maximum length of 64 characters');
                        return;
                      }

                      if (!emailRegExp.hasMatch(email)) {
                        showErrorSnackBar('Invalid email format');
                        return;
                      }

                      if (!mobileRegExp.hasMatch(mobileNumber) || mobileNumber.length != 10) {
                        showErrorSnackBar('Invalid phone number');
                        return;
                      }

                      // All fields are valid, proceed to the Verification page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Verification("String"),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 31, 65, 187)),
                  ),
                  child: Container(
                    width: 230,
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Login", style: TextStyle(color: Color(0xFF1F41BB))),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
