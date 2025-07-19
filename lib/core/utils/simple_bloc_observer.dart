import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

/// Observer simples para BLoCs que faz log das mudanças de estado.
/// 
/// Útil para debug e desenvolvimento, mostra transições de estado
/// e eventos sendo processados pelos BLoCs.
class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      debugPrint('🟢 ${bloc.runtimeType} created');
    }
  }

  @override
  void onEvent(BlocBase bloc, Object? event) {
    super.onEvent(bloc as Bloc, event);
    if (kDebugMode) {
      debugPrint('📧 ${bloc.runtimeType} received event: $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('🔄 ${bloc.runtimeType} state changed:');
      debugPrint('   From: ${change.currentState}');
      debugPrint('   To: ${change.nextState}');
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc as Bloc, transition);
    if (kDebugMode) {
      debugPrint('🔀 ${bloc.runtimeType} transition:');
      debugPrint('   Event: ${transition.event}');
      debugPrint('   Current State: ${transition.currentState}');
      debugPrint('   Next State: ${transition.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      debugPrint('❌ ${bloc.runtimeType} error: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      debugPrint('🔴 ${bloc.runtimeType} closed');
    }
  }
}
