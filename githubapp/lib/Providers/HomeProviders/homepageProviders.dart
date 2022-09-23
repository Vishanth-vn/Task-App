import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:githubapp/Models/organizationModel.dart';
import 'package:githubapp/Models/repositoryModel.dart';
import 'package:http/http.dart' as http;

class HomeProviders with ChangeNotifier {
  List<Organizaton> orgData = [];
  List<Repository> repData = [];

  clearData() {
    orgData = [];
    repData = [];
  }

  getOrganization() {
    return orgData;
  }

  getOrganizationApicall(name) async {
    orgData = [];
    name = name ?? "Vishanth-vn";
    var res = await http.get(
      Uri.parse("https://api.github.com/users/$name/orgs"),
    );
    var result = json.decode(res.body);
    if (res.statusCode == 200) {
      for (int i = 0; i < result.length; i++) {
        orgData.add(Organizaton(result[i]["login"], result[i]["id"],
            result[i]["avatar_url"], result[i]["description"]));
      }
      return true;
    } else {
      return false;
    }
  }

  getRepositoryApicall(name) async {
    repData = [];
    name = name ?? "Vishanth-vn";
    var res =
        await http.get(Uri.parse("https://api.github.com/users/$name/repos"));
    var result = json.decode(res.body);

    if (res.statusCode == 200) {
      for (int i = 0; i < result.length; i++) {
        repData.add(Repository(
            result[i]["name"],
            result[i]["full_name"],
            result[i]["private"],
            result[i]["owner"]["login"],
            result[i]["owner"]["avatar_url"],
            result[i]["description"],
            result[i]["clone_url"],
            result[i]["git_url"],
            result[i]["visibility"],
            result[i]["watchers_count"],
            result[i]["created_at"]));
      }
      return true;
    } else {
      return false;
    }
  }

  getRepository() {
    return repData;
  }
}
