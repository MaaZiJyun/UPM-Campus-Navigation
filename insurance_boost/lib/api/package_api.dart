import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insurance_boost/models/package.dart';

class PackageApi {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('package');

  // when users modify their info again

  static Future<Package?> getDetailByID(String pid) async {
    String id;
    String detail;
    double price;
    String category;
    int point;
    String code;

    await FirebaseFirestore.instance
        .collection('package')
        .doc(pid)
        .get()
        .then((DocumentSnapshot doc) {
      id = pid;
      detail = doc.get('detail');
      price = doc.get('price');
      category = doc.get('category');
      point = doc.get('point');
      code = doc.get('code');
      return Package(id, detail, price, category, point, code);
    });
  }
}
