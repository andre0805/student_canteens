class HR_Comparator {
  const HR_Comparator();

  static int compare(String a, String b) {
    String city1 = a
        .toLowerCase()
        .replaceAll('č', 'c~')
        .replaceAll('ć', 'c~~')
        .replaceAll('đ', 'd~')
        .replaceAll('š', 's~')
        .replaceAll('ž', 'z~')
        .replaceAll("\"", "");

    String city2 = b
        .toLowerCase()
        .replaceAll('č', 'c~')
        .replaceAll('ć', 'c~~')
        .replaceAll('đ', 'd~')
        .replaceAll('š', 's~')
        .replaceAll('ž', 'z~')
        .replaceAll("\"", "");

    return city1.compareTo(city2);
  }
}
