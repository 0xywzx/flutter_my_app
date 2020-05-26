import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/firebase_auth_service.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final firebaseAuth = new FirebaseAuthService();

  MyApp() {
    firebaseAuth.anonymousLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: FlatButton(
      color: Colors.amber,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("get Game Record"),
          StreamBuilder<GameRecord>(
            stream: getGame(),
            builder: (BuildContext c, AsyncSnapshot<GameRecord> data) {
              if (data?.data == null) return Text("Error");

              GameRecord r = data.data;

              return Text("${r.creationTimestamp} + ${r.name}");
            },
          ),
        ],
      ),
      onPressed: () {
        getGame();
      },
    ))));
  }
}

Stream<GameRecord> getGame() {
  return Firestore.instance
      .collection("games")
      .document("zZJKQOuuoYVgsyhJJAgc")
      .get()
      .then((snapshot) {
    try {
      return GameRecord.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

class GameReview {
  String name;
  int howPopular;
  List<String> reviewers;

  GameReview.fromMap(Map<dynamic, dynamic> data)
      : name = data["name"],
        howPopular = data["howPopular"],
        reviewers = List.from(data['reviewers']);
}

StreamBuilder<QuerySnapshot>(
  stream: Firestore.instance.collection("currency").snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData)
      const Text("Loading.....");
    else {
      List<DropdownMenuItem> currencyItems = [];
      for (int i = 0; i < snapshot.data.documents.length; i++) {
        DocumentSnapshot snap = snapshot.data.documents[i];
        currencyItems.add(
          DropdownMenuItem(
            child: Text(
              snap.documentID,
              style: TextStyle(color: Color(0xff11b719)),
            ),
            value: "${snap.documentID}",
          ),
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.coins,
              size: 25.0, color: Color(0xff11b719)),
          SizedBox(width: 50.0),
          DropdownButton(
            items: currencyItems,
            onChanged: (currencyValue) {
              final snackBar = SnackBar(
                content: Text(
                  'Selected Currency value is $currencyValue',
                  style: TextStyle(color: Color(0xff11b719)),
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              setState(() {
                selectedCurrency = currencyValue;
              });
            },
            value: selectedCurrency,
            isExpanded: false,
            hint: new Text(
              "Choose Currency Type",
              style: TextStyle(color: Color(0xff11b719)),
            ),
          ),
        ],
      );
    }
  }),