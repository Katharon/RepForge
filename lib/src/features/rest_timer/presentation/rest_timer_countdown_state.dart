import '../domain/rest_timer_domain.dart';

final class RestTimerCountdownState {
  const RestTimerCountdownState({
    required this.status,
    required this.remaining,
    required this.displayText,
    required this.isVisible,
  });

  factory RestTimerCountdownState.fromSnapshot(RestTimerSnapshot snapshot) {
    return RestTimerCountdownState(
      status: snapshot.status,
      remaining: snapshot.remaining,
      displayText: _formatRemaining(snapshot.remaining),
      isVisible: snapshot.isVisible,
    );
  }

  final RestTimerStatus status;
  final Duration remaining;
  final String displayText;
  final bool isVisible;

  @override
  bool operator ==(Object other) {
    return other is RestTimerCountdownState &&
        other.status == status &&
        other.remaining == remaining &&
        other.displayText == displayText &&
        other.isVisible == isVisible;
  }

  @override
  int get hashCode {
    return Object.hash(status, remaining, displayText, isVisible);
  }
}

String _formatRemaining(Duration remaining) {
  final clamped = remaining.isNegative ? Duration.zero : remaining;
  final totalSeconds = clamped.inSeconds;
  final minutes = totalSeconds ~/ Duration.secondsPerMinute;
  final seconds = totalSeconds.remainder(Duration.secondsPerMinute);
  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}
