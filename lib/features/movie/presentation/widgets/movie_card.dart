import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/movie.dart';

/// Card de filme moderno seguindo o Design System.
class MovieCard extends StatelessWidget {
  /// Dados do filme
  final Movie movie;

  /// Função chamada quando o card é tocado
  final VoidCallback? onTap;

  /// Se deve mostrar o rating
  final bool showRating;

  /// Se deve mostrar a data de lançamento
  final bool showReleaseDate;

  /// Tamanho do card
  final MovieCardSize size;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.showRating = true,
    this.showReleaseDate = true,
    this.size = MovieCardSize.medium,
  });

  /// Factory para criar um card pequeno
  const MovieCard.small({
    super.key,
    required this.movie,
    this.onTap,
    this.showRating = false,
    this.showReleaseDate = false,
  }) : size = MovieCardSize.small;

  /// Factory para criar um card grande
  const MovieCard.large({
    super.key,
    required this.movie,
    this.onTap,
    this.showRating = true,
    this.showReleaseDate = true,
  }) : size = MovieCardSize.large;

  @override
  Widget build(BuildContext context) {
    return AppCard.elevated(
      padding: EdgeInsets.zero, // Remove padding padrão para controle total do layout
      onTap: onTap,
      size: _getCardSize(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Evita espaçamentos extras
        children: [
          _buildPosterSection(),
          _buildInfoSection(),
        ],
      ),
    );
  }

  Widget _buildPosterSection() {
    return Container(
      width: double.infinity,
      height: _getImageHeight(),
      color: AppDesignSystem.shimmerBaseColor,
      child: Stack(
        children: [
          movie.posterPath != null
              ? Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: _getImageHeight(),
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImagePlaceholder(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return AppShimmerBox(
                      width: double.infinity,
                      height: _getImageHeight(),
                      borderRadius: BorderRadius.zero,
                    );
                  },
                )
              : _buildImagePlaceholder(),
          if (showRating && movie.voteAverage > 0)
            Positioned(
              top: AppDesignSystem.spaceSm,
              right: AppDesignSystem.spaceSm,
              child: _buildRatingBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppDesignSystem.shimmerBaseColor,
      child: Center(
        child: Icon(
          Icons.movie,
          size: _getImageHeight() * 0.3,
          color: AppDesignSystem.iconSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    final rating = movie.voteAverage;
    final color = _getRatingColor(rating);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spaceSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: AppDesignSystem.borderRadiusSm,
        boxShadow: AppDesignSystem.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 12,
            color: AppDesignSystem.textPrimaryColor,
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: AppDesignSystem.labelSmall.copyWith(
              color: AppDesignSystem.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 8.0) return AppDesignSystem.successColor;
    if (rating >= 6.0) return AppDesignSystem.warningColor;
    return AppDesignSystem.errorColor;
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      color: AppDesignSystem.cardColor,
      margin: EdgeInsets.zero, // Remove qualquer margem
      padding: const EdgeInsets.all(AppDesignSystem.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            movie.title,
            style: _getTitleStyle(),
            maxLines: size == MovieCardSize.small ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (movie.overview.isNotEmpty && size != MovieCardSize.small) ...[
            const SizedBox(height: AppDesignSystem.spaceSm),
            Text(
              movie.overview,
              style: AppDesignSystem.bodySmall.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
              maxLines: size == MovieCardSize.large ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (showReleaseDate) ...[
            const SizedBox(height: AppDesignSystem.spaceSm),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppDesignSystem.iconSecondaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatReleaseDate(),
                  style: AppDesignSystem.labelSmall.copyWith(
                    color: AppDesignSystem.textTertiaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  TextStyle _getTitleStyle() {
    switch (size) {
      case MovieCardSize.small:
        return AppDesignSystem.titleSmall.copyWith(
          color: AppDesignSystem.textPrimaryColor,
          fontWeight: FontWeight.w600,
        );
      case MovieCardSize.medium:
        return AppDesignSystem.titleMedium.copyWith(
          color: AppDesignSystem.textPrimaryColor,
          fontWeight: FontWeight.w600,
        );
      case MovieCardSize.large:
        return AppDesignSystem.titleLarge.copyWith(
          color: AppDesignSystem.textPrimaryColor,
          fontWeight: FontWeight.w600,
        );
    }
  }

  double _getImageHeight() {
    switch (size) {
      case MovieCardSize.small:
        return 120;
      case MovieCardSize.medium:
        return 200;
      case MovieCardSize.large:
        return 280;
    }
  }

  String _formatReleaseDate() {
    final date = movie.releaseDate;
    final months = [
      '',
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  }

  AppCardSize _getCardSize() {
    switch (size) {
      case MovieCardSize.small:
        return AppCardSize.small;
      case MovieCardSize.medium:
        return AppCardSize.medium;
      case MovieCardSize.large:
        return AppCardSize.large;
    }
  }
}

/// Tamanhos disponíveis para o MovieCard
enum MovieCardSize {
  small,
  medium,
  large,
}

/// Lista de filmes com shimmer loading
class MovieGridView extends StatelessWidget {
  /// Lista de filmes
  final List<Movie> movies;

  /// Se está carregando
  final bool isLoading;

  /// Função chamada quando um filme é tocado
  final Function(Movie)? onMovieTap;

  /// Tamanho dos cards
  final MovieCardSize cardSize;

  /// Número de colunas no grid
  final int crossAxisCount;

  /// Espaçamento entre os itens
  final double spacing;

  const MovieGridView({
    super.key,
    required this.movies,
    this.isLoading = false,
    this.onMovieTap,
    this.cardSize = MovieCardSize.medium,
    this.crossAxisCount = 2,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmerGrid();
    }

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _getAspectRatio(),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(
          movie: movie,
          size: cardSize,
          onTap: () => onMovieTap?.call(movie),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _getAspectRatio(),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: 6, // Mostra 6 placeholders
      itemBuilder: (context, index) {
        return AppShimmerBox(
          height: _getCardHeight(),
          borderRadius: AppDesignSystem.borderRadiusMd,
        );
      },
    );
  }

  double _getAspectRatio() {
    switch (cardSize) {
      case MovieCardSize.small:
        return 0.8;
      case MovieCardSize.medium:
        return 0.65;
      case MovieCardSize.large:
        return 0.6;
    }
  }

  double _getCardHeight() {
    switch (cardSize) {
      case MovieCardSize.small:
        return 200;
      case MovieCardSize.medium:
        return 300;
      case MovieCardSize.large:
        return 400;
    }
  }
}
