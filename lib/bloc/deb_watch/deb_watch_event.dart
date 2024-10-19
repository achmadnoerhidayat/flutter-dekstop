part of 'deb_watch_bloc.dart';

@immutable
abstract class DebWatchEvent {}

class GetDebtWatch extends DebWatchEvent {}

class SearchDebtWatch extends DebWatchEvent {
  final String name;
  SearchDebtWatch({required this.name});
}

class CreateDebtWatch extends DebWatchEvent {
  final DebtWatchModel debtWatchModel;
  CreateDebtWatch({required this.debtWatchModel});
}

class UpdateDebtWatch extends DebWatchEvent {
  final DebtWatchModel debtWatchModel;
  UpdateDebtWatch({required this.debtWatchModel});
}

class DeleteDebtWatch extends DebWatchEvent {
  final int id;
  DeleteDebtWatch({required this.id});
}

class CreateDebtWatchDetail extends DebWatchEvent {
  final DebtWatchModel debtWatchModel;
  CreateDebtWatchDetail({required this.debtWatchModel});
}
