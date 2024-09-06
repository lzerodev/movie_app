import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/home/presentation/movieapp.dart';
import 'package:movie_app/features/home/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/features/movie/presentation/widgets/movie_list.dart';

void main() {
  testWidgets('MovieApp renderiza a HomePage e seus componentes', (WidgetTester tester) async {
    // Construa o widget MyApp e acione a renderização inicial
    await tester.pumpWidget(const MovieApp());
    await tester.pumpWidget(const MovieApp());

    await tester.pumpAndSettle();
    // Verifique se a tela NowPlayingMoviesPage está sendo renderizada
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    // // Verifique se o AppBar está presente e contém o título esperado
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Testflix'), findsOneWidget);

    // // Verifique se o ícone de busca está presente no AppBar
    expect(find.byIcon(Icons.search), findsAny);

    // // Opcionalmente, verifique outros componentes da HomePage
    // // Por exemplo, checar se o corpo contém um MovieListView ou outros widgets específicos
    expect(find.byType(MovieListView), findsOneWidget);
  });
}
