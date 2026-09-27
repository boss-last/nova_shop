class UserProfile {
  final String id;
  final String name;
  final String email;
  final String city;
  final String avatarUrl;
  final String memberSince;
  final int ordersCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
    required this.avatarUrl,
    required this.memberSince,
    required this.ordersCount,
  });
}
