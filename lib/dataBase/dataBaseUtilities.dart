import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/Pet.dart';
import 'package:pet_care/models/Posts.dart';

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

  static CollectionReference<Pet> getPetsCollection(String userID) {
    return getUsersCollection()
        .doc(userID)
        .collection(Pet.collectionName)
        .withConverter<Pet>(
          fromFirestore: (snapshot, options) {
            return Pet.fromJson(snapshot.data()!);
          },
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static Future<void> addPetToFireStore(Pet pet) {
    var msgRef = getPetsCollection(pet.ownerID).doc();
    pet.id = msgRef.id;
    return msgRef.set(pet);
  }

  static Stream<QuerySnapshot<Pet>> readPetFromFirestore(String ownerID) {
    var snapShotMessage = getPetsCollection(ownerID).snapshots();
    return snapShotMessage;
  }

  static DeletePet(Pet pet) {
    // return FirebaseFirestore.instance.collection('USERS').doc(Uid).collection(
    //     'PETS').doc(PetId).delete();
    var petREF = getPetsCollection(pet.ownerID).doc(pet.id);
    FirebaseFirestore.instance.runTransaction(
        (transaction) async => await transaction.delete(petREF));
  }

  static CollectionReference<Posts> getPostCollection() {
    return FirebaseFirestore.instance
        .collection(Posts.collectionName)
        .withConverter<Posts>(
          fromFirestore: (snapshot, options) {
            return Posts.fromJson(snapshot.data()!);
          },
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static Future<void> addPostToFireStore(Posts post) {
    var postRef = getPostCollection().doc();
    post.id = postRef.id;
    return postRef.set(post);
  }

  static Stream<QuerySnapshot<Posts>> readPostsFromFirestore() {
    var snapShotPost = getPostCollection().orderBy('dateTime').snapshots();

    return snapShotPost;
  }

  static DeletePost(Posts post) {
    var petREF = getPostCollection().doc(post.id);
    FirebaseFirestore.instance.runTransaction(
        (transaction) async => await transaction.delete(petREF));
  }

// static CollectionReference<Pet> getPetsCollection() {
//   return FirebaseFirestore.instance
//       .collection(Pet.collectionName)
//       .withConverter<Pet>(
//         fromFirestore: (snapshot, options) {
//           return Pet.fromJson(snapshot.data()!);
//         },
//         toFirestore: (value, options) => value.toJson(),
//       );
// }
//
// static Future<void> addPetToFireStore(Pet pet) {
//   var docRef = getPetsCollection().doc();
//   pet.id = docRef.id;
//   return docRef.set(pet);
// }
//
// static Future<List<Pet>> readPetFromFirestore() async {
//   var snapShotRoom = await getPetsCollection().get();
//   List<Pet> pets = snapShotRoom.docs.map((doc) => doc.data()).toList();
//   return pets;
// }

// static Future<List<Room>> getRoomFromFirebase() async {
//   var snapShotRoom = await getRoomsCollection().get();
//   List<Room> rooms = snapShotRoom.docs.map((doc) => doc.data()).toList();
//   return rooms;
// }

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
