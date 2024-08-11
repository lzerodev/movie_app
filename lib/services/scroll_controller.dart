import 'package:flutter/material.dart';

// Gerencia o ScrollController para detectar quando o usuário atinge o fim da rolagem.
class ScrollService {
  final ScrollController scrollController;
  final VoidCallback onEndOfScroll;
  final double threshold; // Distância antes do final para chamar onEndOfScroll

  // Construtor recebe uma função a ser chamada quando o fim da rolagem é alcançado.
  ScrollService({
    required this.onEndOfScroll,
    ScrollController? controller,
    this.threshold = 50.0, // Valor padrão de 50 pixels
  }) : scrollController = controller ?? ScrollController() {
    scrollController.addListener(_scrollListener);
  }

  // Verifica se a rolagem está próxima do final.
  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - threshold) {
      onEndOfScroll(); // Chama a função passada como parâmetro.
    }
  }

  // Libera os recursos do ScrollController.
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }
}
