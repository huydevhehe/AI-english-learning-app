class AssessmentResult {
  final String overallLevel;
  final String summary;
  final Map<String, dynamic> skillAnalysis;
  final List<String> weaknesses;
  final List<String> learningRoadmap;

  AssessmentResult({
    required this.overallLevel,
    required this.summary,
    required this.skillAnalysis,
    required this.weaknesses,
    required this.learningRoadmap,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      overallLevel: json["overallLevel"],
      summary: json["summary"],
      skillAnalysis: json["skillAnalysis"],
      weaknesses: List<String>.from(json["weaknesses"]),
      learningRoadmap: List<String>.from(json["learningRoadmap"]),
    );
  }
}
