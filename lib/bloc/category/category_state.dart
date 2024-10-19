// ignore_for_file: must_be_immutable

part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySucces extends CategoryState {
  List<CategoryModel> categori;
  CategorySucces({required this.categori});
}

class CategoryError extends CategoryState {
  String error;
  CategoryError({required this.error});
}

class CreateCategorySucces extends CategoryState {}
