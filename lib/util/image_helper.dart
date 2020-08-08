class ImageHelper {
  static String image(String path) {
    assert(path != null);
    List<String> list = path.split('_');

    if (list == null || list.isEmpty) {
      return 'assets/images/' + path;
    }

    switch (list[0]) {
      case 'bg':
        return 'assets/images/background/' + path;
        break;
      case 'btn':
        return 'assets/images/button/' + path;
        break;
      case 'icon':
        return 'assets/images/icon/' + path;
        break;
      case 'launch':
        return 'assets/images/launch/' + path;
        break;
      case 'switch':
        return 'assets/images/switch/' + path;
        break;
      case 'logo':
        return 'assets/images/logo/' + path;
        break;
      default:
        return 'images/' + path;
    }
  }

  static List<String> bodys = List.generate(20, (index) => 'people_body_$index.png');
  static List<String> eyes = List.generate(20, (index) => 'people_eye_$index.png');
  static List<String> foots = List.generate(20, (index) => 'people_foot_$index.png');
  static List<String> hairs = List.generate(20, (index) => 'people_hair_$index.png');
  static List<String> hands = List.generate(10, (index) => 'people_hand_$index.png');
  static List<String> noses = List.generate(3, (index) => 'people_nose_$index.png');
}
