// ignore_for_file: file_names

class Preferences{
  late String religion;
  late String meatPreferences;
  late String organicPreferences;
  late List<String> allergies ;
  late List<String>? ingredientsCantEat;
  late bool hasDiabetes;
  late bool hasCholesterol;

  Preferences(this.religion, this.meatPreferences, this.organicPreferences,
      this.allergies);

  Map<String,dynamic> toJson()=>{
    'Religion' : religion,
    'MeatPreferences' :meatPreferences,
    'OrganicPreferences' : organicPreferences,
    'Allergies' :allergies,
    'IngredientsCantEat' : ingredientsCantEat,
    'HasDiabetes' : hasDiabetes,
    'HasCholesterol' : hasCholesterol
  };
}