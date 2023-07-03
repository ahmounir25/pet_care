import 'package:pet_care/models/myUser.dart';

enum MyEnum { Cat, Dog, Turtle, Bird, Monkey, Fish, Other }

class Pet {
  static String collectionName = 'PETS';
  String id;
  String Name;
  String? age;
  String gender;
  String ownerName;
  String ownerID;
  String ownerPhone;
  String type;
  String? Image;
  String? qr;

  Pet(
      { this.id='',
      required this.Name,
      required this.age,
      required this.gender,
      required this.ownerName,
      required this.ownerID,
      required this.ownerPhone,
      required this.type,
      this.Image = null,
      this.qr}); // without pass cause i will n't save  or generate it

  Pet.fromJson(Map<String, dynamic> map)
      : this(
            id: map['id'],
            Name: map['Name'],
            age: map["age"],
            gender: map['gender'],
            ownerName: map["ownerName"],
            ownerID: map["ownerID"],
            ownerPhone: map["ownerPhone"],
            type: map["type"],
            Image: map["Image"],
            qr: map["qr"]);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Name": Name,
      "age": age,
      "gender": gender,
      "ownerName": ownerName,
      "ownerID": ownerID,
      "ownerPhone": ownerPhone,
      "type": type,
      "Image": Image,
      "qr": qr
    };
  }
}
