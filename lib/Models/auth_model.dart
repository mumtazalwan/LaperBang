class AuthResponseModel {
  final bool success;
  final UserModel? user;
  final String? token;

  AuthResponseModel({
    required this.success,
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      user: json['data'] != null && json['data']['user'] != null
          ? UserModel.fromJson(json['data']['user'])
          : null,
      token: json['data'] != null ? json['data']['token'] : null,
    );
  }
}

class UserModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String role;
  final String? description;
  final String? vendorStatus;
  final Map<String, dynamic>? vendorAdditionalInfo;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
    this.description,
    this.vendorStatus,
    this.vendorAdditionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      description: json['description'],
      vendorStatus: json['vendor_status'],
      vendorAdditionalInfo: json['vendor_additional_info'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}