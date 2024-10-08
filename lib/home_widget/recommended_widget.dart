import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/cubits/recommended_cubit/recommended_states.dart';
import 'package:movie_app/cubits/recommended_cubit/recommended_view_model.dart';
import 'package:movie_app/theme/app_color.dart';

import '../items/custom_widget.dart';
import '../screens/movie_details_screen.dart';

class RecommendedWidget extends StatelessWidget {
  RecommendedWidget({super.key});

  RecommendedViewModel recommendedViewModel = RecommendedViewModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => RecommendedViewModel()..getRecommended(),
      child: BlocBuilder<RecommendedViewModel, RecommendedState>(
          builder: (context, state) {
        if (state is RecommendedLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.darkYellowColor,
            ),
          );
        }
        if (state is RecommendedErrorState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Some Thing Went Wrong!!",
                  style: Theme.of(context).textTheme.headlineMedium),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<RecommendedViewModel>(context)
                      .getRecommended();
                },
                child: Text("Try Again",
                    style: Theme.of(context).textTheme.headlineMedium),
              )
            ],
          );
        }
        if (state is RecommendedSuccessState) {
          return Container(
            height: height * 0.27,
            padding: const EdgeInsets.only(top: 10),
            color: AppColor.secondaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 10),
                  child: Text(
                    "Recommend",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: height * 0.22,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            BlocProvider.of<RecommendedViewModel>(context)
                                .recommendList
                                .length,
                        itemBuilder: (context, index) {
                          final item =
                              BlocProvider.of<RecommendedViewModel>(context)
                                  .recommendList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MovieDetailsScreen.routeName,
                                arguments: item,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Card(
                                surfaceTintColor: AppColor.darkGrayColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                elevation: 0.1,
                                color: const Color(0xFF343534),
                                shadowColor: AppColor.blackColor,
                                child: SizedBox(
                                  height: height * 0.2,
                                  width: width * 0.25,
                                  child: Column(
                                    children: [
                                      CustomScreen(
                                          coverImage:
                                              "https://image.tmdb.org/t/p/w500/${item.backdropPath ?? ""}",
                                          results: item,
                                          image:
                                              "https://image.tmdb.org/t/p/w500/${item.posterPath ?? ""}",
                                          heightMeasure: height * 0.15,
                                          widthMeasure: width * 0.25),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: AppColor.yellowColor,
                                                    size: 12,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "${item.voteAverage ?? ""},",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall,
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Text(
                                                item.title!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Spacer(),
                                              Text(
                                                item.releaseDate ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      }),
    );
  }
}
