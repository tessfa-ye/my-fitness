class ExerciseProgress {
  final String id; // exercise id
  final int totalSets;
  final int repetitions;
  int completedSets;
  int totalTimeSeconds; // total time spent for this exercise

  ExerciseProgress({
    required this.id,
    required this.totalSets,
    required this.repetitions,
    this.completedSets = 0,
    this.totalTimeSeconds = 0,
  });

  double get progress => totalSets > 0 ? completedSets / totalSets : 0;
  bool get isFinished => completedSets >= totalSets;
}
