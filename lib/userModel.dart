class User {
  final String imei;
  final String firstName;
  final String lastName;
  final String passportId;
  final String dob;
  final String email;
  final String photo;
  final String deviceName;
  final double latitude;
  final double longitude;

  User(this.imei, this.firstName, this.lastName, this.passportId, this.dob,
      this.email, this.photo, this.deviceName, this.latitude, this.longitude);

  Map<String, dynamic> toMap() {
    return {
      'imei': imei,
      'firstName': firstName,
      'lastName': lastName,
      'passportId': passportId,
      'dob': dob,
      'email': email,
      'photo': photo,
      'deviceName': deviceName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
