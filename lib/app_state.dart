import 'dart:async';

import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:am_i_dreaming/src/model/user_model.dart';
import 'package:am_i_dreaming/src/service/user_astrological_details_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    initUser();
    initDreams();
  }

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _dreamDocumentSubscription;
  List<DreamDocument> _dreamDocuments = [];

  List<DreamDocument> get dreamDocuments => _dreamDocuments;

  UserAstrologicalDetailsCalculator userAstrologicalDetailsCalculator =
      UserAstrologicalDetailsCalculator();

  Future<void> initUser() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
      GoogleProvider(
          clientId:
              "341744325210-ldbgkg14bk1gbjerfkknkthpifrp0jin.apps.googleusercontent.com")
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<void> initDreams() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _dreamDocumentSubscription = FirebaseFirestore.instance
          .collection('dream')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        _dreamDocuments = [];
        for (final document in snapshot.docs) {
          _dreamDocuments.add(
            DreamDocument(
              text: document.data()['text'] as String,
              timestamp: document.data()['timestamp'] as int,
            ),
          );
        }
        notifyListeners();
      });
    } else {
      _dreamDocuments = [];
      _dreamDocumentSubscription?.cancel();
    }
    notifyListeners();
  }

  Future<DocumentReference> addNewDream(String dream) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('dream').add(<String, dynamic>{
      'text': dream,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<DocumentReference> addUser(UserModel user) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    final userAstrologicalDetails = userAstrologicalDetailsCalculator
        .userAstrologicalDetails(user.birthdayTimestampUTC);

    return FirebaseFirestore.instance.collection('user').add(<String, dynamic>{
      'name': user.name,
      'birthCity': user.birthCity,
      'birthdayTimestampUTC': user.birthdayTimestampUTC,
      'birthCountryCode': user.birthCountryCode,
      'sunZodiac': userAstrologicalDetails.sunZodiac.name,
      'lunarZodiac': userAstrologicalDetails.lunarZodiac.name,
      'zodiacElement': userAstrologicalDetails.zodiacElement.name,
      'zodiacQuality': userAstrologicalDetails.zodiacQuality.name,
      'moonPhase': userAstrologicalDetails.moonPhase.name,
      'houses': userAstrologicalDetails.houses.map((h) => h.name).toList(),
      'sunReturnDate': userAstrologicalDetails.planetReturn.sunReturnDate,
      'moonReturnDate': userAstrologicalDetails.planetReturn.moonReturnDate,
      'ascendant': userAstrologicalDetails.ascendant.name,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
