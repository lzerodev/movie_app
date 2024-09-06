import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:movie_app/features/home/presentation/movieapp.dart';

import 'features/movie/domain/entities/simple_bloc_observer.dart';

void main() async { 
  Bloc.observer = const SimpleBlocObserver();
  await initializeDateFormatting('pt_BR', null); 
  runApp(const MovieApp());
}