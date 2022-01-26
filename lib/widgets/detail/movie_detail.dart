import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:netflix_redesign/models/detail.dart';
import 'package:netflix_redesign/widgets/detail/custom_button.dart';

import '../../constants.dart';

class MovieDetail extends StatefulWidget {
  final Future<Details> futureMovieDetail;

  final String title;
  final String overview;
  final String cover;
  final String rating;
  final String date;
  final bool adult;
  final int id;

  const MovieDetail({
    Key? key,
    required this.futureMovieDetail,
    required this.title,
    required this.overview,
    required this.cover,
    required this.rating,
    required this.date,
    required this.adult,
    required this.id,
  }) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.4,
        width: size.width,
        decoration: BoxDecoration(
          color: kBackgroundColor.withOpacity(0.4),
          backgroundBlendMode: BlendMode.multiply,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width - 60,
              child: Text(
                widget.title,
                style: kMovieTitle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: size.width - 60,
              child: Text(
                widget.overview,
                style: kSectionMovieSubtitle,
                textAlign: TextAlign.center,
                maxLines: 8,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 24,
                  color: kBoxColor.withOpacity(0.2),
                  width: MediaQuery.of(context).size.width / 2 - 60,
                  child: Center(
                    child: Text('Popular among friend', style: kMovieTags),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 24,
                  color: kBoxColor.withOpacity(0.2),
                  width: size.width / 6 - 25,
                  child: Center(
                    child: widget.adult == true
                        ? Text('18+', style: kMovieTags)
                        : Text('13+', style: kMovieTags),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 24,
                  color: kBoxColor.withOpacity(0.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: size.width / 5 - 25,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/star.svg'),
                        const SizedBox(width: 2),
                        Text(widget.rating, style: kMovieTags),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FutureBuilder<Details>(
              future: widget.futureMovieDetail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var genres = snapshot.data!.genres!
                      .map((e) => e.name!.toString())
                      .toList();

                  return Text(
                      Jiffy(widget.date).year.toString() +
                          ', ' +
                          genres.join(" , "),
                      style: kMovieGenre);
                } else if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                    style: kMovieGenre,
                  );
                }
                return Text('', style: kMovieGenre);
              },
            ),
            const SizedBox(height: 38),
            const CustomButton()
          ],
        ),
      ),
    );
  }
}
