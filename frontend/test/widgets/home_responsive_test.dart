import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/di/dependency_injection.dart';
import 'package:movie_app/core/error/result.dart';
import 'package:movie_app/core/utils/responsive_utils.dart';
import 'package:movie_app/features/home/presentation/movieapp.dart';
import 'package:movie_app/features/home/widgets/home.dart';
import 'package:movie_app/features/movie/data/models/movie.dart';
import 'package:movie_app/features/movie/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:movie_app/features/movie/domain/usecases/search_movies_usecase.dart';

import '../test_helpers/test_helpers.dart';

void main() {
  late MockGetNowPlayingMoviesUseCase nowPlaying;

  setUpAll(() async {
    TestSetup.setupFallbacks();
    await initializeDateFormatting('pt_BR');
  });

  setUp(() async {
    DependencyInjection.reset();
    await DependencyInjection.setup();
    nowPlaying = MockGetNowPlayingMoviesUseCase();
    when(() => nowPlaying(any())).thenAnswer(
      (_) async => Success([
        Movie(
          id: 1,
          title: 'Filme de teste',
          posterPath: null,
          backdropPath: null,
          releaseDate: DateTime(2024),
          overview: 'Sinopse de teste',
          voteAverage: 7.5,
        ),
      ]),
    );
    DependencyInjection.register<GetNowPlayingMoviesUseCase>(nowPlaying);
    DependencyInjection.register<SearchMoviesUseCase>(
      MockSearchMoviesUseCase(),
    );
  });

  tearDown(DependencyInjection.reset);

  Future<void> pumpHome(
    WidgetTester tester, {
    Size size = TestHelpers.mobileSize,
  }) async {
    // MediaQuery e constraints precisam representar o mesmo dispositivo.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    await tester.pumpWidget(const MovieApp());
    await tester.pumpAndSettle();
    expect(find.text('Filme de teste'), findsOneWidget);
    verify(() => nowPlaying(any())).called(1);
  }

  Future<void> openProfile(WidgetTester tester) async {
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Usuário'), findsOneWidget);
  }

  SliverGridDelegateWithFixedCrossAxisCount profileGrid(WidgetTester tester) {
    return tester.widget<GridView>(find.byType(GridView)).gridDelegate
        as SliverGridDelegateWithFixedCrossAxisCount;
  }

  group('Testes de Responsividade - Home Widget', () {
    testWidgets('deve renderizar corretamente em dispositivo móvel', (
      tester,
    ) async {
      await pumpHome(tester);
      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isMobile(context), isTrue);
      expect(ResponsiveUtils.isTablet(context), isFalse);
      expect(ResponsiveUtils.isDesktop(context), isFalse);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).title,
        'RTM (Rate That Movie)',
      );
      expect(find.text('RTM'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Notificações'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('deve renderizar corretamente em tablet', (tester) async {
      await pumpHome(tester, size: TestHelpers.tabletSize);
      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isTablet(context), isTrue);
      expect(ResponsiveUtils.isMobile(context), isFalse);
      expect(ResponsiveUtils.isDesktop(context), isFalse);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('deve renderizar corretamente em desktop', (tester) async {
      await pumpHome(tester, size: TestHelpers.desktopSize);
      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isDesktop(context), isTrue);
      expect(ResponsiveUtils.isMobile(context), isFalse);
      expect(ResponsiveUtils.isTablet(context), isFalse);
    });

    testWidgets('deve renderizar corretamente em desktop grande', (
      tester,
    ) async {
      await pumpHome(tester, size: TestHelpers.largeDesktopSize);
      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isLargeDesktop(context), isTrue);
      expect(ResponsiveUtils.isDesktop(context), isTrue);
    });

    group('Perfil - Layout Responsivo', () {
      testWidgets('deve mostrar layout em coluna no mobile e tablet', (
        tester,
      ) async {
        for (final size in [TestHelpers.mobileSize, TestHelpers.tabletSize]) {
          await pumpHome(tester, size: size);
          await openProfile(tester);
          expect(find.byIcon(Icons.person), findsWidgets);
          expect(
            find.text('Cinéfilo apaixonado por aventuras cinematográficas'),
            findsOneWidget,
          );
          expect(find.byType(GridView), findsNothing);
          expect(find.text('Meus Favoritos'), findsOneWidget);
          expect(find.text('Histórico'), findsOneWidget);
          expect(find.text('Configurações'), findsOneWidget);
          // Remonta a Home sem preservar a aba selecionada entre dispositivos.
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        }
      });

      testWidgets('deve mostrar layout em grid no desktop', (tester) async {
        await pumpHome(tester, size: TestHelpers.desktopSize);
        await openProfile(tester);
        expect(profileGrid(tester).crossAxisCount, 2);
        for (final title in [
          'Meus Favoritos',
          'Histórico',
          'Configurações',
          'Ajuda',
          'Sobre',
          'Sair',
        ]) {
          expect(find.text(title), findsOneWidget);
        }
      });

      testWidgets('deve ajustar número de colunas em desktop grande', (
        tester,
      ) async {
        await pumpHome(tester, size: TestHelpers.largeDesktopSize);
        await openProfile(tester);
        expect(profileGrid(tester).crossAxisCount, 3);
      });
    });

    group('Navegação e Interações', () {
      testWidgets('deve navegar entre abas corretamente', (tester) async {
        await pumpHome(tester);
        await tester.tap(find.text('Notificações'));
        await tester.pumpAndSettle();
        expect(find.text('Novos filmes hoje!'), findsOneWidget);
        expect(find.text('Em alta agora'), findsOneWidget);
        expect(find.text('Recomendado para você'), findsOneWidget);
        await openProfile(tester);
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
        expect(find.text('Filme de teste'), findsOneWidget);
        verifyNoMoreInteractions(nowPlaying);
      });

      testWidgets('deve abrir menu e identificar o app no Sobre', (
        tester,
      ) async {
        await pumpHome(tester);
        final menuButton = find.byIcon(Icons.more_vert_rounded);
        expect(menuButton, findsOneWidget);
        await tester.tap(menuButton);
        await tester.pumpAndSettle();
        expect(find.text('Favoritos'), findsOneWidget);
        expect(find.text('Lista para assistir'), findsOneWidget);
        expect(find.text('Configurações'), findsOneWidget);
        expect(find.text('Sobre'), findsOneWidget);
        await tester.tap(find.text('Sobre'));
        await tester.pumpAndSettle();
        final dialog = find.byType(AlertDialog);
        expect(dialog, findsOneWidget);
        expect(
          find.descendant(of: dialog, matching: find.text('RTM')),
          findsOneWidget,
        );
        expect(find.text('Rate That Movie'), findsOneWidget);
        await tester.tap(find.text('Fechar'));
        await tester.pumpAndSettle();
        expect(dialog, findsNothing);
      });

      testWidgets('deve mostrar snackbar ao tocar nas opções do perfil', (
        tester,
      ) async {
        await pumpHome(tester);
        await openProfile(tester);
        await tester.ensureVisible(find.text('Meus Favoritos'));
        await tester.tap(find.text('Meus Favoritos'));
        await tester.pumpAndSettle();
        expect(find.text('Navegando para: Meus Favoritos'), findsOneWidget);
      });
    });

    group('Overflow e Layout', () {
      testWidgets('não deve ter overflow em telas pequenas', (tester) async {
        await pumpHome(tester, size: const Size(320, 568));
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Notificações'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Recomendado para você'));
        await tester.pumpAndSettle();
        expect(
          find.text('Recomendado para você').hitTestable(),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await openProfile(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('deve manter aspect ratio correto no grid desktop', (
        tester,
      ) async {
        await pumpHome(tester, size: TestHelpers.desktopSize);
        await openProfile(tester);
        expect(profileGrid(tester).childAspectRatio, 4.2);
      });

      testWidgets('deve ajustar aspect ratio para desktop grande', (
        tester,
      ) async {
        await pumpHome(tester, size: TestHelpers.largeDesktopSize);
        await openProfile(tester);
        expect(profileGrid(tester).childAspectRatio, 3.8);
      });
    });
  });
}
