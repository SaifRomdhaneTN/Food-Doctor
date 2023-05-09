// ignore_for_file: file_names

class Preferences{
  late String halalKosherPref;
  late String meatPreferences;

  late List<String> allergies ;
  late List<String>? ingredientsCantEat;
  late bool hasDiabetes;
  late bool hasCholesterol;

  Preferences(this.halalKosherPref, this.meatPreferences,
      this.allergies);

  Map<String,dynamic> toJson()=>{
    'HalalKosherPref' : halalKosherPref,
    'MeatPreferences' :meatPreferences,
    'Allergies' :allergies,
    'IngredientsCantEat' : ingredientsCantEat,
    'HasDiabetes' : hasDiabetes,
    'HasCholesterol' : hasCholesterol
  };
}