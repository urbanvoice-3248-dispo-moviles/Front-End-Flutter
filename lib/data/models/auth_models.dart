import '../../domain/entities/statistics.dart';

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginResponse {
  final int userId;
  final String email;
  final String token;

  const LoginResponse({
    required this.userId,
    required this.email,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['user_id'] as int,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }
}

class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ForgotPasswordResponse {
  final String message;
  final String? token;

  const ForgotPasswordResponse({required this.message, this.token});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] as String,
      token: json['token'] as String?,
    );
  }
}

class ResetPasswordRequest {
  final String token;
  final String newPassword;

  const ResetPasswordRequest({required this.token, required this.newPassword});

  Map<String, dynamic> toJson() => {'token': token, 'new_password': newPassword};
}

class StatisticsResponseDto {
  final int totalReports;
  final Map<String, int> reportsByType;
  final Map<String, int> reportsByStatus;

  const StatisticsResponseDto({
    required this.totalReports,
    required this.reportsByType,
    required this.reportsByStatus,
  });

  factory StatisticsResponseDto.fromJson(Map<String, dynamic> json) {
    return StatisticsResponseDto(
      totalReports: json['total_reports'] as int? ?? 0,
      reportsByType: (json['reports_by_type'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          {},
      reportsByStatus: (json['reports_by_status'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          {},
    );
  }

  ReportStatistics toEntity() => ReportStatistics(
        totalReports: totalReports,
        reportsByType: reportsByType,
        reportsByStatus: reportsByStatus,
      );
}
