import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/mixins/design_system_mixin.dart';
import '../../../../core/navigation/navigation.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/app_constants.dart';
import '../../data/models/movie.dart';

class MovieListItem extends StatefulWidget with DesignSystemMixin {
  final Movie movie;

  const MovieListItem({
    super.key,
    required this.movie,
  });

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem>
    with TickerProviderStateMixin, DesignSystemMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
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

  void _onTap() {
    // Navigate to movie detail page with hero transition
    context.goToMovieDetailWithHero(widget.movie);
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: defaultPadding,
            decoration: cardDecoration,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppDesignSystem.borderRadiusMd,
                onTap: _onTap,
                onHover: _onHover,
                child: Padding(
                  padding: defaultPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPosterImage(),
                      const SizedBox(width: AppDesignSystem.spaceMd),
                      Expanded(child: _buildMovieInfo()),
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

  Widget _buildPosterImage() {
    final posterUrl = widget.movie.posterPath != null
        ? '${AppConstants.tmdbImageBaseUrl}/${AppConstants.posterSize}${widget.movie.posterPath}'
        : null;

    return Hero(
      tag: 'movie_${widget.movie.id}',
      child: ClipRRect(
        borderRadius: AppDesignSystem.borderRadiusSm,
        child: SizedBox(
          width: 80,
          height: 120,
          child: posterUrl != null
              ? Image.network(
                  posterUrl,
                  fit: BoxFit.cover,
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppDesignSystem.surfaceColor,
                    child: const Icon(
                      Icons.movie,
                      color: AppDesignSystem.textSecondaryColor,
                      size: 32,
                    ),
                  ),
                )
              : Container(
                  color: AppDesignSystem.surfaceColor,
                  child: const Icon(
                    Icons.movie,
                    color: AppDesignSystem.textSecondaryColor,
                    size: 32,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    final voteAverage = widget.movie.voteAverage;
    final releaseDate =
        DateFormat.yMMMd('pt_BR').format(widget.movie.releaseDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.movie.title,
          style: sectionTitleStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDesignSystem.spaceSm),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            ),
            const SizedBox(width: AppDesignSystem.spaceXs),
            Text(
              voteAverage.toStringAsFixed(1),
              style: subtitleStyle,
            ),
            const SizedBox(width: AppDesignSystem.spaceMd),
            Text(
              releaseDate,
              style: subtitleStyle,
            ),
          ],
        ),
        const SizedBox(height: AppDesignSystem.spaceSm),
        Text(
          widget.movie.overview,
          style: secondaryTextStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
