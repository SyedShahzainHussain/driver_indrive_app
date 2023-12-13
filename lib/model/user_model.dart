import 'package:firebase_database/firebase_database.dart';

class DriversModel {
  String? id;
  String? email;
  String? name;
  String? phone;

  DriversModel({this.id, this.email, this.name, this.phone});

  DriversModel.fromJson(DataSnapshot snap) {
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    name = (snap.value as dynamic)["name"];
    phone = (snap.value as dynamic)["phone"];
  }
}
