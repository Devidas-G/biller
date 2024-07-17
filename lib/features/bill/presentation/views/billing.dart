// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../di.dart';
import '../../../../widgets/message.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import '../../providers/bill_provider.dart';
import '../bloc/bill_bloc.dart';
import '../widgets/widgets.dart';
import 'searchpage.dart';

class Billing extends StatefulWidget {
  const Billing({super.key});

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  final BillBloc billBloc = sl<BillBloc>();
  late BillProvider billProvider;
  @override
  Widget build(BuildContext context) {
    billProvider = Provider.of<BillProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: CategoryDropdown(
          categories: billProvider.selectCategories,
          onChanged: (CategoryEntity? value) {
            if (value == null) {
              billBloc.add(const GetAllItemsEvent());
            } else {
              billBloc.add(GetItemsOfCategoryEvent(value));
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Searchpage(
                      onTap: (ItemEntity item) {
                        billProvider.addTempBillItem(item);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: BlocProvider(
        create: (context) => billBloc..add(const GetAllItemsEvent()),
        child: BlocListener<BillBloc, BillState>(
          listener: (context, state) {
            if (state.status == BillStatus.loaded) {
              billProvider.selectCategories = state.categories;
            }
          },
          child: SafeArea(
            child: BlocBuilder<BillBloc, BillState>(
              builder: (context, state) {
                switch (state.status) {
                  case BillStatus.initial || BillStatus.loading:
                    return const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  case BillStatus.error:
                    return MessageDisplay(
                      message: state.message,
                    );
                  case BillStatus.loaded || BillStatus.toast:
                    return DisplayBill(
                      selectionItems: state.items,
                      tempBillItems: billProvider.tempBillItems,
                      onItemSelected: (ItemEntity item) {
                        billProvider.addTempBillItem(item);
                      },
                      onItemRemoved: (ItemEntity item) {
                        billProvider.removeTempBillItem(item);
                      },
                      total: billProvider.total,
                    );
                  default:
                    return const MessageDisplay(
                      message: 'Something went wrong',
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
