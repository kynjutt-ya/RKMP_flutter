import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../listings/cubit/listings_cubit.dart';
import '../../../shared/item_adapter.dart';
import '../../listings/widgets/item_table.dart';
import '../cubit/profile_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          final favoriteIds = profileState.favoriteItems;
          
          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет избранных объявлений',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавляйте объявления в избранное,\nчтобы не потерять их',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<ListingsCubit, ListingsState>(
            builder: (context, listingsState) {
              final favoriteListings = listingsState.allItems
                  .where((listing) => favoriteIds.contains(listing.id))
                  .toList();

              if (favoriteListings.isEmpty) {
                return const Center(
                  child: Text('Избранные объявления не найдены'),
                );
              }

              final favoriteItems = ItemAdapter.toItemList(favoriteListings);
              return ItemTable(
                items: favoriteItems,
                onTap: (item) => context.push('/listings/item', extra: item),
              );
            },
          );
        },
      ),
    );
  }
}

