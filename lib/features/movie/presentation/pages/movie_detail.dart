import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/mixins/design_system_mixin.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/movie.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin, DesignSystemMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDecoratedButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: compactPadding,
      decoration: cardDecoration.copyWith(
        color: AppDesignSystem.cardColor.withOpacity(0.9),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final releaseDate =
        DateFormat.yMMMd('pt_BR').format(widget.movie.releaseDate);

    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildMovieHeader(releaseDate),
                    _buildMovieStats(),
                    _buildMovieOverview(),
                    _buildActionButtons(),
                    const SizedBox(height: AppDesignSystem.spaceXl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppDesignSystem.backgroundColor,
      foregroundColor: AppDesignSystem.textPrimaryColor,
      leading: _buildDecoratedButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppDesignSystem.textPrimaryColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        _buildDecoratedButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite
                ? AppDesignSystem.accentColor
                : AppDesignSystem.textPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'movie_${widget.movie.id}',
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppDesignSystem.surfaceColor,
                    child: const Icon(
                      Icons.movie,
                      color: AppDesignSystem.iconSecondaryColor,
                      size: 80,
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppDesignSystem.backgroundColor.withOpacity(0.3),
                    AppDesignSystem.backgroundColor.withOpacity(0.8),
                    AppDesignSystem.backgroundColor,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieHeader(String releaseDate) {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.movie.title,
            style: AppDesignSystem.headlineLarge.copyWith(
              color: AppDesignSystem.textPrimaryColor,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppDesignSystem.spaceMd),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppDesignSystem.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppDesignSystem.accentColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.movie.voteAverage.toStringAsFixed(1),
                      style: AppDesignSystem.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDesignSystem.spaceMd),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppDesignSystem.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppDesignSystem.cardBorderColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppDesignSystem.iconSecondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      releaseDate,
                      style: AppDesignSystem.bodyMedium.copyWith(
                        color: AppDesignSystem.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovieStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLg),
      child: AppCardLegacy(
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.star_rounded,
                label: 'Avaliação',
                value: widget.movie.voteAverage.toStringAsFixed(1),
                color: AppDesignSystem.accentColor,
              ),
              _buildStatDivider(),
              _buildStatItem(
                icon: Icons.people_rounded,
                label: 'Votos',
                value: '${(widget.movie.voteAverage * 100).toInt()}',
                color: AppDesignSystem.infoColor,
              ),
              _buildStatDivider(),
              _buildStatItem(
                icon: Icons.category_rounded,
                label: 'Categoria',
                value: _getScoreLabel(widget.movie.voteAverage),
                color: AppDesignSystem.successColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDesignSystem.spaceSm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: AppDesignSystem.borderRadiusMd,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceSm),
        Text(
          value,
          style: AppDesignSystem.titleMedium.copyWith(
            color: AppDesignSystem.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppDesignSystem.bodySmall.copyWith(
            color: AppDesignSystem.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppDesignSystem.cardBorderColor,
    );
  }

  Widget _buildMovieOverview() {
    if (widget.movie.overview.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
      child: AppCardLegacy(
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: compactPadding,
                    decoration: const BoxDecoration(
                      gradient: AppDesignSystem.primaryGradient,
                      borderRadius: AppDesignSystem.borderRadiusSm,
                    ),
                    child: const Icon(
                      Icons.description_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDesignSystem.spaceMd),
                  Text(
                    'Sinopse',
                    style: AppDesignSystem.titleLarge.copyWith(
                      color: AppDesignSystem.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDesignSystem.spaceMd),
              Text(
                widget.movie.overview,
                style: AppDesignSystem.bodyLarge.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Assistir Trailer',
              icon: Icons.play_circle_rounded,
              onPressed: () {
                // TODO: Implementar reprodução do trailer
              },
              variant: AppButtonVariant.primary,
            ),
          ),
          const SizedBox(width: AppDesignSystem.spaceMd),
          AppButton(
            text: '',
            icon: Icons.share_rounded,
            onPressed: () {
              // TODO: Implementar compartilhamento
            },
            variant: AppButtonVariant.secondary,
          ),
        ],
      ),
    );
  }

  String _getScoreLabel(double score) {
    if (score >= 8.0) return 'Excelente';
    if (score >= 7.0) return 'Muito Bom';
    if (score >= 6.0) return 'Bom';
    if (score >= 5.0) return 'Regular';
    return 'Ruim';
  }
}
