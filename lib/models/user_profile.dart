class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final Gender gender;
  final double heightCm;
  final double weightKg;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
  });

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    Gender? gender,
    double? heightCm,
    double? weightKg,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}

enum Gender { male, female, other }
