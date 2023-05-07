class SuperVisor {
  SuperVisor({
    required this.username,
    required this.profileImage,
    required this.phone,
  });

  final String username; // email
  final String profileImage;
  final String phone;

  factory SuperVisor.fromMap(Map<String, dynamic> data) {
    final superVisor = data;
    return SuperVisor(
      username: superVisor['name'],
      profileImage:
          superVisor['profile_image'] ?? 'assets/images/user_avatar.png',
      phone: superVisor['phone'],
    );
  }

  @override
  String toString() =>
      'SuperVisor(username: $username, profile: $profileImage, phone: $phone)';
}

typedef SuperVisorList = List<SuperVisor>;
