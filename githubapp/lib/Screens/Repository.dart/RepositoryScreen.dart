import 'package:flutter/material.dart';
import 'package:githubapp/Models/BranchModel.dart';
import 'package:githubapp/Models/repositoryModel.dart';
import 'package:githubapp/Models/userModels.dart';
import 'package:githubapp/Providers/HomeProviders/homepageProviders.dart';
import 'package:githubapp/Providers/RepositoryProvider.dart/repositoryProviders.dart';
import 'package:githubapp/Styles/appColors.dart';
import 'package:githubapp/Styles/textCollection.dart';
import 'package:githubapp/Widgets/TitleandDesc.dart';
import 'package:provider/provider.dart';

class RepositoryScreen extends StatefulWidget {
  static const routeName = "/Organization";
  var index;
  var name;
  RepositoryScreen({super.key, this.index, this.name});

  @override
  State<RepositoryScreen> createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen> {
  List<Repository> repData = [];
  List<UserModel> memberData = [];
  List<BranchModel> branchData = [];
  late Repository selected;
  @override
  void initState() {
    getOrganization();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getOrganization() {
    repData =
        Provider.of<HomeProviders>(context, listen: false).getRepository();
    selected = repData[widget.index];
    getMembers();
  }

//Function to get the collaborators and branches.
  getMembers() async {
    setState(() {
      _isloading = true;
    });
    var res1 = await Provider.of<RepositoryProviders>(context, listen: false)
        .getCollabMemberApicall(widget.name, selected.name);
    if (res1) {
      memberData = Provider.of<RepositoryProviders>(context, listen: false)
          .getCollabMember();
    }
    var res2 = await Provider.of<RepositoryProviders>(context, listen: false)
        .getBranchApicall(widget.name, selected.name);
    if (res2) {
      branchData =
          Provider.of<RepositoryProviders>(context, listen: false).getBranch();
    }
    setState(() {
      _isloading = false;
    });
  }

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Repository")),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            //Quick sort to navigate across repos.
            Container(
              height: 35,
              child: ListView.builder(
                itemCount: repData.length,
                itemBuilder: ((context, index) => InkWell(
                      onTap: () {
                        setState(() {
                          selected = repData[index];
                        });
                        getMembers();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                            color: selected.giturl == repData[index].giturl
                                ? AppColors.themeColor.shade400
                                : AppColors.pureWhiteColor),
                        child: Center(
                          child: Container(
                              margin: EdgeInsets.all(7),
                              child: Text(repData[index].name)),
                        ),
                      ),
                    )),
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Repo Profile and info
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.themeColor,
                      child: CircleAvatar(
                        radius: 53,
                        backgroundImage: NetworkImage(
                            "https://miro.medium.com/max/398/1*EeL55uzE2XcMNkv4ir2M_w.png"),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TitleandDesc("Git URL", selected.giturl),
                    TitleandDesc("Clone URL", selected.cloneurl),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //Repo basic details
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleandDesc("Name", selected.name),
                      TitleandDesc("Description", selected.description),
                      TitleandDesc("Fullname", selected.fullname),
                      _isloading
                          ? Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 100),
                                  child: CircularProgressIndicator()),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (memberData.isNotEmpty)
                                  Text(
                                    "Collaborators",
                                    style: TextStyleCollection
                                        .mediumRegularTextStyle14
                                        .copyWith(
                                      color: AppColors.themeColor,
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 120,
                                  child: ListView.builder(
                                      itemCount: memberData.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, i) => Container(
                                            margin: EdgeInsets.only(right: 20),
                                            width: 120,
                                            height: 120,
                                            child: ImageCard(
                                                memberData[i].profileicon,
                                                memberData[i].username),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          )),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                if (branchData.isNotEmpty)
                                  Text(
                                    "Branch(s)",
                                    style: TextStyleCollection
                                        .mediumRegularTextStyle14
                                        .copyWith(
                                      color: AppColors.themeColor,
                                    ),
                                  ),
                                if (branchData.isNotEmpty)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (branchData.isNotEmpty)
                                  Container(
                                    height: 120,
                                    child: ListView.builder(
                                        itemCount: branchData.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, i) => Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              width: 120,
                                              height: 120,
                                              child: ImageCard(
                                                  "https://miro.medium.com/max/398/1*EeL55uzE2XcMNkv4ir2M_w.png",
                                                  branchData[i].name),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )),
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //Repo other info
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleandDesc("Owner", selected.owner),
                      TitleandDesc("Visibility", selected.visibility),
                      TitleandDesc(
                          "Watchers Count", selected.watcherscount.toString()),
                      TitleandDesc(
                          "Created At",
                          selected.createdat
                              .toString()
                              .replaceAll("T", " ")
                              .replaceAll("Z", "")),
                    ]),
              ),
            )
          ],
        ),
      )),
    );
  }

  Column ImageCard(avatar, name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          radius: 40,
        ),
        Container(
            margin: EdgeInsets.all(4),
            child: Text(
              name,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ))
      ],
    );
  }
}
