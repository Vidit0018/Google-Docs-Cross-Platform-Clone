import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String profilePic;
  final String uid;
  final String token;

  UserModel({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.token,
  });

  // Factory constructor for creating a UserModel instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      profilePic: json['profilePic'] as String,
      uid: json['_id'] as String,
      token: json['token'] as String,
    );
  }

  // Method to convert a UserModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'token': token,
    };
  }

  // Optional: Convert the UserModel to a JSON string
  String toJsonString() => json.encode(toJson());

  // Optional: Create a UserModel instance from a JSON string
  factory UserModel.fromJsonString(String source) =>
      UserModel.fromJson(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? uid,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }
}
