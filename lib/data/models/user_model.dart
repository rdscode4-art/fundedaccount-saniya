class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isVerified;
  final bool isKycVerified;
  final bool twoFactorEnabled;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isVerified = false,
    this.isKycVerified = false,
    this.twoFactorEnabled = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      isVerified: json['is_verified'] ?? false,
      isKycVerified: json['is_kyc_verified'] ?? false,
      twoFactorEnabled: json['two_factor_enabled'] ?? false,
    );
  }
}