import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flutter_app/models/http_exception.dart';

class auth with ChangeNotifier {
  DateTime? _expiReddate;
    Timer? authtime;
    String? _token ;
   String? _useid;

  bool get isauth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiReddate != null &&
        _expiReddate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get useid {
    return _useid ;
  }

  Future<void> authenticate(
      String email, String passwod, String URLsegment) async {
    var URL =
        "https://identitytoolkit.googleapis.com/v1/accounts:$URLsegment?key=AIzaSyCIXd8xLeLJ8CGN8FmAunKbgsbHXLQLe4E";
    try {
      final res = await http.post(Uri.parse(URL),
          body: json.encode({
            'email': email,
            'password': passwod,
            'returnSecureToken': true,
          }));

      final resdata = json.decode(res.body);


      if (resdata['error'] != null) {
        throw httpexception(resdata['error']['message']);
      }
      _token = resdata['idToken'];
      _expiReddate = DateTime.now()
          .add(Duration(seconds: int.parse(resdata['expiresIn'])));
      _useid = resdata['localId'];
      notifyListeners();
      var prefs = await SharedPreferences.getInstance();
      String userdata = json.encode({
        'token': _token,
        'expiReddate': _expiReddate!.toIso8601String(),
        'useid': _useid,
      });
      prefs.setString("userdata", userdata);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> signup(String email, String passwod) {
    return authenticate(email, passwod, 'signUp');
  }

  Future<void> signin(String email, String passwod) {
    return authenticate(email, passwod, 'signInWithPassword');
  }

  Future<bool> tryautologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userdata")) {
      return false;
    }
    Map<String, dynamic> extracteddata = json.decode(prefs.getString("userdata") as String)
        as Map<String, dynamic>;
    final extacteddate = DateTime.parse(extracteddata['expiReddate']);
    if (extacteddate.isBefore(DateTime.now())) return false;
    _expiReddate = extacteddate;
    _token = extracteddata['token'] ;
    _useid = extracteddata['useid'] ;
    notifyListeners();
    autologout();
    return true;
  }

  Future<void> logout() async {
    _token = null ;
    _useid = null ;
    _expiReddate = null  ;
    if (authtime != null) {
      authtime!.cancel();
      authtime = null ;
    }
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autologout()  {
    if (authtime != null) {
      authtime!.cancel();
    }
    final timetoexpired = _expiReddate!.difference(DateTime.now()).inSeconds as int;
    authtime = Timer(Duration(seconds: timetoexpired), logout);
    notifyListeners();
  }
}
