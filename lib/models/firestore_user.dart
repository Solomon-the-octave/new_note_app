import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  final String uid;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime createdAt;

  const FirestoreUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone,
    required this.createdAt,
  });

  factory FirestoreUser.fromMap(Map<String, dynamic> data) => FirestoreUser(
    uid: data['uid'],
    fullName: data['fullName'],
    email: data['email'],
    phone: data['phone'],
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'createdAt': FieldValue.serverTimestamp(),
    'role': 'primary_caregiver',
    'profileImageUrl': '',
    'languagePreference': 'en',
    'notificationPreferences': {
      'medicationReminders': true,
      'taskAlerts': false,
    },
    'families': [],
  };
}