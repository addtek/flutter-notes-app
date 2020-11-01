import 'package:QuickNotes/Feature/InheritedBlocs.dart';
import 'package:QuickNotes/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queries/collections.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    Key key,
    @required this.query,
    @required this.notes,
  }) : super(key: key);

  final String query;
  final List notes;

  @override
  Widget build(BuildContext context) {
    var filterItems = Collection(notes);
    Map<dynamic, int> filterMap = Map();

    for (dynamic item in filterItems.distinct().toList()) {
      var numberOfOccurrences = filterItems.count((b) => b.title == item.title);
      filterMap[item] = numberOfOccurrences;
    }
    /*    for (int i = 0; i < list.Count; i++)
{
    //Get count of current element to before:
    int count = list.Take(i+1)
                    .Count(r => r.UserName == list[i].UserName);
    list[i].Count = count;
} */

    var filters = filterItems
        .distinct()
        .toList()
        .map(
          (b) => DropdownMenuItem(
                child: Text("${b.title} (${filterMap[b]})"),
                value: b.title,
              ),
        )
        .toList();

    filters.insert(
        0,
        DropdownMenuItem(
          child: Text("All (${notes.length})"),
          value: "",
        ));
    return DropdownButton(
      hint: Text("Filter by book"),
      isExpanded: true,
      onChanged: (value) {
        InheritedBlocs.of(context)
            .searchBloc
            .searchTerm
            .add(SearchQuery(queryText: query, book: value));
      },
      items: filters,
    );
  }
}
