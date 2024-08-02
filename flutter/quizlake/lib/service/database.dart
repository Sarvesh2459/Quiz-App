import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

class DatabaseService {
  // upload quizData

  Future addQuizData(Map<String, dynamic> quizData, String quizId) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Quiz")
        .doc(quizId)
        .collection("MCQs")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // create room the admin publishes quiz
  Future CreateRoom(Map<String, dynamic> roomData, String roomID) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("Room")
        .doc(roomID)
        .set(roomData)
        .catchError((e) {
      print(e.toString());
    });

    await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Room")
        .doc(roomID)
        .set(roomData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future JoinRoom(Map<String, dynamic> PlayerData, String roomID) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("Room")
        .doc(roomID)
        .collection("Players")
        .doc(uid)
        .set(PlayerData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future GetQuizData(String roomID) async {
    String uid = "";
    String quizID = "";
    await FirebaseFirestore.instance
        .collection("Room")
        .doc(roomID)
        .get()
        .then((value) => uid = value.get("userID"));
    await FirebaseFirestore.instance
        .collection("Room")
        .doc(roomID)
        .get()
        .then((value) => quizID = value.get("quizID"));

    return await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Quiz")
        .doc(quizID)
        .snapshots();
  }

  Future getRoomData() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Room")
        .snapshots();
  }

  Future GetPlayers(String roomID) async {
    return await FirebaseFirestore.instance
        .collection("Room")
        .doc(roomID)
        .collection("Players")
        .snapshots();
  }

  Future LeaveRoom(String roomID) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("Room")
        .doc(roomID)
        .collection("Players")
        .doc(uid)
        .delete();
  }

  Future getQuestionData(String roomID) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    String quizID = "";
    var docsnapshot =
        await FirebaseFirestore.instance.collection("Room").doc(roomID).get();

    if (docsnapshot.exists) {
      Map<String, dynamic> Fielddata = docsnapshot.data()!;
      quizID = Fielddata["quizID"];
    }

    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Quiz")
        .doc(quizID)
        .collection("MCQs")
        .doc()
        .snapshots();
  }
}
