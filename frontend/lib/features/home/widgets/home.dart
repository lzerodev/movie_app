import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_cubit.dart';

import '../../../core/navigation/navigation_extensions.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/widgets/rtm_logo.dart';
import '../../movie/presentation/pages/now_playing_movies.dart';
import '../../movie/presentation/pages/search_movies.dart';

/// Dados para opções do perfil
class _ProfileOptionData {
  final IconData icon;
  final String title;
  final String subtitle;

  _ProfileOptionData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: AppConstants.appShortName,
      titleWidget: currentPageIndex == 0
          ? _buildBrandTitle()
          : Text(
              const [
                'Descobrir',
                'Buscar',
                'Favoritos',
                'Perfil',
              ][currentPageIndex],
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
      appBarHeight: 80,
      actions: _buildAppBarActions(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBrandTitle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Semantics(
          header: true,
          label: AppConstants.appDisplayName,
          excludeSemantics: true,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: RtmLogo()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appShortName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 23,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    if (constraints.maxWidth >= 200) ...[
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.appName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 11,
                          height: 1.2,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: currentPageIndex,
      children: [
        HeroMode(enabled: currentPageIndex == 0, child: _buildHomePage()),
        HeroMode(
          enabled: currentPageIndex == 1,
          child: SearchMoviesPage(embedded: true, focusNode: _searchFocusNode),
        ),
        _buildFavoritesPage(),
        _buildProfilePage(),
      ],
    );
  }

  Widget _buildHomePage() {
    return const Padding(
      padding: EdgeInsets.all(AppDesignSystem.spaceMd),
      child: NowPlayingMoviesPage(),
    );
  }

  Widget _buildFavoritesPage() {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Seus favoritos, em breve',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                'Você poderá guardar filmes e séries na sua conta.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return SingleChildScrollView(
          padding: ResponsiveUtils.responsivePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveUtils.getMaxContentWidth(context),
              ),
              child: Column(
                children: [
                  _buildResponsiveProfileHeader(deviceType, context),
                  SizedBox(height: ResponsiveUtils.responsiveSpacing(context)),
                  _buildResponsiveProfileOptions(deviceType, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveProfileHeader(
    DeviceType deviceType,
    BuildContext context,
  ) {
    final avatarSize = ResponsiveUtils.responsive<double>(
      context,
      mobile: 80,
      tablet: 100,
      desktop: 120,
      largeDesktop: 140,
    );
    final iconSize = avatarSize * 0.5;

    return AppCard(
      child: Padding(
        padding: ResponsiveUtils.responsive<EdgeInsets>(
          context,
          mobile: const EdgeInsets.all(24),
          tablet: const EdgeInsets.all(32),
          desktop: const EdgeInsets.all(40),
        ),
        child: Column(
          children: [
            // Avatar com tamanho responsivo
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                    Theme.of(context).colorScheme.surfaceContainer,
                  ],
                ),
              ),
              child: Icon(
                Icons.person,
                size: iconSize,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 0.75),

            // Nome com tipografia responsiva
            Text(
              'Usuário',
              style:
                  ResponsiveUtils.responsive<TextStyle>(
                    context,
                    mobile: Theme.of(context).textTheme.titleLarge!,
                    tablet: Theme.of(context).textTheme.headlineSmall!,
                    desktop: Theme.of(context).textTheme.headlineMedium!,
                  ).copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: ResponsiveUtils.responsiveSpacing(context) * 0.5),

            // Descrição com layout responsivo
            Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveUtils.responsive<double>(
                  context,
                  mobile: 300,
                  tablet: 400,
                  desktop: 500,
                ),
              ),
              child: Text(
                'Cinéfilo apaixonado por aventuras cinematográficas',
                style:
                    ResponsiveUtils.responsive<TextStyle>(
                      context,
                      mobile: Theme.of(context).textTheme.bodyMedium!,
                      tablet: Theme.of(context).textTheme.bodyLarge!,
                      desktop: Theme.of(context).textTheme.bodyLarge!,
                    ).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveProfileOptions(
    DeviceType deviceType,
    BuildContext context,
  ) {
    final options = [
      _ProfileOptionData(
        icon: Icons.favorite_outline,
        title: 'Meus Favoritos',
        subtitle: 'Filmes salvos para assistir depois',
      ),
      _ProfileOptionData(
        icon: Icons.history,
        title: 'Histórico',
        subtitle: 'Filmes que você já assistiu',
      ),
      _ProfileOptionData(
        icon: Icons.settings_outlined,
        title: 'Configurações',
        subtitle: 'Personalize sua experiência',
      ),
      _ProfileOptionData(
        icon: Icons.help_outline,
        title: 'Ajuda',
        subtitle: 'Central de suporte e FAQ',
      ),
      _ProfileOptionData(
        icon: Icons.info_outline,
        title: 'Sobre',
        subtitle: 'Informações do aplicativo',
      ),
      _ProfileOptionData(
        icon: Icons.logout_outlined,
        title: 'Sair',
        subtitle: 'Fazer logout da conta',
      ),
    ];

    // Layout em grid para desktop/largeDesktop
    if (deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop) {
      final columns = deviceType == DeviceType.largeDesktop ? 3 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: deviceType == DeviceType.largeDesktop ? 3.8 : 4.2,
        ),
        itemCount: options.length,
        itemBuilder: (itemContext, index) {
          return _buildResponsiveProfileOption(
            options[index],
            deviceType,
            context,
          );
        },
      );
    } else {
      // Layout em coluna para mobile e tablet
      return Column(
        children: options.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildResponsiveProfileOption(option, deviceType, context),
          );
        }).toList(),
      );
    }
  }

  Widget _buildResponsiveProfileOption(
    _ProfileOptionData option,
    DeviceType deviceType,
    BuildContext context,
  ) {
    final iconSize = ResponsiveUtils.responsive<double>(
      context,
      mobile: 24,
      tablet: 26,
      desktop: 28,
      largeDesktop: 30,
    );

    final padding = ResponsiveUtils.responsive<EdgeInsets>(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(20),
      desktop: const EdgeInsets.all(24),
    );

    return AppCard(
      onTap: () {
        // TODO: Implementar navegação específica para cada opção
        _handleProfileOptionTap(option.title);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            // Ícone com container decorativo
            Container(
              width: iconSize + 8,
              height: iconSize + 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive<double>(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
              ),
              child: Icon(
                option.icon,
                color: Theme.of(context).colorScheme.primary,
                size: iconSize,
              ),
            ),
            SizedBox(width: ResponsiveUtils.responsiveSpacing(context) * 0.75),

            // Conteúdo expandido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      option.title,
                      style:
                          ResponsiveUtils.responsive<TextStyle>(
                            context,
                            mobile: Theme.of(context).textTheme.titleSmall!,
                            tablet: Theme.of(context).textTheme.titleMedium!,
                            desktop: Theme.of(context).textTheme.titleMedium!,
                          ).copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Mostra subtitle com lógica melhorada
                  if (deviceType == DeviceType.mobile ||
                      deviceType == DeviceType.tablet ||
                      (deviceType == DeviceType.desktop &&
                          option.subtitle.length < 30) ||
                      (deviceType == DeviceType.largeDesktop &&
                          option.subtitle.length < 35)) ...[
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        option.subtitle,
                        style:
                            ResponsiveUtils.responsive<TextStyle>(
                              context,
                              mobile: Theme.of(context).textTheme.bodySmall!,
                              tablet: Theme.of(context).textTheme.bodyMedium!,
                              desktop: Theme.of(context).textTheme.bodyMedium!,
                            ).copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: deviceType == DeviceType.mobile ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Ícone de navegação
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: ResponsiveUtils.responsive<double>(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleProfileOptionTap(String option) {
    // TODO: Implementar navegação baseada na opção selecionada
    context.showMessage('Navegando para: $option');
  }

  Widget _buildBottomNavigationBar() {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() => currentPageIndex = index);
          if (index == 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && currentPageIndex == 1) {
                _searchFocusNode.requestFocus();
              }
            });
          }
        },
        backgroundColor: colors.surface,
        indicatorColor: colors.primary.withValues(alpha: .14),
        indicatorShape: const StadiumBorder(),
        height: 76,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Descobrir',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      PopupMenuButton<ThemeMode>(
        tooltip: 'Tema',
        icon: const Icon(Icons.brightness_6_outlined),
        initialValue: context.watch<ThemeCubit>().state,
        onSelected: context.read<ThemeCubit>().select,
        itemBuilder: (_) => [
          CheckedPopupMenuItem(
            value: ThemeMode.light,
            checked: context.read<ThemeCubit>().state == ThemeMode.light,
            child: const Text('Claro'),
          ),
          CheckedPopupMenuItem(
            value: ThemeMode.dark,
            checked: context.read<ThemeCubit>().state == ThemeMode.dark,
            child: const Text('Escuro'),
          ),
          CheckedPopupMenuItem(
            value: ThemeMode.system,
            checked: context.read<ThemeCubit>().state == ThemeMode.system,
            child: const Text('Sistema'),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 16),
        child: SizedBox(
          width: 48,
          height: 48,
          child: PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            icon: Icon(
              Icons.more_horiz_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            tooltip: 'Mais opções',
            position: PopupMenuPosition.under,
            offset: const Offset(0, 8),
            shape: RoundedRectangleBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            color: Theme.of(context).colorScheme.surface,
            elevation: 8,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'watchlist',
                child: _buildMenuItem(
                  icon: Icons.bookmark_outline,
                  title: 'Lista para assistir',
                  subtitle: 'Filmes salvos para depois',
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'settings',
                child: _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Configurações',
                  subtitle: 'Personalizar app',
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'Sobre',
                  subtitle: 'Informações do app',
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceXs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spaceXs),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: AppDesignSystem.borderRadiusXs,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDesignSystem.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'favorites':
        _showSnackBar('Favoritos - Em desenvolvimento');
        break;
      case 'watchlist':
        _showSnackBar('Lista para assistir - Em desenvolvimento');
        break;
      case 'settings':
        _showSnackBar('Configurações - Em desenvolvimento');
        break;
      case 'about':
        _showAboutDialog();
        break;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            const SizedBox(width: AppDesignSystem.spaceMd),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        margin: const EdgeInsets.all(AppDesignSystem.spaceMd),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSm),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                    Theme.of(context).colorScheme.surfaceContainer,
                  ],
                ),
                borderRadius: AppDesignSystem.borderRadiusSm,
              ),
              child: const RtmLogo(),
            ),
            const SizedBox(width: AppDesignSystem.spaceMd),
            Text(
              AppConstants.appShortName,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMd),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: AppDesignSystem.borderRadiusMd,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Versão', '1.0.0'),
                  const SizedBox(height: AppDesignSystem.spaceSm),
                  _buildInfoRow('Desenvolvido por', 'LZeroDev'),
                  const SizedBox(height: AppDesignSystem.spaceSm),
                  _buildInfoRow('Tecnologia', 'Flutter & TMDb API'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: const RoundedRectangleBorder(
                borderRadius: AppDesignSystem.borderRadiusSm,
              ),
            ),
            child: Text(
              'Fechar',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppDesignSystem.spaceMd),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
