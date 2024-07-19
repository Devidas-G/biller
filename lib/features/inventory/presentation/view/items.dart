import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di.dart';
import '../bloc/item_bloc.dart';
import '../bloc/inventory_events.dart';
import '../../domain/entity/item.dart';
import '../bloc/item_state.dart';
import '../../domain/entity/category.dart';
import '../../../../widgets/message.dart';
import '../widgets/delete_item.dart';
import '../widgets/widgets.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class ItemsManagement extends StatefulWidget {
  const ItemsManagement({super.key});

  @override
  State<ItemsManagement> createState() => _ItemsManagementState();
}

class _ItemsManagementState extends State<ItemsManagement> {
  ItemBloc itemBloc = sl<ItemBloc>();

  void fetchItems(List<CategoryEntity> categories) {
    itemBloc.add(GetInventoryItemsEvent(
        GetInventoryItemsParams(categories: categories)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("ITEMS"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddItems(
                            categories: itemBloc.state.categories,
                            onSave: (item) {
                              itemBloc.add(AddItemEvent(
                                  item: item, categories: item.categories));
                            },
                          )));
                },
                child: const Text("Add Items")),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        body: BlocProvider(
          create: (context) => itemBloc..add(const GetInventoryEvent()),
          child: BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state.status == ItemStatus.toast) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SafeArea(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  return (() {
                    switch (state.status) {
                      case ItemStatus.initial || ItemStatus.loading:
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        );
                      case ItemStatus.error:
                        return MessageDisplay(
                          message: state.message,
                        );
                      case ItemStatus.toast || ItemStatus.loaded:
                        return ItemsDisplay(
                          items: state.items,
                          onDelete: (ItemEntity item) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteItem(
                                    name: item.name,
                                    price: item.price.toString(),
                                    onDelete: () {
                                      itemBloc.add(DeleteItemEvent(item: item));
                                    },
                                  );
                                });
                          },
                          onEdit: (ItemEntity item) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditItem(
                                      item: item,
                                      categories: state.categories,
                                      onSave: (ItemEntity newitem) {
                                        itemBloc.add(UpdateItemEvent(
                                            item: item,
                                            categories: newitem.categories));
                                      },
                                    )));
                          },
                          categories: state.categories,
                          selectedCategories: state.selectedCategories,
                          onCategorySelected:
                              (List<CategoryEntity> newSelectedCategories) {
                            fetchItems(newSelectedCategories);
                          },
                          onCategoryRemoved:
                              (List<CategoryEntity> previousCategories) {
                            fetchItems(previousCategories);
                          },
                        );
                      default:
                        return const MessageDisplay(
                          message: "Something went wrong",
                        );
                    }
                  }());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
