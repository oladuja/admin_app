import 'package:admin_app/models/msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteId(room) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference = firestore.collection('roomId');
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await document.reference.delete();
    }
    print('Collection deleted from Firestore successfully.');
  } catch (e) {
    print(e);
  }
}

Future<void> sendIdToFirebase(String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference roomsCollection = firestore.collection('roomId');
  DocumentReference documentReference = roomsCollection.doc(id);
  await documentReference.set({
    'id': id,
  });
  // Success message
  print('ID saved to Firestore successfully.');
}

Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String id) async {
  try {
    return FirebaseFirestore.instance.collection('users').doc(id).get();
  } catch (e) {
    rethrow;
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> getlastMessage(String id) async {
  try {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('admin')
        .collection('message-sent')
        .doc(id)
        .get();
  } catch (e) {
    rethrow;
  }
}

var store = FirebaseFirestore.instance;

Future<void> sendMessage(String message, String id) async {
  try {
    await store
        .collection('chats')
        .doc('admin')
        .collection('message-sent')
        .doc(id)
        .set({
      'timeOfLastMessage': Timestamp.now(),
      'message': message,
    });

    await store
        .collection('chats')
        .doc('admin')
        .collection('message-sent')
        .doc(id)
        .collection('messages')
        .add(
          Message(
            isSender: 'admin',
            message: message,
            timestamp: Timestamp.now(),
          ).toJson(),
        );
    await store
        .collection('chats')
        .doc(id)
        .collection('message-sent')
        .doc('admin')
        .set({
      'timeOfLastMessage': Timestamp.now(),
      'message': message,
    });

    await store
        .collection('chats')
        .doc(id)
        .collection('message-sent')
        .doc('admin')
        .collection('messages')
        .add(
          Message(
            isSender: 'admin',
            message: message,
            timestamp: Timestamp.now(),
          ).toJson(),
        );
  } catch (e) {
    print(e);
    rethrow;
  }
}
