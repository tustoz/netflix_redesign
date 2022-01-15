// ignore_for_file: recursive_getters

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiffy/jiffy.dart';

import 'package:netflix_redesign/constants.dart';
import 'package:netflix_redesign/models/detail.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String overview;
  final String cover;
  final String rating;
  final String date;
  final bool adult;
  final int id;

  const DetailScreen(
      {Key? key,
      required this.title,
      required this.overview,
      required this.cover,
      required this.rating,
      required this.date,
      required this.adult,
      required this.id})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Details> futureMoviesDetail;

  Future<Details> fetchMoviesDetail(id) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=2d4d6c169da2c07b0371c7c1ac1c3648'));

    if (response.statusCode == 200) {
      return Details.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Movie');
    }
  }

  @override
  void initState() {
    super.initState();
    futureMoviesDetail = fetchMoviesDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              CachedNetworkImage(imageUrl: widget.cover, fit: BoxFit.cover),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        kBackgroundColor,
                        kBackgroundColor,
                        Colors.grey.shade50.withOpacity(0.0),
                        Colors.grey.shade50.withOpacity(0.0),
                        Colors.grey.shade50.withOpacity(0.0),
                        Colors.grey.shade50.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: kBackgroundColor.withOpacity(0.4),
                      backgroundBlendMode: BlendMode.multiply),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Text(
                          widget.title,
                          style: kMovieTitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
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
                              child: Text('Popular among friend',
                                  style: kMovieTags),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 24,
                            color: kBoxColor.withOpacity(0.2),
                            width: MediaQuery.of(context).size.width / 6 - 25,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            width: MediaQuery.of(context).size.width / 5 - 25,
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
                        future: futureMoviesDetail,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.symmetric(horizontal: 35),
                          padding: const EdgeInsets.only(right: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/play_arrow.svg'),
                                const SizedBox(width: 8),
                                Text('Watch Now', style: kMovieWatch),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
