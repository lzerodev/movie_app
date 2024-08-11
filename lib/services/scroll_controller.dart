import 'package:flutter/material.dart';

// Gerencia o ScrollController para detectar quando o usuário atinge o fim da rolagem.
class ScrollService {
  final ScrollController scrollController = ScrollController();

  // Construtor recebe uma função a ser chamada quando o fim da rolagem é alcançado.
  ScrollService(VoidCallback onEndOfScroll) {
    scrollController.addListener(() {
      // Verifica se a rolagem está próxima do final (50 pixels antes).
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        onEndOfScroll(); // Chama a função passada como parâmetro.
      }
    });
  }

  // Libera os recursos do ScrollController.
  void dispose() {
    scrollController.dispose();
  }
}
