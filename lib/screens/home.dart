import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:netflix_redesign/models/movie.dart';
import 'package:netflix_redesign/screens/detail.dart';
import 'package:netflix_redesign/utils/services.dart';
import 'package:netflix_redesign/widgets/bottom_bar.dart';
import 'package:netflix_redesign/widgets/home/category_list.dart';
import 'package:netflix_redesign/widgets/home/home_header.dart';
import 'package:netflix_redesign/widgets/home/search_bar.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  @override
  void initState() {
    futureDiscoverMovie = fetchDiscoverMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: backgroundCover(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: SafeArea(
              child: RefreshIndicator(
                color: kPrimaryColor,
                onRefresh: () {
                  return Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const BottomBar(),
                    ),
                  );
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      const SearchBar(),
                      const CategoryList(),
                      popularCarousel(),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget popularCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text('Popular', style: kSectionTitle),
        ),
        const SizedBox(height: 24),
        FutureBuilder<Movie>(
          future: futureDiscoverMovie,
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
                                cover: posterUrl + item.posterPath.toString(),
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
                              imageUrl: posterUrl + item.posterPath.toString(),
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

            return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget backgroundCover() {
    return FutureBuilder<Movie>(
      future: futureDiscoverMovie,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: posterUrl +
                  snapshot.data!.results![_current].posterPath.toString(),
              fit: BoxFit.fill,
              color: Colors.black.withOpacity(0.7),
              colorBlendMode: BlendMode.darken,
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/cover.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.7),
              colorBlendMode: BlendMode.darken,
            ),
          );
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/cover.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
        );
      },
    );
  }
}
