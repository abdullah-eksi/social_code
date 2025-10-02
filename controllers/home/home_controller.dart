import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int selectedCategoryIndex = 0;
  int refreshTrigger = 0;
  bool isSidebarOpen = false;
  
  // Kategori seçimi işlemi
  void selectCategory(int index) {
    if (selectedCategoryIndex == index) {
      refreshContent();
    } else {
      selectedCategoryIndex = index;
      notifyListeners();
    }
  }
  
  // İçeriği yenilemek için kullanılan metod
  void refreshContent() {
    refreshTrigger++;
    notifyListeners();
  }
  
  // Sidebar durumunu değiştirme (notifyListeners yok)
  void toggleSidebar() {
    isSidebarOpen = !isSidebarOpen;
    // notifyListeners(); <--- Kaldırdık
  }
}
