import 'package:flutter/material.dart';
import 'package:netflix_redesign/models/movie.dart';
import 'package:netflix_redesign/widgets/loading.dart';
import 'package:netflix_redesign/widgets/movies/trending_item.dart';

import '../../constants.dart';

class TrendingList extends StatelessWidget {
  final Future<Movie> futureTrendingMovie;

  const TrendingList({Key? key, required this.futureTrendingMovie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            'Trending',
            style: kSectionMovieTitle,
          ),
        ),
        const SizedBox(height: 24),
        FutureBuilder<Movie>(
          future: futureTrendingMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TrendingItem(snapshot: snapshot);
            } else if (snapshot.hasError) {
              return Text(
                '${snapshot.error}',
                style: kSectionMovieSubtitle.apply(
                  color: kPrimaryColor,
                ),
              );
            }

            // By default, show a loading spinner.
            return const Loading(
              padding: EdgeInsets.symmetric(horizontal: 143),
            );
          },
        ),
      ],
    );
  }
}
