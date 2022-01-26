// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:netflix_redesign/constants.dart';
import 'package:netflix_redesign/models/movie.dart';
import 'package:netflix_redesign/screens/detail.dart';
import 'package:netflix_redesign/utils/services.dart';

class SearchItem extends StatelessWidget {
  final Result data;
  final int index;

  const SearchItem({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: data.title.toString(),
              adult: data.adult!,
              cover: posterUrl + data.posterPath.toString(),
              date: data.releaseDate.toString(),
              rating: data.voteAverage.toString(),
              overview: data.overview.toString(),
              id: data.id!,
            ),
          ),
        );
      },
      child: Card(
        color: kBackgroundColor,
        child: Container(
          margin: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  data.posterPath == null
                      ? const Placeholder()
                      : Hero(
                          tag: posterUrl + data.posterPath.toString(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.27,
                              child: Image.network(
                                posterUrl + data.posterPath.toString(),
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor,
                                      ),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Text(
                          data.title.toString(),
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/star.svg'),
                          const SizedBox(width: 5),
                          Text(
                            data.voteAverage.toString(),
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.releaseDate!.isNotEmpty
                        ? Jiffy(data.releaseDate.toString()).yMMMd
                        : 'N/A',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
