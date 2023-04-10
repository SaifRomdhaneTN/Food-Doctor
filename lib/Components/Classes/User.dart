class UserLocal {
  late String _fullname;
  late DateTime _dateofbirth ;
  late int _age;
  late String _countryofResidence;
  late String _phoneNumber;
  late bool _filledform;




  UserLocal(this._fullname, this._dateofbirth, this._age, this._countryofResidence,
      this._phoneNumber);

  String getfullname() => _fullname;

  void fullname(String value) {
    _fullname = value;
  }

  DateTime getdateofbirth() => _dateofbirth;

  void dateofbirth(DateTime value) {
    _dateofbirth = value;
  }

  int getage() => _age;

  void age(int value) {
    _age = value;
  }

  String getcountryofResidence() => _countryofResidence;

  void countryofResidence(String value) {
    _countryofResidence = value;
  }

  String getphoneNumber() => _phoneNumber;

  void phoneNumber(String value) {
    _phoneNumber = value;
  }

  bool getfilledform() => _filledform;

  void filledform(bool value) {
    _filledform = value;
  }


  Map<String,dynamic> toJson()=>{
    'FullName' : _fullname,
    'DateOfBirth' : _dateofbirth,
    'Age' : _age,
    'PhoneNumber' : _phoneNumber,
    'FilledForm' : _filledform
  };
}