// Original imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utills/ClientConfig.dart';
// New imports
import '../ManagerModels//SettingsModel.dart';
import '../ManagerModels//AdminModel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Change from individual properties to models
  SettingsModel settings = SettingsModel();
  bool isLoading = false;
  AdminModel? adminInfo;