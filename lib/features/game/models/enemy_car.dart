import 'dart:math';
import 'package:flutter/material.dart';
import 'game_object.dart';

enum VehicleType { truck, taxi, limousine, bus, van }

class EnemyCar extends GameObject {
  static const double _initialBaseSpeed = 3.0;
  double baseSpeed;
  double speed;
  final Color color;
  final Random _random = Random();
  final VehicleType vehicleType;

  EnemyCar()
      : baseSpeed = _initialBaseSpeed,
        speed = _initialBaseSpeed + Random().nextDouble() * 2,
        color = _getVehicleColor(
            VehicleType.values[Random().nextInt(VehicleType.values.length)]),
        vehicleType =
            VehicleType.values[Random().nextInt(VehicleType.values.length)],
        super(position: const Offset(0, -100));

  static Color _getVehicleColor(VehicleType type) {
    switch (type) {
      case VehicleType.truck:
        return Colors.grey[800]!;
      case VehicleType.taxi:
        return Colors.yellow[600]!;
      case VehicleType.limousine:
        return Colors.black;
      case VehicleType.bus:
        return Colors.blue[700]!;
      case VehicleType.van:
        return Colors.white;
    }
  }

  void adjustSpeed(double newSpeed) {
    speed = newSpeed;
    debugPrint('Araç hızı ayarlandı: $speed');
  }

  @override
  void update() {
    position = Offset(position.dx, position.dy + speed);
  }

  @override
  void render(Canvas canvas, Size size) {
    switch (vehicleType) {
      case VehicleType.truck:
        _renderTruck(canvas);
        break;
      case VehicleType.taxi:
        _renderTaxi(canvas);
        break;
      case VehicleType.limousine:
        _renderLimousine(canvas);
        break;
      case VehicleType.bus:
        _renderBus(canvas);
        break;
      case VehicleType.van:
        _renderVan(canvas);
        break;
    }
  }

  void _renderTruck(Canvas canvas) {
    const width = 70.0;
    const height = 120.0;
    const cabinHeight = 40.0;

    // Kamyon kasası
    final bodyPath = Path()
      ..moveTo(position.dx - width / 2, position.dy + height / 2)
      ..lineTo(position.dx - width / 2, position.dy - height / 2 + cabinHeight)
      ..lineTo(position.dx + width / 2, position.dy - height / 2 + cabinHeight)
      ..lineTo(position.dx + width / 2, position.dy + height / 2)
      ..close();

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // Kabin
    final cabinPath = Path()
      ..moveTo(position.dx - width / 2, position.dy - height / 2 + cabinHeight)
      ..lineTo(position.dx - width / 2, position.dy - height / 2)
      ..lineTo(position.dx, position.dy - height / 2)
      ..lineTo(position.dx + width / 4, position.dy - height / 2 + cabinHeight)
      ..close();

    final cabinPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawPath(cabinPath, cabinPaint);

    _drawWheels(canvas, width, height, 12); // Büyük tekerlekler
  }

  void _renderTaxi(Canvas canvas) {
    const width = 50.0;
    const height = 90.0;

    // Taksi gövdesi
    final bodyPath = Path()
      ..moveTo(position.dx - width / 2, position.dy + height / 2)
      ..lineTo(position.dx - width / 2, position.dy)
      ..quadraticBezierTo(
        position.dx - width / 2,
        position.dy - height / 2,
        position.dx,
        position.dy - height / 2,
      )
      ..quadraticBezierTo(
        position.dx + width / 2,
        position.dy - height / 2,
        position.dx + width / 2,
        position.dy,
      )
      ..lineTo(position.dx + width / 2, position.dy + height / 2)
      ..close();

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // Taksi işareti
    final signPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(position.dx, position.dy - height / 2 + 10),
        width: 20,
        height: 10,
      ),
      signPaint,
    );

    _drawWheels(canvas, width, height, 8);
  }

  void _renderLimousine(Canvas canvas) {
    const width = 50.0;
    const height = 140.0;

    // Limuzin gövdesi
    final bodyPath = Path()
      ..moveTo(position.dx - width / 2, position.dy + height / 2)
      ..lineTo(position.dx - width / 2, position.dy - height / 4)
      ..quadraticBezierTo(
        position.dx - width / 2,
        position.dy - height / 2,
        position.dx,
        position.dy - height / 2,
      )
      ..quadraticBezierTo(
        position.dx + width / 2,
        position.dy - height / 2,
        position.dx + width / 2,
        position.dy - height / 4,
      )
      ..lineTo(position.dx + width / 2, position.dy + height / 2)
      ..close();

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // Pencereler
    final windowPaint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          position.dx - width / 4,
          position.dy - height / 3 + (i * 25),
          width / 2,
          20,
        ),
        windowPaint,
      );
    }

    _drawWheels(canvas, width, height, 8);
  }

  void _renderBus(Canvas canvas) {
    const width = 65.0;
    const height = 130.0;

    // Otobüs gövdesi
    final bodyPath = Path()
      ..moveTo(position.dx - width / 2, position.dy + height / 2)
      ..lineTo(position.dx - width / 2, position.dy - height / 2 + 20)
      ..quadraticBezierTo(
        position.dx - width / 2,
        position.dy - height / 2,
        position.dx - width / 3,
        position.dy - height / 2,
      )
      ..lineTo(position.dx + width / 2, position.dy - height / 2)
      ..lineTo(position.dx + width / 2, position.dy + height / 2)
      ..close();

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // Pencereler
    final windowPaint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          position.dx - width / 2 + 5,
          position.dy - height / 2 + 25 + (i * 25),
          width - 10,
          20,
        ),
        windowPaint,
      );
    }

    _drawWheels(canvas, width, height, 10);
  }

  void _renderVan(Canvas canvas) {
    const width = 60.0;
    const height = 100.0;

    // Van gövdesi
    final bodyPath = Path()
      ..moveTo(position.dx - width / 2, position.dy + height / 2)
      ..lineTo(position.dx - width / 2, position.dy - height / 4)
      ..quadraticBezierTo(
        position.dx - width / 2,
        position.dy - height / 2,
        position.dx + width / 2,
        position.dy - height / 2,
      )
      ..lineTo(position.dx + width / 2, position.dy + height / 2)
      ..close();

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // Yan kapı
    final doorPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - width / 4,
        position.dy - height / 4,
        width / 2,
        height / 2,
      ),
      doorPaint,
    );

    _drawWheels(canvas, width, height, 10);
  }

  void _drawWheels(
      Canvas canvas, double width, double height, double wheelSize) {
    final wheelPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final wheelRimPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    void drawWheel(double x, double y) {
      canvas.drawCircle(
        Offset(x, y),
        wheelSize,
        wheelPaint,
      );
      canvas.drawCircle(
        Offset(x, y),
        wheelSize / 2,
        wheelRimPaint,
      );
    }

    // Ön tekerlekler
    drawWheel(position.dx - width / 2 + wheelSize, position.dy - height / 4);
    drawWheel(position.dx + width / 2 - wheelSize, position.dy - height / 4);

    // Arka tekerlekler
    drawWheel(position.dx - width / 2 + wheelSize, position.dy + height / 4);
    drawWheel(position.dx + width / 2 - wheelSize, position.dy + height / 4);
  }

  bool isOffScreen() {
    return position.dy > 1000;
  }

  void initializePosition(double screenWidth) {
    final lanes = [
      screenWidth * 0.25,
      screenWidth * 0.5,
      screenWidth * 0.75,
    ];

    final laneIndex = _random.nextInt(3);
    position = Offset(lanes[laneIndex], -100);
    debugPrint('Düşman araç başlangıç pozisyonu: $position');
  }
}
