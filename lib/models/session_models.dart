class SessionResponse {
  final String title;
  final String sessionGuid;
  final int sessionNumber;
  final bool isActive;
  final String userGuid;
  final List<SectionModel> sections;

  SessionResponse({
    required this.title,
    required this.sessionGuid,
    required this.sessionNumber,
    required this.isActive,
    required this.userGuid,
    required this.sections,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    final sectionsJson = (json['sections'] as List?) ?? const [];
    return SessionResponse(
      title: (json['title'] as String?) ?? '',
      sessionGuid: (json['sessionGuid'] as String?) ?? '',
      sessionNumber: (json['sessionNumber'] as num?)?.toInt() ?? 0,
      isActive: (json['isActive'] as bool?) ?? false,
      userGuid: (json['userGuid'] as String?) ?? '',
      sections: sectionsJson
          .whereType<Map>()
          .map((e) => SectionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class SectionModel {
  final String? sectionGuid;
  final String sessionGuid;
  final String exerciseGuid;
  final String sectionType;
  final int? order;
  final bool? supersetWithNext;

  SectionModel({
    required this.sectionGuid,
    required this.sessionGuid,
    required this.exerciseGuid,
    required this.sectionType,
    this.order,
    this.supersetWithNext,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        sectionGuid: json['sectionGuid'] as String?,
        sessionGuid: (json['sessionGuid'] as String?) ?? '',
        exerciseGuid: (json['exerciseGuid'] as String?) ?? '',
        sectionType: (json['sectionType'] as String?) ?? 'Hypertrophy',
        order: (json['order'] as num?)?.toInt(),
        supersetWithNext: json['supersetWithNext'] as bool?,
      );
}
