import 'package:flutter/material.dart';

import '../di/dependency_injection.dart';
import '../../features/movie/presentation/bloc/movie_modern_bloc.dart';

/// Extensões para facilitar o uso do Dependency Injection em Widgets.
/// 
/// Estas extensões fornecem métodos convenientes para acessar BLoCs
/// e outras dependências de forma type-safe e organizada.
extension DIBlocExtensions on BuildContext {
  /// Cria e fornece um [MovieModernBloc] usando DI.
  /// 
  /// Este BLoC usa os novos UseCases com Clean Architecture.
  /// Exemplo de uso:
  /// ```dart
  /// BlocProvider<MovieModernBloc>(
  ///   create: context.createMovieModernBloc,
  ///   child: MyWidget(),
  /// )
  /// ```
  MovieModernBloc Function(BuildContext) get createMovieModernBloc =>
      (context) => DependencyInjection.createMovieModernBloc();
}

/// Extensões para facilitar o acesso a dependências específicas.
extension DIServiceExtensions on BuildContext {
  /// Acessa facilmente qualquer dependência registrada no DI.
  /// 
  /// Exemplo de uso:
  /// ```dart
  /// final repository = context.get<IMovieRepository>();
  /// final useCase = context.get<SearchMoviesUseCase>();
  /// ```
  T get<T extends Object>() => DependencyInjection.get<T>();
}
