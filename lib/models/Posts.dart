class Posts {
  static String collectionName = 'POSTS';
  String id;
  String publisherName;
  String publisherId;
  String? pubImage;
  String phone;
  String address;
  String pet;
  String Content;
  String type;
  int dateTime;
  String? Image;

  Posts(
      {this.id = '',
      required this.publisherName,
      required this.publisherId,
      required this.pubImage,
      required this.phone,
      required this.address,
      required this.pet,
      required this.Content,
      required this.type,
      required this.dateTime,
      required this.Image});

  Posts.fromJson(Map<String, dynamic> map)
      : this(
            id: map['id'],
            publisherName: map['publisherName'],
            publisherId: map["publisherId"],
            pubImage: map["pubImage"],
            phone: map['phone'],
            address: map['address'],
            pet: map["pet"],
            Content: map['Content'],
            type: map['type'],
            dateTime: map['dateTime'],
            Image: map['Image']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "publisherName": publisherName,
      "publisherId": publisherId,
      "pubImage": pubImage,
      "phone": phone,
      "address": address,
      "pet": pet,
      "Content": Content,
      "type": type,
      "dateTime": dateTime,
      "Image": Image
    };
  }
}
