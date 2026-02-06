import 'dart:convert';
import 'package:ai_health/const/api_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// =====================
/// MODEL
/// =====================
class Meme {
  final String name;
  final String url;

  Meme({required this.name, required this.url});

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      name: json['name'],
      url: json['url'],
    );
  }
}

/// =====================
/// ISOLATE PARSER
/// =====================
List<Meme> parseMemes(String body) {
  final decoded = jsonDecode(body);
  final List memes = decoded['data']['memes'];

  return memes.take(10).map((e) => Meme.fromJson(e)).toList();
}

/// =====================
/// MEME LIST WIDGET
/// =====================
class MemeListPage extends StatefulWidget {
  const MemeListPage({super.key});

  @override
  State<MemeListPage> createState() => _MemeListPageState();
}

class _MemeListPageState extends State<MemeListPage> {
  late final Future<List<Meme>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchMemes();
  }

  Future<List<Meme>> _fetchMemes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load memes');
    }

    return compute(parseMemes, response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meme>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              MemeSkeleton(),
              SizedBox(height: 16),
              MemeSkeleton(),
            ],
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Could not load memes 😕',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        final memes = snapshot.data!;

        return Column(
          children: memes
              .map(
                (meme) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MemeCard(meme: meme),
            ),
          )
              .toList(),
        );
      },
    );
  }
}

/// =====================
/// MEME CARD (UI POLISHED)
/// =====================
class MemeCard extends StatelessWidget {
  final Meme meme;

  const MemeCard({required this.meme, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: meme.url,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  memCacheHeight: 450,
                  fadeInDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  placeholder: (_, __) => const MemeSkeleton(compact: true),
                  errorWidget: (_, __, ___) =>
                  const MemeSkeleton(compact: true),
                ),
              ),
            ),

            /// TITLE
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Text(
                meme.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// SKELETON (POLISHED)
/// =====================
class MemeSkeleton extends StatelessWidget {
  final bool compact;

  const MemeSkeleton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? double.infinity : 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}