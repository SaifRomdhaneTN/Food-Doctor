// ignore_for_file: file_names

class Preferences{
  late String HalalKosherPref;
  late String meatPreferences;
  late String organicPreferences;
  late List<String> allergies ;
  late List<String>? ingredientsCantEat;
  late bool hasDiabetes;
  late bool hasCholesterol;

  Preferences(this.HalalKosherPref, this.meatPreferences, this.organicPreferences,
      this.allergies);

  Map<String,dynamic> toJson()=>{
    'HalalKosherPref' : HalalKosherPref,
    'MeatPreferences' :meatPreferences,
    'OrganicPreferences' : organicPreferences,
    'Allergies' :allergies,
    'IngredientsCantEat' : ingredientsCantEat,
    'HasDiabetes' : hasDiabetes,
    'HasCholesterol' : hasCholesterol
  };
}