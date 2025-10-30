import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String msg = "";
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> messagesStream =
    _db.collection('messages').orderBy("createdDate", descending: false).snapshots(includeMetadataChanges: true);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: ()=>_mAuth.signOut(),
                child: Icon(Icons.logout)
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: messagesStream,
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Center(child: Text("Error al cargar los mensajes"));
                    }
                    if(snapshot.connectionState== ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    if(docs.isEmpty){
                      return Center(child: Text("No hay mensajes"));
                    }
                    return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index){
                          final data = docs[index].data() as Map<String,dynamic>;
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(data["user"]),
                              subtitle: Text(data["message"]),
                            ),
                          );
                        }
                    );

                  }
              )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8, top: 8),
            child: Row(
              children: [
                Expanded(
                    child: Form(
                      key: _formKey,
                        child: TextFormField(
                           validator: (value)=> value!.isEmpty ? '' : null,
                            onSaved: (value)=> msg=value??'',
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                            )
                        )
                    )
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(50, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2
                      )
                    ),
                    onPressed: ()=>addMessage(),
                    child: Icon(Icons.send)
                )
              ],
            ),
          )
        ]
      )
    );
  }

  void addMessage() async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();
    CollectionReference messagesRef = _db.collection('messages');
    Map<String,dynamic> data = <String,dynamic>{};
    data["message"]=msg;
    data["createdDate"]=FieldValue.serverTimestamp();
    data["user"]=_mAuth.currentUser?.email;
    await messagesRef.add(data);
    _formKey.currentState!.reset();
  }
}

