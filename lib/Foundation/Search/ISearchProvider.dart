
abstract class ISearchProvider {
  Future<List<dynamic>> getSearchResults(
      String searchTerm, List<String> booksToSearch);

  Future init();
}
