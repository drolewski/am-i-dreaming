import 'dart:async';

import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:am_i_dreaming/src/model/moon_model.dart';
import 'package:am_i_dreaming/src/model/sex_enum.dart';
import 'package:am_i_dreaming/src/model/user_astrological_details.dart';
import 'package:am_i_dreaming/src/model/user_document.dart';
import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:am_i_dreaming/src/service/user_astrological_details_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_options.dart';
import '../functions/astrological_calculator.dart';
import '../model/user_model.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    initUser();
  }

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  User? _userStored = null;

  User? get userStored => _userStored;

  StreamSubscription<QuerySnapshot>? _dreamDocumentSubscription;
  List<DreamDocument> _dreamDocuments = [];

  List<DreamDocument> get dreamDocuments => _dreamDocuments;

  StreamSubscription<QuerySnapshot>? _userDocumentSubscription;
  UserDocument _userDocument = UserDocument.empty();

  UserDocument get userDocument => _userDocument;

  bool _userDocumentSet = false;

  bool get userDocumentSet => _userDocumentSet;

  bool _dreamDocumentSet = false;

  bool get dreamDocumentSet => _dreamDocumentSet;

  UserAstrologicalDetailsCalculator userAstrologicalDetailsCalculator =
      UserAstrologicalDetailsCalculator();

  Future<void> initUser() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _userStored = user;
        _userDocumentSubscription = FirebaseFirestore.instance
            .collection('user')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .limit(1)
            .snapshots()
            .listen((snapshot) {
          _userDocument = UserDocument.empty();
          _userDocumentSet = true;
          if (snapshot.docs.length == 1) {
            _userDocument = UserDocument(
              id: snapshot.docs[0].id,
              name: snapshot.docs[0].data()['name'] as String,
              sex: SexEnum.fromString(snapshot.docs[0].data()['sex'] as String),
              birthCity: snapshot.docs[0].data()['birthCity'] as String,
              birthdayTimestampUTC: snapshot.docs[0].data()['timestamp'] as int,
              birthCountryCode:
                  snapshot.docs[0].data()['birthCountryCode'] as String,
              sunZodiac: ZodiacEnum.fromString(
                  snapshot.docs[0].data()['sunZodiac'] as String),
              lunarZodiac: ZodiacEnum.fromString(
                  snapshot.docs[0].data()['lunarZodiac'] as String),
              zodiacElement: ZodiacElementEnum.fromString(
                  snapshot.docs[0].data()['zodiacElement'] as String),
              zodiacQuality: ZodiacQualityEnum.fromString(
                  snapshot.docs[0].data()['zodiacQuality'] as String),
              moonPhase: MoonPhaseEnum.fromString(
                  snapshot.docs[0].data()['moonPhase'] as String),
              houses: (snapshot.docs[0].data()['houses'] as List<dynamic>)
                  .map((element) => ZodiacEnum.fromString(element as String))
                  .toList(),
              sunReturnDate: snapshot.docs[0].data()['sunReturnDate'] as int,
              moonReturnDate: snapshot.docs[0].data()['moonReturnDate'] as int,
              ascendant: ZodiacEnum.fromString(
                  snapshot.docs[0].data()['ascendant'] as String),
              timestamp: snapshot.docs[0].data()['timestamp'] as int,
              userId: snapshot.docs[0].data()['userId'] as String,
            );
          }
          notifyListeners();
        });
        _dreamDocumentSubscription = FirebaseFirestore.instance
            .collection('dream')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _dreamDocuments = [];
          _dreamDocumentSet = true;
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
        _loggedIn = false;
        _dreamDocuments = [];
        _dreamDocumentSet = false;
        _userDocument = UserDocument.empty();
        _userDocumentSet = false;
        _userDocumentSubscription?.cancel();
        _dreamDocumentSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> destroy() async {
    _loggedIn = false;
    _dreamDocuments = [];
    _dreamDocumentSet = false;
    _userDocument = UserDocument.empty();
    _userDocumentSet = false;
    _userDocumentSubscription?.cancel();
    _dreamDocumentSubscription?.cancel();
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

  Future<DocumentReference> saveData(UserModel user) async {
    if (!loggedIn) {
      throw Exception('Must be logged in');
    }
    final userAstrologicalDetails =
        await _userAstrologicalDetails(user.birthdayTimestampUTC);

    return FirebaseFirestore.instance.collection('user').add(<String, dynamic>{
      'name': user.name,
      'sex': user.sex,
      'birthCity': user.birthCity,
      'birthdayTimestampUTC': user.birthdayTimestampUTC,
      'birthCountryCode': user.birthCountryCode,
      'sunZodiac': userAstrologicalDetails.sunZodiac.name,
      'lunarZodiac': userAstrologicalDetails.lunarZodiac.name,
      'zodiacElement': userAstrologicalDetails.zodiacElement.name,
      'zodiacQuality': userAstrologicalDetails.zodiacQuality.name,
      'moonPhase': userAstrologicalDetails.moonPhase.name,
      'houses': userAstrologicalDetails.houses.map((h) => h.name).toList(),
      'sunReturnDate': userAstrologicalDetails
          .planetReturn.sunReturnDate.millisecondsSinceEpoch,
      'moonReturnDate': userAstrologicalDetails
          .planetReturn.moonReturnDate.millisecondsSinceEpoch,
      'ascendant': userAstrologicalDetails.ascendant.name,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> updateUserData(AstrologicalData? astrologicalData) async {
    if (!loggedIn) {
      throw Exception('Must be logged in');
    }

    if (astrologicalData != null) {
      return FirebaseFirestore.instance
          .collection('user')
          .doc(userDocument.id)
          .update({
        'sunZodiac': astrologicalData.sunZodiac,
        'lunarZodiac': astrologicalData.lunarZodiac,
        'zodiacElement': astrologicalData.zodiacElement,
        'zodiacQuality': astrologicalData.zodiacQuality,
        'moonPhase': astrologicalData.moonPhase,
        'houses': astrologicalData.astrologicalHouses,
        'sunReturnDate': astrologicalData.planetReturns.sunReturnDate,
        'moonReturnDate': astrologicalData.planetReturns.moonReturnDate,
        'ascendant': astrologicalData.ascendantZodiac,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    }
  }

  Future<UserAstrologicalDetails> _userAstrologicalDetails(
      int timestamp) async {
    return await userAstrologicalDetailsCalculator.userAstrologicalDetails(
        timestamp); // TODO there is problem - move it into theedge function.
  }
}
