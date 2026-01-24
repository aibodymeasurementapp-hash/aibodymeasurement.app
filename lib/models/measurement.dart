class Measurement {
  final String id;
  final double shirtLength;
  final double waist;
  final double chest;
  final double shoulder;
  final double sleevesLength;
  final double hip;
  final double inseam;
  final String additionalInstructions;
  final DateTime createdAt;

  Measurement({
    required this.id,
    required this.shirtLength,
    required this.waist,
    required this.chest,
    required this.shoulder,
    required this.sleevesLength,
    required this.hip,
    required this.inseam,
    required this.additionalInstructions,
    required this.createdAt,
  });

  Measurement copyWith({
    String? id,
    double? shirtLength,
    double? waist,
    double? chest,
    double? shoulder,
    double? sleevesLength,
    double? hip,
    double? inseam,
    String? additionalInstructions,
    DateTime? createdAt,
  }) {
    return Measurement(
      id: id ?? this.id,
      shirtLength: shirtLength ?? this.shirtLength,
      waist: waist ?? this.waist,
      chest: chest ?? this.chest,
      shoulder: shoulder ?? this.shoulder,
      sleevesLength: sleevesLength ?? this.sleevesLength,
      hip: hip ?? this.hip,
      inseam: inseam ?? this.inseam,
      additionalInstructions: additionalInstructions ?? this.additionalInstructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MeasurementResult {
  final String id;
  final double shoulderWidth;
  final double chest;
  final double waist;
  final double hip;
  final double leftArmLength;
  final double rightArmLength;
  final double leftLegLength;
  final double rightLegLength;
  final double height;
  final DateTime createdAt;

  MeasurementResult({
    required this.id,
    required this.shoulderWidth,
    required this.chest,
    required this.waist,
    required this.hip,
    required this.leftArmLength,
    required this.rightArmLength,
    required this.leftLegLength,
    required this.rightLegLength,
    required this.height,
    required this.createdAt,
  });
}
