class Person {
  final String name;
  final String from;
  final String pic;
  final String numOfFollowers;
  final String numOfPosts;
  final String numOfFollowing;

  const Person({
    this.name,
    this.from,
    this.pic,
    this.numOfFollowers,
    this.numOfPosts,
    this.numOfFollowing,
  });
}

List<Person> people() {
  return [
    Person(
      name: 'Christine Wallace',
      from: 'France, Perpignan',
      pic: 'assets/caique-silva.jpg',
      numOfFollowers: '2.8k',
      numOfPosts: '346',
      numOfFollowing: '845',
    ),
    Person(
      name: 'Loren Turner',
      from: 'France, Villeurbanne',
      pic: 'assets/caique-silva.jpg',
      numOfFollowers: '1.5k',
      numOfPosts: '86',
      numOfFollowing: '352',
    ),
    Person(
      name: 'Lori Perez',
      from: 'France, Nantes',
      pic: 'assets/caique-silva.jpg',
      numOfFollowers: '869',
      numOfPosts: '135',
      numOfFollowing: '485',
    ),
  ];
}
