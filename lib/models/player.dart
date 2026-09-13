import 'package:flutter/material.dart';

/// Represents a local player in the game
class Player {
  final int id;
  final String name;
  final Color color;
  final String avatarIcon;
  int score;
  int correctAnswers;
  int totalAnswered;

  Player({
    required this.id,
    required this.name,
    required this.color,
    required this.avatarIcon,
    this.score = 0,
    this.correctAnswers = 0,
    this.totalAnswered = 0,
  });

  /// Add correct answer score (+1 point)
  void addScore() {
    score += 1;
    correctAnswers += 1;
    totalAnswered += 1;
  }

  /// Mark incorrect answer (0 points)
  void markIncorrect() {
    totalAnswered += 1;
  }

  /// Reset player statistics
  void reset() {
    score = 0;
    correctAnswers = 0;
    totalAnswered = 0;
  }

  /// Accuracy percentage
  double get accuracy {
    if (totalAnswered == 0) return 0.0;
    return (correctAnswers / totalAnswered) * 100;
  }

  Player copyWith({
    int? id,
    String? name,
    Color? color,
    String? avatarIcon,
    int? score,
    int? correctAnswers,
    int? totalAnswered,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalAnswered: totalAnswered ?? this.totalAnswered,
    );
  }
}
