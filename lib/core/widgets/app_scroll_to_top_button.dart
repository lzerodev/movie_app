import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Botão flutuante para voltar ao topo de listas com scroll.
/// 
/// Widget reutilizável que oferece funcionalidade de scroll-to-top
/// com animações suaves e posicionamento configurável.
class AppScrollToTopButton extends StatefulWidget {
  /// Controller do scroll a ser monitorado
  final ScrollController scrollController;
  
  /// Função customizada ao pressionar (opcional)
  final VoidCallback? onPressed;
  
  /// Limite de scroll para mostrar o botão (em pixels)
  final double threshold;
  
  /// Duração da animação de show/hide
  final Duration animationDuration;
  
  /// Duração da animação do scroll
  final Duration scrollAnimationDuration;
  
  /// Curva da animação do scroll
  final Curve scrollCurve;
  
  /// Posicionamento relativo ao Stack pai
  final EdgeInsets positioning;
  
  /// Ícone personalizado (opcional)
  final IconData icon;
  
  /// Tamanho do botão
  final double size;
  
  /// Tooltip personalizado
  final String? tooltip;
  
  /// Variante visual do botão
  final AppScrollButtonVariant variant;

  const AppScrollToTopButton({
    super.key,
    required this.scrollController,
    this.onPressed,
    this.threshold = 500.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.scrollAnimationDuration = const Duration(milliseconds: 800),
    this.scrollCurve = Curves.easeOutCubic,
    this.positioning = const EdgeInsets.only(bottom: 100, right: 16),
    this.icon = Icons.keyboard_arrow_up_rounded,
    this.size = 48.0,
    this.tooltip,
    this.variant = AppScrollButtonVariant.elevated,
  });

  @override
  State<AppScrollToTopButton> createState() => _AppScrollToTopButtonState();
}

class _AppScrollToTopButtonState extends State<AppScrollToTopButton>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _scaleController;
  late AnimationController _opacityController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup dos controllers de animação
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Setup das animações
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _opacityController,
      curve: Curves.easeInOut,
    ));

    // Listener do scroll
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _scaleController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = widget.scrollController.offset > widget.threshold;
    
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
      
      if (shouldShow) {
        _scaleController.forward();
        _opacityController.forward();
      } else {
        _scaleController.reverse();
        _opacityController.reverse();
      }
    }
  }

  void _scrollToTop() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else {
      widget.scrollController.animateTo(
        0,
        duration: widget.scrollAnimationDuration,
        curve: widget.scrollCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: widget.positioning.bottom,
      right: widget.positioning.right,
      left: widget.positioning.left,
      top: widget.positioning.top,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _opacityAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: _buildButton(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton() {
    final variant = widget.variant;
    
    return Tooltip(
      message: widget.tooltip ?? 'Voltar ao topo',
      preferBelow: false,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: _getDecoration(variant),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _scrollToTop,
            borderRadius: BorderRadius.circular(widget.size / 2),
            splashColor: _getSplashColor(variant),
            highlightColor: _getHighlightColor(variant),
            child: Container(
              padding: EdgeInsets.all(widget.size * 0.25),
              child: Icon(
                widget.icon,
                color: _getIconColor(variant),
                size: widget.size * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(AppScrollButtonVariant variant) {
    switch (variant) {
      case AppScrollButtonVariant.elevated:
        return BoxDecoration(
          color: AppDesignSystem.cardColor,
          borderRadius: BorderRadius.circular(widget.size / 2),
          border: Border.all(
            color: AppDesignSystem.accentColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppDesignSystem.primaryColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: AppDesignSystem.accentColor.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );
      
      case AppScrollButtonVariant.filled:
        return BoxDecoration(
          gradient: AppDesignSystem.accentGradient,
          borderRadius: BorderRadius.circular(widget.size / 2),
          boxShadow: [
            BoxShadow(
              color: AppDesignSystem.accentColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
      
      case AppScrollButtonVariant.outlined:
        return BoxDecoration(
          color: AppDesignSystem.backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(widget.size / 2),
          border: Border.all(
            color: AppDesignSystem.accentColor,
            width: 2,
          ),
        );
        
      case AppScrollButtonVariant.minimal:
        return BoxDecoration(
          color: AppDesignSystem.backgroundColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(widget.size / 2),
        );
    }
  }

  Color _getSplashColor(AppScrollButtonVariant variant) {
    switch (variant) {
      case AppScrollButtonVariant.elevated:
      case AppScrollButtonVariant.outlined:
      case AppScrollButtonVariant.minimal:
        return AppDesignSystem.accentColor.withOpacity(0.1);
      case AppScrollButtonVariant.filled:
        return Colors.white.withOpacity(0.1);
    }
  }

  Color _getHighlightColor(AppScrollButtonVariant variant) {
    switch (variant) {
      case AppScrollButtonVariant.elevated:
      case AppScrollButtonVariant.outlined:
      case AppScrollButtonVariant.minimal:
        return AppDesignSystem.accentColor.withOpacity(0.05);
      case AppScrollButtonVariant.filled:
        return Colors.white.withOpacity(0.05);
    }
  }

  Color _getIconColor(AppScrollButtonVariant variant) {
    switch (variant) {
      case AppScrollButtonVariant.elevated:
      case AppScrollButtonVariant.outlined:
      case AppScrollButtonVariant.minimal:
        return AppDesignSystem.accentColor;
      case AppScrollButtonVariant.filled:
        return Colors.white;
    }
  }
}

/// Variantes visuais do botão scroll-to-top
enum AppScrollButtonVariant {
  /// Botão elevado com sombra (padrão)
  elevated,
  
  /// Botão preenchido com gradiente
  filled,
  
  /// Botão apenas com borda
  outlined,
  
  /// Botão minimalista
  minimal,
}
