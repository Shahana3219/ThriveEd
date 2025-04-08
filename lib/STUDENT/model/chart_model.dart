// To parse this JSON data, do
//
//     final ChartModel = ChartModelFromJson(jsonString);

import 'dart:convert';

ChartModel ChartModelFromJson(String str) => ChartModel.fromJson(json.decode(str));

String ChartModelToJson(ChartModel data) => json.encode(data.toJson());

class ChartModel {
    int? session;
    int? score;

    ChartModel({
        this.session,
        this.score,
    });

    factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        session: json["session"],
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "session": session,
        "score": score,
    };
}
