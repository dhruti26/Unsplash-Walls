import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:wallpaper_guru/controller/apiOper.dart';
import 'package:wallpaper_guru/model/categoryModel.dart';
import 'package:wallpaper_guru/model/photosModel.dart';
import 'package:wallpaper_guru/views/screens/FullScreen.dart';
import 'package:wallpaper_guru/views/widgets/CustomAppBar.dart';
import 'package:wallpaper_guru/views/widgets/SearchBar.dart';
import 'package:wallpaper_guru/views/widgets/catBlock.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _categoryController = TextEditingController(); // Add this line
  late List<PhotosModel> trendingWallList;
  late List<CategoryModel> CatModList;
  bool isLoading = true;

  GetCatDetails() async {
    CatModList = await ApiOperations.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(CatModList);
    setState(() {
      CatModList = CatModList;
    });
  }

  GetTrendingWallpapers() async {
    trendingWallList = await ApiOperations.getTrendingWallpapers();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _categoryController.clear();
    GetCatDetails();
    GetTrendingWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: CustomAppBar(
          word1: "Unsplash",
          word2: "Walls",
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SearchBarhere()),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _categoryController,
                                decoration: InputDecoration(
                                  hintText: 'Add Category',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),

                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                // Handle the button tap to add the category to CatModList
                                String newCategory = _categoryController.text;
                                setState(() {
                                  CatModList.add(
                                    CategoryModel(
                                      catName: newCategory,
                                      catImgUrl: 'https://images.pexels.com/photos/956999/milky-way-starry-sky-night-sky-star-956999.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // You can provide an empty image URL or null here
                                    ),
                                  );
                                });
                                _categoryController.clear(); // Clear the input field
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 20.0),
                          child:  SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: CatModList.length,
                            itemBuilder: (context, index) {
                              return CatBlock(
                                categoryImgSrc: CatModList[index].catImgUrl,
                                categoryName: CatModList[index].catName,
                              );
                            },
                          ),
                        ),
                       ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 700,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      child: GridView.builder(
                          physics: BouncingScrollPhysics(),//scrollbar effect
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 400,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 13,
                                  mainAxisSpacing: 10),
                          itemCount: trendingWallList.length,
                          itemBuilder: ((context, index) => GridTile(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullScreen(
                                                imgUrl: trendingWallList[index]
                                                    .imgSrc)));
                                  },
                                  child: Hero(
                                    tag: trendingWallList[index].imgSrc,
                                    child: Container(
                                      height: 800,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                            height: 800,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            trendingWallList[index].imgSrc),
                                      ),
                                    ),
                                  ),
                                ),
                              ))),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
