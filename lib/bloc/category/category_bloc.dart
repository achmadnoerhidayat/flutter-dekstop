// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:kasir_dekstop/models/category_model.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductHelper productHelper = ProductHelper();
  CategoryBloc() : super(CategoryInitial()) {
    on<GetCategory>((event, emit) async {
      emit(CategoryLoading());
      final response = await productHelper.getCategori();
      emit(CategorySucces(categori: response));
    });
    on<GetCategoryKasir>((event, emit) async {
      emit(CategoryLoading());
      final response = await productHelper.getCategoriKasir();
      emit(CategorySucces(categori: response));
    });
    on<CreateCategory>((event, emit) async {
      emit(CategoryLoading());
      await productHelper.insertCategori(event.nama);
      emit(CreateCategorySucces());
    });
    on<UpdateCategory>((event, emit) async {
      emit(CategoryLoading());
      await productHelper.updateCategori(event.nama);
      emit(CreateCategorySucces());
    });
    on<DeleteCategory>((event, emit) async {
      emit(CategoryLoading());
      await productHelper.deleteCategori(event.id);
      emit(CreateCategorySucces());
    });
  }
}
