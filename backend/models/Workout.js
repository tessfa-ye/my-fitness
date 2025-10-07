const mongoose = require("mongoose");

const WorkoutSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    type: { type: String, required: true }, // e.g., "strength", "cardio"

    exercises: [
      {
        name: String,
        image: String,
        sets: Number,
        repetitions: Number,
        timeInMinutes: Number,
      },
    ],

    // for tracking progress
    completedSets: { type: Number, default: 0 },
    totalSets: { type: Number, default: 0 },
    timeSpentSeconds: { type: Number, default: 0 },
    isFinished: { type: Boolean, default: false },

    createdAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Workout", WorkoutSchema);
