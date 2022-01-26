// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:netflix_redesign/models/movie.dart';
import 'package:netflix_redesign/screens/detail.dart';
import 'package:netflix_redesign/widgets/loading.dart';

import '../../constants.dart';

class PopularCarousel extends StatefulWidget {
  int current;
  final String posterUrl;
  final Future<Movie> futureDiscoverMovie;
  final CarouselController carouselController;

  PopularCarousel({
    Key? key,
    required this.current,
    required this.posterUrl,
    required this.futureDiscoverMovie,
    required this.carouselController,
  }) : super(key: key);

  @override
  _PopularCarouselState createState() => _PopularCarouselState();
}

class _PopularCarouselState extends State<PopularCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text('Popular', style: kSectionTitle),
        ),
        const SizedBox(height: 24),
        FutureBuilder<Movie>(
          future: widget.futureDiscoverMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: 256,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 256.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.45,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    onPageChanged: (index, reason) {
                      setState(() {
                        widget.current = index;
                      });
                    },
                  ),
                  carouselController: widget.carouselController,
                  items: [
                    ...snapshot.data!.results!.map(
                      (item) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                cover: widget.posterUrl +
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
                        child: Container(
                          height: 256,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  widget.posterUrl + item.posterPath.toString(),
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${snapshot.error}', style: kErrorText),
                ],
              );
            }

            return const Loading(
              padding: EdgeInsets.only(top: 100),
            );
          },
        ),
      ],
    );
  }
}
