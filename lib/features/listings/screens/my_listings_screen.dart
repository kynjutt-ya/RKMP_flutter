import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/listings_cubit.dart';
import '../models/item.dart';
import '../widgets/item_table.dart';
import 'add_item_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои объявления'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddItemScreen(ownerName: 'Вы')),
        ).then((newItem) {
          if (newItem != null) {
            context.read<ListingsCubit>().addListing(newItem);
          }
        }),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ListingsCubit, ListingsState>(
        builder: (context, state) {
          final myItems = state.myItems;
          return myItems.isEmpty
              ? const Center(child: Text('У вас пока нет объявлений'))
              : ItemTable(
            items: myItems,
            onDelete: (id) => context.read<ListingsCubit>().removeListing(id),
          );
        },
      ),
    );
  }
}