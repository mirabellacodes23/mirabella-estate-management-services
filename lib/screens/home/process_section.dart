// ===============================
// File: lib/screens/home/process_section.dart
// MEMS luxury six-step staircase process
// Responsive: staircase on desktop, vertical journey on mobile/tablet
// ===============================

import 'package:flutter/material.dart';

import '../../data/data.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key, this.onGetStarted});

  final VoidCallback? onGetStarted;

  static const _gold = Color(0xFFD6A84B);
  static const _lightGold = Color(0xFFFFD978);
  static const _darkGold = Color(0xFF6E4B13);

  void _fallback(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening contact section...')));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final clampedMq = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final icons = <IconData>[
      Icons.forum_outlined,
      Icons.fact_check_outlined,
      Icons.description_outlined,
      Icons.home_work_outlined,
      Icons.settings_outlined,
      Icons.trending_up_rounded,
    ];

    final titleSize = width >= 1100
        ? 46.0
        : width >= 700
        ? 36.0
        : 28.0;

    final subtitleSize = width >= 700 ? 17.0 : 15.0;

    return MediaQuery(
      data: clampedMq,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: width < 700 ? 18 : 36,
          vertical: width < 700 ? 20 : 10,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050505), Color(0xFF0B0B0B), Color(0xFF12100C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1350),
            child: Column(
              children: [
                // Header label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: _gold, width: 1.4),
                  ),
                  child: const Text(
                    'HOW IT WORKS',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Simple & Transparent Process',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 14),

                const _GoldDivider(),

                const SizedBox(height: 14),

                Text(
                  'A seamless six-step journey to stress-free property management.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFB8B8B8),
                    fontSize: subtitleSize,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: width >= 1000 ? 42 : 34),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final useStaircase = constraints.maxWidth >= 1000;

                    if (useStaircase) {
                      return _DesktopStaircase(icons: icons);
                    }

                    return _MobileProcessJourney(icons: icons);
                  },
                ),

                const SizedBox(height: 34),

                ElevatedButton.icon(
                  onPressed: () => (onGetStarted ?? () => _fallback(context))(),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('TALK TO A MEMS EXPERT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: const Color(0xFF111111),
                    elevation: 8,
                    shadowColor: _gold.withOpacity(0.35),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// DESKTOP STAIRCASE
// =======================================================

class _DesktopStaircase extends StatelessWidget {
  const _DesktopStaircase({required this.icons});

  final List<IconData> icons;

  static const List<double> _heights = [300, 340, 380, 420, 460, 500];

  @override
  Widget build(BuildContext context) {
    const stageHeight = 540.0;

    return SizedBox(
      height: stageHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: const _StaircaseLinePainter(cardHeights: _heights),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(processData.length, (index) {
                final step = processData[index];
                final cardHeight =
                    _heights[index < _heights.length
                        ? index
                        : _heights.length - 1];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 5,
                      right: index == processData.length - 1 ? 0 : 5,
                    ),
                    child: SizedBox(
                      height: cardHeight,
                      child: _StaircaseCard(
                        stepNumber: step.step,
                        title: step.title,
                        description: step.description,
                        icon: icons[index % icons.length],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaircaseCard extends StatefulWidget {
  const _StaircaseCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;

  @override
  State<_StaircaseCard> createState() => _StaircaseCardState();
}

class _StaircaseCardState extends State<_StaircaseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD6A84B);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.fromLTRB(14, 22, 14, 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B1B1B), Color(0xFF101010)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: _hovered ? const Color(0xFFFFD978) : const Color(0xFF76531C),
            width: _hovered ? 1.8 : 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? gold.withOpacity(0.30)
                  : Colors.black.withOpacity(0.50),
              blurRadius: _hovered ? 24 : 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF17130B),
                border: Border.all(color: gold, width: 1.3),
              ),
              child: Text(
                widget.stepNumber,
                style: const TextStyle(
                  color: gold,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Icon(widget.icon, color: gold, size: 42),

            const SizedBox(height: 16),

            Text(
              widget.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 12),

            Flexible(
              child: Text(
                widget.description,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 12.5,
                  height: 1.45,
                ),
              ),
            ),

            const SizedBox(height: 14),

            const SizedBox(
              width: 90,
              height: 22,
              child: CustomPaint(painter: _GoldWavePainter()),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// MOBILE / TABLET JOURNEY
// =======================================================

class _MobileProcessJourney extends StatelessWidget {
  const _MobileProcessJourney({required this.icons});

  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(processData.length, (index) {
        final step = processData[index];

        return _MobileProcessStep(
          stepNumber: step.step,
          title: step.title,
          description: step.description,
          icon: icons[index % icons.length],
          isLast: index == processData.length - 1,
        );
      }),
    );
  }
}

class _MobileProcessStep extends StatelessWidget {
  const _MobileProcessStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.isLast,
  });

  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD6A84B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF17130B),
                  border: Border.all(color: gold, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: gold.withOpacity(0.20), blurRadius: 12),
                  ],
                ),
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    color: gold,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 150,
                  color: const Color(0xFF76531C),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF4D3818)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2112),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: gold, size: 25),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color(0xFFB8B8B8),
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =======================================================
// HEADER DIVIDER
// =======================================================

class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Divider(color: Color(0xFF76531C), thickness: 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.diamond_outlined,
            color: Color(0xFFD6A84B),
            size: 13,
          ),
        ),
        SizedBox(
          width: 110,
          child: Divider(color: Color(0xFF76531C), thickness: 1),
        ),
      ],
    );
  }
}

// =======================================================
// GOLD CONNECTING LINE + ARROW
// =======================================================

class _StaircaseLinePainter extends CustomPainter {
  const _StaircaseLinePainter({required this.cardHeights});

  final List<double> cardHeights;

  @override
  void paint(Canvas canvas, Size size) {
    if (cardHeights.isEmpty) return;

    const gold = Color(0xFFD6A84B);
    const stageHeight = 540.0;

    final glowPaint = Paint()
      ..color = gold.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final linePaint = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < cardHeights.length; i++) {
      final x = ((i + 0.5) / cardHeights.length) * size.width;
      final y = stageHeight - cardHeights[i] - 8;
      points.add(Offset(x, y));
    }

    path.moveTo(points.first.dx - 40, points.first.dy);

    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      if (i == 0) {
        path.lineTo(point.dx, point.dy);
      } else {
        final previous = points[i - 1];
        final controlX = (previous.dx + point.dx) / 2;

        path.cubicTo(
          controlX,
          previous.dy,
          controlX,
          point.dy,
          point.dx,
          point.dy,
        );
      }
    }

    final endPoint = Offset(points.last.dx + 45, points.last.dy - 34);

    path.quadraticBezierTo(
      points.last.dx + 28,
      points.last.dy - 8,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, glowPaint);
    _drawDashedPath(canvas, path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFFFFD978);

    for (final point in points) {
      canvas.drawCircle(point, 4.5, dotPaint);
    }

    // Arrow head
    final arrowPaint = Paint()
      ..color = gold
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      endPoint,
      Offset(endPoint.dx - 13, endPoint.dy + 4),
      arrowPaint,
    );

    canvas.drawLine(
      endPoint,
      Offset(endPoint.dx - 5, endPoint.dy + 13),
      arrowPaint,
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashLength = 7.0;
    const gapLength = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final next = distance + dashLength;

        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );

        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StaircaseLinePainter oldDelegate) {
    return oldDelegate.cardHeights != cardHeights;
  }
}

class _GoldWavePainter extends CustomPainter {
  const _GoldWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const gold = Color(0xFFD6A84B);

    final glowPaint = Paint()
      ..color = gold.withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final linePaint = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.65)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.20,
        size.width * 0.32,
        size.height * 0.20,
        size.width * 0.50,
        size.height * 0.55,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.90,
        size.width * 0.80,
        size.height * 0.90,
        size.width,
        size.height * 0.35,
      );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _GoldWavePainter oldDelegate) {
    return false;
  }
}
