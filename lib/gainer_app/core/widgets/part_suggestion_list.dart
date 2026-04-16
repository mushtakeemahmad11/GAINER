import 'package:flutter/material.dart';

class PartSuggestionList extends StatelessWidget {
  final bool isLoading;
  final List<String> suggestions;
  final Function(String) onTap;

  const PartSuggestionList({
    super.key,
    required this.isLoading,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return
        // isLoading
        //   ? Container(
        //       color: Colors.white,
        //       height: 160,
        //       child: const Center(child: CircularProgressIndicator()),
        //     )
        //   : suggestions.isEmpty
        //       ? const SizedBox.shrink()
        //       :
        suggestions.isEmpty
            ? const SizedBox.shrink()
            : Container(
                constraints: const BoxConstraints(
                  minHeight: 30,
                  maxHeight: 160,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index];
                          return InkWell(
                            onTap: () {
                              onTap(suggestion);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(suggestion),
                            ),
                          );
                        },
                      ),
              );
  }
}
