const express = require('express');
const router = express.Router();
const User = require('../models/user');
const authMiddleware = require('../middleware/auth'); // verifies JWT
const multer = require('multer');
const path = require('path');

// Upload config (for avatar images)
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// 🟢 Get profile
router.get('/', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// 🟢 Update profile (name, bio, avatar)
router.put('/', authMiddleware, upload.single('avatar'), async (req, res) => {
  try {
    const updateData = {
      name: req.body.name,
      bio: req.body.bio,
    };
    if (req.file) {
      updateData.avatar = `/uploads/${req.file.filename}`;
    }
    const user = await User.findByIdAndUpdate(req.user.id, updateData, { new: true }).select('-password');
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
