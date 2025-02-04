import 'dart:math';
import 'package:flutter/material.dart';
import 'game_object.dart';

class PlayerCar extends GameObject {
  static const double speed = 5.0; // Sabit hız
  double _horizontalPosition;

  PlayerCar()
      : _horizontalPosition = 0.5, // Başlangıçta ortada
        super(position: Offset.zero);

  void setHorizontalPosition(double screenWidth, Offset pointerPosition) {
    // Ekran genişliğine göre yatay pozisyonu güncelle
    _horizontalPosition = (pointerPosition.dx / screenWidth).clamp(0.1, 0.9);
  }

  @override
  void update() {
    // Pozisyon render'da güncelleniyor
  }

  @override
  void render(Canvas canvas, Size size) {
    position = Offset(size.width * _horizontalPosition, size.height - 100);

    // Ferrari kırmızısı gövde rengi ve gradyanı
    final bodyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFDC1F26), // Ferrari Kırmızısı
        const Color(0xFFA51C21), // Koyu Ferrari Kırmızısı
      ],
    );

    // Araba gövdesi için path
    final bodyPath = Path();

    // Gövde boyutları (daha alçak ve geniş)
    const width = 60.0;
    const height = 85.0;

    // Ferrari tarzı gövde şekli
    bodyPath.moveTo(
        position.dx - width / 2, position.dy + height / 2); // Sol alt

    // Sol taraf (kavisli)
    bodyPath.quadraticBezierTo(
      position.dx - width / 2, position.dy, // Kontrol noktası
      position.dx - width / 2.2, position.dy - height / 3, // Orta nokta
    );

    // Ön kaput (alçak ve sportif)
    bodyPath.quadraticBezierTo(
      position.dx - width / 3, position.dy - height / 1.8, // Kontrol noktası
      position.dx, position.dy - height / 1.7, // Burun noktası
    );

    // Sağ taraf (simetrik)
    bodyPath.quadraticBezierTo(
      position.dx + width / 3, position.dy - height / 1.8, // Kontrol noktası
      position.dx + width / 2.2, position.dy - height / 3, // Orta nokta
    );

    bodyPath.quadraticBezierTo(
      position.dx + width / 2, position.dy, // Kontrol noktası
      position.dx + width / 2, position.dy + height / 2, // Sağ alt
    );

    bodyPath.close();

    // Gövdeyi çiz
    final bodyPaint = Paint()
      ..shader = bodyGradient.createShader(
        Rect.fromCenter(
          center: position,
          width: width,
          height: height,
        ),
      );
    canvas.drawPath(bodyPath, bodyPaint);

    // Spor cam tasarımı
    final windowPath = Path();
    windowPath.moveTo(position.dx - width / 3, position.dy - height / 5);
    windowPath.quadraticBezierTo(
      position.dx - width / 4,
      position.dy - height / 2,
      position.dx,
      position.dy - height / 2.2,
    );
    windowPath.quadraticBezierTo(
      position.dx + width / 4,
      position.dy - height / 2,
      position.dx + width / 3,
      position.dy - height / 5,
    );
    windowPath.close();

    final windowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey[300]!,
          Colors.grey[800]!,
        ],
      ).createShader(
        Rect.fromCenter(
          center: position,
          width: width,
          height: height / 2,
        ),
      );
    canvas.drawPath(windowPath, windowPaint);

    // Ferrari logosu
    final logoPaint = Paint()
      ..color = Colors.yellow[700]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(position.dx, position.dy - height / 2 + 8),
      4,
      logoPaint,
    );

    // Spor jantlar
    final wheelPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final wheelRimPaint = Paint()
      ..color = const Color(0xFFCCCCCC) // Metalik gri
      ..style = PaintingStyle.fill;

    // Gelişmiş tekerlek fonksiyonu
    void drawWheel(double x, double y) {
      // Dış tekerlek
      canvas.drawCircle(
        Offset(x, y),
        9,
        wheelPaint,
      );
      // Metalik jant
      canvas.drawCircle(
        Offset(x, y),
        5,
        wheelRimPaint,
      );
      // Jant detayları
      for (var i = 0; i < 5; i++) {
        final angle = (i * 2 * pi) / 5;
        canvas.drawLine(
          Offset(x, y),
          Offset(x + cos(angle) * 4, y + sin(angle) * 4),
          Paint()..color = const Color(0xFFCCCCCC),
        );
      }
    }

    // Tekerlekleri çiz
    drawWheel(position.dx - width / 2 + 8, position.dy - height / 4); // Sol ön
    drawWheel(position.dx + width / 2 - 8, position.dy - height / 4); // Sağ ön
    drawWheel(
        position.dx - width / 2 + 8, position.dy + height / 4); // Sol arka
    drawWheel(
        position.dx + width / 2 - 8, position.dy + height / 4); // Sağ arka

    // Xenon farlar
    final headlightPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    // Modern far tasarımı
    canvas.drawPath(
      Path()
        ..moveTo(position.dx - width / 2.5, position.dy - height / 2 + 5)
        ..quadraticBezierTo(
          position.dx - width / 3,
          position.dy - height / 2 + 5,
          position.dx - width / 3.5,
          position.dy - height / 2 + 8,
        ),
      headlightPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(position.dx + width / 2.5, position.dy - height / 2 + 5)
        ..quadraticBezierTo(
          position.dx + width / 3,
          position.dy - height / 2 + 5,
          position.dx + width / 3.5,
          position.dy - height / 2 + 8,
        ),
      headlightPaint,
    );

    // LED stop lambaları
    final tailLightPaint = Paint()
      ..color = Colors.red[700]!
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    // Modern stop lambası tasarımı
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(position.dx, position.dy + height / 2 - 3),
        width: width * 0.6,
        height: 2,
      ),
      tailLightPaint,
    );

    // Aerodinamik detaylar
    final detailPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Yan çizgiler ve hava girişleri
    canvas.drawLine(
      Offset(position.dx - width / 2.2, position.dy - height / 4),
      Offset(position.dx - width / 4, position.dy - height / 4),
      detailPaint,
    );
    canvas.drawLine(
      Offset(position.dx + width / 4, position.dy - height / 4),
      Offset(position.dx + width / 2.2, position.dy - height / 4),
      detailPaint,
    );

    // Spor difüzör
    canvas.drawPath(
      Path()
        ..moveTo(position.dx - width / 3, position.dy + height / 2)
        ..lineTo(position.dx, position.dy + height / 2 - 5)
        ..lineTo(position.dx + width / 3, position.dy + height / 2),
      detailPaint,
    );

    // Neon efekti
    final neonPaint = Paint()
      ..color = const Color(0xFFDC1F26).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);

    canvas.drawPath(bodyPath, neonPaint);
  }

  bool checkCollision(GameObject other) {
    // Çarpışma kontrolü için arabaların boyutlarını kullan
    final carWidth = 60.0;
    final carHeight = 85.0;

    final thisRect = Rect.fromCenter(
      center: position,
      width: carWidth,
      height: carHeight,
    );

    final otherRect = Rect.fromCenter(
      center: other.position,
      width: carWidth,
      height: carHeight,
    );

    return thisRect.overlaps(otherRect);
  }
}
