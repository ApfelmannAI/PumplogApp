class AuthSession {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  Map<String, String> toStorage() => {
        'accessToken': accessToken,
        if (refreshToken != null) 'refreshToken': refreshToken!,
        if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
      };

  factory AuthSession.fromStorage(Map<String, String> map) => AuthSession(
        accessToken: map['accessToken'] ?? '',
        refreshToken: map['refreshToken'],
        expiresAt: map['expiresAt'] == null ? null : DateTime.tryParse(map['expiresAt']!),
      );
}
