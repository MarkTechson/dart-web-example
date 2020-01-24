import 'dart:convert';
import 'dart:html';

void main() {
  final app = MovieApp();
  app.start();
}

class MovieApp {
  MovieApp();

  void _handleClick(MouseEvent event) {
    event.preventDefault();
    var input = querySelector('input') as InputElement;
    var _movieSearchText = input.value;

    if (_movieSearchText?.isEmpty == false) {
      var path =
          'http://www.omdbapi.com/?apiKey=e93eeb78&t=${_movieSearchText}';

      final httpRequest = HttpRequest();
      httpRequest
        ..open('GET', path)
        ..onLoadEnd.listen((e) => _requestComplete(httpRequest))
        ..send('');
    }
  }

  void _requestComplete(HttpRequest request) {
    switch (request.status) {
      case 200:
        _processResponse(request.responseText);
        return;
      default:
        print('Error');
    }
  }

  void _processResponse(String json) {
    var data = jsonDecode(json);
    if (data["Response"] == "True") {
      _displayMovie(
        data['Title'],
        data['Year'],
        data['Plot'],
      );
    } else {
      _displayMovie(
        "Movie not found",
        "",
        "The movie that you are looking for isn't available. Try something else",
      );
    }
  }

  void _displayMovie(String title, String year, String plot) {
    querySelector(".movie-info > h1").text = title;
    querySelector(".movie-info > h2").text = year;
    querySelector(".movie-info > h3").text = plot;
  }

  void start() {
    querySelector('.submit-search').onClick.listen(_handleClick);
  }

  render() {
    querySelector('#items').text = 'Your Dart app is running.';
  }
}
