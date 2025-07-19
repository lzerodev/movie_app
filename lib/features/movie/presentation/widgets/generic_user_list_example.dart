import 'package:flutter/material.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/widgets.dart';

/// Exemplo de uso da AppPaginatedList para lista de usuários genérica
class GenericUserListExample extends StatefulWidget {
  const GenericUserListExample({super.key});

  @override
  State<GenericUserListExample> createState() => _GenericUserListExampleState();
}

class _GenericUserListExampleState extends State<GenericUserListExample> {
  List<User> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasReachedMax = false;
  String? _errorMessage;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Genérica de Usuários'),
        backgroundColor: AppDesignSystem.surfaceColor,
      ),
      body: AppPaginatedList<User>(
        // === DADOS DA LISTA ===
        items: _users,
        hasReachedMax: _hasReachedMax,
        isLoadingMore: _isLoading && _users.isNotEmpty,
        isLoading: _isLoading && _users.isEmpty,
        hasError: _hasError,
        errorMessage: _errorMessage,
        
        // === BUILDERS ===
        itemBuilder: (context, user, index) {
          return _UserListItem(
            user: user,
            index: index,
          );
        },
        
        // === CALLBACKS ===
        onLoadMore: _loadMoreUsers,
        onRefresh: _handleRefresh,
        onRetry: _retryLoad,
        
        // === CONFIGURAÇÕES CUSTOMIZADAS ===
        emptyStateConfig: const AppEmptyStateConfig(
          icon: Icons.people_outline,
          title: 'Nenhum usuário encontrado',
          subtitle: 'Não há usuários para exibir no momento.',
          actionLabel: 'Recarregar',
          variant: AppEmptyStateVariant.list,
        ),
        
        scrollConfig: const AppScrollConfig(
          showScrollToTop: true,
          scrollToTopPosition: EdgeInsets.only(
            bottom: 20,
            right: 20,
          ),
          scrollToTopVariant: AppScrollButtonVariant.filled,
          scrollToTopThreshold: 300.0,
          loadMoreThreshold: 0.8, // Carrega quando chegar a 80% do final
          scrollPhysics: AppScrollPhysicsType.bouncing,
          loadingMoreMessage: 'Carregando mais usuários...',
        ),
        
        layoutConfig: const AppListLayoutConfig(
          padding: EdgeInsets.all(AppDesignSystem.spaceMd),
          separatorHeight: 8.0,
        ),
        
        animationConfig: const AppListAnimationConfig(
          enableItemAnimation: true,
          animationDuration: 250,
          staggerDelay: 30,
          animationCurve: Curves.easeOut,
        ),
      ),
    );
  }

  // === MÉTODOS DE CARREGAMENTO ===
  Future<void> _loadUsers() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      // Simula carregamento de API
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final newUsers = _generateMockUsers(_currentPage);
      
      setState(() {
        if (_currentPage == 1) {
          _users = newUsers;
        } else {
          _users.addAll(newUsers);
        }
        
        _hasReachedMax = newUsers.length < 10; // Simula final da paginação
        _isLoading = false;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erro ao carregar usuários: $e';
      });
    }
  }

  void _loadMoreUsers() {
    _loadUsers();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _currentPage = 1;
      _hasReachedMax = false;
    });
    
    await _loadUsers();
  }

  void _retryLoad() {
    _loadUsers();
  }

  // === GERAÇÃO DE DADOS MOCK ===
  List<User> _generateMockUsers(int page) {
    final List<User> users = [];
    final int start = (page - 1) * 10;
    
    for (int i = start; i < start + 10; i++) {
      users.add(User(
        id: i,
        name: 'Usuário ${i + 1}',
        email: 'usuario${i + 1}@example.com',
        avatar: 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
        role: _getRoleForIndex(i),
      ));
    }
    
    return users;
  }

  String _getRoleForIndex(int index) {
    final roles = ['Admin', 'User', 'Moderator', 'Editor'];
    return roles[index % roles.length];
  }
}

/// Widget para item individual da lista de usuários
class _UserListItem extends StatelessWidget {
  final User user;
  final int index;

  const _UserListItem({
    required this.user,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(user.avatar),
          onBackgroundImageError: (_, __) {},
          child: user.avatar.isEmpty 
            ? Icon(
                Icons.person,
                color: AppDesignSystem.iconSecondaryColor,
              )
            : null,
        ),
        title: Text(
          user.name,
          style: AppDesignSystem.titleMedium.copyWith(
            color: AppDesignSystem.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: AppDesignSystem.bodyMedium.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _getRoleColor(user.role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.role,
                style: AppDesignSystem.labelSmall.copyWith(
                  color: _getRoleColor(user.role),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppDesignSystem.iconSecondaryColor,
          size: 16,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuário selecionado: ${user.name}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppDesignSystem.errorColor;
      case 'moderator':
        return AppDesignSystem.warningColor;
      case 'editor':
        return AppDesignSystem.infoColor;
      default:
        return AppDesignSystem.successColor;
    }
  }
}

/// Model de exemplo para usuário
class User {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
