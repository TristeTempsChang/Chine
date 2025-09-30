import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/movie.dart';
import 'services/movie_api.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  late Future<List<Movie>> _futureMovies;
  final Set<int> _likedIds = <int>{};
  static const String _prefsKey = 'liked_movie_ids';

  @override
  void initState() {
    super.initState();
    _futureMovies = MovieApi.fetchPopular();
    _loadLikes();
  }

  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_prefsKey) ?? <String>[];
    setState(() {
      _likedIds
        ..clear()
        ..addAll(ids.map(int.parse));
    });
  }

  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _likedIds.map((e) => e.toString()).toList(),
    );
  }

  void _toggleLike(int movieId) {
    setState(() {
      if (_likedIds.contains(movieId)) {
        _likedIds.remove(movieId);
      } else {
        _likedIds.add(movieId);
      }
    });
    _saveLikes();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureMovies = MovieApi.fetchPopular();
    });
    await _futureMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Movie>>(
          future: _futureMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTileSkeleton();
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '加载失败：${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final movies = snapshot.data ?? <Movie>[];
            if (movies.isEmpty) {
              return const Center(child: Text('暂无电影'));
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: movies.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final m = movies[i];
                final liked = _likedIds.contains(m.id);
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: _PosterThumb(url: m.posterUrl),
                  title: Text(
                    m.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      m.overview.isEmpty ? '暂无简介' : m.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: liked ? Colors.red : null,
                    onPressed: () => _toggleLike(m.id),
                    tooltip: liked ? '取消喜欢' : '喜欢',
                  ),
                  onTap: () => _toggleLike(m.id),
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

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: 8,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 60,
            height: 90,
            color: Colors.grey.shade300,
          ),
          title: Container(
            height: 16,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.only(bottom: 8, right: 40),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 12, color: Colors.grey.shade300),
              const SizedBox(height: 6),
              Container(
                  height: 12, width: 180, color: Colors.grey.shade300),
            ],
          ),
        );
      },
    );
  }
}
