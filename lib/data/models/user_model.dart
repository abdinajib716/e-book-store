import '../../domain/entities/models/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.profilePicture,
    super.dateOfBirth,
    super.gender,
    required super.preferredLanguage,
    super.interests = const [],
    super.isEmailVerified = false,
    required super.createdAt,
    required super.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing user data: $json');
      return UserModel(
        id: json['id'] ?? json['_id'] ?? '',
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        phoneNumber: json['phoneNumber'],
        profilePicture: json['profilePicture'] ?? json['avatar'],
        dateOfBirth: json['dateOfBirth'] != null 
            ? DateTime.parse(json['dateOfBirth']) 
            : null,
        gender: json['gender'],
        preferredLanguage: json['preferredLanguage'] ?? 'en',
        interests: List<String>.from(json['interests'] ?? []),
        isEmailVerified: json['isEmailVerified'] ?? false,
        createdAt: json['createdAt'] != null 
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'])
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing user data: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'preferredLanguage': preferredLanguage,
      'interests': interests,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? profilePicture,
    DateTime? dateOfBirth,
    String? gender,
    String? preferredLanguage,
    List<String>? interests,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      interests: interests ?? List.from(this.interests),
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
