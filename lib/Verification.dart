import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verification extends StatefulWidget {
  final String verificationCode;

  Verification(this.verificationCode, {Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtp(BuildContext context, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          // OTP verification successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP verified successfully!'),
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate to the home page
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    } catch (e) {
      // Handle OTP verification failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP verification failed. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  String _code = '';
  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
        timer.cancel();
      });
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex == 3) _currentIndex = 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Lottie.asset(
                        'assets/images/number.json',
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "OTP Verification",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Enter the OTP sent to your phone number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 14,
                  color: Color(0xFF0B0A0A),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: widget.otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: 'Enter OTP',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code?",
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isResendAgain) return;
                      resend();
                    },
                    child: Text(
                      _isResendAgain ? "Try again in $_start seconds" : "Resend New",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  )
                ],
              ),
              SizedBox(height: 135),
              MaterialButton(
                elevation: 0,
                onPressed: () {
                  String enteredOtp = widget.otpController.text;
                  widget.verifyOtp(context, enteredOtp); // Pass context here
                },
                color: Color(0xFF1F41BB),
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 3,
                        color: Colors.black,
                      )
                    : _isVerified
                        ? Icon(Icons.check_circle, color: Colors.white, size: 30)
                        : Text(
                            "Verify",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
