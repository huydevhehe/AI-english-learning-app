# 📘 AI English Learning App

🚀 A cross-platform English learning application built with Flutter, focusing on AI-assisted assessment, question generation, and personalized practice.

## ✨ Features
- 🧠 AI-powered English proficiency assessment  
- ✍️ AI-generated questions and exercises based on user level  
- 🎤 Speaking practice with speech-to-text and AI feedback  
- 📚 Vocabulary and topic-based learning modules  
- 🎮 Mini-games to reinforce language skills  
- 🔥 User progress tracking and streak system  

## 🛠️ Tech Stack
- Flutter (Dart)
- Firebase (Authentication, Firestore, Cloud Functions)
- AI APIs for assessment, question generation, and feedback
- RESTful API integration

## 🗂️ Project Structure
- `lib/` – Flutter application source code  
- `functions/` – Backend logic and AI integration  
- `assets/` – Animations and static resources  

## 🔐 Security
- Sensitive API keys are stored in environment variables  
- No API keys or secrets are committed to this repository  

## ▶️ Setup (Local)
```bash
flutter pub get
flutter run
firebase emulators:start --only functions
adb reverse tcp:5001 tcp:5001
