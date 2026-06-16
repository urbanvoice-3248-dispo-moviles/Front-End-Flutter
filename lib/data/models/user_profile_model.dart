import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  final int id;
  final String name;
  final String lastName;
  final int age;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int,
      name: json['name'] as String,
      lastName: json['last_name'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'age': age,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      lastName: lastName,
      age: age,
      email: email,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class CreateProfileRequest {
  final String name;
  final String lastName;
  final int age;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final String password;

  const CreateProfileRequest({
    required this.name,
    required this.lastName,
    required this.age,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'last_name': lastName,
      'age': age,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'password': password,
    };
  }
}

class UpdateProfileRequest {
  final String name;
  final String lastName;
  final int age;
  final String phoneNumber;
  final String? profileImageUrl;

  const UpdateProfileRequest({
    required this.name,
    required this.lastName,
    required this.age,
    required this.phoneNumber,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'last_name': lastName,
      'age': age,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
    };
  }
}
