class Option {
  String id = '';
  String storeId = '';
  String name = '';
  String description = '';
  double price = 0.0;

  static const COLLECTION = "options";
  static const NAME = "name";
  static const STORE_ID = "store_id";
  static const DESCRIPTION = "description";
  static const PRICE = "price";

  Option();

  Map<String, dynamic> serialize(String storeId) {
    return <String, dynamic>{
      STORE_ID: storeId,
      NAME: this.name,
      DESCRIPTION: this.description,
      PRICE: this.price,
    };
  }

  static Option deserialize(Map<String, dynamic>? doc, String docId) {
    print(doc);
    Option option = Option();
    option.id =  docId;
    option.storeId = doc?[STORE_ID] ?? '';
    option.name = doc?[NAME] ?? 'Unknown';
    option.description = doc?[DESCRIPTION] ?? '';
    option.price = doc?[PRICE] ?? 0.0;
    return option;
  }
}