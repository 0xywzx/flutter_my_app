import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     initialRoute: '/',
     routes: {
       '/': (context) => MyHomePage(),
       '/AddScreen': (context) => AddScreen(),
     },
   );
 }
}

// class Simple extends StatelessWidget {
//   @override
//   Future<QuerySnapshot> getDocuments() async {
//     QuerySnapshot ulist = await Firestore.instance.collection('univ_list').document('埼玉大学').collection('dep_list').getDocuments();
//     var list = [];
//     for (int i = 0; i < ulist.documents.length; i++) {
//       var a = ulist.documents[i].documentID;
//       list.add(a);
//     }
//     print(list);
//   }

//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Welcome to Flutter',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Welcome to Flutter'),
//         ),
//         body: Center(
//           child: ListTile(
//             title: Text('Text'),
//             onTap: () {
//               getDocuments();
//             },       
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() {
   return _MyHomePageState();
 }
}

class _MyHomePageState extends State<MyHomePage> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Firebase Test'),
     ),
     body: _buildBody(context),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.add),
       onPressed: () {
         Navigator.pushNamed(context, '/AddScreen');
       },
     ),
   );
 }

 Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
     stream: Firestore.instance.collection('baby').snapshots(),
     builder: (context, snapshot) {
       if (!snapshot.hasData) return LinearProgressIndicator();

       return _buildList(context, snapshot.data.documents);
     },
   );
 }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.name),
         trailing: Text(record.votes.toString()),
         onTap: () => record.reference.updateData({'votes': FieldValue.increment(1)}),       
      ),
     ),
   );
 }
}

class Record {
 final String name;
 final int votes;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['votes'] != null),
       name = map['name'],
       votes = map['votes'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$votes>";
}

class AddScreensub extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddScreensubState();
}

//final addReferences = Firestore.instance.reference().child('baby');
class Univlist {
  String name;
  final DocumentReference reference;

  Univlist.fromMap(Map<String, dynamic> data, {this.reference})
    : name = data['name'];

  Univlist.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class _AddScreensubState extends State<AddScreensub> {
  final _detailController = TextEditingController();
  int _radioValue1 = 3;
  String _univ;
  List<String> univList11 = [];

  Future<QuerySnapshot> getUnivlist() async {
    QuerySnapshot ulist = await Firestore.instance.collection('univ_list').document('埼玉大学').collection('dep_list').getDocuments();
    for (int i = 0; i < ulist.documents.length; i++) {
      var a = ulist.documents[i].documentID;
      univList11.add(a);
    }
    print(univList11);
  }

  void _handleRadioValue1Changed(int value) {
    setState(() {
      _radioValue1 = value; 
    });
  }

  Widget univDropbox() {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('univ_list').snapshots(),
      builder: (context, snapshot){
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
              Text('大学名'),
              SizedBox(width: 15.0),
              DropdownButton(
                items: currencyItems,
                onChanged: (value) {
                  setState(() {
                    _univ = value;
                  });
                },
                value: _univ,
                hint: new Text('oo大学')
              ),
            ],
          );
        }
      }
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Screen')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _detailController,
              decoration: InputDecoration(labelText: 'Detail expranation'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('授業の質'),
                new Radio(
                  value: 1,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValue1Changed,
                ),
                new Text('1'),
                new Radio(
                  value: 2,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValue1Changed,
                ),
                new Text('2'),
                new Radio(
                  value: 3,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValue1Changed,
                ),
                new Text('3'),
                new Radio(
                  value: 4,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValue1Changed,
                ),
                new Text('4'),
                new Radio(
                  value: 5,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValue1Changed,
                ),
                new Text('5'),
              ],
            ),
            univDropbox(),
            RaisedButton(
              child: Text('Add'),
              onPressed: () async {
                await Firestore.instance.collection('lecture').document('埼玉大学').collection('経済学部').document('マクロ経済学').setData(
                  {
                    "quality": 3
                  }
                );
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Text('ss')
            ),
          ],
        ),
      ),
    );
  }

  // Widget univList(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection('univ_list').document('埼玉大学').collection('dep_list').snapshots(),
  //     builder: (context, snapshot) {
  //       return _buildUnivList(context, snapshot.data.documents);
  //     },
  //   );
  // } 

  // Widget _buildUnivList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return ListView(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     children: snapshot.map((data) => _buildUnivListItem(context, data)).toList(),
  //   );
  // }

  // Widget _buildUnivListItem(BuildContext context, DocumentSnapshot data) {
  //   final univList = Univlist.fromSnapshot(data);
    
  //   return Padding(
  //     key: ValueKey(univList.name),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: ListTile(
  //         title: Text(univList.name),
  //     ),
  //     ),
  //   );
  // }

}

