import 'package:flutter/material.dart';
import 'package:githubapp/Models/organizationModel.dart';
import 'package:githubapp/Models/repositoryModel.dart';
import 'package:githubapp/Models/userModels.dart';
import 'package:githubapp/Providers/OrganizationProvider/OrganizationProviders.dart';
import 'package:githubapp/Providers/HomeProviders/homepageProviders.dart';
import 'package:githubapp/Styles/appColors.dart';
import 'package:githubapp/Styles/textCollection.dart';
import 'package:provider/provider.dart';

class OrganizationScreen extends StatefulWidget {
  static const routeName = "/Organization";
  var index;
  var name;
  OrganizationScreen({super.key, this.index, this.name});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  List<Organizaton> orgData = [];
  List<UserModel> memberData = [];
  List<Repository> repData = [];
  late Organizaton selected;
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
    orgData =
        Provider.of<HomeProviders>(context, listen: false).getOrganization();
    selected = orgData[widget.index];
    getMembers();
  }

//Function to call Organizations Members and repos and other additional infos
  getMembers() async {
    setState(() {
      _isloading = true;
    });
    var res1 = await Provider.of<OrganizationProviders>(context, listen: false)
        .getOrganizationMemberApicall(selected.name);
    if (res1) {
      memberData = Provider.of<OrganizationProviders>(context, listen: false)
          .getOrganizatioMember();
    }
    var res2 = await Provider.of<OrganizationProviders>(context, listen: false)
        .getRepositoryApicall(selected.name);
    if (res2) {
      repData = Provider.of<OrganizationProviders>(context, listen: false)
          .getRepository();
    }

    setState(() {
      _isloading = false;
    });
  }

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Organisation")),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            //Quick sort to navigate across orgs.
            Container(
              height: 35,
              child: ListView.builder(
                itemCount: orgData.length,
                itemBuilder: ((context, index) => InkWell(
                      onTap: () {
                        setState(() {
                          selected = orgData[index];
                        });
                        getMembers();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                            color: selected.id == orgData[index].id
                                ? AppColors.themeColor.shade400
                                : AppColors.pureWhiteColor),
                        child: Center(
                          child: Container(
                              margin: EdgeInsets.all(7),
                              child: Text(orgData[index].name)),
                        ),
                      ),
                    )),
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.themeColor,
              child: CircleAvatar(
                radius: 53,
                backgroundImage: NetworkImage(selected.avatars),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //Organization info
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style:
                        TextStyleCollection.mediumRegularTextStyle14.copyWith(
                      color: AppColors.themeColor,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    selected.name,
                    style:
                        TextStyleCollection.largeRegularTextStyle20.copyWith(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Description",
                    style:
                        TextStyleCollection.mediumRegularTextStyle14.copyWith(
                      color: AppColors.themeColor,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    selected.description ?? "Description not available.",
                    style: TextStyleCollection.mediumRegularTextStyle16
                        .copyWith(height: 1.4),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Member info
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
                                "Members",
                                style: TextStyleCollection
                                    .mediumRegularTextStyle14
                                    .copyWith(
                                  color: AppColors.themeColor,
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            //List the number of member in the organization.
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
                            //Repo info
                            if (repData.isNotEmpty)
                              Text(
                                "Repository",
                                style: TextStyleCollection
                                    .mediumRegularTextStyle14
                                    .copyWith(
                                  color: AppColors.themeColor,
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            //List the number of repo in the organization.
                            Container(
                              height: 120,
                              child: ListView.builder(
                                  itemCount: repData.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) => Container(
                                        margin: EdgeInsets.only(right: 20),
                                        width: 120,
                                        height: 120,
                                        child: ImageCard(
                                            "https://miro.medium.com/max/398/1*EeL55uzE2XcMNkv4ir2M_w.png",
                                            repData[i].name),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      )),
                            )
                          ],
                        ),
                ],
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
        SizedBox(
          height: 3,
        ),
        Text(name)
      ],
    );
  }
}
