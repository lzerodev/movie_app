import 'package:flutter/material.dart';

import '../../../../core/navigation/navigation.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/movie.dart';

/// Demonstração do sistema de navegação AppRouter
class NavigationDemoPage extends StatelessWidget {
  const NavigationDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: 'Sistema de Navegação',
      body: Padding(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Navegação Básica'),
            const SizedBox(height: AppDesignSystem.spaceMd),
            _buildNavigationButtons(context),
            const SizedBox(height: AppDesignSystem.spaceXl),
            _buildSectionTitle('Transições Customizadas'),
            const SizedBox(height: AppDesignSystem.spaceMd),
            _buildTransitionButtons(context),
            const SizedBox(height: AppDesignSystem.spaceXl),
            _buildSectionTitle('Dialogs e Modals'),
            const SizedBox(height: AppDesignSystem.spaceMd),
            _buildDialogButtons(context),
            const SizedBox(height: AppDesignSystem.spaceXl),
            _buildSectionTitle('Mensagens'),
            const SizedBox(height: AppDesignSystem.spaceMd),
            _buildMessageButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppDesignSystem.titleLarge.copyWith(
        color: AppDesignSystem.textPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Filmes em Cartaz',
          icon: Icons.movie_outlined,
          onPressed: () => context.goToNowPlayingMovies(),
          variant: AppButtonVariant.primary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Buscar Filmes',
          icon: Icons.search,
          onPressed: () => context.goToSearchMovies(),
          variant: AppButtonVariant.secondary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Detalhes de Filme (Exemplo)',
          icon: Icons.info_outline,
          onPressed: () => _navigateToMovieDetail(context),
          variant: AppButtonVariant.secondary,
        ),
      ],
    );
  }

  Widget _buildTransitionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Slide com Fade',
          icon: Icons.slideshow,
          onPressed: () =>
              _showTransitionDemo(context, AppTransitionType.slideFade),
          variant: AppButtonVariant.primary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Zoom',
          icon: Icons.zoom_in,
          onPressed: () => _showTransitionDemo(context, AppTransitionType.zoom),
          variant: AppButtonVariant.secondary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Modal Slide',
          icon: Icons.vertical_align_bottom,
          onPressed: () =>
              _showTransitionDemo(context, AppTransitionType.modalSlide),
          variant: AppButtonVariant.secondary,
        ),
      ],
    );
  }

  Widget _buildDialogButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Dialog de Confirmação',
          icon: Icons.help_outline,
          onPressed: () => _showConfirmationDialog(context),
          variant: AppButtonVariant.primary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Dialog de Informação',
          icon: Icons.info,
          onPressed: () => _showInfoDialog(context),
          variant: AppButtonVariant.secondary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Loading Dialog',
          icon: Icons.hourglass_empty,
          onPressed: () => _showLoadingDialog(context),
          variant: AppButtonVariant.secondary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Bottom Sheet',
          icon: Icons.view_agenda,
          onPressed: () => _showBottomSheet(context),
          variant: AppButtonVariant.text,
        ),
      ],
    );
  }

  Widget _buildMessageButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Mensagem Simples',
          icon: Icons.message,
          onPressed: () => context.showMessage('Esta é uma mensagem simples!'),
          variant: AppButtonVariant.primary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Mensagem de Sucesso',
          icon: Icons.check_circle,
          onPressed: () =>
              context.showSuccessMessage('Operação realizada com sucesso!'),
          variant: AppButtonVariant.secondary,
        ),
        const SizedBox(height: AppDesignSystem.spaceMd),
        AppButton(
          text: 'Mensagem de Erro',
          icon: Icons.error,
          onPressed: () => context.showErrorMessage('Ops! Algo deu errado.'),
          variant: AppButtonVariant.secondary,
        ),
      ],
    );
  }

  void _navigateToMovieDetail(BuildContext context) {
    // Cria um filme de exemplo
    final movie = Movie(
      id: 999,
      title: 'Filme de Demonstração',
      overview:
          'Este é um filme de exemplo para demonstrar o sistema de navegação.',
      posterPath: '/example.jpg',
      backdropPath: '/example-backdrop.jpg',
      releaseDate: DateTime.now(),
      voteAverage: 8.5,
    );

    context.goToMovieDetailWithHero(movie);
  }

  void _showTransitionDemo(
      BuildContext context, AppTransitionType transitionType) {
    final route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return _TransitionDemoPage(transitionType: transitionType);
      },
      transitionsBuilder: transitionType.builder,
      transitionDuration: const Duration(milliseconds: 500),
    );

    Navigator.of(context).push(route);
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final result = await context.showConfirmationDialog(
      title: 'Confirmar Ação',
      message: 'Deseja realmente executar esta ação?',
      confirmText: 'Sim',
      cancelText: 'Não',
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      context.showSuccessMessage('Ação confirmada!');
    } else {
      // ignore: use_build_context_synchronously
      context.showMessage('Ação cancelada.');
    }
  }

  Future<void> _showInfoDialog(BuildContext context) async {
    await context.showInfoDialog(
      title: 'Informação',
      message: 'Este é um dialog de informação usando o sistema de navegação.',
      buttonText: 'Entendi',
    );
  }

  Future<void> _showLoadingDialog(BuildContext context) async {
    try {
      await context.showLoadingDialog(
        message: 'Processando...',
        future: Future.delayed(const Duration(seconds: 2)),
      );

      // ignore: use_build_context_synchronously
      context.showSuccessMessage('Processamento concluído!');
    } catch (error) {
      // ignore: use_build_context_synchronously
      context.showErrorMessage('Erro no processamento: $error');
    }
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    await context.showAppBottomSheet(
      content: Container(
        padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppDesignSystem.textSecondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceLg),
            Text(
              'Bottom Sheet Modal',
              style: AppDesignSystem.titleLarge.copyWith(
                color: AppDesignSystem.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceMd),
            Text(
              'Este é um bottom sheet criado usando o sistema de navegação.',
              style: AppDesignSystem.bodyLarge.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignSystem.spaceXl),
            AppButton(
              text: 'Fechar',
              onPressed: () => AppRouter.pop(),
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

/// Página de demonstração de transições
class _TransitionDemoPage extends StatelessWidget {
  final AppTransitionType transitionType;

  const _TransitionDemoPage({required this.transitionType});

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: 'Transição: ${transitionType.name}',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: AppDesignSystem.accentGradient,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppDesignSystem.accentColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.animation,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceXl),
            Text(
              'Transição: ${transitionType.name}',
              style: AppDesignSystem.headlineSmall.copyWith(
                color: AppDesignSystem.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDesignSystem.spaceMd),
            Text(
              'Esta página foi aberta usando a transição ${transitionType.name}.',
              style: AppDesignSystem.bodyLarge.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignSystem.spaceXl),
            AppButton(
              text: 'Voltar',
              icon: Icons.arrow_back,
              onPressed: () => AppRouter.pop(),
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
