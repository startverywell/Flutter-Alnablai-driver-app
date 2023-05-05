import 'dart:developer' as developer;

class Profile {
  Profile({
    required this.username,
    required this.profileImage,
    required this.nameEN,
    required this.phone,
    required this.birthday,
    required this.address,
    required this.workingHours,
    required this.totalDistance,
    required this.totalTrips,
  });

  final String username; // email
  final String profileImage;
  final String nameEN;
  final String phone;
  final String birthday;
  final String address;
  final String workingHours;
  final String totalDistance;
  final int totalTrips;

  factory Profile.fromMap(Map<String, dynamic> data) {
    final driver = data['driver'];
    String datee = driver['age'];
    List<String> substrings = datee.split("-");

    String age = substrings[2] + "/" + substrings[1] + "/" + substrings[0];
    return Profile(
      username: driver['user_name'],
      profileImage: driver['profile_image'] ?? 'assets/images/user_avatar.png',
      nameEN: driver['name_en'],
      phone: driver['phone'],
      birthday: age,
      address: driver['address'] ?? '',
      // ! following data must be from server...
      // workingHours: double.parse(driver['workingHours']),
      workingHours: driver['workingHours'].toString(),
      totalDistance: driver['totalDistance'].toString(),
      totalTrips: driver['totalTrips'] ?? 0,
    );
  }

  // used for profile editing.
  Profile copyWith(
    String nameVal,
    String phoneVal,
    String birthdayVal,
    String addressVal,
  ) {
    return Profile(
        username: username,
        profileImage: profileImage,
        nameEN: nameVal,
        phone: phoneVal,
        birthday: birthdayVal,
        address: addressVal,
        workingHours: workingHours,
        totalDistance: totalDistance,
        totalTrips: totalTrips);
  }

  @override
  String toString() => 'Profile(username: $username, profile: $profileImage, '
      'nameEN: $nameEN, phone: $phone, birthday: $birthday, address: $address)';
}
