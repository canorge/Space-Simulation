class StepMotor {
  final double stepAngle = 0.6;
  double currentAngle = 0;

  StepMotor();

  double snapToStep(double angle) {
    return (angle / stepAngle).round() * stepAngle;
  }

Future<void> moveTo(
  double targetAngle, {
  int stepDelay = 20,
  required Function(double) onStep,
}) async {
  targetAngle = snapToStep(targetAngle);
  currentAngle = snapToStep(currentAngle);

  int direction = targetAngle > currentAngle ? 1 : -1;

  int steps = ((targetAngle - currentAngle).abs() / stepAngle).round();
  print("Adım sayısı: $steps, Hedef açı: $targetAngle, Mevcut açı: $currentAngle");
  for (int i = 0; i < steps; i++) {
    //await Future.delayed(Duration(milliseconds: 100));
    currentAngle += direction * stepAngle;
    currentAngle = snapToStep(currentAngle);
    print("Adım ${i + 1}/$steps, Yeni açı: $currentAngle");
    onStep(currentAngle); // Arayüzü güncelle
    await Future.delayed(Duration(milliseconds: stepDelay));
  }
}

}
