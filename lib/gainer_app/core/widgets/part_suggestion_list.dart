import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';

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
    return suggestions.isEmpty
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
                ? Center(child: GainerCircularLoader())
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
