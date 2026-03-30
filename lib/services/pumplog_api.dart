import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../models/session_models.dart';

class PumpLogApi {
  final http.Client _client;

  PumpLogApi([http.Client? client]) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}/pumplog$path');

  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  Future<List<SessionResponse>> getActiveSessions(String token) async {
    final res = await _client.get(_uri('/ActiveSessions'), headers: _headers(token));
    if (res.statusCode >= 400) {
      throw Exception('ActiveSessions fehlgeschlagen (${res.statusCode}): ${res.body}');
    }
    final decoded = jsonDecode(res.body) as List<dynamic>;
    return decoded
        .whereType<Map>()
        .map((e) => SessionResponse.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> createSession(String token) async {
    final res = await _client.post(_uri(''), headers: _headers(token), body: '{}');
    if (res.statusCode >= 400) {
      throw Exception('Session erstellen fehlgeschlagen (${res.statusCode}): ${res.body}');
    }
  }
}
