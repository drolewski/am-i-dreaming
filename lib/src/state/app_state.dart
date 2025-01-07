import 'dart:async';

import 'package:am_i_dreaming/src/model/dream_document.dart';
import 'package:am_i_dreaming/src/model/horoscope_model.dart';
import 'package:am_i_dreaming/src/model/moon_model.dart';
import 'package:am_i_dreaming/src/model/personalized_horoscope_document.dart';
import 'package:am_i_dreaming/src/model/sex_enum.dart';
import 'package:am_i_dreaming/src/model/user_document.dart';
import 'package:am_i_dreaming/src/model/user_status.dart';
import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../firebase_options.dart';
import '../functions/astrological_calculator.dart';
import '../model/user_model.dart';
import '../util/date_formater.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    initUser();
  }

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  User? _userStored = null;

  User? get userStored => _userStored;

  StreamSubscription<QuerySnapshot>? _userStatusDocumentSubscription;
  UserStatus? _userStatus = null;

  UserStatus? get userStatus => _userStatus;

  StreamSubscription<QuerySnapshot>? _dreamDocumentSubscription;
  List<DreamDocument> _dreamDocuments = [];

  List<DreamDocument> get dreamDocuments => _dreamDocuments;

  StreamSubscription<QuerySnapshot>? _userDocumentSubscription;
  UserDocument _userDocument = UserDocument.empty();

  UserDocument get userDocument => _userDocument;

  StreamSubscription<QuerySnapshot>? _userHoroscopesSubscription;
  List<Horoscope> _horoscopes = [];

  List<Horoscope> get horoscopes => _horoscopes;

  StreamSubscription<QuerySnapshot>?
  _userPersonalizedHoroscopeDocumentSubscription;
  PersonalizedHoroscopeDocument? _personalizedHoroscopeDocument;

  PersonalizedHoroscopeDocument? get personalizedHoroscopeDocument =>
      _personalizedHoroscopeDocument;

  bool _userDocumentSet = false;

  bool get userDocumentSet => _userDocumentSet;

  bool _dreamDocumentSet = false;

  bool get dreamDocumentSet => _dreamDocumentSet;

  bool _horoscopesSet = false;

  bool get horoscopesSet => _horoscopesSet;

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
              birthdayTimestampUTC:
              snapshot.docs[0].data()['birthdayTimestampUTC'] as int,
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
                id: document.id,
                text: document.data()['text'] as String,
                timestamp: document.data()['timestamp'] as int,
                prompt: document.data()['prompt'] as String? ?? "",
                url: document.data()['url'] as String? ?? "",
              ),
            );
          }
          notifyListeners();
        });
        _userStatusDocumentSubscription = FirebaseFirestore.instance
            .collection('userStatus')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .limit(1)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.docs.length == 1) {
            final document = snapshot.docs[0];
            _userStatus = UserStatus(
                id: document.id,
                updatedAt: document.data()['updatedAt'] as int,
                isSingleHoroscopeGenerated:
                document.data()['isSingleHoroscopeGenerated'] as bool,
                areAllHoroscopesGenerated:
                document.data()['areAllHoroscopesGenerated'] as bool,
                isPersonalizedHoroscopeGenerated:
                document.data()['isPersonalizedHoroscopeGenerated'] as bool,
                numberOfDreams: document.data()['numberOfDreams'] as int);

            notifyListeners();
          }
        });
        updateHoroscopes();
        updatePersonalizedHoroscope();
      } else {
        _loggedIn = false;
        _dreamDocuments = [];
        _dreamDocumentSet = false;
        _userDocument = UserDocument.empty();
        _userDocumentSet = false;
        _userStatus = null;
        _horoscopes = [];
        _horoscopesSet = false;
        _personalizedHoroscopeDocument = null;
        _userDocumentSubscription?.cancel();
        _dreamDocumentSubscription?.cancel();
        _userStatusDocumentSubscription?.cancel();
        _userHoroscopesSubscription?.cancel();
        _userPersonalizedHoroscopeDocumentSubscription?.cancel();
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
    _userStatus = null;
    _horoscopes = [];
    _horoscopesSet = false;
    _personalizedHoroscopeDocument = null;
    _userDocumentSubscription?.cancel();
    _dreamDocumentSubscription?.cancel();
    _userStatusDocumentSubscription?.cancel();
    _userHoroscopesSubscription?.cancel();
    _userPersonalizedHoroscopeDocumentSubscription?.cancel();
    notifyListeners();
  }

  Future<DocumentReference> addNewDream(String dream, String prompt) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    upsertUserStatus(UserStatus(
        id: userStatus?.id,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        isSingleHoroscopeGenerated: userStatus?.isSingleHoroscopeGenerated ?? false,
        areAllHoroscopesGenerated: userStatus?.areAllHoroscopesGenerated ?? false,
        isPersonalizedHoroscopeGenerated: userStatus?.isPersonalizedHoroscopeGenerated ?? false,
        numberOfDreams: (userStatus?.numberOfDreams ?? 0 )+ 1));

    return FirebaseFirestore.instance.collection('dream').add(<String, dynamic>{
      'text': dream,
      'prompt': prompt,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<DocumentReference?> saveData(UserModel user,
      AstrologicalData? astrologicalData) async {
    if (!loggedIn) {
      throw Exception('Must be logged in');
    }

    if (astrologicalData != null) {
      return FirebaseFirestore.instance
          .collection('user')
          .add(<String, dynamic>{
        'name': user.name,
        'sex': user.sex,
        'birthCity': user.birthCity,
        'birthdayTimestampUTC': user.birthdayTimestampUTC,
        'birthCountryCode': user.birthCountryCode,
        'sunZodiac': astrologicalData.sunZodiac,
        'lunarZodiac': astrologicalData.lunarZodiac,
        'zodiacElement': astrologicalData.zodiacElement,
        'zodiacQuality': astrologicalData.zodiacQuality,
        'moonPhase': astrologicalData.moonPhase,
        'houses': astrologicalData.astrologicalHouses,
        'sunReturnDate': astrologicalData.planetReturns.sunReturnDate,
        'moonReturnDate': astrologicalData.planetReturns.moonReturnDate,
        'ascendant': astrologicalData.ascendantZodiac,
        'timestamp': DateTime
            .now()
            .millisecondsSinceEpoch,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    }
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

  Future<void> upsertUserStatus(UserStatus userStatus) async {
    if (!loggedIn) {
      throw Exception('Must be logged in');
    }

    if (userStatus.id != null) {
      return FirebaseFirestore.instance
          .collection('userStatus')
          .doc(userStatus.id)
          .update({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'updatedAt': userStatus.updatedAt,
        'isSingleHoroscopeGenerated': userStatus.isSingleHoroscopeGenerated,
        'areAllHoroscopesGenerated': userStatus.areAllHoroscopesGenerated,
        'isPersonalizedHoroscopeGenerated':
        userStatus.isPersonalizedHoroscopeGenerated,
        'numberOfDreams': userStatus.numberOfDreams,
      });
    }
    FirebaseFirestore.instance.collection('userStatus').add(<String, dynamic>{
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'updatedAt': userStatus.updatedAt,
      'isSingleHoroscopeGenerated': userStatus.isSingleHoroscopeGenerated,
      'areAllHoroscopesGenerated': userStatus.areAllHoroscopesGenerated,
      'isPersonalizedHoroscopeGenerated':
      userStatus.isPersonalizedHoroscopeGenerated,
      'numberOfDreams': userStatus.numberOfDreams,
    });
  }

  Future<void> updateHoroscopes() async {
    _userHoroscopesSubscription = FirebaseFirestore.instance
        .collection('horoscope')
        .where('date',
        isEqualTo: formatTimeStampToSimpleDate(
            DateTime
                .now()
                .millisecondsSinceEpoch))
        .snapshots()
        .listen((snapshot) {
      _horoscopes = [];
      for (final document in snapshot.docs) {
        _horoscopes.add(
          Horoscope(
            zodiac: ZodiacEnum.fromString(document.data()['zodiac'] as String)
                .toModel(),
            language: document.data()['language'] as String,
            date: document.data()['date'] as String? ?? "",
            value: document.data()['value'] as String? ?? "",
          ),
        );
      }
      _horoscopesSet = true;

      notifyListeners();
    });
  }

  Future<void> updatePersonalizedHoroscope() async {
    _userHoroscopesSubscription = FirebaseFirestore.instance
        .collection('personalizedHoroscope')
        .where(Filter.and(
        Filter("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid),
        Filter("date",
            isEqualTo: formatTimeStampToSimpleDate(
                DateTime
                    .now()
                    .millisecondsSinceEpoch))))
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.length == 1) {
        _personalizedHoroscopeDocument = PersonalizedHoroscopeDocument(
            date: snapshot.docs[0].data()['date'],
            horoscope: snapshot.docs[0].data()['horoscope'],
            language: snapshot.docs[0].data()['language'],
            userId: snapshot.docs[0].data()['userId']);
      }
      notifyListeners();
    });
  }
}
