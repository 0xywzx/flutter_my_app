class Univlist {
  String name;
  final DocumentReference reference;

  Univlist.fromMap(Map<String, dynamic> data, {this.reference})
    : name = data['name'];

  Univlist.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class _AddScreenState extends State<AddScreen> {
  final _detailController = TextEditingController();
  int _radioValue1 = 3;
  void _handleRadioValue1Changed(int value) {
    setState(() {
      _radioValue1 = value; 
    });
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
              child: univList(context)
            ),
          ],
        ),
      ),
    );
  }

  Widget univList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('univ_list').document('埼玉大学').collection('dep_list').snapshots(),
      builder: (context, snapshot) {
        return _buildUnivList(context, snapshot.data.documents);
      },
    );
  } 

  Widget _buildUnivList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildUnivListItem(context, data)).toList(),
    );
  }

  Widget _buildUnivListItem(BuildContext context, DocumentSnapshot data) {
    final univList = Univlist.fromSnapshot(data);
    print(univList.name);
    return Padding(
      key: ValueKey(univList.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(univList.name),
      ),
      ),
    );
  }

}