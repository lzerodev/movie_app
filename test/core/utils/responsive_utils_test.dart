import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/utils/responsive_utils.dart';

void main() {
  group('ResponsiveUtils Tests', () {
    testWidgets('should detect mobile device correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 600)),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Text(
                    ResponsiveUtils.isMobile(context) ? 'Mobile' : 'Not Mobile',
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('should detect tablet device correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(700, 600)),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Text(
                    ResponsiveUtils.isTablet(context) ? 'Tablet' : 'Not Tablet',
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Tablet'), findsOneWidget);
    });

    testWidgets('should detect desktop device correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1100, 800)),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Text(
                    ResponsiveUtils.isDesktop(context) ? 'Desktop' : 'Not Desktop',
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets('should return correct responsive values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 600)),
            child: Builder(
              builder: (context) {
                final responsiveValue = ResponsiveUtils.responsive<String>(
                  context,
                  mobile: 'Mobile Value',
                  tablet: 'Tablet Value',
                  desktop: 'Desktop Value',
                );
                
                return Scaffold(
                  body: Text(responsiveValue),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Mobile Value'), findsOneWidget);
    });

    testWidgets('should handle ResponsiveBuilder correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1100, 800)),
            child: ResponsiveBuilder(
              builder: (context, deviceType) {
                return Scaffold(
                  body: Text('Device: ${deviceType.toString()}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.textContaining('DeviceType.desktop'), findsOneWidget);
    });
  });
}
