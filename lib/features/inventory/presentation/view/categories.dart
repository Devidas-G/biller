import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../../../../widgets/widgets.dart';
import '../../domain/entity/category.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';
import '../bloc/inventory_events.dart';
import '../widgets/widgets.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  CategoryBloc categoryBloc = sl<CategoryBloc>();

  void addCategory() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Use the input from the text fields
                  final String name = nameController.text;
                  // Add the new category or handle the input as needed
                  categoryBloc.add(AddCategoryEvent(
                      categoryEntity: CategoryEntity(name: name)));

                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Categories"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  addCategory();
                },
                child: const Text("Add categories")),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        body: BlocProvider(
          create: (context) => categoryBloc..add(GetCategoriesEvent()),
          child: BlocListener<CategoryBloc, CategoryBlocState>(
            listener: (context, state) {
              if (state.status == CategoryStatus.toast) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SafeArea(child: BlocBuilder<CategoryBloc, CategoryBlocState>(
              builder: (context, state) {
                switch (state.status) {
                  case CategoryStatus.initial || CategoryStatus.loading:
                    return const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  case CategoryStatus.error:
                    return MessageDisplay(
                      message: state.message,
                    );
                  case CategoryStatus.loaded || CategoryStatus.toast:
                    return CategoriesDisplay(
                      categories: state.categories,
                      onDelete: (CategoryEntity category) {
                        categoryBloc
                            .add(DeleteCategoryEvent(categoryEntity: category));
                      },
                      onEdit: (CategoryEntity category) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditCategory(
                                category: category,
                                onSave: (CategoryEntity newCategory) {
                                  categoryBloc.add(EditCategoryEvent(
                                      categoryEntity: newCategory));
                                },
                              );
                            });
                      },
                    );
                  default:
                    return const MessageDisplay(
                      message: 'Something went wrong',
                    );
                }
              },
            )),
          ),
        ));
  }
}
