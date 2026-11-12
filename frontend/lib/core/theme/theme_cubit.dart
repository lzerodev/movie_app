import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Preferência da sessão. O catálogo continua sob MovieModernBloc.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  void select(ThemeMode mode) => emit(mode);
}
