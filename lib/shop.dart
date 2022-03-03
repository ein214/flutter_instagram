import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  getData() async {
    try {
      var result = await auth.createUserWithEmailAndPassword(email: 'test1@test.com', password: '123456');
      result.user?.updateDisplayName('은거');
      print(result.user);
    } catch(e) {
      print(e);
    }
    /*
    var result = await firestore.collection('product').get();
    if (result.docs.isNotEmpty) {
      for (var doc in result.docs) {
        print(doc['name']);
      }
    }

     */

    //저장장
    //await firestore.collection('product').add({'name': '내복', 'price': 3000});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임'),
    );
  }
}
