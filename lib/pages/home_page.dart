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
  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

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
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: (){
            addMessage();
          },
          child: Icon(Icons.add, color: Colors.black,),
      ),
      body: Center(
        child: Text("Bienvenido ${_mAuth.currentUser?.email??'...'}"),
      ),
    );
  }

  void addMessage() async {
    CollectionReference messagesRef = _mFirestore.collection('messages');
    Map<String,dynamic> data = <String,dynamic>{};
    data["message"]="Hola desde app firebase";
    data["time"]=FieldValue.serverTimestamp();
    data["user"]=_mAuth.currentUser?.email;
    await messagesRef.add(data);
  }
}
