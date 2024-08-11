import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/main.dart';
import 'package:movie_app/screens/now_playing_movies.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_list_view.dart';

void main() {
  testWidgets('MyApp renderiza NowPlayingMoviesPage e seus componentes', (WidgetTester tester) async {
    // Construa o widget MyApp e acione a renderização inicial
    await tester.pumpWidget(const MyApp());

    // Verifique se a tela NowPlayingMoviesPage está sendo renderizada
    expect(find.byType(NowPlayingMoviesPage), findsOneWidget);

    // Verifique se o AppBar está presente e contém o título esperado
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Now Playing Movies'), findsOneWidget);

    // Verifique se o ícone de busca está presente no AppBar
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Opcionalmente, verifique outros componentes da NowPlayingMoviesPage
    // Por exemplo, checar se o corpo contém um MovieListView ou outros widgets específicos
    expect(find.byType(MovieListView), findsOneWidget);
  });
}
