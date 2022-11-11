import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/entry.dart';
import 'models/account.dart';



class Constants {
  static String url = "http://10.0.2.2:5000"; // "http://127.0.0.1:5000";
  static String login = "/auth/login";
  static String entry = "/entry";
  static String account = "/account";
}

class ApiService extends ChangeNotifier {
  final FlutterSecureStorage storage;
  ApiService(this.storage);

  Future<void> setToken(String token) async {
    return storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return storage.read(key: 'token');
  }

  Future<http.Response> httpGet(path, headers, {params}) async {
    var url = Uri.parse(Constants.url + path).replace(queryParameters: params);
    var resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200) {
      return resp;
    } else {
      throw Exception("HTTP GET error");
    }
  }

  Future<http.Response> httpGetWithToken(path, {params}) async {
      String? token = await getToken();
      if (token == null) {
        throw Exception("Token not present");
      }
      var headers = {
        'Authorization': 'Bearer $token'
      };
      return httpGet(path, headers, params: params);
  }

  Future<http.Response> httpPost(path, headers, {body}) async {
    var url = Uri.parse(Constants.url + path);
    var resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode == 200) {
      return resp;
    } else {
      throw Exception("HTTP POST error");
    }
  }

  Future<http.Response> httpPostWithToken(path, {body}) async {
      String? token = await getToken();
      if (token == null) {
        throw Exception("Token not present");
      }
      var headers = {
        'Authorization': 'Bearer $token'
      };
      return httpPost(path, headers, body: body);
  }

  Future<bool> getLogin(user, password) async {
    String encodedUserData = base64.encode(utf8.encode('$user:$password'));
    var headers = {
      'Authorization': 'Basic $encodedUserData',
    };
    try {
      http.Response resp = await httpGet(Constants.login, headers);
      String token = jsonDecode(resp.body)["token"];
      await setToken(token);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<List<Entry>> getEntries() async {
    http.Response resp = await httpGetWithToken(Constants.entry);
    Iterable results = jsonDecode(resp.body);
    List<Entry> entries = results.map((model) => Entry.fromJson(model)).toList();
    return entries;
  }

  Future<List<Account>> getAccounts({name, type}) async {
    http.Response resp = await httpGetWithToken(Constants.account, params: {
        'name': name,
        'type': type,
      });
    Iterable results = jsonDecode(resp.body);
    List<Account> accounts = results.map((model) => Account.fromJson(model)).toList();
    return accounts;
  }
}
