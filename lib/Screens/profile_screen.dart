import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:threads/Cubit/timeLine_cubit/time_line_cubit.dart';

import '../TimeOfPost.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int followerCount = 548;
  final List<String> profileImages = [
    'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1853047/pexels-photo-1853047.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/428333/pexels-photo-428333.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: SizedBox(
          child: ImageIcon(AssetImage('assets/Images/lock.png'),
              color: Colors.white),
        ),
        actions: [
          ImageIcon(AssetImage('assets/Images/instagram.png'),
              color: Colors.white),
          SizedBox(width: widthScreen*0.03),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
          SizedBox(width: widthScreen*0.015),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              pinned: false,
              floating: false,
              expandedHeight: heightScreen * 0.28,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.all( widthScreen*0.043),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${FirebaseAuth.instance.currentUser!.displayName}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: widthScreen*0.055,
                                    ),
                                  ),
                                  Text(
                                    '${FirebaseAuth.instance.currentUser!.displayName?.replaceAll(' ', '').toLowerCase() ?? ''}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: widthScreen*0.038,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Profile image with clear constraints
                            CircleAvatar(
                              radius: widthScreen*0.065,
                              backgroundImage: NetworkImage(
                                  '${FirebaseAuth.instance.currentUser!.photoURL}'),
                            ),
                          ]),
                      SizedBox(
                        height: heightScreen*0.02,
                      ),
                      Row(
                        children: [
                          // Ensure Stack has a limited size by wrapping it in SizedBox
                          SizedBox(
                            height: heightScreen*0.05, // Constrain height
                            width: widthScreen*0.21, // Constrain width
                            child: Stack(
                              children:
                                  profileImages.asMap().entries.map((entry) {
                                int index = entry.key;
                                String imageUrl = entry.value;
                                return Positioned(
                                  left: index * 20.0, // Adjust the overlap
                                  child: CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl),
                                      radius: 15, // Avatar size
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: widthScreen*0.01), // Space between avatars and text
                          Flexible(
                            child: Text(
                              '$followerCount followers',
                              style: TextStyle(
                                fontSize: widthScreen*0.038,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // To avoid overflow
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: heightScreen*0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: widthScreen*0.44,
                            height: heightScreen*0.045,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade900),
                            ),
                            child: TextButton(
                              onPressed: () {

                                  },


                              child: Text(
                                'Edit Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: widthScreen*0.44,
                            height: heightScreen*0.045,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade900),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Share profile',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<TimeLineCubit, TimeLineState>(
              builder: (context, state) {
                if (state is TimeLineLoading) {
                  return
                      SliverToBoxAdapter(
                        child: Skeletonizer(
                          enableSwitchAnimation: true,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[500]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              children: List.generate(
                                8,
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
                        final post = state.Myposts[index];
                        final createdAt = post.createdAt;
                        final date =
                            TimeOfPosts().formatTimeDifference(createdAt);

                        return Column(
                          children: [
                            Container(
                              padding:EdgeInsets.all(widthScreen*0.045),
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: widthScreen*0.054,
                                            backgroundImage: NetworkImage(post
                                                .user.photo),
                                          ),
                                          SizedBox(width: widthScreen*0.035),
                                          Row(
                                            children: [
                                              Text(
                                                post.user.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                date,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontSize: widthScreen*0.038),
                                              ),
                                            ],
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
                      childCount: state.Myposts.length, // Number of items
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
