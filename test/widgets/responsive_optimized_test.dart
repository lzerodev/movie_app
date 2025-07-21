import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/utils/responsive_utils.dart';

void main() {
  group('Testes de Responsividade Otimizados', () {
    const mobileSize = Size(360, 640);
    const tabletSize = Size(768, 1024);
    const desktopSize = Size(1200, 800);
    const largeDesktopSize = Size(1920, 1080);

    Widget createResponsiveTestWidget({
      required Widget child,
      Size? screenSize,
    }) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: screenSize ?? mobileSize,
            devicePixelRatio: 3.0,
            textScaleFactor: 1.0,
          ),
          child: Scaffold(body: child),
        ),
      );
    }

    group('ResponsiveUtils Core', () {
      testWidgets('deve detectar dispositivo móvel corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: mobileSize,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Text('isMobile: ${ResponsiveUtils.isMobile(context)}'),
                    Text('isTablet: ${ResponsiveUtils.isTablet(context)}'),
                    Text('isDesktop: ${ResponsiveUtils.isDesktop(context)}'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('isMobile: true'), findsOneWidget);
        expect(find.text('isTablet: false'), findsOneWidget);
        expect(find.text('isDesktop: false'), findsOneWidget);
      });

      testWidgets('deve detectar tablet corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: tabletSize,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Text('isMobile: ${ResponsiveUtils.isMobile(context)}'),
                    Text('isTablet: ${ResponsiveUtils.isTablet(context)}'),
                    Text('isDesktop: ${ResponsiveUtils.isDesktop(context)}'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('isMobile: false'), findsOneWidget);
        expect(find.text('isTablet: true'), findsOneWidget);
        expect(find.text('isDesktop: false'), findsOneWidget);
      });

      testWidgets('deve detectar desktop corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: desktopSize,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Text('isMobile: ${ResponsiveUtils.isMobile(context)}'),
                    Text('isTablet: ${ResponsiveUtils.isTablet(context)}'),
                    Text('isDesktop: ${ResponsiveUtils.isDesktop(context)}'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('isMobile: false'), findsOneWidget);
        expect(find.text('isTablet: false'), findsOneWidget);
        expect(find.text('isDesktop: true'), findsOneWidget);
      });
    });

    group('Layout Responsivo', () {
      testWidgets('deve aplicar colunas corretas por dispositivo', (WidgetTester tester) async {
        for (final testCase in [
          {'size': mobileSize, 'expectedCols': 1},
          {'size': tabletSize, 'expectedCols': 2},
          {'size': desktopSize, 'expectedCols': 3},
          {'size': largeDesktopSize, 'expectedCols': 4},
        ]) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final columns = ResponsiveUtils.getGridColumns(context);
                  
                  return Column(
                    children: [
                      Text('Columns: $columns'),
                      Text('Expected: ${testCase['expectedCols']}'),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) => Container(
                            key: Key('grid-item-$index'),
                            color: Colors.blue,
                            child: Center(child: Text('Item $index')),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );

          await tester.pump();

          // Verifica se o número de colunas está correto
          expect(find.text('Columns: ${testCase['expectedCols']}'), findsOneWidget);
          // Verifica se pelo menos um item é renderizado
          expect(find.text('Item 0'), findsOneWidget);
        }
      });

      testWidgets('deve adaptar valores com responsive', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: mobileSize,
            child: Builder(
              builder: (context) {
                final padding = ResponsiveUtils.responsive<double>(
                  context,
                  mobile: 16.0,
                  tablet: 24.0,
                  desktop: 32.0,
                );
                
                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Container(
                    key: const Key('responsive-container'),
                    color: Colors.red,
                    child: Text('Padding: $padding'),
                  ),
                );
              },
            ),
          ),
        );

        expect(find.byKey(const Key('responsive-container')), findsOneWidget);
        expect(find.text('Padding: 16.0'), findsOneWidget);
      });
    });

    group('Breakpoints e Media Queries', () {
      testWidgets('deve aplicar estilos corretos por breakpoint', (WidgetTester tester) async {
        final breakpointTests = [
          {
            'size': mobileSize,
            'name': 'Mobile',
            'expectedColor': Colors.red,
          },
          {
            'size': tabletSize,
            'name': 'Tablet',
            'expectedColor': Colors.green,
          },
          {
            'size': desktopSize,
            'name': 'Desktop',
            'expectedColor': Colors.blue,
          },
        ];

        for (final test in breakpointTests) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              screenSize: test['size'] as Size,
              child: Builder(
                builder: (context) {
                  Color containerColor;
                  
                  if (ResponsiveUtils.isMobile(context)) {
                    containerColor = Colors.red;
                  } else if (ResponsiveUtils.isTablet(context)) {
                    containerColor = Colors.green;
                  } else {
                    containerColor = Colors.blue;
                  }
                  
                  return Container(
                    key: Key('responsive-container-${test['name']}'),
                    width: 100,
                    height: 100,
                    color: containerColor,
                    child: Text(test['name'] as String),
                  );
                },
              ),
            ),
          );

          expect(find.byKey(Key('responsive-container-${test['name']}')), findsOneWidget);
          expect(find.text(test['name'] as String), findsOneWidget);
        }
      });

      testWidgets('deve detectar device type corretamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: tabletSize,
            child: Builder(
              builder: (context) {
                final deviceType = ResponsiveUtils.getDeviceType(context);
                return Text('Device: ${deviceType.name}');
              },
            ),
          ),
        );

        expect(find.text('Device: tablet'), findsOneWidget);
      });
    });

    group('Edge Cases e Performance', () {
      testWidgets('deve lidar com telas muito pequenas', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: const Size(200, 300),
            child: Builder(
              builder: (context) {
                final mediaQuery = MediaQuery.of(context);
                return Column(
                  children: [
                    Text('Width: ${mediaQuery.size.width}'),
                    Text('Height: ${mediaQuery.size.height}'),
                    Text('Is Mobile: ${ResponsiveUtils.isMobile(context)}'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('Width: 200.0'), findsOneWidget);
        expect(find.text('Height: 300.0'), findsOneWidget);
        expect(find.text('Is Mobile: true'), findsOneWidget);
      });

      testWidgets('deve lidar com telas muito grandes', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: const Size(3840, 2160), // 4K
            child: Builder(
              builder: (context) {
                final mediaQuery = MediaQuery.of(context);
                return Column(
                  children: [
                    Text('Width: ${mediaQuery.size.width}'),
                    Text('Height: ${mediaQuery.size.height}'),
                    Text('Is Desktop: ${ResponsiveUtils.isDesktop(context)}'),
                    Text('Is Large Desktop: ${ResponsiveUtils.isLargeDesktop(context)}'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('Width: 3840.0'), findsOneWidget);
        expect(find.text('Height: 2160.0'), findsOneWidget);
        expect(find.text('Is Desktop: true'), findsOneWidget);
        expect(find.text('Is Large Desktop: true'), findsOneWidget);
      });

      testWidgets('deve funcionar com responsive helper', (WidgetTester tester) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            screenSize: tabletSize,
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.responsive<String>(
                  context,
                  mobile: 'Mobile Value',
                  tablet: 'Tablet Value',
                  desktop: 'Desktop Value',
                );
                
                return Text('Result: $value');
              },
            ),
          ),
        );

        expect(find.text('Result: Tablet Value'), findsOneWidget);
      });
    });
  });
}
