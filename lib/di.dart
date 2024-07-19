import 'package:get_it/get_it.dart';
import 'features/bill/data/repo/bill_repo_impl.dart';
import 'features/bill/data/datasource/local_datasource.dart';
import 'features/bill/domain/repos/bill_repo.dart';
import 'features/bill/presentation/bloc/bill_bloc.dart';
import 'features/inventory/data/datasource/inventory_local_datasource.dart';
import 'features/inventory/data/repos/inventory_repo_impl.dart';
import 'features/inventory/domain/repos/inventory_repo.dart';
import 'features/inventory/presentation/bloc/category_bloc.dart';
import 'features/inventory/presentation/bloc/item_bloc.dart';
import 'features/pdfgeneration/data/datasources/local_datasource.dart';
import 'features/pdfgeneration/data/repositories/generate_pdf_repo_impl.dart';
import 'features/pdfgeneration/domain/repositories/generate_pdf_repo.dart';
import 'features/pdfgeneration/presentation/bloc/pdf_bloc.dart';

import 'features/bill/domain/usecases/usecases.dart' as bill;
import 'features/inventory/domain/usecases/usecases.dart';
import 'features/pdfgeneration/domain/usecases/generate_pdf.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
//! Core

//! External

//! Features - Inventory
// Bloc
  sl.registerFactory(() => ItemBloc(
      getCategories: sl(),
      getItems: sl(),
      addItem: sl(),
      getAllItems: sl(),
      deleteItem: sl(),
      updateItem: sl()));
  sl.registerFactory(() => CategoryBloc(
      getCategories: sl(),
      addCategory: sl(),
      deleteCategory: sl(),
      editCategory: sl()));
// Use cases
  sl.registerLazySingleton(() => GetItems(sl()));
  sl.registerLazySingleton(() => GetAllItems(sl()));
  sl.registerLazySingleton(() => AddItem(sl()));
  sl.registerLazySingleton(() => UpdateItem(sl()));
  sl.registerLazySingleton(() => DeleteItem(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => EditCategory(sl()));
// Repository
  sl.registerLazySingleton<InventoryRepo>(
    () => InventoryRepoImpl(inventoryLocalDatasource: sl()),
  );
// Data sources
  sl.registerLazySingleton<InventoryLocalDatasource>(
    () => InventoryLocalDatasourceImpl(),
  );

//! Features - Bill
// Bloc
  sl.registerFactory(() => BillBloc(
      getAllItems: sl(),
      getSearchItems: sl(),
      getCategories: sl(),
      getItemsOfCategory: sl()));
// Use cases
  sl.registerLazySingleton(() => bill.GetAllItems(sl()));
  sl.registerLazySingleton(() => bill.GetSearchItems(sl()));
  sl.registerLazySingleton(() => bill.GetCategories(sl()));
  sl.registerLazySingleton(() => bill.GetItemsOfCategory(sl()));
// Repository
  sl.registerLazySingleton<BillRepo>(
    () => BillRepoImpl(billLocalDataSource: sl()),
  );
// Data sources
  sl.registerLazySingleton<BillLocalDataSource>(
    () => BillLocalDataSourceImpl(),
  );

//! Features - Generate Pdf
// Bloc
  sl.registerFactory(() => PdfBloc(generatePdf: sl()));
// Use cases
  sl.registerLazySingleton(() => GeneratePdf(sl()));
// Repository
  sl.registerLazySingleton<GeneratePdfRepo>(
    () => GeneratePdfRepoImpl(pdfLocalDataSource: sl()),
  );
// Data sources
  sl.registerLazySingleton<PdfLocalDataSource>(
    () => PdfLocalDataSourceImpl(),
  );
}
