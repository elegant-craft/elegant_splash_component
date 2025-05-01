import 'package:flutter/material.dart';
import 'package:elegant_progress_bar/elegant_progress_bar.dart';

class SplashScreen extends StatelessWidget {
  final ImageProvider logo;
  final Stream<double> progressStream;
  final VoidCallback? onComplete;
  final Color backgroundColor;

  const SplashScreen({
    Key? key,
    required this.logo,
    required this.progressStream,
    this.onComplete,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: StreamBuilder<double>(
          stream: progressStream,
          initialData: 0,
          builder: (context, snapshot) {
            final p = (snapshot.data ?? 0).clamp(0.0, 1.0);
            if (p >= 1.0) onComplete?.call();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: logo, width: 120),
                SizedBox(height: 24),
                ProgressBar(progress: p),
              ],
            );
          },
        ),
      ),
    );
  }
}