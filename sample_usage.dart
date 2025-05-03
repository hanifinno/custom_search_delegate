
// Invoke search like this:
showSearch(
  context: context,
  delegate: CustomSearchDelegate<String>(
    items: ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'],
    itemBuilder: (item, query) => ListTile(
      title: Text(
        item,
        style: TextStyle(
          fontWeight: item.toLowerCase().contains(query.toLowerCase())
              ? FontWeight.bold
              : FontWeight.normal,
          color: item.toLowerCase().contains(query.toLowerCase())
              ? Colors.blue
              : Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
    ),
    searchFieldLabel: 'Search fruits...',
    searchFieldStyle: const TextStyle(fontSize: 18),
    listPadding: const EdgeInsets.symmetric(vertical: 16),
    notFoundWidget: const Center(
      child: Text(
        'No fruits found 😞',
        style: TextStyle(fontSize: 18),
    ),
    filter: (item, query) => item.toLowerCase().contains(query.toLowerCase()),
  ),
);
