import 'package:flutter/material.dart';

class CustomSearchDelegate<T> extends SearchDelegate<T> {
  final List<T> items;
  final Widget Function(T item, String query) itemBuilder;
  final Widget Function(BuildContext context)? leading;
  final List<Widget> Function(BuildContext context)? actions;
  final String searchFieldLabel;
  final TextStyle? searchFieldStyle;
  final InputDecorationTheme? searchFieldDecorationTheme;
  final bool hideSearchOnNotFound;
  final Widget? notFoundWidget;
  final Widget? errorWidget;
  final Future<List<T>> Function(String query)? asyncFilter;
  final bool Function(T item, String query)? filter;
  final EdgeInsets? listPadding;
  final ScrollPhysics? listPhysics;

  CustomSearchDelegate({
    required this.items,
    required this.itemBuilder,
    this.leading,
    this.actions,
    this.searchFieldLabel = 'Search',
    this.searchFieldStyle,
    this.searchFieldDecorationTheme,
    this.hideSearchOnNotFound = false,
    this.notFoundWidget,
    this.errorWidget,
    this.asyncFilter,
    this.filter,
    this.listPadding,
    this.listPhysics,
  });

  @override
  String get searchFieldLabel => this.searchFieldLabel;

  @override
  TextStyle? get searchFieldStyle => this.searchFieldStyle;

  @override
  InputDecorationTheme? get searchFieldDecorationTheme =>
      this.searchFieldDecorationTheme;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: searchFieldDecorationTheme,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
    );
  }

  List<T> _filterItems(String query) {
    if (filter != null) {
      return items.where((item) => filter!(item, query)).toList();
    }
    return items
        .where((item) =>
            item.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return actions?.call(context) ??
        [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => query = '',
            )
        ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return leading?.call(context) ??
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => close(context, null as T),
        );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    try {
      final filteredItems = _filterItems(query);

      if (filteredItems.isEmpty && hideSearchOnNotFound) {
        return notFoundWidget ??
            const Center(child: Text('No results found'));
      }

      return ListView.separated(
        padding: listPadding ?? const EdgeInsets.all(16),
        physics: listPhysics ?? const ClampingScrollPhysics(),
        itemCount: filteredItems.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return InkWell(
            onTap: () => close(context, item),
            child: itemBuilder(item, query),
          );
        },
      );
    } catch (e) {
      return errorWidget ?? Center(child: Text('Error: ${e.toString()}'));
    }
  }
}
