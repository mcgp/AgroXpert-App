import 'dart:convert';

import 'package:agroxpert/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:agroxpert/models/estimates_model.dart';
import 'package:flutter/services.dart';
import '../models/farm_lot_model.dart';

final dio = Dio();

Future getEstimatesVsProduction(
    List<String> idsEstimates, String idFinalProduction) async {
  Map<String, dynamic> ids = {
    "ids": idsEstimates,
  };

  final responseEstimates =
      await dio.post('$baseUrl/estimates-production/harvest', data: ids);
  final responseProduction =
      await dio.get('$baseUrl/final-production/$idFinalProduction');

  dynamic dataMaping =
      mapData(responseEstimates.data['data'], responseProduction.data['data']);

  return dataMaping;
}

List<DataGraph> mapData(dynamic estimates, dynamic productionFinal) {
  List<DataGraph> dataGraph = [];

  dataGraph
      .add(DataGraph('Producción Final', productionFinal['totalProduction']));

  for (var estimate in estimates) {
    dataGraph.add(DataGraph(estimate['date'], estimate['totalProduction']));
  }

  return dataGraph;
}

class DataGraph {
  DataGraph(this.type, this.value);
  final String type;
  final int value;
}
