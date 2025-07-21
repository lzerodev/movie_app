import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:movie_app/core/widgets/app_card.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_empty_state.dart';
import 'package:movie_app/core/widgets/app_loading_indicator.dart';
import 'package:movie_app/core/utils/responsive_utils.dart';
import 'package:movie_app/features/home/widgets/home.dart';
import '../test_helpers/test_helpers.dart';

void main() {
  group('Golden Tests - Visual Regression', () {
    
    group('Core Widgets Golden Tests', () {
      testGoldens('AppCard variants should match golden files', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            Device.phone,
            Device.iphone11,
            Device.tabletPortrait,
          ])
          ..addScenario(
            widget: const AppCard(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Default Card'),
              ),
            ),
            name: 'default_card',
          )
          ..addScenario(
            widget: const AppCard.secondary(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Secondary Card'),
              ),
            ),
            name: 'secondary_card',
          )
          ..addScenario(
            widget: const AppCard.outlined(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Outlined Card'),
              ),
            ),
            name: 'outlined_card',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'app_card_variants');
      });

      testGoldens('AppButton variants should match golden files', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                AppButton(
                  text: 'Primary Button',
                  variant: AppButtonVariant.primary,
                  onPressed: null,
                ),
                SizedBox(height: 16),
                AppButton(
                  text: 'Secondary Button',
                  variant: AppButtonVariant.secondary,
                  onPressed: null,
                ),
                SizedBox(height: 16),
                AppButton(
                  text: 'Text Button',
                  variant: AppButtonVariant.text,
                  onPressed: null,
                ),
                SizedBox(height: 16),
                AppButton(
                  text: 'Loading Button',
                  isLoading: true,
                  onPressed: null,
                ),
              ],
            ),
            name: 'button_variants',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'app_button_variants');
      });

      testGoldens('AppEmptyState should match golden files', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: const AppEmptyState(
              icon: Icons.movie,
              title: 'Nenhum filme encontrado',
              subtitle: 'Tente buscar por outro termo',
              actionLabel: 'Tentar novamente',
            ),
            name: 'empty_state_with_action',
          )
          ..addScenario(
            widget: const AppEmptyState(
              icon: Icons.error,
              title: 'Erro ao carregar',
              subtitle: 'Verifique sua conexão',
            ),
            name: 'empty_state_error',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'app_empty_state_variants');
      });

      testGoldens('AppLoadingIndicator should match golden files', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: const AppLoadingIndicator(),
            name: 'loading_default',
          )
          ..addScenario(
            widget: const AppLoadingIndicator(
              message: 'Carregando filmes...',
            ),
            name: 'loading_with_message',
          )
          ..addScenario(
            widget: const AppLoadingIndicator(
              size: AppLoadingSize.large,
              message: 'Processando...',
            ),
            name: 'loading_large',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'app_loading_variants');
      });
    });

    group('Responsive Layout Golden Tests', () {
      testGoldens('HomePage should match golden files across devices', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            Device.phone,
            Device.iphone11,
            Device.tabletPortrait,
            Device.tabletLandscape,
            const Device(
              name: 'desktop',
              size: Size(1200, 800),
              devicePixelRatio: 1.0,
            ),
            const Device(
              name: 'large_desktop',
              size: Size(1920, 1080),
              devicePixelRatio: 1.0,
            ),
          ])
          ..addScenario(
            widget: const HomePage(),
            name: 'home_page',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'home_page_responsive');
      });

      testGoldens('Profile section should match golden files', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            Device.phone,
            Device.tabletPortrait,
            const Device(
              name: 'desktop',
              size: Size(1200, 800),
              devicePixelRatio: 1.0,
            ),
          ])
          ..addScenario(
            widget: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    // Simula navegação para a aba de perfil
                    return ResponsiveBuilder(
                      builder: (context, deviceType) {
                        return SingleChildScrollView(
                          padding: ResponsiveUtils.responsivePadding(context),
                          child: Column(
                            children: [
                              // Aqui seria o conteúdo do perfil
                              Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Text('Profile Content'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            name: 'profile_section',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'profile_section_responsive');
      });
    });

    group('Dark Mode Golden Tests', () {
      testGoldens('Core widgets should match golden files in dark mode', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: MaterialApp(
              theme: ThemeData.dark(),
              home: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    AppCard(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Dark Mode Card'),
                      ),
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      text: 'Dark Mode Button',
                      onPressed: null,
                    ),
                    SizedBox(height: 16),
                    AppEmptyState(
                      icon: Icons.movie,
                      title: 'Dark Mode Empty',
                      subtitle: 'Testing dark theme',
                    ),
                  ],
                ),
              ),
            ),
            name: 'dark_mode_widgets',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'dark_mode_widgets');
      });
    });

    group('Edge Cases Golden Tests', () {
      testGoldens('Widgets should handle long text gracefully', (tester) async {
        const longText = 'Este é um texto muito longo que deve ser tratado adequadamente pelos widgets sem causar overflow ou problemas de layout. Deve ser truncado ou quebrado corretamente.';
        
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(longText),
                  ),
                ),
                SizedBox(height: 16),
                AppButton(
                  text: longText,
                  onPressed: null,
                ),
                SizedBox(height: 16),
                AppEmptyState(
                  icon: Icons.movie,
                  title: longText,
                  subtitle: longText,
                ),
              ],
            ),
            name: 'long_text_handling',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'long_text_handling');
      });

      testGoldens('Small screen layout should not overflow', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            const Device(
              name: 'small_phone',
              size: Size(320, 568), // iPhone SE size
              devicePixelRatio: 2.0,
            ),
          ])
          ..addScenario(
            widget: const HomePage(),
            name: 'small_screen',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'small_screen_layout');
      });
    });
  });
}
