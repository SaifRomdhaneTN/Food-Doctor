// ignore_for_file: file_names

class Product{
  final String _name;
  final String _maker;
  final String _imageURL;
  final String _canEat;
  final String _barcode;
  final Map<String,dynamic> _details;
  final List<String> _ingreidients;
  final List<String> _categories;
  final DateTime _lastScan;

  Product(this._name, this._maker, this._imageURL, this._details, this._canEat, this._barcode, this._ingreidients, this._categories, this._lastScan);

  Map<String, dynamic> getdetails() => _details;

  String getimageURL() => _imageURL;

  String getmaker() => _maker;

  String getname() => _name;
  String getCanEat() => _canEat;
  String getBarCode() => _barcode;
  List<String> getIngreidients() => _ingreidients;
  List<String> getCategories() => _categories;
  DateTime getFirstScan()=>_lastScan;
  Map<String,dynamic> toMap(){
    return{
      'Name':_name,
      'Maker':_maker,
      'ImageUrl':_imageURL,
      'Barcode':_barcode,
      'Details':_details,
      'Ingreidients':_ingreidients,
      'Categories':_categories,
      'LastScan':_lastScan
    };
  }
}