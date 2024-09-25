import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:threads/Cubit/addPost_cubit/add_post_cubit.dart';
import 'package:threads/Screens/home_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController controller = TextEditingController();
  Uint8List? _image;

  // Requesting permissions for Camera and Storage
  Future<bool> requestPermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus storageStatus = await Permission.storage.request();

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      return true;
    } else {
      print('Permissions denied');
      return false;
    }
  }

  // Function to pick image from gallery or camera
  Future<Uint8List?> pickImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? _imageFile = await _picker.pickImage(source: source);
      if (_imageFile != null) {
        return await _imageFile.readAsBytes();
      } else {
        print('No image selected.');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  void selectImage() async {
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      print('Permissions not granted');
      return;
    }

    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    } else {
      print('No image selected or an error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => AddPostCubit(),
      child: BlocBuilder<AddPostCubit, AddPostState>(
        builder: (context, state) {
          if (state is AddPostLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AddPostSuccess) {
            Future.microtask(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            });

          } else if (state is AddPostFailed) {
            // Handle failure state
            return Center(child: Text(state.error));
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              splashColor: Colors.black,
              backgroundColor: Colors.grey.withOpacity(.22),
              onPressed: selectImage,
              child: ImageIcon(
                color: Colors.white,
                AssetImage(
                    'assets/Images/image-gallery.png'),
              ),
            ),
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(widthScreen*0.009),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: widthScreen*0.026
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                'New thread',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: widthScreen*0.05,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: state is AddPostLoading ? null : () {
                    context.read<AddPostCubit>().addPost(context, _image);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(widthScreen*0.015),

                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                          fontSize: widthScreen*0.026

                      ),
                    ),
                  ),
                ),

              ],
            ),
            body: Container(
              width: widthScreen,
              height: heightScreen,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: widthScreen*0.05),
                      child: Container(
                        width: widthScreen,
                        height: heightScreen*0.001,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthScreen*0.05),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: widthScreen*0.054,
                            backgroundImage: NetworkImage(
                                '${FirebaseAuth.instance.currentUser!.photoURL}'),
                          ),
                          SizedBox(width: widthScreen*0.03),
                          Text(
                            '${FirebaseAuth.instance.currentUser!.displayName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: widthScreen*0.038,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(widthScreen*0.04),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: context.read<AddPostCubit>().controller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter your thread content',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null, // Allows for multi-line input
                          ),
                          Container(
                            width: widthScreen,
                            height: heightScreen*0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: _image != null
                                  ? DecorationImage(
                                image: MemoryImage(_image!),
                                fit: BoxFit.contain,
                              )
                                  : null, // No image when _image is null
                            ),
                            child: _image == null
                                ? Center(child: Text('', style: TextStyle(color: Colors.white))) // Optional: Add a message or leave it empty
                                : null, // You can also leave this as null if you don’t want anything displayed
                          ),

                        ],
                      ),
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
