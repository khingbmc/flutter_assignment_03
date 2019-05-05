import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils{
  static void addTask(String title){
    Firestore.instance.collection('todo').document().setData({'title':title, 'done':false});
  }

  static void update(String id, bool value){
    final DocumentReference todo = Firestore.instance.document('todo/'+id);

    Firestore.instance.runTransaction((Transaction tx) async{
      DocumentSnapshot postSnap = await tx.get(todo);
      if(postSnap.exists){
        await tx.update(todo, <String, dynamic>{'done':value});

      }
    });
  }

  static void deleteEach(String documentID){

    final DocumentReference todo = Firestore.instance.document('todo/'+documentID);

    Firestore.instance.runTransaction((Transaction tx) async{
      DocumentSnapshot postSnap = await tx.get(todo);
      if(postSnap.exists){
        await tx.delete(todo);
      }
    });
  }

  static void deleteAllDone() async{
    QuerySnapshot query = await Firestore.instance.collection('todo').where('done', isEqualTo:true).getDocuments();

    query.documents.forEach((f) => FirestoreUtils.deleteEach(f.documentID));
  }
}