import 'player.dart';
import 'question.dart';

enum GameStatus {
  idle,
  readyToPass,
  playing,
  revealed,
  roundTransition,
  finished
}

/// Represents the active game session state and settings
class GameSession {
  final List<Player> players;
  final int totalRounds;
  final int secondsPerTurn;
  final List<Question> questionQueue;
  
  int currentRound;
  int currentPlayerIndex;
  int currentQuestionIndex;
  bool isAnswerRevealed;
  GameStatus status;

  GameSession({
    required this.players,
    required this.totalRounds,
    required this.secondsPerTurn,
    required this.questionQueue,
    this.currentRound = 1,
    this.currentPlayerIndex = 0,
    this.currentQuestionIndex = 0,
    this.isAnswerRevealed = false,
    this.status = GameStatus.readyToPass,
  });

  Player get activePlayer => players[currentPlayerIndex];

  Question? get currentQuestion {
    if (currentQuestionIndex >= 0 && currentQuestionIndex < questionQueue.length) {
      return questionQueue[currentQuestionIndex];
    }
    return null;
  }

  /// Total turns completed in the session
  int get totalTurnsCompleted => ((currentRound - 1) * players.length) + currentPlayerIndex;

  /// Total turns in game
  int get totalTurns => totalRounds * players.length;

  /// Progress fraction (0.0 to 1.0)
  double get progressFraction {
    if (totalTurns == 0) return 0.0;
    return (totalTurnsCompleted / totalTurns).clamp(0.0, 1.0);
  }

  /// Get players sorted by score (descending)
  List<Player> get rankedPlayers {
    final list = List<Player>.from(players);
    list.sort((a, b) => b.score.compareTo(a.score));
    return list;
  }
}
