import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showStartButton = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      setState(() {
        _showStartButton = true;
      });
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0A0E21),
                    Colors.blueGrey[900]!,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Icon(
                      Icons.laptop_mac,
                      size: 120,
                      color: Colors.blueAccent[400],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // App Name with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'TechStore',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent[400],
                      shadows: [
                        Shadow(
                          blurRadius: 15.0,
                          color: Colors.blueAccent.withOpacity(0.6),
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Premium Laptops Collection',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey[300],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Start Button with slide animation
                if (_showStartButton)
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ElevatedButton(
                        onPressed: _navigateToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: Colors.blueAccent[400]!,
                              width: 2,
                            ),
                          ),
                          elevation: 8,
                          shadowColor: Colors.blueAccent.withOpacity(0.5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'START SHOPPING',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                // Loading indicator (only shows before button appears)
                if (!_showStartButton)
                  CircularProgressIndicator(
                    color: Colors.blueAccent[400],
                    strokeWidth: 3,
                  ),
              ],
            ),
          ),

          // Animated background elements
          Positioned(
            top: 100,
            left: 50,
            child: AnimatedOpacity(
              opacity: _showStartButton ? 0.3 : 0.1,
              duration: const Duration(seconds: 2),
              child: Icon(
                Icons.memory,
                size: 40,
                color: Colors.blueAccent[400]!.withOpacity(0.5),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            right: 50,
            child: AnimatedOpacity(
              opacity: _showStartButton ? 0.3 : 0.1,
              duration: const Duration(seconds: 2),
              child: Icon(
                Icons.computer,
                size: 40,
                color: Colors.blueAccent[400]!.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}