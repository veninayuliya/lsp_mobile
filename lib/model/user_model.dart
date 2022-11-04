// ignore_for_file: non_constant_identifier_names

class UserModel {
  late String user_name;
  late String nama;
  late String pass_word;
  late String no_telp;

  UserModel(this.user_name, this.nama, this.pass_word, this.no_telp);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_name': user_name,
      'nama': nama,
      'pass_word': pass_word,
      'no_telp': no_telp
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    user_name = map['user_name'];
    nama = map['nama'];
    pass_word = map['pass_word'];
    no_telp = map['no_telp'];
  }
}
