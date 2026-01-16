import 'package:flutter/material.dart';
import '../models/memory_card_model.dart';
import '../services/memory_card_service.dart';

class MemoryCardController extends ChangeNotifier {
  final MemoryCardService _service = MemoryCardService();

  List<MemoryCardItem> cards = [];
  MemoryCardItem? firstFlipped;
  bool isProcessing = false;
  int score = 0;
  int moves = 0;
  bool isLoading = true;

  MemoryCardController() {
    startGame();
  }

  Future<void> startGame() async {
    // RESET STATE TRƯỚC KHI notify
    firstFlipped = null;
    isProcessing = false;
    score = 0;
    moves = 0;
    cards.clear();
    isLoading = true;
    notifyListeners();

    // Lấy 6 cặp (12 thẻ)
    final newCards = await _service.getGameCards(6);
    
    // Check lại nếu controller còn mounted (trong thực tế provider ko check mounted dễ như widget, 
    // nhưng ta check xem state có phải đang loading ko để gán)
    if (isLoading) {
      cards = newCards;
      isLoading = false;
      notifyListeners();
    }
  }

  void onCardTap(MemoryCardItem card) {
    if (isProcessing || card.isFlipped || card.isMatched) return;

    card.isFlipped = true;
    notifyListeners();

    if (firstFlipped == null) {
      // Thẻ đầu tiên
      firstFlipped = card;
    } else {
      // Thẻ thứ hai
      isProcessing = true;
      moves++;
      
      if (firstFlipped!.pairId == card.pairId) {
        // MATCH!
        firstFlipped!.isMatched = true;
        card.isMatched = true;
        score += 10;
        firstFlipped = null;
        isProcessing = false;
        
        notifyListeners();
      } else {
        // NO MATCH -> Úp lại sau 1s
        notifyListeners(); // Update UI
        
        Future.delayed(const Duration(milliseconds: 1000), () {
          // Kiểm tra xem thẻ có còn trong list không (phòng trường hợp reset game giữa chừng)
          if (cards.contains(firstFlipped)) {
             firstFlipped!.isFlipped = false;
          }
          if (cards.contains(card)) {
             card.isFlipped = false;
          }
          
          firstFlipped = null;
          isProcessing = false;
          notifyListeners();
        });
      }
    }
  }

  bool isGameCompleted() {
    return cards.isNotEmpty && cards.every((c) => c.isMatched);
  }
}
