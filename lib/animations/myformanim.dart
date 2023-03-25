import 'package:flutter/material.dart';

class MyFormAnimation extends StatefulWidget {
  @override
  _MyFormAnimationState createState() => _MyFormAnimationState();
}

class _MyFormAnimationState extends State<MyFormAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _animationController.forward();
      // Perform form submission here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Form'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: _animationController.value * 100,
                  height: _animationController.value * 100,
                  child: child,
                );
              },
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue.shade900,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
