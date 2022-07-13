import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:validatorless/validatorless.dart';
import 'package:web_service/controller/cep_controller.dart';
import 'package:web_service/core/widgets/message_widget.dart';
import 'package:web_service/models/result_cep.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    CepController cepController = CepController();
    final cepEC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              shareCep(cepController, context);
            },
            icon: const Icon(
              Icons.share,
              color: Colors.black45,
            ),
          ),
        ],
        title: const Text(
          'Consultar Cep',
          style: TextStyle(color: Colors.black45),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: cepEC,
                  decoration: const InputDecoration(hintText: 'Digite o cep'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  validator: Validatorless.multiple(
                    [
                      Validatorless.required('Campo obrigatorio!'),
                      Validatorless.min(10, 'Digite um CEP valido!'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cepController.searchCep(
                        cepEC.text.replaceFirst('.', '').replaceFirst('-', ''),
                        context,
                      );
                    }
                  },
                  child: const Text('Pesquisar'),
                ),
                const SizedBox(
                  height: 55,
                ),
                ValueListenableBuilder<ResultCep>(
                  valueListenable: cepController.resultData,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Visibility(
                          visible: value.localidade.toString().isNotEmpty,
                          child: Text(
                            value.localidade.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: value.bairro.toString().isNotEmpty,
                          child: Text(
                            value.bairro.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          value.cep.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          value.ddd.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Visibility(
                          visible: value.gia.toString().isNotEmpty,
                          child: Text(
                            value.gia.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          value.ibge.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Visibility(
                          visible: value.logradouro.toString().isNotEmpty,
                          child: Text(
                            value.logradouro.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

shareCep(dynamic dataCep, BuildContext context) {
  final cepData = dataCep.resultData.value;

  if (cepData.cep != "") {
    Share.share(
        'CEP:${cepData.cep}, Logradouro:${cepData.logradouro}, Bairro:${cepData.bairro}, Localidde:${cepData.localidade}, UF:${cepData.uf}, Ibge:${cepData.ibge}, Gia:${cepData.gia}, DDD:${cepData.ddd}');
  } else {
    Messages.alert("Cep nao pesquisado", "Voce nao pesquisou um cep", context);
  }
}
