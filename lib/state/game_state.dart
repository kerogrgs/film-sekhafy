import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/game_session.dart';
import '../models/player.dart';
import '../models/question.dart';
import '../services/question_service.dart';

/// Central Game State Provider managing turn-based local multiplayer state
class GameState extends ChangeNotifier {
  GameSession? _session;
  Timer? _turnTimer;
  int _remainingSeconds = 30;
  bool _isTimerActive = false;

  GameSession? get session => _session;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimerActive => _isTimerActive;
  bool get isGameActive => _session != null && _session!.status != GameStatus.finished;

  Player? get activePlayer => _session?.activePlayer;
  Question? get currentQuestion => _session?.currentQuestion;
  GameStatus get status => _session?.status ?? GameStatus.idle;
  int get currentRound => _session?.currentRound ?? 1;
  int get totalRounds => _session?.totalRounds ?? 5;
  List<Player> get players => _session?.players ?? [];
  bool get isAnswerRevealed => _session?.isAnswerRevealed ?? false;

  /// Default player avatars and colors
  static const List<String> defaultAvatars = ['⚽', '🏆', '👟', '🧤'];

  /// Start a new game session
  Future<void> startNewGame({
    required List<String> playerNames,
    required int rounds,
    required int turnSeconds,
  }) async {
    _stopTimer();

    final List<Player> newPlayers = [];
    for (int i = 0; i < playerNames.length; i++) {
      newPlayers.add(
        Player(
          id: i + 1,
          name: playerNames[i].trim().isEmpty ? 'لاعب ${i + 1}' : playerNames[i].trim(),
          color: AppColors.playerColors[i % AppColors.playerColors.length],
          avatarIcon: defaultAvatars[i % defaultAvatars.length],
        ),
      );
    }

    final totalRequiredQuestions = rounds * newPlayers.length;
    final questions = await QuestionService.getShuffledQuestions(
      count: totalRequiredQuestions,
    );

    _session = GameSession(
      players: newPlayers,
      totalRounds: rounds,
      secondsPerTurn: turnSeconds,
      questionQueue: questions,
      status: GameStatus.readyToPass,
    );

    _remainingSeconds = turnSeconds;
    notifyListeners();
  }

  /// Called when the active player receives the phone and confirms readiness
  void confirmReadyAndStartTurn() {
    if (_session == null) return;
    
    _session!.status = GameStatus.playing;
    _session!.isAnswerRevealed = false;
    _remainingSeconds = _session!.secondsPerTurn;
    _startTurnTimer();
    notifyListeners();
  }

  /// Reveals the correct 3 answers
  void revealAnswer() {
    if (_session == null || _session!.status != GameStatus.playing) return;
    
    _session!.isAnswerRevealed = true;
    _session!.status = GameStatus.revealed;
    _stopTimer();
    notifyListeners();
  }

  /// Submits the active player's result (Correct = +1, Incorrect = 0)
  void recordAnswer({required bool isCorrect}) {
    if (_session == null) return;

    _stopTimer();

    // Safely update player stats
    final currentPlayer = _session!.activePlayer;
    if (isCorrect) {
      currentPlayer.addScore();
    } else {
      currentPlayer.markIncorrect();
    }

    // Move to next question in queue
    _session!.currentQuestionIndex++;
    _session!.isAnswerRevealed = false;

    // Turn rotation calculation
    final nextPlayerIndex = _session!.currentPlayerIndex + 1;

    if (nextPlayerIndex < _session!.players.length) {
      // Next player's turn in current round
      _session!.currentPlayerIndex = nextPlayerIndex;
      _session!.status = GameStatus.readyToPass;
      _remainingSeconds = _session!.secondsPerTurn;
    } else {
      // Round completed
      final nextRound = _session!.currentRound + 1;
      if (nextRound <= _session!.totalRounds) {
        // Start next round
        _session!.currentRound = nextRound;
        _session!.currentPlayerIndex = 0;
        _session!.status = GameStatus.readyToPass;
        _remainingSeconds = _session!.secondsPerTurn;
      } else {
        // Game finished!
        _session!.status = GameStatus.finished;
      }
    }

    notifyListeners();
  }

  /// Rematch with same players & settings
  Future<void> rematch() async {
    if (_session == null) return;

    final existingPlayers = _session!.players.map((p) {
      p.reset();
      return p;
    }).toList();

    final totalRequiredQuestions = _session!.totalRounds * existingPlayers.length;
    final questions = await QuestionService.getShuffledQuestions(
      count: totalRequiredQuestions,
    );

    _session = GameSession(
      players: existingPlayers,
      totalRounds: _session!.totalRounds,
      secondsPerTurn: _session!.secondsPerTurn,
      questionQueue: questions,
      status: GameStatus.readyToPass,
    );

    _remainingSeconds = _session!.secondsPerTurn;
    notifyListeners();
  }

  /// Timer management
  void _startTurnTimer() {
    _stopTimer();
    if (_session?.secondsPerTurn == 0) return; // 0 means unlimited

    _isTimerActive = true;
    _turnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _stopTimer();
        // Automatically reveal answer when time runs out
        if (_session != null && _session!.status == GameStatus.playing) {
          revealAnswer();
        }
      }
    });
  }

  void _stopTimer() {
    _turnTimer?.cancel();
    _turnTimer = null;
    _isTimerActive = false;
  }

  /// Reset session
  void resetGame() {
    _stopTimer();
    _session = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
