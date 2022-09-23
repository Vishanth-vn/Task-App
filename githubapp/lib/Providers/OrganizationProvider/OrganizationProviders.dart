import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:githubapp/Models/repositoryModel.dart';
import 'package:githubapp/Models/userModels.dart';
import 'package:http/http.dart' as http;

class OrganizationProviders with ChangeNotifier {
  List<UserModel> orgMember = [];
  List<Repository> repData = [];
  clearData() {
    orgMember = [];
    repData = [];
  }

  getOrganizatioMember() {
    return orgMember;
  }

  getOrganizationMemberApicall(name) async {
    orgMember = [];
    name = name ?? "Vishanth-vn";
    var res =
        await http.get(Uri.parse("https://api.github.com/orgs/$name/members"));

    var result = json.decode(res.body);

    if (res.statusCode == 200) {
      for (int i = 0; i < result.length; i++) {
        orgMember.add(UserModel(result[i]["login"], result[i]["login"], "",
            result[i]["avatar_url"], ""));
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
        await http.get(Uri.parse("https://api.github.com/orgs/$name/repos"));
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
