/// Model representing a Three-in-One football trivia question
class Question {
  final int id;
  final String category;
  final String question;
  final List<String> answers;
  final String hint;
  final String difficulty;

  const Question({
    required this.id,
    required this.category,
    required this.question,
    required this.answers,
    required this.hint,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int? ?? 0,
      category: json['category'] as String? ?? 'عام',
      question: json['question'] as String? ?? '',
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      hint: json['hint'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'متوسط',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'answers': answers,
      'hint': hint,
      'difficulty': difficulty,
    };
  }
}
