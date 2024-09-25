import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:threads/Cubit/timeLine_cubit/time_line_cubit.dart';
import 'package:threads/Screens/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:threads/TimeOfPost.dart';
import 'package:shimmer/shimmer.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    context.read<TimeLineCubit>().getTimeLine();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              pinned: false,
              floating: false,
              expandedHeight: heightScreen * 0.23,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: widthScreen*0.045, top:  widthScreen*0.045, right:  widthScreen*0.045),
                      child: Column(
                        children: [
                          SizedBox(
                            width: widthScreen * 0.1,
                            height: heightScreen * 0.05,
                            child: Image.asset('assets/Images/Vector.png'),
                          ),
                          SizedBox(height: heightScreen * 0.01),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const PostScreen()),
                              );
                            },
                            child: Container(
                              width: widthScreen,
                              height: heightScreen * 0.14,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: widthScreen*0.054,
                                        backgroundImage: NetworkImage(
                                            '${FirebaseAuth.instance.currentUser!.photoURL}'),
                                      ),
                                      SizedBox(width: widthScreen*0.035),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${FirebaseAuth.instance.currentUser!.displayName}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              fontSize: widthScreen*0.038,
                                            ),
                                          ),
                                          Text(
                                            'What\'s new?',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                                fontSize: widthScreen*0.038
                                            ),
                                          ),
                                          SizedBox(height: heightScreen*0.014),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: widthScreen*0.05,
                                                child: ImageIcon(
                                                  color: Colors.grey,
                                                  AssetImage(
                                                      'assets/Images/image-gallery.png',),
                                                ),
                                              ),
                                              SizedBox(width: widthScreen*0.02,),
                                              SizedBox(
                                                width: widthScreen*0.05,
                                                child: ImageIcon(
                                                  color: Colors.grey,
                                                  AssetImage(
                                                      'assets/Images/camera.png'),
                                                ),
                                              ),
                                              SizedBox(width: widthScreen*0.02,),
                                              SizedBox(
                                                width: widthScreen*0.05,
                                                child: ImageIcon(
                                                  color: Colors.grey,
                                                  AssetImage(
                                                      'assets/Images/gif.png'),
                                                ),
                                              ),
                                              SizedBox(width: widthScreen*0.02,),
                                              SizedBox(
                                                width: widthScreen*0.05,
                                                child: ImageIcon(
                                                  color: Colors.grey,
                                                  AssetImage(
                                                      'assets/Images/microphone.png'),
                                                ),
                                              ),
                                              SizedBox(width: widthScreen*0.02,),                                              SizedBox(width: widthScreen*0.05,
                                                child: ImageIcon(
                                                  color: Colors.grey,
                                                  AssetImage(
                                                      'assets/Images/hash-tag.png'),
                                                ),
                                              ),
                                              SizedBox(width: widthScreen*0.02,),
                                              SizedBox(width: widthScreen*0.05,
                                                child: ImageIcon(
                                                  color: Colors.grey,
                                                  AssetImage(
                                                      'assets/Images/menu-post.png'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: heightScreen*0.001,
                      color: Color(0xff333638),
                      width: widthScreen,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<TimeLineCubit, TimeLineState>(
              builder: (context, state) {
                if (state is TimeLineLoading) {
                  return SliverToBoxAdapter(
                    child: Skeletonizer(
                      enableSwitchAnimation: true,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[500]!,
                        highlightColor: Colors.grey[100]!,
                        child: Column(
                          children: List.generate(
                            9,
                                (index) => ListTile(
                              leading: CircleAvatar(
                                radius: widthScreen*0.054,
                                backgroundImage: NetworkImage(
                                  'https://images.pexels.com/photos/24014245/pexels-photo-24014245/free-photo-of-photo-of-a-small-domestic-dog-lying-on-the-floor.jpeg',
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Skeleton'),
                                  Text(
                                    'SkeletonSkeletonSkeletonSeletonSkeletonSkeletonSkeletonSkeleton',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                } else if (state is TimeLineSuccess) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final post = state.posts[index];
                        final createdAt = post.createdAt;
                        final date =
                            TimeOfPosts().formatTimeDifference(createdAt);

                        return Column(
                          children: [
                            Container(
                              padding:EdgeInsets.all(widthScreen*0.045),
                              child: Column(children: [
                                Row(children: [
                                  CircleAvatar(
                                    radius: widthScreen*0.054,
                                    backgroundImage:
                                        NetworkImage(post.user.photo),
                                  ),
                                  SizedBox(width: widthScreen*0.035),
                                  Row(
                                    children: [
                                      Text(
                                        post.user.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: widthScreen*0.038
                                        ),
                                      ),
                                      SizedBox(width: widthScreen*0.03),
                                      Text(
                                        date,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: widthScreen*0.038
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                                SizedBox(height: heightScreen*0.01),
                                Container(
                                  width: widthScreen,
                                  child: Text(
                                    post.content,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: widthScreen*0.038),
                                  ),
                                ),
                                SizedBox(height: heightScreen*0.02),
                                if (post.imageUrl != '')
                                  Column(
                                    children: [
                                      Container(
                                        width: widthScreen,
                                        height: heightScreen*0.45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(post.imageUrl),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: heightScreen*0.035),
                                    ],
                                  )
                                else
                                  Text(''),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: widthScreen*0.1,
                                      child: ImageIcon(
                                        color: Colors.white,
                                        AssetImage('assets/Images/like.png'),
                                      ),
                                    ),
                                    SizedBox(width: widthScreen*0.06),
                                    SizedBox(
                                      width: widthScreen*0.1,
                                      child: ImageIcon(
                                        color: Colors.white,
                                        AssetImage('assets/Images/comment.png'),
                                      ),
                                    ),
                                    SizedBox(width: widthScreen*0.06),
                                     SizedBox(
                                       width: widthScreen*0.1,
                                       child: ImageIcon(
                                        color: Colors.white,
                                        AssetImage('assets/Images/repost.png'),
                                                                           ),
                                     ),
                                    SizedBox(width: widthScreen*0.06),
                                     SizedBox(
                                       width: widthScreen*0.1,
                                       child: ImageIcon(
                                        color: Colors.white,
                                        AssetImage('assets/Images/share.png'),
                                                                           ),
                                     ),
                                  ],
                                ),
                                SizedBox(height: heightScreen*0.01),
                              ]),
                            ),
                            Container(
                              height: heightScreen*0.001,
                              color: Color(0xff333638),
                              width: widthScreen,
                            ),
                          ],
                        );
                      },
                      childCount: state.posts.length, // Number of items
                    ),
                  );
                } else if (state is TimeLineFailed) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No posts available')),
                );
              },
            ),
          ],
        ),

      ),
    );
  }
}
