import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Widget de loading personalizado que segue o Design System da aplicação.
class AppLoading extends StatelessWidget {
  /// Tamanho do indicador de loading
  final double? size;
  
  /// Cor do indicador de loading
  final Color? color;
  
  /// Espessura da linha do indicador
  final double? strokeWidth;
  
  /// Mensagem a ser exibida abaixo do loading (opcional)
  final String? message;
  
  /// Se deve mostrar um overlay semi-transparente
  final bool overlay;
  
  const AppLoading({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
    this.message,
    this.overlay = false,
  });
  
  /// Factory para criar um loading pequeno
  const AppLoading.small({
    super.key,
    this.color,
    this.strokeWidth,
    this.message,
    this.overlay = false,
  }) : size = 16;
  
  /// Factory para criar um loading médio (padrão)
  const AppLoading.medium({
    super.key,
    this.color,
    this.strokeWidth,
    this.message,
    this.overlay = false,
  }) : size = 24;
  
  /// Factory para criar um loading grande
  const AppLoading.large({
    super.key,
    this.color,
    this.strokeWidth,
    this.message,
    this.overlay = false,
  }) : size = 48;
  
  /// Factory para criar um loading com overlay
  const AppLoading.overlay({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
    this.message,
  }) : overlay = true;
  
  @override
  Widget build(BuildContext context) {
    final loadingWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: CircularProgressIndicator(
            color: color ?? AppDesignSystem.accentColor,
            strokeWidth: strokeWidth ?? 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppDesignSystem.spaceMd),
          Text(
            message!,
            style: AppDesignSystem.bodyMedium.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
    
    if (overlay) {
      return Container(
        color: AppDesignSystem.backgroundColor.withOpacity(0.8),
        child: Center(child: loadingWidget),
      );
    }
    
    return loadingWidget;
  }
}

/// Widget de shimmer para efeito de loading em listas
class AppShimmer extends StatefulWidget {
  /// Widget filho que terá o efeito shimmer
  final Widget child;
  
  /// Cor base do shimmer
  final Color? baseColor;
  
  /// Cor de destaque do shimmer
  final Color? highlightColor;
  
  /// Se o efeito está ativo
  final bool enabled;
  
  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });
  
  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    if (widget.enabled) {
      _controller.repeat();
    }
  }
  
  @override
  void didUpdateWidget(AppShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppDesignSystem.shimmerBaseColor,
                widget.highlightColor ?? AppDesignSystem.shimmerHighlightColor,
                widget.baseColor ?? AppDesignSystem.shimmerBaseColor,
              ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Widget de placeholder para loading de conteúdo
class AppShimmerBox extends StatelessWidget {
  /// Largura do box
  final double? width;
  
  /// Altura do box
  final double height;
  
  /// Raio da borda
  final BorderRadius? borderRadius;
  
  const AppShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppDesignSystem.shimmerBaseColor,
          borderRadius: borderRadius ?? AppDesignSystem.borderRadiusMd,
        ),
      ),
    );
  }
}
