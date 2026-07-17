class EditProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? jobTitle;
  final String? birthday;
  final String? gender;
  final String? image;

  EditProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    this.jobTitle,
    this.birthday,
    this.gender,
    this.image,
  });

  factory EditProfileModel.fromJson(Map<String,dynamic> json){
    return EditProfileModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      jobTitle: json["jobTitle"] ?? "",
      birthday: json["birthday"] ?? "",
      gender: json["gender"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name":name,
      "email":email,
      "phone":phone,
      "jobTitle":jobTitle,
      "birthday":birthday,
      "gender":gender,
      "image":image,
    };
  }
}