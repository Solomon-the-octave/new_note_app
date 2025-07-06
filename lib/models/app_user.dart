class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data) => AppUser(
    id: data['id'] ?? '',
    name: data['fullName'] ?? '',
    email: data['email'] ?? '',
    phone: data['phone'],
  );
}