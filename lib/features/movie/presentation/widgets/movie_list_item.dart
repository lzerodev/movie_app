import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../core/navigation/navigation.dart';
import '../../data/models/movie.dart';

class MovieListItem extends StatefulWidget {
  const MovieListItem({required this.movie, super.key});

  final Movie movie;

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voteAverage = widget.movie.voteAverage;
    final releaseDate = DateFormat.yMMMd('pt_BR').format(widget.movie.releaseDate);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.spaceMd,
              vertical: AppDesignSystem.spaceSm,
            ),
            decoration: BoxDecoration(
              color: AppDesignSystem.cardColor,
              borderRadius: AppDesignSystem.borderRadiusMd,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppDesignSystem.accentColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppDesignSystem.cardColor,
                  AppDesignSystem.cardColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppDesignSystem.borderRadiusMd,
                onTap: () {
                  // Usa o novo sistema de navegação com transição hero
                  context.goToMovieDetailWithHero(widget.movie);
                },
                onHover: (isHovered) {
                  setState(() {
                    _isHovered = isHovered;
                  });
                  if (isHovered) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppDesignSystem.spaceMd),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPosterSection(),
                      const SizedBox(width: AppDesignSystem.spaceMd),
                      Expanded(child: _buildInfoSection(voteAverage, releaseDate)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPosterSection() {
    return Hero(
      tag: 'movie_${widget.movie.id}',
      child: Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppDesignSystem.surfaceColor,
                child: const Icon(
                  Icons.movie,
                  color: AppDesignSystem.iconSecondaryColor,
                  size: 40,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: AppDesignSystem.surfaceColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppDesignSystem.accentColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(double voteAverage, String releaseDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.movie.title,
          style: AppDesignSystem.titleMedium.copyWith(
            color: AppDesignSystem.textPrimaryColor,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDesignSystem.spaceSm),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppDesignSystem.accentColor.withOpacity(0.8),
                    AppDesignSystem.accentColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppDesignSystem.accentColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    voteAverage.toStringAsFixed(1),
                    style: AppDesignSystem.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDesignSystem.spaceSm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppDesignSystem.primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppDesignSystem.primaryLightColor,
                  width: 1,
                ),
              ),
              child: Text(
                _getScoreLabel(voteAverage),
                style: AppDesignSystem.labelSmall.copyWith(
                  color: AppDesignSystem.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceSm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppDesignSystem.surfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: AppDesignSystem.textSecondaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                releaseDate,
                style: AppDesignSystem.bodySmall.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesignSystem.spaceSm),
        if (widget.movie.overview.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppDesignSystem.surfaceColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppDesignSystem.borderColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.movie.overview,
              style: AppDesignSystem.bodySmall.copyWith(
                color: AppDesignSystem.textTertiaryColor,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
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
