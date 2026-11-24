class Center {
  final String id;
  final String centerName;
  final String centerCode;
  final String primaryContactName;
  final String countryCode;
  final String mobileNumber;
  final String email;
  final String address;
  final bool isActive;

  const Center({
    required this.id,
    required this.centerName,
    required this.centerCode,
    required this.primaryContactName,
    required this.countryCode,
    required this.mobileNumber,
    required this.email,
    this.address = '',
    this.isActive = true,
  });

  factory Center.fromJson(Map<String, dynamic> json) {
    return Center(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      centerName: (json['centerName'] ?? '').toString(),
      centerCode: (json['centerCode'] ?? '').toString(),
      primaryContactName: (json['primaryContactName'] ?? '').toString(),
      countryCode: (json['countryCode'] ?? '+92').toString(),
      mobileNumber: (json['mobileNumber'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : true,
    );
  }
}