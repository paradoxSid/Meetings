/// Stores information about user
class User {
  String authToken;
  String email;
  String firstName;
  String lastName;
  String address;
  String phoneNumber;

  User(
    this.authToken,
    this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.phoneNumber,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['auth_token'] as String,
        json['email'] as String,
        json['first_name'] as String,
        json['last_name'] as String,
        json['address'] as String,
        json['phone_number'] as String,
      );

  Map<String, dynamic> toJson() => {
        'auth_token': authToken,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'phone_number': phoneNumber,
      };
}
