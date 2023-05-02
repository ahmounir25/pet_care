import 'package:pet_care/models/Pet.dart';

class myUser {
  static String collectionName = 'USERS';
  String id;
  String Name;
  String phone;
  String email;
  String address;
  List<Pet>myPets=[];

  myUser(
      {required this.id,
      required this.Name,
      required this.phone,
      required this.email,
      required this.address}); // without pass cause i will n't save  or generate it

  myUser.fromJson(Map<String, dynamic> map)
      : this(
            id: map['id'],
            Name: map['Name'],
            phone: map["phone"],
            email: map['email'],
            address: map['address']);

  Map<String, dynamic> toJson() {
    return {"id": id, "Name": Name, "phone": phone, "email": email,"address":address};
  }
}
