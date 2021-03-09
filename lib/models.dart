class Person {
  final String name;
  final String from;
  final String pic;
  final String work;
  final String numOfFollowers;
  final String numOfPosts;
  final String numOfFollowing;

  const Person({
    this.name,
    this.from,
    this.pic,
    this.work,
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
      pic: 'assets/1.jpeg',
      work: "Photoreporter at 'Le Monde', blogger and freelance journalist",
      numOfFollowers: '2.8k',
      numOfPosts: '346',
      numOfFollowing: '845',
    ),
    Person(
      name: 'Loren Turner',
      from: 'France, Villeurbanne',
      pic: 'assets/2.jpeg',
      work: "Photoreporter at 'Le Monde', blogger and freelance journalist",
      numOfFollowers: '1.5k',
      numOfPosts: '86',
      numOfFollowing: '352',
    ),
    Person(
      name: 'Lori Perez',
      from: 'France, Nantes',
      pic: 'assets/3.jpeg',
      work: "Photoreporter at 'Le Monde', blogger and freelance journalist",
      numOfFollowers: '869',
      numOfPosts: '135',
      numOfFollowing: '485',
    ),
  ];
}
