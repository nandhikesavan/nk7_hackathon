class UserData {
  // Basic user info
  String name;
  String gender;
  bool isPresent;
  DateTime? lastAttendanceTime;

  // Optional ID field
  String? userId;

  // Additional fields
  String role;
  DateTime? dob;
  String country;
  String state;
  String district;
  String city;
  String address;
  String area;
  String phoneNumber;
  String experience;
  String profileImage;

  // ✅ Bus Details
  String busNumber;
  String busDriverName;
  String busNumberPlate;

  // Constructor
  UserData({
    required this.name,
    required this.gender,
    this.isPresent = false,
    this.lastAttendanceTime,
    this.userId,
    this.role = '',
    this.dob,
    this.country = 'India',
    this.state = '',
    this.district = '',
    this.city = '',
    this.address = '',
    this.area = '',
    this.phoneNumber = '+91',
    this.experience = '',
    this.profileImage = '',
    this.busNumber = '',
    this.busDriverName = '',
    this.busNumberPlate = '',
  });

  // ✅ TO JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'isPresent': isPresent,
      'lastAttendanceTime': lastAttendanceTime?.toIso8601String(),
      'userId': userId,
      'role': role,
      'dob': dob?.toIso8601String(),
      'country': country,
      'state': state,
      'district': district,
      'city': city,
      'address': address,
      'area': area,
      'phoneNumber': phoneNumber,
      'experience': experience,
      'profileImage': profileImage,
      'busNumber': busNumber,
      'busDriverName': busDriverName,
      'busNumberPlate': busNumberPlate,
    };
  }

  // ✅ FROM JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      isPresent: json['isPresent'] ?? false,
      lastAttendanceTime:
          json['lastAttendanceTime'] != null
              ? DateTime.tryParse(json['lastAttendanceTime'])
              : null,
      userId: json['userId'],
      role: json['role'] ?? '',
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      country: json['country'] ?? 'India',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '+91',
      experience: json['experience'] ?? '',
      profileImage: json['profileImage'] ?? '',
      busNumber: json['busNumber'] ?? '',
      busDriverName: json['busDriverName'] ?? '',
      busNumberPlate: json['busNumberPlate'] ?? '',
    );
  }

  // ✅ Toggle attendance status
  void toggleAttendance() {
    isPresent = !isPresent;
    lastAttendanceTime = DateTime.now();
  }

  // ✅ Format user data for display
  Map<String, String> getDisplayData() {
    return {
      'Name': name.isNotEmpty ? name : 'Not provided',
      'Gender': gender.isNotEmpty ? gender : 'Not provided',
      'Role': role.isNotEmpty ? role : 'Not provided',
      'Date of Birth':
          dob != null
              ? '${dob!.day.toString().padLeft(2, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.year}'
              : 'Not provided',
      'Country': country,
      'State': state.isNotEmpty ? state : 'Not provided',
      'District': district.isNotEmpty ? district : 'Not provided',
      'City': city.isNotEmpty ? city : 'Not provided',
      'Address': address.isNotEmpty ? address : 'Not provided',
      'Area': area.isNotEmpty ? area : 'Not provided',
      'Phone Number': phoneNumber.isNotEmpty ? phoneNumber : 'Not provided',
      'Experience': experience.isNotEmpty ? experience : 'Not provided',
      'Attendance Status': isPresent ? 'Present' : 'Absent',
      'Last Attendance Time':
          lastAttendanceTime != null
              ? '${lastAttendanceTime!.day.toString().padLeft(2, '0')}-${lastAttendanceTime!.month.toString().padLeft(2, '0')}-${lastAttendanceTime!.year} ${lastAttendanceTime!.hour}:${lastAttendanceTime!.minute}'
              : 'Not recorded',
      'Bus Number': busNumber.isNotEmpty ? busNumber : 'Not provided',
      'Bus Driver Name':
          busDriverName.isNotEmpty ? busDriverName : 'Not provided',
      'Bus Number Plate':
          busNumberPlate.isNotEmpty ? busNumberPlate : 'Not provided',
    };
  }

  // ✅ Reset all fields
  void reset() {
    name = '';
    gender = '';
    isPresent = false;
    lastAttendanceTime = null;
    role = '';
    dob = null;
    country = 'India';
    state = '';
    district = '';
    city = '';
    address = '';
    area = '';
    phoneNumber = '+91';
    experience = '';
    profileImage = '';
    busNumber = '';
    busDriverName = '';
    busNumberPlate = '';
    userId = null;
  }
}
