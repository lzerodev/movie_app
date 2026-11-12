import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/utils/responsive_utils.dart';
import 'package:movie_app/features/home/widgets/home.dart';
import '../test_helpers/test_helpers.dart';

void main() {
  group('Testes de Responsividade - Home Widget', () {
    
    testWidgets('deve renderizar corretamente em dispositivo móvel', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          screenSize: TestHelpers.mobileSize,
          child: const HomePage(),
        ),
      );

      // Verifica se está em modo mobile
      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isMobile(context), isTrue);
      expect(ResponsiveUtils.isTablet(context), isFalse);
      expect(ResponsiveUtils.isDesktop(context), isFalse);

      // Verifica se encontra elementos básicos
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      
      // Verifica navegação inferior
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Notificações'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('deve renderizar corretamente em tablet', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          screenSize: TestHelpers.tabletSize,
          child: const HomePage(),
        ),
      );

      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isTablet(context), isTrue);
      expect(ResponsiveUtils.isMobile(context), isFalse);
      expect(ResponsiveUtils.isDesktop(context), isFalse);

      // Em tablet, deveria ter elementos similares ao mobile mas com espaçamento maior
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('deve renderizar corretamente em desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          screenSize: TestHelpers.desktopSize,
          child: const HomePage(),
        ),
      );

      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isDesktop(context), isTrue);
      expect(ResponsiveUtils.isMobile(context), isFalse);
      expect(ResponsiveUtils.isTablet(context), isFalse);
    });

    testWidgets('deve renderizar corretamente em desktop grande', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestWidget(
          screenSize: TestHelpers.largeDesktopSize,
          child: const HomePage(),
        ),
      );

      final context = tester.element(find.byType(HomePage));
      expect(ResponsiveUtils.isLargeDesktop(context), isTrue);
      expect(ResponsiveUtils.isDesktop(context), isTrue);
    });

    group('Perfil - Layout Responsivo', () {
      testWidgets('deve mostrar layout em coluna no mobile e tablet', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            screenSize: TestHelpers.mobileSize,
            child: const HomePage(),
          ),
        );

        // Navega para a aba de perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        // Verifica se encontra o header do perfil
        expect(find.byIcon(Icons.person), findsWidgets);
        expect(find.text('Usuário'), findsOneWidget);
        expect(find.text('Cinéfilo apaixonado por aventuras cinematográficas'), findsOneWidget);

        // Verifica opções do perfil
        expect(find.text('Meus Favoritos'), findsOneWidget);
        expect(find.text('Histórico'), findsOneWidget);
        expect(find.text('Configurações'), findsOneWidget);
      });

      testWidgets('deve mostrar layout em grid no desktop', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            screenSize: TestHelpers.desktopSize,
            child: const HomePage(),
          ),
        );

        // Navega para a aba de perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        // Em desktop, deve usar GridView para as opções
        expect(find.byType(GridView), findsOneWidget);
        
        // Verifica se todas as opções estão presentes
        expect(find.text('Meus Favoritos'), findsOneWidget);
        expect(find.text('Histórico'), findsOneWidget);
        expect(find.text('Configurações'), findsOneWidget);
        expect(find.text('Ajuda'), findsOneWidget);
        expect(find.text('Sobre'), findsOneWidget);
        expect(find.text('Sair'), findsOneWidget);
      });

      testWidgets('deve ajustar número de colunas em desktop grande', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            screenSize: TestHelpers.largeDesktopSize,
            child: const HomePage(),
          ),
        );

        // Navega para a aba de perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        // Em desktop grande, deveria ter 3 colunas no grid
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, equals(3));
      });
    });

    group('Navegação e Interações', () {
      testWidgets('deve navegar entre abas corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const HomePage(),
          ),
        );

        // Verifica aba inicial (Home)
        expect(find.byType(NavigationBar), findsOneWidget);

        // Navega para Notificações
        await tester.tap(find.text('Notificações'));
        await tester.pumpAndSettle();

        // Verifica conteúdo de notificações
        expect(find.text('Novos filmes hoje!'), findsOneWidget);
        expect(find.text('Em alta agora'), findsOneWidget);
        expect(find.text('Recomendado para você'), findsOneWidget);

        // Navega para Perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        // Verifica conteúdo do perfil
        expect(find.text('Usuário'), findsOneWidget);
      });

      testWidgets('deve abrir menu de opções no AppBar', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const HomePage(),
          ),
        );

        // Tenta encontrar e tocar no botão de menu
        final menuButton = find.byIcon(Icons.more_vert_rounded);
        if (menuButton.hasFound) {
          await tester.tap(menuButton);
          await tester.pumpAndSettle();

          // Verifica se o menu abriu com as opções
          expect(find.text('Favoritos'), findsOneWidget);
          expect(find.text('Lista para assistir'), findsOneWidget);
          expect(find.text('Configurações'), findsOneWidget);
          expect(find.text('Sobre'), findsOneWidget);
        }
      });

      testWidgets('deve mostrar snackbar ao tocar nas opções do perfil', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const HomePage(),
          ),
        );

        // Navega para a aba de perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        // Toca em uma opção do perfil
        await tester.tap(find.text('Meus Favoritos'));
        await tester.pumpAndSettle();

        // Verifica se a mensagem foi mostrada
        expect(find.text('Navegando para: Meus Favoritos'), findsOneWidget);
      });
    });

    group('Overflow e Layout', () {
      testWidgets('não deve ter overflow em telas pequenas', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            screenSize: const Size(320, 568), // iPhone SE size
            child: const HomePage(),
          ),
        );

        await tester.pumpAndSettle();

        // Verifica se não há overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('deve manter aspect ratio correto no grid desktop', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            screenSize: TestHelpers.desktopSize,
            child: const HomePage(),
          ),
        );

        // Navega para a aba de perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        
        // Verifica aspect ratio para desktop
        expect(delegate.childAspectRatio, equals(4.2));
      });

      testWidgets('deve ajustar aspect ratio para desktop grande', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            screenSize: TestHelpers.largeDesktopSize,
            child: const HomePage(),
          ),
        );

        // Navega para a aba de perfil
        await tester.tap(find.text('Perfil'));
        await tester.pumpAndSettle();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        
        // Verifica aspect ratio para desktop grande
        expect(delegate.childAspectRatio, equals(3.8));
      });
    });
  });
}
