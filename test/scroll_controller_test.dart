import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/services/scroll_controller.dart';

void main() {
  testWidgets('ScrollService triggers onEndOfScroll when scrolled near the end', (WidgetTester tester) async {
    // Define uma função mock para onEndOfScroll
    bool didTrigger = false;
    final scrollService = ScrollService(
      onEndOfScroll: () {
        didTrigger = true;
      },
    );

    // Cria um widget para testar o ScrollService
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            controller: scrollService.scrollController,
            itemCount: 100,
            itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
          ),
        ),
      ),
    );

    // Simula a rolagem perto do final
    scrollService.scrollController.jumpTo(
      scrollService.scrollController.position.maxScrollExtent - 10, // Próximo ao final
    );

    // Rebuild para aplicar a rolagem
    await tester.pumpAndSettle();

    // Verifica se a função onEndOfScroll foi chamada
    expect(didTrigger, isTrue);

    // Libere os recursos do ScrollService
    scrollService.dispose();
  });
}
