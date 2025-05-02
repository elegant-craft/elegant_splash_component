import 'package:flutter/material.dart';
import 'package:elegant_progress_bar/elegant_progress_bar.dart';

class SplashScreen extends StatelessWidget {
  final ImageProvider logo;
  final double width;
  final double height;
  final BoxFit fit;
  final Stream<double> progressStream;
  final VoidCallback? onComplete;
  final Color backgroundColor;
  final Color? backgroundColorLight;
  final Color? backgroundColorNight;
  final double progressBarBottom;
  final List<Widget>? overlays;

  const SplashScreen({
    Key? key,
    required this.logo,
    this.width = 180,
    double? height,
    this.fit = BoxFit.fitWidth,
    required this.progressStream,
    this.onComplete,
    this.backgroundColor = const Color.fromARGB(255, 134, 220, 182),
    Color? backgroundColorLight,
    Color? backgroundColorNight,
    this.progressBarBottom = 100,
    this.overlays,
  })  : height = height ?? width,
        backgroundColorLight = backgroundColorLight,
        backgroundColorNight = backgroundColorNight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final bg = (brightness == Brightness.dark
            ? (backgroundColorNight ?? backgroundColor)
            : (backgroundColorLight ?? backgroundColor));

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Logo 居中，z轴高于背景
          Center(
            child: Image(
              image: logo,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
          // 可选的覆盖组件，z轴高于 logo，低于进度条
          if (overlays != null)
            ...overlays!.map((w) => Center(child: w)),
          // 进度条，基于距离底部的偏移
          Positioned(
            bottom: progressBarBottom,
            left: 0,
            right: 0,
            child: StreamBuilder<double>(
              stream: progressStream,
              initialData: 0,
              builder: (context, snapshot) {
                final p = (snapshot.data ?? 0).clamp(0.0, 1.0);
                if (p >= 1.0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onComplete?.call();
                  });
                }
                return ProgressBar(progress: p);
              },
            ),
          ),
        ],
      ),
    );
  }
}