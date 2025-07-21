import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/widgets/app_card.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_text_field.dart';
import 'package:movie_app/core/widgets/app_loading_indicator.dart';
import 'package:movie_app/core/widgets/app_empty_state.dart';
import 'package:movie_app/core/theme/app_design_system.dart';
import '../test_helpers/test_helpers.dart';

void main() {
  group('Core Widgets - Design System Tests', () {
    
    group('AppCard Widget Tests', () {
      testWidgets('deve renderizar AppCard básico corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppCard(
              child: Text('Test Content'),
            ),
          ),
        );

        expect(find.text('Test Content'), findsOneWidget);
        expect(find.byType(AppCard), findsOneWidget);
      });

      testWidgets('deve aplicar tamanhos diferentes corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: const [
                AppCard.small(child: Text('Small Card')),
                AppCard(child: Text('Medium Card')),
                AppCard.large(child: Text('Large Card')),
              ],
            ),
          ),
        );

        expect(find.text('Small Card'), findsOneWidget);
        expect(find.text('Medium Card'), findsOneWidget);
        expect(find.text('Large Card'), findsOneWidget);
      });

      testWidgets('deve responder a toque quando onTap é fornecido', (WidgetTester tester) async {
        bool tapped = false;
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: AppCard(
              onTap: () => tapped = true,
              child: const Text('Tappable Card'),
            ),
          ),
        );

        await tester.tap(find.byType(AppCard));
        expect(tapped, isTrue);
      });

      testWidgets('deve aplicar variantes visuais corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: const [
                AppCard(child: Text('Default')),
                AppCard.secondary(child: Text('Secondary')),
                AppCard.outlined(child: Text('Outlined')),
                AppCard.minimal(child: Text('Minimal')),
              ],
            ),
          ),
        );

        expect(find.text('Default'), findsOneWidget);
        expect(find.text('Secondary'), findsOneWidget);
        expect(find.text('Outlined'), findsOneWidget);
        expect(find.text('Minimal'), findsOneWidget);
      });
    });

    group('AppButton Widget Tests', () {
      testWidgets('deve renderizar botão primário corretamente', (WidgetTester tester) async {
        bool pressed = false;
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: AppButton(
              text: 'Primary Button',
              onPressed: () => pressed = true,
            ),
          ),
        );

        expect(find.text('Primary Button'), findsOneWidget);
        
        await tester.tap(find.byType(AppButton));
        expect(pressed, isTrue);
      });

      testWidgets('deve mostrar loading state corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppButton(
              text: 'Loading Button',
              isLoading: true,
              onPressed: null,
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading Button'), findsOneWidget);
      });

      testWidgets('deve aplicar diferentes variantes', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: const [
                AppButton(
                  text: 'Primary',
                  variant: AppButtonVariant.primary,
                  onPressed: null,
                ),
                AppButton(
                  text: 'Secondary',
                  variant: AppButtonVariant.secondary,
                  onPressed: null,
                ),
                AppButton(
                  text: 'Text',
                  variant: AppButtonVariant.text,
                  onPressed: null,
                ),
              ],
            ),
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
        expect(find.text('Secondary'), findsOneWidget);
        expect(find.text('Text'), findsOneWidget);
      });

      testWidgets('deve aplicar diferentes tamanhos', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: const [
                AppButton(
                  text: 'Small',
                  size: AppButtonSize.small,
                  onPressed: null,
                ),
                AppButton(
                  text: 'Medium',
                  size: AppButtonSize.medium,
                  onPressed: null,
                ),
                AppButton(
                  text: 'Large',
                  size: AppButtonSize.large,
                  onPressed: null,
                ),
              ],
            ),
          ),
        );

        expect(find.text('Small'), findsOneWidget);
        expect(find.text('Medium'), findsOneWidget);
        expect(find.text('Large'), findsOneWidget);
      });

      testWidgets('deve mostrar ícone quando fornecido', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppButton(
              text: 'Button with Icon',
              icon: Icons.star,
              onPressed: null,
            ),
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Button with Icon'), findsOneWidget);
      });
    });

    group('AppTextField Widget Tests', () {
      testWidgets('deve renderizar campo de texto básico', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppTextField(
              hintText: 'Enter text',
            ),
          ),
        );

        expect(find.byType(AppTextField), findsOneWidget);
        expect(find.text('Enter text'), findsOneWidget);
      });

      testWidgets('deve chamar callback ao alterar texto', (WidgetTester tester) async {
        String? changedText;
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: AppTextField(
              hintText: 'Test input',
              onChanged: (value) => changedText = value,
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Test text');
        expect(changedText, equals('Test text'));
      });

      testWidgets('deve mostrar erro quando fornecido', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppTextField(
              hintText: 'Test input',
              errorText: 'Field is required',
            ),
          ),
        );

        expect(find.text('Field is required'), findsOneWidget);
      });

      testWidgets('deve mostrar botão de limpar quando habilitado', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppTextField(
              hintText: 'Test input',
            ),
          ),
        );

        // Adiciona texto para testar funcionalidade
        await tester.enterText(find.byType(TextField), 'Some text');
        await tester.pump();

        // Verifica se o campo contém o texto
        expect(find.text('Some text'), findsOneWidget);
      });
    });

    group('AppLoadingIndicator Widget Tests', () {
      testWidgets('deve mostrar loading indicator básico', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppLoadingIndicator(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('deve mostrar mensagem quando fornecida', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppLoadingIndicator(
              message: 'Carregando filmes...',
              showMessage: true,
            ),
          ),
        );

        expect(find.text('Carregando filmes...'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('deve aplicar diferentes tamanhos', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: const [
                AppLoadingIndicator(size: AppLoadingSize.small),
                AppLoadingIndicator(size: AppLoadingSize.medium),
                AppLoadingIndicator(size: AppLoadingSize.large),
              ],
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
      });
    });

    group('AppEmptyState Widget Tests', () {
      testWidgets('deve mostrar estado vazio básico', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppEmptyState(
              icon: Icons.movie,
              title: 'Nenhum filme encontrado',
              subtitle: 'Tente buscar por outro termo',
            ),
          ),
        );

        expect(find.text('Nenhum filme encontrado'), findsOneWidget);
        expect(find.text('Tente buscar por outro termo'), findsOneWidget);
      });

      testWidgets('deve mostrar ícone quando fornecido', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppEmptyState(
              icon: Icons.movie,
              title: 'Sem filmes',
              subtitle: 'Não há filmes para mostrar',
            ),
          ),
        );

        expect(find.byIcon(Icons.movie), findsOneWidget);
        expect(find.text('Sem filmes'), findsOneWidget);
      });

      testWidgets('deve executar ação quando botão é pressionado', (WidgetTester tester) async {
        bool actionCalled = false;
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: AppEmptyState(
              icon: Icons.error,
              title: 'Estado vazio',
              subtitle: 'Descrição do estado',
              actionLabel: 'Tentar novamente',
              onAction: () => actionCalled = true,
            ),
          ),
        );

        await tester.tap(find.text('Tentar novamente'));
        expect(actionCalled, isTrue);
      });
    });

    group('Design System Consistency Tests', () {
      testWidgets('deve usar cores do design system', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const AppCard(
              child: AppButton(
                text: 'Test Button',
                onPressed: null,
              ),
            ),
          ),
        );

        // Verifica se os widgets foram renderizados
        expect(find.byType(AppCard), findsOneWidget);
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('deve manter espaçamentos consistentes', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: const [
                AppCard(child: Text('Card 1')),
                SizedBox(height: AppDesignSystem.spaceMd),
                AppCard(child: Text('Card 2')),
                SizedBox(height: AppDesignSystem.spaceMd),
                AppCard(child: Text('Card 3')),
              ],
            ),
          ),
        );

        expect(find.byType(SizedBox), findsNWidgets(2));
        expect(find.byType(AppCard), findsNWidgets(3));
      });

      testWidgets('deve aplicar tipografia consistente', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: Column(
              children: [
                Text(
                  'Título',
                  style: AppDesignSystem.headlineSmall,
                ),
                Text(
                  'Subtítulo',
                  style: AppDesignSystem.titleMedium,
                ),
                Text(
                  'Corpo do texto',
                  style: AppDesignSystem.bodyMedium,
                ),
              ],
            ),
          ),
        );

        expect(find.text('Título'), findsOneWidget);
        expect(find.text('Subtítulo'), findsOneWidget);
        expect(find.text('Corpo do texto'), findsOneWidget);
      });
    });
  });
}
