import 'package:shared_preferences/shared_preferences.dart';

class NotaStorageService {
  // Chave que funciona como nome do espaço onde guardamos textos
  static const String chaveNota = 'nota_inicial';

  final SharedPreferencesAsync _perfs = SharedPreferencesAsync();

  Future<void> salvarNotas(String texto) async {
    await _perfs.setString(chaveNota, texto);
  }

  //recupera a nota e retorna a string mesmo quando não existe valor
  Future<String> buscarNota() async {
    //string significa que o retorno pode ser string ou null

    final String? nota = await _perfs.getString(chaveNota);
    //?? usa o tesxto vazio xaso a nota seja null
    return nota ?? '';
  }

  //exlui somente o valdor que foi salvo na chve nota
  Future<void> apagarNota() async {
    await _perfs.remove(chaveNota);
  }
}
