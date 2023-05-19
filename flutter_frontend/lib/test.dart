void main() {
  List list1 = [1, 2, 3];
  List list2 = list1;

  list1.clear();
  list1.add(4);
  print(list1);
  print(list2);
}


