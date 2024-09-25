import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads/Cubit/Search_cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..searchUsers(_searchController.text),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          double widthScreen = MediaQuery.of(context).size.width;
          double heightScreen = MediaQuery.of(context).size.height;
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(widthScreen*0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: heightScreen*0.02),
                    TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        // Trigger the search based on the input
                        BlocProvider.of<SearchCubit>(context)
                            .searchUsers(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Search',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: heightScreen*0.02),
                    if (state is SearchLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    else if (state is SearchSuccess)
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return Container(
                              width: widthScreen,
                              height: heightScreen*0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border(top: BorderSide.none),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading:
                                CircleAvatar(
                                  radius: widthScreen*0.05,
                                  backgroundImage: NetworkImage(
                                      user.photo),
                                ),

                                title: Text(
                                  user.name,
                                  style: TextStyle(color: Colors.white,
                                    fontSize: widthScreen*0.04),
                                ),
                                trailing: Container(
                                  width: widthScreen*0.2,
                                  height: heightScreen*0.045,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(color: Colors.white,fontSize: widthScreen*0.03),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else if (state is SearchFailed)
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      )
                    else
                      Text(
                        'No users found',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
