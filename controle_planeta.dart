import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/planeta.dart';

class ControlePlaneta {
  static Database? _bd;
  
  //Retorna o banco de dados, se ele não estiver aberto ele inicia.
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  //inicia o banco de dados.

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarBD,
      );
  }
  //cria a tabela no banco de dados.

  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
    CREATE TABLE planetas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      tamanho REAL NOT NULL,
      distancia REAL NOT NULL,
      apelido TEXT,
    );
    ''';
    await bd.execute(sql);
  }
  //le todos os planetas do banco.

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }
  //insere um planeta no banco.

  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('planetas', planeta.toMap());
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id]);
  }
  //exclui um planeta do banco.

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id]);

  }
}
