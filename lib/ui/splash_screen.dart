import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaurant_app/common/style.dart';
import 'home_page.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/splash_screen';

  const SplashScreenPage({super.key});
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingWidget(),
            const SizedBox(height: 20),
            Image.asset(
              'assets/restaurant.png',
              width: 100,
              height: 100
            ),
            const SizedBox(height: 20),
            const Text(
              'Restaurant App',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: secondColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: secondColor,
        secondRingColor: Colors.white,
        thirdRingColor: Colors.grey,
        size: 50,
      ),
    );
  }
}
