const express = require("express");
const router = express.Router();
const Workout = require("../models/Workout");
const auth = require("../middleware/auth");

// ✅ Add Workout
router.post("/", auth, async (req, res) => {
  try {
    const { type, exercises } = req.body;

    const workout = new Workout({
      userId: req.user.id,
      type,
      exercises,
    });

    await workout.save();
    res.status(201).json(workout);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ✅ Get all workouts for logged-in user
router.get("/", auth, async (req, res) => {
  try {
    const workouts = await Workout.find({ userId: req.user.id }).sort({ createdAt: -1 });
    res.json(workouts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ✅ Update workout progress
router.put("/:id/progress", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const { completedSets, totalSets, timeSpentSeconds, isFinished } = req.body;

    const workout = await Workout.findOne({ _id: id, userId: req.user.id });
    if (!workout) return res.status(404).json({ message: "Workout not found" });

    workout.completedSets = completedSets;
    workout.totalSets = totalSets;
    workout.timeSpentSeconds = timeSpentSeconds;
    workout.isFinished = isFinished;

    await workout.save();
    res.json(workout);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ✅ Get workout stats
router.get("/stats/:userId", auth, async (req, res) => {
  try {
    const userId = req.params.userId;

    const workouts = await Workout.find({ userId });
    const finished = workouts.filter(w => w.isFinished).length;
    const inProgress = workouts.filter(w => !w.isFinished).length;
    const totalTimeSeconds = workouts.reduce(
      (sum, w) => sum + (w.timeSpentSeconds || 0),
      0
    );

    res.json({
      finished,
      inProgress,
      totalTimeSeconds,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ✅ Finish workout manually
router.put("/:id/finish", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const workout = await Workout.findOne({ _id: id, userId: req.user.id });
    if (!workout) return res.status(404).json({ message: "Workout not found" });

    workout.isFinished = true;
    await workout.save();
    res.json(workout);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
