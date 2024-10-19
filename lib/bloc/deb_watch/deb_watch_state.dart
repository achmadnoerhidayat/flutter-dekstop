part of 'deb_watch_bloc.dart';

@immutable
abstract class DebWatchState {}

class DebWatchInitial extends DebWatchState {}

class DebWatchLoading extends DebWatchState {}

class DebWatchSuccess extends DebWatchState {
  final List<DebtWatchModel> watch;
  DebWatchSuccess({required this.watch});
}

class DebWatchError extends DebWatchState {}

class RequestDebWatchSuccess extends DebWatchState {
  final int id;
  RequestDebWatchSuccess({required this.id});
}
