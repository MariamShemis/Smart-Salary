class UserModel {
  static const String collectionName = "users";

  String id;
  String name;
  String email;
  String phone;
  String? jobTitle;
  String? birthday;
  String? gender;
  String? image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.jobTitle,
    this.birthday,
    this.gender,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      jobTitle: json["jobTitle"],
      birthday: json["birthday"],
      gender: json["gender"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "jobTitle": jobTitle,
      "birthday": birthday,
      "gender": gender,
      "image": image,
    };
  }
}