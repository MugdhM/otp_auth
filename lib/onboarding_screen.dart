import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_login.dart';
import 'user_signup.dart';

class Onboarding3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 428,
            height: 750,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -80,
                  top: -180,
                  child: Container(
                    width: 372,
                    height: 372,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4699999988079071),
                    ),
                  ),
                ),
                Positioned(
                  left: -180,
                  top: 400,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(0.47),
                    child: Container(
                      width: 372,
                      height: 372,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Color(0xFFF1F4FF)),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -400.70,
                  top: 470,
                  child: Container(
                    width: 496,
                    height: 496,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Color(0xFFF1F4FF)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: -360,
                  child: Container(
                    width: 635,
                    height: 635,
                    decoration: ShapeDecoration(
                      shape: OvalBorder(
                        side: BorderSide(width: 3, color: Color(0xFFF7F9FF)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 148,
                  top: -400,
                  child: Container(
                    width: 635,
                    height: 635,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF7F9FF),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<Map<String, String>> onBoardingData = [
    {
      "image": 'assets/images/1.jpg',
      "title": 'Welcome to Sustaina',
      "description":
          'Join us to monitor and manage your water and electricity for a sustainable lifestyle.'
    },
    {
      "image": 'assets/images/2.jpg',
      "title": 'Smart Water Management',
      "description":
          'Optimize water usage for a sustainable lifestyle with personalized tools.'
    },
    {
      "image": 'assets/images/3.jpg',
      "title": 'Save Your Electricity Bills ',
      "description":
          'Cut costs and reduce your electricity bills with efficient usage tips.'
    },
    {
      "image": 'assets/images/4.jpg',
      "title": 'Make Your Home Energy Efficient ',
      "description":
          'Use our app to optimize your home for energy efficiency, promoting a more sustainable future.'
    },
  ];

  Color whiteColor = Colors.white;
  Color otherColor = const Color(0xFF19173D);

  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    bool onboardingCompleted = await isOnboardingCompleted();

    if (onboardingCompleted) {
      // Onboarding has been completed, navigate to the desired screen
      navigateToHome(); // Replace with your desired screen
    }
  }

  Future<bool> isOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  void markOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_completed', true);
  }

  void onChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  void goToNextPage() {
    if (currentPage < onBoardingData.length - 1) {
      pageController.animateToPage(currentPage + 1,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void skipToLastPage() {
    pageController.jumpToPage(onBoardingData.length - 1);
  }

  void onOnboardingCompleted() {
    markOnboardingCompleted();
    // Navigate to the next screen (e.g., home screen)
    navigateToHome(); // Replace with your desired screen
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your home screen
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: currentPage < 3
            ? [
                TextButton(
                  onPressed: skipToLastPage,
                  child: Text(
                    'Skip',
                    style: TextStyle(color: otherColor),
                  ),
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          // Background Widget (Onboarding3)
          Onboarding3(),

          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemCount: onBoardingData.length,
            onPageChanged: onChanged,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 48, right: 48),
                    child: Container(
                      width: 297.86,
                      height: 278,
                      child: Image.asset(onBoardingData[index]['image']!),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 43, right: 42, top: 20),
                    child: Text(
                      onBoardingData[index]['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                        color: Color(0xFF1F41BB),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 42, right: 42, bottom: 120),
                    child: Text(
                      onBoardingData[index]['description']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (currentPage < 3)
            Positioned(
              bottom: 20,
              left: 20,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: List<Widget>.generate(
                    onBoardingData.length,
                    (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 10,
                        width: (index == currentPage) ? 20 : 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (index == currentPage)
                              ? Color.fromARGB(255, 31, 65, 187)
                              : Color.fromARGB(237, 237, 237, 237),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          if (currentPage < onBoardingData.length - 1)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: goToNextPage,
                backgroundColor: Color(0xFF1F41BB),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),

          if (currentPage == (onBoardingData.length - 1))
            Positioned(
              bottom: 20,
              left: 40,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: onOnboardingCompleted,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10), backgroundColor: Color(0xFF1F41BB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xFFCAD6FF),
                    elevation: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (currentPage == (onBoardingData.length - 1))
            Positioned(
              bottom: 20,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 60),
                child: TextButton(
                  onPressed: () {
                    // Navigate to the signup page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF0A0A0A), backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0A0A0A),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: OnBoardingScreen()));
}
