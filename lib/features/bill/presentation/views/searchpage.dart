import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../../../../widgets/message.dart';
import '../../domain/entity/item.dart';
import '../bloc/bill_bloc.dart';

class Searchpage extends StatefulWidget {
  final ValueChanged<ItemEntity> onTap;
  const Searchpage({super.key, required this.onTap});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final TextEditingController _controller = TextEditingController();
  BillBloc billBloc = sl<BillBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => billBloc,
      child: BlocBuilder<BillBloc, BillState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _controller,
                onChanged: (text) {
                  billBloc.add(GetSearchItemsEvent(text));
                },
                decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Search Items',
                    contentPadding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ))),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: Container(
                  // width: double.infinity,
                  // height: double.infinity,
                  color: Colors.transparent,
                  child: (() {
                    switch (state.status) {
                      case BillStatus.initial:
                        return const MessageDisplay(
                          message: "Search For Items",
                        );
                      case BillStatus.loading:
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
                        return SearchBody(
                          items: state.items,
                          onTap: (ItemEntity item) => widget.onTap(item),
                        );
                      default:
                        return const MessageDisplay(
                          message: 'Something went wrong',
                        );
                    }
                  }()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchBody extends StatelessWidget {
  final ValueChanged<ItemEntity> onTap;
  final List<ItemEntity> items;
  const SearchBody({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          ItemEntity item = items[index];
          return ListTile(
            onTap: () => onTap(item),
            title: Text(item.name),
          );
        });
  }
}
