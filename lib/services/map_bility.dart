import 'package:flutter/material.dart';
import 'package:riwama/services/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  late PlaceApiProvider apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Enter your address'),
      );
    } else {
      return FutureBuilder<List<Suggestion>>(
        future: _getAddressSuggestions(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No suggestions found'),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data![index].description),
                onTap: () {
                  close(context, snapshot.data![index]);
                },
              ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data!.length,
            );
          }
        },
      );
    }
  }

  Future<List<Suggestion>> _getAddressSuggestions(BuildContext context) async {
    try {
      if (query.trim().isEmpty) return []; // Empty query, return an empty list
      return await apiClient.fetchSuggestions(
        query,
        Localizations.localeOf(context).languageCode,
      );
    } catch (e) {
      // Handle any API request errors gracefully
      return [];
    }
  }
}