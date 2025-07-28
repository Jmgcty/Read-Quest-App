enum RouteNames {
  root(path: '/'),
  login(path: '/login'),
  signup(path: '/signup'),
  home(path: '/home'),
  membership(path: '/membership'),
  dashboard(path: '/dashboard'),
  book(path: '/book'),
  profile(path: '/profile'),
  modules(path: '/modules'),
  addModule(path: '/add-module'),
  readModule(path: '/read-module/:title/:file'),
  readBook(path: '/read-book/:title/:file');

  final String path;

  const RouteNames({required this.path});
}
