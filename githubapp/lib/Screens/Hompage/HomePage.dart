import 'package:flutter/material.dart';
import 'package:githubapp/Models/organizationModel.dart';
import 'package:githubapp/Models/repositoryModel.dart';
import 'package:githubapp/Models/userModels.dart';
import 'package:githubapp/Providers/LoginProviders/LoginProviders.dart';
import 'package:githubapp/Providers/HomeProviders/homepageProviders.dart';
import 'package:githubapp/Providers/OrganizationProvider/OrganizationProviders.dart';
import 'package:githubapp/Providers/RepositoryProvider.dart/repositoryProviders.dart';
import 'package:githubapp/Screens/LoginPage/LoginScreen.dart';
import 'package:githubapp/Screens/Organization/Organisation.dart';
import 'package:githubapp/Screens/Repository.dart/RepositoryScreen.dart';
import 'package:githubapp/Styles/appColors.dart';
import 'package:githubapp/Styles/textCollection.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  static const routeName = "/homePage";
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late UserModel user;
  bool _isOrgSelected = true;
  bool _isRepoSelected = false;
  List<Organizaton> orgData = [];
  List<Repository> repData = [];
  bool _isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//To get the User Information from the github signin.
  getUserData() async {
    user =
        await Provider.of<LoginProvider>(context, listen: false).getUserData();
    setState(() {
      _isLoading = true;
    });
    getOrgAndRepo();
  }

//To get the Organization and Repository
  getOrgAndRepo() async {
    await Provider.of<HomeProviders>(context, listen: false)
        .getOrganizationApicall(user.username);

    orgData =
        Provider.of<HomeProviders>(context, listen: false).getOrganization();
    await Provider.of<HomeProviders>(context, listen: false)
        .getRepositoryApicall(user.username);
    repData =
        Provider.of<HomeProviders>(context, listen: false).getRepository();

    setState(() {
      _isLoading = false;
    });
  }

  clearData() async {
    await Provider.of<HomeProviders>(context, listen: false).clearData();
    await Provider.of<RepositoryProviders>(context, listen: false).clearData();
    await Provider.of<OrganizationProviders>(context, listen: false)
        .clearData();
    setState(() {});
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //Pull to refersh to get the latest records.
        getOrgAndRepo();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    //Clear The stored Records/data.
                    clearData();
                  },
                  icon: Icon(Icons.logout)),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //Shows the Login In Section.
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                            color: AppColors.themeColor.shade50,
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Logged In as,",
                                    style: TextStyleCollection
                                        .mediumRegularTextStyle16
                                        .copyWith(color: AppColors.themeColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 43,
                                      backgroundColor: AppColors.themeColor,
                                      child: CircleAvatar(
                                        radius: 38,
                                        backgroundColor: AppColors.themeColor,
                                        backgroundImage: _isLoading
                                            ? null
                                            : NetworkImage(user.profileicon),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username.toString(),
                                          style: TextStyleCollection
                                              .mediumRegularTextStyle16,
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(user.email.toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //To Display Orgs or Repos based on User Interaction
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isOrgSelected = true;
                                  _isRepoSelected = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.gradient_outlined,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Organizations")
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _isOrgSelected
                                        ? AppColors.themeColor.shade200
                                        : Colors.grey.shade200),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isOrgSelected = false;
                                  _isRepoSelected = true;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Repository")
                                  ],
                                ),
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _isRepoSelected
                                        ? AppColors.themeColor.shade200
                                        : Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Title Section
                      //This section is extract as a method increase resusability.
                      AnimatedSwitcher(
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        duration: Duration(milliseconds: 400),
                        child: _isOrgSelected
                            ? ListTitle(
                                orgData.length.toString(), "Organization(s)")
                            : ListTitle(
                                repData.length.toString(), "Repository(s)"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Records Section.
                      //This section is extract as a method increase resusability.
                      if (orgData.length != 0 && _isOrgSelected)
                        for (int i = 0; i < orgData.length; i++)
                          HomePageListTile(i, orgData[i].name,
                              orgData[i].avatars, orgData[i].description, true),
                      if (repData.length != 0 && _isRepoSelected)
                        for (int i = 0; i < repData.length; i++)
                          HomePageListTile(
                              i,
                              repData[i].name,
                              "https://miro.medium.com/max/398/1*EeL55uzE2XcMNkv4ir2M_w.png",
                              repData[i].description,
                              false),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Container HomePageListTile(int i, name, avatar, description, isOrg) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 80,
      child: InkWell(
        onTap: () {
          if (isOrg) {
            //Navigates to Orgs Details Page if user taps on Orgs
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrganizationScreen(
                          index: i,
                          name: user.username,
                        )));
          } else {
            //Navigates to Repo Details Page if user taps on repo
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RepositoryScreen(
                          index: i,
                          name: user.username,
                        )));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.themeColor,
                    child: CircleAvatar(
                      radius: 33,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(avatar),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyleCollection.mediumSemiBoldTextStyle14,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        //handling the date if description is null.
                        description ?? "Description not available",
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyleCollection.smallRegularTextStyleSize12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              child: Icon(Icons.arrow_forward_ios_rounded),
              margin: EdgeInsets.only(right: 10),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
        color: (i % 2) == 0
            ? AppColors.themeColor.shade50
            : AppColors.pureWhiteColor,
      ),
    );
  }

  Row ListTitle(number, name) {
    return Row(
      key: GlobalKey(),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Text(
            number,
            style: TextStyleCollection.largeBoldTextStyle22
                .copyWith(color: AppColors.themeColor, fontSize: 30),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(name,
            style: TextStyleCollection.largeBoldTextStyle20
                .copyWith(color: AppColors.themeColor, fontSize: 18))
      ],
    );
  }
}
