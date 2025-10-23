import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/movie.dart';
import 'services/movie_api.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  static const String _prefsKey = 'liked_movie_ids';
  late Future<List<Movie>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _futureFavorites = _loadFavorites();
  }

  Future<List<Movie>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList(_prefsKey)?.map(int.parse).toSet() ?? {};

    final allMovies = await MovieApi.fetchPopular();

    return allMovies.where((m) => likedIds.contains(m.id)).toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureFavorites = _loadFavorites();
    });
    await _futureFavorites;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes films favoris'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Movie>>(
          future: _futureFavorites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erreur de chargement : ${snapshot.error}'),
              );
            }

            final movies = snapshot.data ?? [];
            if (movies.isEmpty) {
              return const Center(
                child: Text('Aucun film ajouté aux favoris.'),
              );
            }

            return ListView.separated(
              itemCount: movies.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final m = movies[i];
                return ListTile(
                  leading: _PosterThumb(url: m.posterUrl),
                  title: Text(
                    m.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    m.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PosterThumb extends StatelessWidget {
  final String? url;
  const _PosterThumb({required this.url});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    if (url == null) {
      return Container(
        width: 60,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius,
        ),
        child: const Icon(Icons.movie),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url!,
        width: 60,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 60,
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: borderRadius,
          ),
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}
