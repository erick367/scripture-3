/// Custom exception for AI Mentor service errors
class MentorException implements Exception {
  final String message;
  
  MentorException(this.message);
  
  @override
  String toString() => message;
}
