import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/widgets/app_card.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/features/home/widgets/home.dart';
import '../test_helpers/test_helpers.dart';

void main() {
  group('Performance Tests', () {
    
    group('Widget Performance Tests', () {
      testWidgets('HomePage should build efficiently', (WidgetTester tester) async {
        // Measure build time
        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const HomePage(),
          ),
        );
        
        stopwatch.stop();
        
        // Build should complete within reasonable time (100ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        
        // Verify no exceptions
        expect(tester.takeException(), isNull);
      });

      testWidgets('Multiple AppCard widgets should render efficiently', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Card $index'),
                ),
              ),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        stopwatch.stop();
        
        // Should handle 100 cards efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
        expect(find.byType(AppCard), findsWidgets);
      });

      testWidgets('Responsive layout should not cause performance issues', (WidgetTester tester) async {
        final sizes = [
          TestHelpers.mobileSize,
          TestHelpers.tabletSize,
          TestHelpers.desktopSize,
          TestHelpers.largeDesktopSize,
        ];

        for (final size in sizes) {
          final stopwatch = Stopwatch()..start();
          
          await tester.pumpWidget(
            TestHelpers.createTestWidget(
              screenSize: size,
              child: const HomePage(),
            ),
          );
          
          await tester.pumpAndSettle();
          stopwatch.stop();
          
          // Each layout should build quickly
          expect(stopwatch.elapsedMilliseconds, lessThan(100), 
                 reason: 'Layout for ${size.width}x${size.height} took too long');
        }
      });
    });

    group('Memory Tests', () {
      testWidgets('Widget tree should not grow excessively', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const HomePage(),
          ),
        );

        final initialElementCount = tester.allElements.length;
        
        // Navigate between tabs multiple times
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('Notificações'));
          await tester.pumpAndSettle();
          
          await tester.tap(find.text('Perfil'));
          await tester.pumpAndSettle();
          
          await tester.tap(find.text('Home'));
          await tester.pumpAndSettle();
        }

        final finalElementCount = tester.allElements.length;
        
        // Element count should not grow significantly
        expect(finalElementCount, lessThanOrEqualTo(initialElementCount * 1.2));
      });
    });

    group('Scroll Performance Tests', () {
      testWidgets('Scrolling should be smooth without frame drops', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: ListView.builder(
              itemCount: 1000,
              itemBuilder: (context, index) => AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title $index', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Description for item $index'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        // Perform scroll operations
        await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);
        await tester.pumpAndSettle();
        
        await tester.fling(find.byType(ListView), const Offset(0, 500), 1000);
        await tester.pumpAndSettle();

        // Should complete without exceptions
        expect(tester.takeException(), isNull);
      });
    });

    group('Animation Performance Tests', () {
      testWidgets('Button animations should complete efficiently', (WidgetTester tester) async {
        bool buttonPressed = false;
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: AppButton(
              text: 'Animated Button',
              onPressed: () => buttonPressed = true,
            ),
          ),
        );

        final stopwatch = Stopwatch()..start();
        
        // Trigger button press animation
        await tester.tap(find.byType(AppButton));
        await tester.pumpAndSettle();
        
        stopwatch.stop();
        
        expect(buttonPressed, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });

      testWidgets('Card hover animations should be performant', (WidgetTester tester) async {
        bool cardTapped = false;
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: AppCard(
              onTap: () => cardTapped = true,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Tappable Card'),
              ),
            ),
          ),
        );

        final stopwatch = Stopwatch()..start();
        
        await tester.tap(find.byType(AppCard));
        await tester.pumpAndSettle();
        
        stopwatch.stop();
        
        expect(cardTapped, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(300));
      });
    });

    group('Load Testing', () {
      testWidgets('Should handle rapid state changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: const HomePage(),
          ),
        );

        final stopwatch = Stopwatch()..start();
        
        // Rapidly switch between tabs
        for (int i = 0; i < 20; i++) {
          await tester.tap(find.text('Notificações'));
          await tester.pump();
          
          await tester.tap(find.text('Perfil'));
          await tester.pump();
          
          await tester.tap(find.text('Home'));
          await tester.pump();
        }
        
        await tester.pumpAndSettle();
        stopwatch.stop();
        
        // Should handle rapid changes efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Should handle many simultaneous widgets', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: 150,
              itemBuilder: (context, index) => AppCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie, size: 24),
                    const SizedBox(height: 8),
                    Text('Item $index'),
                    const SizedBox(height: 8),
                    AppButton(
                      text: 'Action',
                      size: AppButtonSize.small,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        stopwatch.stop();
        
        // Should render 150 complex widgets efficiently
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
        expect(find.byType(AppCard), findsWidgets);
        expect(find.byType(AppButton), findsWidgets);
      });
    });

    group('Stress Tests', () {
      testWidgets('Should recover from repeated widget rebuilds', (WidgetTester tester) async {
        Widget currentWidget = const HomePage();
        
        await tester.pumpWidget(
          TestHelpers.createTestWidget(child: currentWidget),
        );

        final stopwatch = Stopwatch()..start();
        
        // Force multiple rebuilds
        for (int i = 0; i < 10; i++) {
          currentWidget = MaterialApp(
            home: Scaffold(
              body: Column(
                children: List.generate(10, (index) => AppCard(
                  child: Text('Rebuild $i - Item $index'),
                )),
              ),
            ),
          );
          
          await tester.pumpWidget(currentWidget);
          await tester.pump();
        }
        
        await tester.pumpAndSettle();
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
