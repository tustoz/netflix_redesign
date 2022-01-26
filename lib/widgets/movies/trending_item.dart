import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:netflix_redesign/models/movie.dart';
import 'package:netflix_redesign/screens/detail.dart';
import 'package:netflix_redesign/utils/services.dart';

import '../../constants.dart';

class TrendingItem extends StatelessWidget {
  final AsyncSnapshot<Movie> snapshot;

  const TrendingItem({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.results!.length,
      itemBuilder: (context, index) {
        var data = snapshot.data!.results![index];
        var posterPath = data.posterPath.toString();
        var title = data.title.toString();
        var date = data.releaseDate.toString();
        var rating = data.voteAverage.toString();
        var overview = data.overview.toString();
        var adult = data.adult!;
        var id = data.id!.toInt();

        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  cover: posterUrl + posterPath,
                  title: title,
                  rating: rating,
                  date: date,
                  overview: overview,
                  adult: adult,
                  id: id,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(35, 0, 35, 16),
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: kBoxColor.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 14, 0, 16),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width / 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: posterUrl + posterPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          title,
                          maxLines: 2,
                          style: kSectionMovieTitle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Text(
                          snapshot.data!.results![index].overview.toString(),
                          maxLines: 3,
                          style: kSectionMovieSubtitle.copyWith(
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/time.svg'),
                          const SizedBox(width: 8),
                          Text(
                            Jiffy(snapshot.data!.results![index].releaseDate
                                    .toString())
                                .yMMMd,
                            style: kSectionMovieSubtitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0),
                    ),
                    color: kSecondaryColor,
                  ),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.08,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      SvgPicture.asset('assets/icons/star.svg',
                          color: kBackgroundColor),
                      const SizedBox(height: 5),
                      Text(
                        snapshot.data!.results![index].voteAverage.toString(),
                        style: kMovieRating.apply(color: kBackgroundColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
