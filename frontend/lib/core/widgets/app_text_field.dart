import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_design_system.dart';

/// Campo de entrada personalizado que segue o Design System da aplicação.
class AppTextField extends StatefulWidget {
  /// Texto do label
  final String? label;
  
  /// Texto do placeholder
  final String? hintText;
  
  /// Texto de ajuda/descrição
  final String? helperText;
  
  /// Texto de erro
  final String? errorText;
  
  /// Controlador do campo
  final TextEditingController? controller;
  
  /// Valor inicial do campo
  final String? initialValue;
  
  /// Função chamada quando o valor muda
  final ValueChanged<String>? onChanged;
  
  /// Função chamada quando o campo é submetido
  final ValueChanged<String>? onSubmitted;
  
  /// Função de validação
  final FormFieldValidator<String>? validator;
  
  /// Ícone do campo
  final IconData? icon;
  
  /// Ícone de prefixo
  final Widget? prefixIcon;
  
  /// Ícone de sufixo
  final Widget? suffixIcon;
  
  /// Se o campo é obrigatório
  final bool required;
  
  /// Se o campo está habilitado
  final bool enabled;
  
  /// Se o campo é readonly
  final bool readOnly;
  
  /// Se o campo é para senha
  final bool obscureText;
  
  /// Tipo do teclado
  final TextInputType? keyboardType;
  
  /// Ação do teclado
  final TextInputAction? textInputAction;
  
  /// Formatadores de entrada
  final List<TextInputFormatter>? inputFormatters;
  
  /// Número máximo de linhas
  final int? maxLines;
  
  /// Número mínimo de linhas
  final int? minLines;
  
  /// Comprimento máximo do texto
  final int? maxLength;
  
  /// FocusNode do campo
  final FocusNode? focusNode;
  
  /// Se deve fazer autofocus
  final bool autofocus;
  
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.focusNode,
    this.autofocus = false,
  });
  
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: AppDesignSystem.labelLarge.copyWith(
                color: AppDesignSystem.textPrimaryColor,
              ),
              children: [
                if (widget.required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppDesignSystem.errorColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDesignSystem.spaceSm),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          style: AppDesignSystem.bodyLarge.copyWith(
            color: widget.enabled 
                ? AppDesignSystem.textPrimaryColor
                : AppDesignSystem.textSecondaryColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppDesignSystem.bodyLarge.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            helperText: widget.helperText,
            helperStyle: AppDesignSystem.bodySmall.copyWith(
              color: AppDesignSystem.textSecondaryColor,
            ),
            errorText: widget.errorText,
            errorStyle: AppDesignSystem.bodySmall.copyWith(
              color: AppDesignSystem.errorColor,
            ),
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: widget.enabled
                        ? AppDesignSystem.iconPrimaryColor
                        : AppDesignSystem.iconSecondaryColor,
                  )
                : widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.enabled
                ? AppDesignSystem.inputBackgroundColor
                : AppDesignSystem.inputDisabledColor,
            contentPadding: const EdgeInsets.all(AppDesignSystem.spaceMd),
            border: const OutlineInputBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              borderSide: BorderSide(
                color: AppDesignSystem.borderColor,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              borderSide: BorderSide(
                color: AppDesignSystem.borderColor,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              borderSide: BorderSide(
                color: AppDesignSystem.accentColor,
                width: 2,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              borderSide: BorderSide(
                color: AppDesignSystem.errorColor,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              borderSide: BorderSide(
                color: AppDesignSystem.errorColor,
                width: 2,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
              borderSide: BorderSide(
                color: AppDesignSystem.borderDisabledColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppDesignSystem.iconSecondaryColor,
        ),
      );
    }
    
    return widget.suffixIcon;
  }
}

/// Campo de busca personalizado
class AppSearchField extends StatefulWidget {
  /// Texto do placeholder
  final String? hintText;
  
  /// Controlador do campo
  final TextEditingController? controller;
  
  /// Função chamada quando o valor muda
  final ValueChanged<String>? onChanged;
  
  /// Função chamada quando o campo é submetido
  final ValueChanged<String>? onSubmitted;
  
  /// Função chamada quando o botão de limpar é pressionado
  final VoidCallback? onClear;
  
  /// Se deve mostrar o botão de limpar
  final bool showClearButton;
  
  /// FocusNode do campo
  final FocusNode? focusNode;
  
  /// Se deve fazer autofocus
  final bool autofocus;
  
  const AppSearchField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClearButton = true,
    this.focusNode,
    this.autofocus = false,
  });
  
  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _showClearButton = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClearButton = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }
  
  void _onTextChanged() {
    final showClear = _controller.text.isNotEmpty && widget.showClearButton;
    if (_showClearButton != showClear) {
      setState(() {
        _showClearButton = showClear;
      });
    }
  }
  
  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      style: AppDesignSystem.bodyLarge.copyWith(
        color: AppDesignSystem.textPrimaryColor,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Buscar...',
        hintStyle: AppDesignSystem.bodyLarge.copyWith(
          color: AppDesignSystem.textSecondaryColor,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppDesignSystem.iconSecondaryColor,
        ),
        suffixIcon: _showClearButton
            ? IconButton(
                onPressed: _onClear,
                icon: const Icon(
                  Icons.clear,
                  color: AppDesignSystem.iconSecondaryColor,
                ),
              )
            : null,
        filled: true,
        fillColor: AppDesignSystem.inputBackgroundColor,
        contentPadding: const EdgeInsets.all(AppDesignSystem.spaceMd),
        border: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
          borderSide: BorderSide(
            color: AppDesignSystem.accentColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
