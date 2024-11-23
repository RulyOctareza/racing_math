import 'package:flutter/material.dart';

class RaceTrackPainter extends CustomPainter {
  final double playerPosition;
  final double computerPosition;
  final int questionsAnswered; // Tambahkan ini untuk tracking progress

  RaceTrackPainter({
    required this.playerPosition,
    required this.computerPosition,
    this.questionsAnswered = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Setup paint untuk track
    final trackPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40.0;

    // Setup paint untuk border track
    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Paint untuk garis start/finish
    final startFinishPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    // Paint untuk checkpoint
    final checkpointPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Paint untuk mobil
    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    final computerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Membuat path untuk track
    final trackPath = Path();
    const double padding = 50.0;
    final double width = size.width - (padding * 2);
    final double height = size.height - (padding * 2);

    // Definisi track
    trackPath.moveTo(padding, size.height - padding); // Start point
    trackPath.lineTo(width + padding, size.height - padding); // Bottom
    trackPath.lineTo(width + padding, padding); // Right
    trackPath.lineTo(padding, padding); // Top
    trackPath.lineTo(padding, size.height - padding); // Left (back to start)

    // Gambar track dan border
    canvas.drawPath(trackPath, trackPaint);
    canvas.drawPath(trackPath, borderPaint);

    // Gambar garis start/finish
    final startLine = Path()
      ..moveTo(padding - 20, size.height - padding)
      ..lineTo(padding + 20, size.height - padding);
    canvas.drawPath(startLine, startFinishPaint);

    // Mendapatkan metrics untuk track
    final pathMetrics = trackPath.computeMetrics().first;
    final totalLength = pathMetrics.length;

    // Gambar checkpoint untuk setiap pertanyaan (3 checkpoint per lap)
    for (int i = 1; i <= 5; i++) {
      final checkpointPosition = (totalLength / 5) * i;
      final checkpointTangent =
          pathMetrics.getTangentForOffset(checkpointPosition);
      if (checkpointTangent != null) {
        // Gambar garis checkpoint
        canvas.drawCircle(
          checkpointTangent.position,
          5,
          checkpointPaint..style = PaintingStyle.fill,
        );

        // Tambahkan label checkpoint
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          checkpointTangent.position.translate(-6, -6),
        );
      }
    }

    // Gambar mobil
    final playerTangent = pathMetrics.getTangentForOffset(
      pathMetrics.length * playerPosition,
    );
    final computerTangent = pathMetrics.getTangentForOffset(
      pathMetrics.length * computerPosition,
    );

    if (playerTangent != null) {
      canvas.drawCircle(playerTangent.position, 10, playerPaint);
    }

    if (computerTangent != null) {
      canvas.drawCircle(computerTangent.position, 10, computerPaint);
    }

    // Draw progress indicator
    // final progressText = TextPainter(
    //   text: TextSpan(
    //     text: 'Q: ${questionsAnswered}/3',
    //     style: const TextStyle(color: Colors.white, fontSize: 14),
    //   ),
    //   textDirection: TextDirection.ltr,
    // );
    // progressText.layout();
    // progressText.paint(canvas, Offset(size.width - 80, 20));
  }

  @override
  bool shouldRepaint(RaceTrackPainter oldDelegate) {
    return oldDelegate.playerPosition != playerPosition ||
        oldDelegate.computerPosition != computerPosition ||
        oldDelegate.questionsAnswered != questionsAnswered;
  }
}
