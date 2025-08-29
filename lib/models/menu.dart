
class Menu {
  String menuId;
  String categoryId;
  String display;

  Menu(this.menuId, this.categoryId, this.display);

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      json['menuId'],
      json['categoryId'],
      json['display'],
    );
  }
}