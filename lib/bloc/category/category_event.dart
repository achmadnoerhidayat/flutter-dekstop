// ignore_for_file: must_be_immutable

part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class GetCategory extends CategoryEvent {}

class GetCategoryKasir extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  CategoryModel nama;
  CreateCategory({required this.nama});
}

class UpdateCategory extends CategoryEvent {
  CategoryModel nama;
  UpdateCategory({required this.nama});
}

class DeleteCategory extends CategoryEvent {
  int id;
  DeleteCategory({required this.id});
}
