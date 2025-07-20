import 'package:flutter/material.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/widgets/app_button.dart' show AppCardLegacy;
import '../../../core/theme/app_design_system.dart';
import '../../../core/navigation/navigation.dart';
import '../../movie/presentation/pages/now_playing_movies.dart';
import '../../movie/presentation/pages/search_movies.dart';
import '../../movie/presentation/pages/navigation_demo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: 'Testflix',
      actions: _buildAppBarActions(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    return IndexedStack(
      index: currentPageIndex,
      children: [
        _buildHomePage(),
        _buildNotificationsPage(),
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
  
  Widget _buildNotificationsPage() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceMd),
      child: Column(
        children: [
          _buildNotificationCard(
            icon: Icons.new_releases,
            title: 'Novos filmes hoje!',
            subtitle: 'Descubra onde assistir seus filmes favoritos',
            color: AppDesignSystem.accentColor,
          ),
          const SizedBox(height: AppDesignSystem.spaceMd),
          _buildNotificationCard(
            icon: Icons.local_fire_department,
            title: 'Em alta agora',
            subtitle: 'Veja os filmes mais populares da semana',
            color: AppDesignSystem.warningColor,
          ),
          const SizedBox(height: AppDesignSystem.spaceMd),
          _buildNotificationCard(
            icon: Icons.star,
            title: 'Recomendado para você',
            subtitle: 'Baseado nos seus filmes favoritos',
            color: AppDesignSystem.successColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return AppCardLegacy(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppDesignSystem.spaceSm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: AppDesignSystem.borderRadiusSm,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppDesignSystem.titleMedium.copyWith(
            color: AppDesignSystem.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppDesignSystem.bodyMedium.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppDesignSystem.iconSecondaryColor,
          size: 16,
        ),
      ),
    );
  }
  
  Widget _buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: AppDesignSystem.spaceXl),
          _buildProfileOptions(),
        ],
      ),
    );
  }
  
  Widget _buildProfileHeader() {
    return AppCardLegacy(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppDesignSystem.accentGradient,
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppDesignSystem.textPrimaryColor,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spaceMd),
          Text(
            'Usuário',
            style: AppDesignSystem.headlineSmall.copyWith(
              color: AppDesignSystem.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spaceSm),
          Text(
            'Cinéfilo apaixonado por aventuras',
            style: AppDesignSystem.bodyMedium.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileOptions() {
    return Column(
      children: [
        _buildProfileOption(
          icon: Icons.favorite_outline,
          title: 'Meus Favoritos',
          subtitle: 'Filmes salvos para assistir depois',
        ),
        _buildProfileOption(
          icon: Icons.history,
          title: 'Histórico',
          subtitle: 'Filmes que você já assistiu',
        ),
        _buildProfileOption(
          icon: Icons.settings_outlined,
          title: 'Configurações',
          subtitle: 'Personalize sua experiência',
        ),
        _buildProfileOption(
          icon: Icons.help_outline,
          title: 'Ajuda',
          subtitle: 'Central de suporte e FAQ',
        ),
        _buildProfileOption(
          icon: Icons.navigation_rounded,
          title: 'Demo de Navegação',
          subtitle: 'Teste do sistema de navegação',
          onTap: () => _navigateToNavigationDemo(),
        ),
      ],
    );
  }
  
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceMd),
      child: AppCardLegacy(
        onTap: onTap ?? () {
          // TODO: Implementar navegação
        },
        child: ListTile(
          leading: Icon(
            icon,
            color: AppDesignSystem.accentColor,
            size: 24,
          ),
          title: Text(
            title,
            style: AppDesignSystem.titleMedium.copyWith(
              color: AppDesignSystem.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: AppDesignSystem.bodyMedium.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppDesignSystem.iconSecondaryColor,
            size: 16,
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppDesignSystem.cardBorderColor,
            width: 0.5,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: AppDesignSystem.surfaceColor,
        indicatorColor: AppDesignSystem.accentColor.withOpacity(0.15),
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
        ),
        elevation: 0,
        height: 80,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: currentPageIndex == 0 
                  ? AppDesignSystem.accentColor 
                  : AppDesignSystem.iconSecondaryColor,
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceXs),
              decoration: BoxDecoration(
                color: AppDesignSystem.accentColor.withOpacity(0.1),
                borderRadius: AppDesignSystem.borderRadiusSm,
              ),
              child: const Icon(
                Icons.home_rounded,
                color: AppDesignSystem.accentColor,
              ),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              label: const Text(
                '2',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppDesignSystem.accentColor,
              textColor: AppDesignSystem.textPrimaryColor,
              child: Icon(
                Icons.notifications_outlined,
                color: currentPageIndex == 1 
                    ? AppDesignSystem.accentColor 
                    : AppDesignSystem.iconSecondaryColor,
              ),
            ),
            selectedIcon: Badge(
              label: const Text(
                '2',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppDesignSystem.accentColor,
              textColor: AppDesignSystem.textPrimaryColor,
              child: Container(
                padding: const EdgeInsets.all(AppDesignSystem.spaceXs),
                decoration: BoxDecoration(
                  color: AppDesignSystem.accentColor.withOpacity(0.1),
                  borderRadius: AppDesignSystem.borderRadiusSm,
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: AppDesignSystem.accentColor,
                ),
              ),
            ),
            label: 'Notificações',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
              color: currentPageIndex == 2 
                  ? AppDesignSystem.accentColor 
                  : AppDesignSystem.iconSecondaryColor,
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceXs),
              decoration: BoxDecoration(
                color: AppDesignSystem.accentColor.withOpacity(0.1),
                borderRadius: AppDesignSystem.borderRadiusSm,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppDesignSystem.accentColor,
              ),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppDesignSystem.accentGradient,
        borderRadius: AppDesignSystem.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppDesignSystem.accentColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppDesignSystem.accentColor.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _navigateToSearch,
        backgroundColor: Colors.transparent,
        foregroundColor: AppDesignSystem.textPrimaryColor,
        elevation: 0,
        highlightElevation: 0,
        splashColor: AppDesignSystem.textPrimaryColor.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
        ),
        icon: const Icon(
          Icons.search_rounded,
          size: 24,
        ),
        label: Text(
          'Buscar',
          style: AppDesignSystem.labelLarge.copyWith(
            color: AppDesignSystem.textPrimaryColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
  
  void _navigateToSearch() {
    context.goToSearchMovies();
  }

  void _navigateToNavigationDemo() {
    context.goToNavigationDemo();
  }

  List<Widget> _buildAppBarActions() {
    return [
      // Botão de busca com badge
      Container(
        margin: const EdgeInsets.only(right: AppDesignSystem.spaceSm),
        decoration: BoxDecoration(
          color: AppDesignSystem.accentColor.withOpacity(0.1),
          borderRadius: AppDesignSystem.borderRadiusSm,
          border: Border.all(
            color: AppDesignSystem.accentColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: _navigateToSearch,
          icon: const Icon(
            Icons.search_rounded,
            color: AppDesignSystem.accentColor,
          ),
          tooltip: 'Buscar filmes',
          splashRadius: 20,
        ),
      ),
      // Menu de opções
      Container(
        margin: const EdgeInsets.only(right: AppDesignSystem.spaceMd),
        decoration: BoxDecoration(
          color: AppDesignSystem.cardColor,
          borderRadius: AppDesignSystem.borderRadiusSm,
          border: Border.all(
            color: AppDesignSystem.cardBorderColor,
            width: 1,
          ),
        ),
        child: PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          icon: const Icon(
            Icons.more_vert_rounded,
            color: AppDesignSystem.iconPrimaryColor,
          ),
          tooltip: 'Mais opções',
          shape: const RoundedRectangleBorder(
            borderRadius: AppDesignSystem.borderRadiusMd,
            side: BorderSide(
              color: AppDesignSystem.cardBorderColor,
            ),
          ),
          color: AppDesignSystem.cardColor,
          elevation: 8,
          shadowColor: AppDesignSystem.primaryColor.withOpacity(0.3),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'favorites',
              child: _buildMenuItem(
                icon: Icons.favorite_outline,
                title: 'Favoritos',
                subtitle: 'Meus filmes salvos',
              ),
            ),
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
              color: AppDesignSystem.accentColor.withOpacity(0.1),
              borderRadius: AppDesignSystem.borderRadiusXs,
            ),
            child: Icon(
              icon,
              color: AppDesignSystem.accentColor,
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
                  style: AppDesignSystem.titleSmall.copyWith(
                    color: AppDesignSystem.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppDesignSystem.bodySmall.copyWith(
                    color: AppDesignSystem.textSecondaryColor,
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
            const Icon(
              Icons.info_outline,
              color: AppDesignSystem.textPrimaryColor,
              size: 20,
            ),
            const SizedBox(width: AppDesignSystem.spaceMd),
            Expanded(
              child: Text(
                message,
                style: AppDesignSystem.bodyMedium.copyWith(
                  color: AppDesignSystem.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppDesignSystem.cardColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          side: BorderSide(
            color: AppDesignSystem.cardBorderColor,
          ),
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
        backgroundColor: AppDesignSystem.cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
          side: BorderSide(
            color: AppDesignSystem.cardBorderColor,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceSm),
              decoration: const BoxDecoration(
                gradient: AppDesignSystem.accentGradient,
                borderRadius: AppDesignSystem.borderRadiusSm,
              ),
              child: const Icon(
                Icons.movie_outlined,
                color: AppDesignSystem.textPrimaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceMd),
            Text(
              'Testflix',
              style: AppDesignSystem.headlineSmall.copyWith(
                color: AppDesignSystem.textPrimaryColor,
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
              'Seu app de filmes favorito',
              style: AppDesignSystem.bodyLarge.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppDesignSystem.spaceMd),
              decoration: BoxDecoration(
                color: AppDesignSystem.backgroundColor,
                borderRadius: AppDesignSystem.borderRadiusMd,
                border: Border.all(
                  color: AppDesignSystem.cardBorderColor,
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
              backgroundColor: AppDesignSystem.accentColor.withOpacity(0.1),
              shape: const RoundedRectangleBorder(
                borderRadius: AppDesignSystem.borderRadiusSm,
              ),
            ),
            child: Text(
              'Fechar',
              style: AppDesignSystem.labelLarge.copyWith(
                color: AppDesignSystem.accentColor,
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
        Text(
          label,
          style: AppDesignSystem.bodyMedium.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
        Text(
          value,
          style: AppDesignSystem.bodyMedium.copyWith(
            color: AppDesignSystem.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
