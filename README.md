[![Total alerts](https://img.shields.io/lgtm/alerts/g/cianmce/sample.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/cianmce/sample/alerts/)

[![Language grade: JavaScript](https://img.shields.io/lgtm/grade/javascript/g/cianmce/sample.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/cianmce/sample/context:javascript)

# Ruby on Rails Tutorial sample application

This is the sample application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

## License

All source code in the [Ruby on Rails Tutorial](http://railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```
