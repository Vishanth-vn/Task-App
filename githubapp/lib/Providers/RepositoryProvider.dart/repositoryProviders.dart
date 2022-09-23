import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:githubapp/Models/BranchModel.dart';
import 'package:githubapp/Models/userModels.dart';
import 'package:http/http.dart' as http;

class RepositoryProviders with ChangeNotifier {
  List<UserModel> collabMember = [];
  List<BranchModel> branchModel = [];
  clearData() {
    collabMember = [];
    collabMember = [];
  }

  getCollabMember() {
    return collabMember;
  }

  getCollabMemberApicall(name, repo) async {
    collabMember = [];
    name = name ?? "Vishanth-vn";
    var res = await http.get(
        Uri.parse("https://api.github.com/repos/$name/$repo/collaborators"),
        headers: {
          "Authorization": "token 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"
        });

    var result = json.decode(res.body);

    if (res.statusCode == 200) {
      for (int i = 0; i < result.length; i++) {
        collabMember.add(UserModel(result[i]["login"], result[i]["login"], "",
            result[i]["avatar_url"], ""));
      }
      return true;
    } else {
      return false;
    }
  }

  getBranchApicall(repo, name) async {
    branchModel = [];
    name = name ?? "Vishanth-vn";
    var res = await http.get(
      Uri.parse("https://api.github.com/repos/$repo/$name/branches"),
    );

    var result = json.decode(res.body);

    if (res.statusCode == 200) {
      for (int i = 0; i < result.length; i++) {
        branchModel.add(BranchModel(result[i]["name"]));
      }
      return true;
    } else {
      return false;
    }
  }

  getBranch() {
    return branchModel;
  }
}
