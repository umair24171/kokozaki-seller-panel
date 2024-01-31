import 'package:firebase_auth/firebase_auth.dart';

String currentUser = FirebaseAuth.instance.currentUser!.uid;
