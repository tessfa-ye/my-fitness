const express = require('express');
const router = express.Router();
const User = require('../models/user');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
require('dotenv').config();

// Signup
router.post('/signup', async (req, res) => {
  const { name, email, password } = req.body;

  try {
    // 1️⃣ Validate input
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'All fields are required!' });
    }

    // 2️⃣ Check if email exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    // 3️⃣ Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // 4️⃣ Create user
    const user = await User.create({
      name,
      email,
      password: hashedPassword,
    });

    // ✅ Convert _id to string explicitly
    const userId = user._id.toString();

    // 5️⃣ Create token with string id
    const token = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });

    // 6️⃣ Build a clean user object to send
    const userData = {
      id: userId,
      name: user.name,
      email: user.email,
    };

    // 7️⃣ Send response
    res.status(201).json({ user: userData, token });
  } catch (err) {
    console.error('Signup Error:', err);
    res.status(500).json({ message: err.message });
  }
});



// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });

    // ✅ Make sure you return all these fields:
    res.json({
      _id: user._id,
      name: user.name,
      email: user.email,
      token, // ✅ Important
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});


module.exports = router;
