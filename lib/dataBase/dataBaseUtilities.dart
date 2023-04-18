import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/myUser.dart';

class DataBaseUtils {
  static CollectionReference<myUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(myUser.collectionName)
        .withConverter<myUser>(
          fromFirestore: (snapshot, options) {
            return myUser.fromJson(snapshot.data()!);
          },
          toFirestore: (value, options) => value.toJson(),
        );
  }

  // static CollectionReference<Room> getRoomsCollection() {
  //   return FirebaseFirestore.instance
  //       .collection(Room.collectionName)
  //       .withConverter<Room>(
  //         fromFirestore: (snapshot, options) {
  //           return Room.fromJson(snapshot.data()!);
  //         },
  //         toFirestore: (value, options) => value.toJson(),
  //       );
  // }


  static Future<void> addUserToFireStore(myUser user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  static Future<myUser?> readUserFromFirestore(String id) async {
    DocumentSnapshot<myUser> userRef = await getUsersCollection().doc(id).get();
    return userRef.data();
  }

  // static Future<void> addRoomToFirebase(Room room) {
  //   var docRef = getRoomsCollection().doc();
  //   room.id = docRef.id;
  //   return docRef.set(room);
  // }
  //
  // static Future<List<Room>> getRoomFromFirebase() async {
  //   var snapShotRoom = await getRoomsCollection().get();
  //   List<Room> rooms = snapShotRoom.docs.map((doc) => doc.data()).toList();
  //   return rooms;
  // }
  //
  // static CollectionReference<Message> getMessagesCollection(String roomID) {
  //   return getRoomsCollection().doc(roomID)
  //       .collection(Message.collectionName)
  //       .withConverter<Message>(
  //     fromFirestore: (snapshot, options) {
  //       return Message.fromJson(snapshot.data()!);
  //     },
  //     toFirestore: (value, options) => value.toJson(),
  //   );
  // }
  // static Future<void> addMessageToFireStore(Message message){
  //   var msgRef = getMessagesCollection(message.roomId).doc();
  //   message.id=msgRef.id;
  //   return msgRef.set(message);
  // }
  //
  // static Stream<QuerySnapshot<Message>>getMessageFromFirebase(String roomId)  {
  //   var snapShotMessage =  getMessagesCollection(roomId).orderBy('dateTime').snapshots();
  //   return snapShotMessage;
  // }

}
