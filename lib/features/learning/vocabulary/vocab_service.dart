import 'vocab_question_model.dart';

class VocabService {
  List<VocabQuestion> loadQuestions() {
    final raw = [
      {
        "q": "Banana nghĩa là gì?",
        "a": ["Quả chuối", "Quả lê", "Quả xoài", "Quả nho"],
        "correct": 0,
        "animation": "assets/animations/banana.json"
      },
      {
        "q": "Dog nghĩa là gì?",
        "a": ["Con mèo", "Con chó", "Con gà", "Con vịt"],
        "correct": 1,
        "animation": "assets/animations/long_dog.json"
      },
      {
        "q": "Happy nghĩa là:",
        "a": ["Vui", "Buồn", "Giận", "Sợ"],
        "correct": 0,
        "animation": "assets/animations/happy.json"
      },
      {
        "q": "Book nghĩa là gì?",
        "a": ["Sách", "Bút", "Bàn", "Ghế"],
        "correct": 0,
        "animation": "assets/animations/book.json"
      },
      {
        "q": "Car nghĩa là gì?",
        "a": ["Xe đạp", "Ô tô", "Xe bus", "Máy bay"],
        "correct": 1,
        "animation": "assets/animations/red_car.json"
      },
      {
        "q": "Fast nghĩa là:",
        "a": ["Chậm", "Nhanh", "Nặng", "Nhẹ"],
        "correct": 1,
        "animation": "assets/animations/fast.json"
      },
      {
        "q": "Love nghĩa là:",
        "a": ["Yêu", "Ghét", "Giận", "Buồn"],
        "correct": 0,
        "animation": "assets/animations/love.json"
      },
      {
        "q": "House nghĩa là gì?",
        "a": ["Nhà", "Trường học", "Bệnh viện", "Cửa hàng"],
        "correct": 0,
        "animation": "assets/animations/home.json"
      },
      {
        "q": "Teacher nghĩa là:",
        "a": ["Bác sĩ", "Giáo viên", "Luật sư", "Kỹ sư"],
        "correct": 1,
        "animation": "assets/animations/teacher.json"
      },
      {
        "q": "Astronaut nghĩa là gì?",
        "a": ["Phi công", "Phi hành gia", "Nhà khoa học", "Kỹ sư"],
        "correct": 1,
        "animation": "assets/animations/phihanhgia.json"
      },
    ];

    return raw.map((e) => VocabQuestion.fromMap(e)).toList();
  }
}
