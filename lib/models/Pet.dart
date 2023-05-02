import 'package:pet_care/models/myUser.dart';

enum MyEnum { Cat, Dog, Turtle, Bird, Monkey, Fish, Other }

class Pet {
  static String collectionName = 'PETS';
  String id = '';
  String Name;
  int? age;
  String gender;
  String ownerName;
  String ownerID;
  String type;

  Pet(
      {required this.Name,
      required this.age,
      required this.gender,
      required this.ownerName,
      required this.ownerID,
      required this.type}); // without pass cause i will n't save  or generate it

  Pet.fromJson(Map<String, dynamic> map)
      : this(
            Name: map['Name'],
            age: map["age"],
            gender: map['gender'],
            ownerName: map["ownerName"],
            ownerID: map["ownerID"],
            type: map["type"]);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Name": Name,
      "age": age,
      "gender":gender,
      "ownerName": ownerName,
      "ownerID": ownerID,
      "type": type
    };
  }
}
