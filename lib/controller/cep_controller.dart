// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web_service/core/widgets/message_widget.dart';
import 'package:web_service/models/result_cep.dart';

class CepController {
  ValueNotifier<ResultCep> resultData = ValueNotifier<ResultCep>(
    ResultCep(
      cep: '',
      logradouro: '',
      complemento: '',
      bairro: '',
      localidade: '',
      uf: '',
      ibge: '',
      gia: '',
      ddd: '',
      siafi: '',
    ),
  );

  Future<ResultCep> searchCep(String cep, BuildContext context) async {
    var result = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    try {
      if (result.statusCode == 200) {
        if (result.data['erro'] != null) {
          Messages.alert(
              'Erro', 'Digite um CEP valido e tente novamente!', context);
        } else {
          Messages.success('Sucesso', 'Cep encontrado com sucesso!', context);
        }
      } else {
        Messages.alert('Erro', 'Erro ao buscar o CEP!', context);
      }
    } catch (e) {
      log(e.toString());
    }

    return resultData.value = ResultCep.fromMap(result.data);
  }


}
