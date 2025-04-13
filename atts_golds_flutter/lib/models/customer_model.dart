class CustomerModel {
  final String id;
  final String name;
  final String mobile;

  CustomerModel({required this.id, required this.name, required this.mobile});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}
