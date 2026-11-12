import 'package:material_ui/material_ui.dart';

import '../../../../core/navigation/navigation.dart';
import '../../data/models/movie.dart';

/// Card usado no catálogo e na busca, com a mesma tag Hero do detalhe.
class MovieListItem extends StatefulWidget {
  final Movie movie;
  final bool compact;
  final bool featured;

  const MovieListItem({
    super.key,
    required this.movie,
    this.compact = true,
    this.featured = false,
  });

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: 1.02,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final info = Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star_rounded, color: colors.tertiary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'TMDb ${widget.movie.voteAverage.toStringAsFixed(1)} / 10 · ${widget.movie.releaseDate.year}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    final poster = Hero(
      tag: 'movie_${widget.movie.id}',
      child: MoviePoster(movie: widget.movie),
    );
    Widget content;
    if (widget.featured) {
      content = SizedBox(
        height: 310,
        child: Stack(
          fit: StackFit.expand,
          children: [
            poster,
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xEE100F14)],
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EM CARTAZ',
                    style: TextStyle(
                      color: Color(0xFFB8DFC8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF3CB81),
                        size: 17,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'TMDb ${widget.movie.voteAverage.toStringAsFixed(1)} / 10',
                          style: text.labelMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (widget.compact) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, height: 135, child: poster),
          Expanded(child: info),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(aspectRatio: 2 / 3, child: poster),
          info,
        ],
      );
    }
    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.featured ? 24 : 18),
          side: BorderSide(color: colors.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.goToMovieDetailWithHero(widget.movie),
          onHover: (hover) =>
              hover ? _controller.forward() : _controller.reverse(),
          child: content,
        ),
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final Movie movie;
  const MoviePoster({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
    if (movie.posterPath == null || movie.posterPath!.isEmpty) {
      return placeholder;
    }
    return Image.network(
      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, error, stack) => placeholder,
    );
  }
}
