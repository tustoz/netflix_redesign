import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:netflix_redesign/constants.dart';
import 'package:netflix_redesign/utils/services.dart';
import 'package:netflix_redesign/widgets/detail/movie_detail.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String overview;
  final String cover;
  final String rating;
  final String date;
  final bool adult;
  final int id;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.overview,
    required this.cover,
    required this.rating,
    required this.date,
    required this.adult,
    required this.id,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // make the image cover the entire screen
              Hero(
                tag: widget.cover,
                child: CachedNetworkImage(
                  imageUrl: widget.cover,
                  fit: BoxFit.cover,
                ),
              ),
              // make the bottom image dark with gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: size.height * 0.3,
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
              // put the container with movie details on the top of the image.
              MovieDetail(
                futureMovieDetail: futureMovieDetails,
                title: widget.title,
                overview: widget.overview,
                cover: widget.cover,
                rating: widget.rating,
                date: widget.date,
                adult: widget.adult,
                id: widget.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
