import 'package:flutter/material.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_design_system.dart';
import '../../movie/presentation/pages/now_playing_movies.dart';
import '../../movie/presentation/pages/search_movies.dart';

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
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _navigateToSearch,
        ),
      ],
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
    return AppCard(
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
    return AppCard(
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
      ],
    );
  }
  
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignSystem.spaceMd),
      child: AppCard(
        onTap: () {
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
    return NavigationBar(
      selectedIndex: currentPageIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      backgroundColor: AppDesignSystem.surfaceColor,
      indicatorColor: AppDesignSystem.accentColor.withOpacity(0.2),
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            color: currentPageIndex == 0 
                ? AppDesignSystem.accentColor 
                : AppDesignSystem.iconSecondaryColor,
          ),
          selectedIcon: const Icon(
            Icons.home,
            color: AppDesignSystem.accentColor,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(
            label: const Text('2'),
            backgroundColor: AppDesignSystem.accentColor,
            textColor: AppDesignSystem.textPrimaryColor,
            child: Icon(
              Icons.notifications_outlined,
              color: currentPageIndex == 1 
                  ? AppDesignSystem.accentColor 
                  : AppDesignSystem.iconSecondaryColor,
            ),
          ),
          selectedIcon: const Badge(
            label: Text('2'),
            backgroundColor: AppDesignSystem.accentColor,
            textColor: AppDesignSystem.textPrimaryColor,
            child: Icon(
              Icons.notifications,
              color: AppDesignSystem.accentColor,
            ),
          ),
          label: 'Notificações',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
            color: currentPageIndex == 2 
                ? AppDesignSystem.accentColor 
                : AppDesignSystem.iconSecondaryColor,
          ),
          selectedIcon: const Icon(
            Icons.person,
            color: AppDesignSystem.accentColor,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
  
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToSearch,
      backgroundColor: AppDesignSystem.accentColor,
      foregroundColor: AppDesignSystem.textPrimaryColor,
      icon: const Icon(Icons.search),
      label: const Text('Buscar'),
    );
  }
  
  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchMoviesPage(),
      ),
    );
  }
}
