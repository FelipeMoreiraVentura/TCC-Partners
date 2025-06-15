import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> chatHistory = [];
TextEditingController sourcePrompt = TextEditingController();
User? user = FirebaseAuth.instance.currentUser;
