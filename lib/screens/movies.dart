// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:netflix_redesign/constants.dart';
import 'package:netflix_redesign/models/movie.dart';
import 'package:netflix_redesign/models/detail.dart';
import 'package:netflix_redesign/screens/detail.dart';

class Movies extends StatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final CarouselController _carouselController = CarouselController();

  late Future<Movie> futureTrendingMovie;
  late Future<Details> futureMoviesDetail;
  late List<int> mid = [];

  int _current = 0;

  Future<Movie> fetchTrendingMovie() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?api_key=2d4d6c169da2c07b0371c7c1ac1c3648'));

    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Movie');
    }
  }

  @override
  void initState() {
    futureTrendingMovie = fetchTrendingMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Movie>(
                future: futureTrendingMovie,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var posterUrl = 'https://image.tmdb.org/t/p/original';

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.4,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        carouselController: _carouselController,
                        items: [
                          ...snapshot.data!.results!.map(
                            (item) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      cover: posterUrl +
                                          item.posterPath.toString(),
                                      title: item.title.toString(),
                                      rating: item.voteAverage.toString(),
                                      date: item.releaseDate.toString(),
                                      overview: item.overview.toString(),
                                      adult: item.adult!,
                                      id: item.id!.toInt(),
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: MediaQuery.of(context).size.width,
                                    child: CachedNetworkImage(
                                      imageUrl: posterUrl +
                                          item.posterPath.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Special For You',
                                          style: kSpecial,
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          child: Center(
                                            child: Text(
                                              item.title.toString(),
                                              style: kMovieTitle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 143),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Column(
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
                        var posterUrl = 'https://image.tmdb.org/t/p/original';

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

                            return GestureDetector(
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
                                margin:
                                    const EdgeInsets.fromLTRB(35, 0, 35, 16),
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
                                      margin: const EdgeInsets.fromLTRB(
                                          12, 14, 0, 16),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
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
                                      padding: const EdgeInsets.only(
                                          top: 16, bottom: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Text(
                                              title,
                                              maxLines: 2,
                                              style: kSectionMovieTitle,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            child: Text(
                                              snapshot.data!.results![index]
                                                  .overview
                                                  .toString(),
                                              maxLines: 3,
                                              style: kSectionMovieSubtitle
                                                  .copyWith(
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/icons/time.svg'),
                                              const SizedBox(width: 8),
                                              Text(
                                                Jiffy(snapshot
                                                        .data!
                                                        .results![index]
                                                        .releaseDate
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10),
                                          SvgPicture.asset(
                                              'assets/icons/star.svg',
                                              color: kBackgroundColor),
                                          const SizedBox(height: 5),
                                          Text(
                                            snapshot.data!.results![index]
                                                .voteAverage
                                                .toString(),
                                            style: kMovieRating.apply(
                                                color: kBackgroundColor),
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
                      } else if (snapshot.hasError) {
                        return Text(
                          '${snapshot.error}',
                          style: kSectionMovieSubtitle.apply(
                            color: kPrimaryColor,
                          ),
                        );
                      }

                      // By default, show a loading spinner.
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 143),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
