class Services {
  static String collectionName = 'SERVICES';
  String id;
  String Name;
  String phone;
  String location;
  String? type;

  Services(
      { this.id = '', required this.Name, required this.phone, required this.location, required this.type});

  Services.fromJson(Map<String, dynamic> map)
      : this(
      id: map['id'],
      Name: map['Name'],
      phone: map['phone'],
      location: map['location'],
      type: map['type']
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Name": Name,
      "phone": phone,
      "location": location,
      "type": type
    };
  }
}