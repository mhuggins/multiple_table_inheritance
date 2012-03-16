0.1.6

* Fix issue with mass assignment sanitizer classes not being loaded
  consistently across different versions of Rails 3.

0.1.5

* Fix issue with LoggerSanitizer not being defined in Rails projects.

0.1.4

* Fixed mass assignment when security is only defined in child model.
* Added support for namespaced models.
* Added many more unit tests.

0.1.3

* Fixed a bug that prevented migrations from being run properly.
* Added several unit tests.

0.1.2

* Fixed a bug that resulted in parent record not being accessible after
  performing a find directly on the child model.
* Added many more unit tests.

0.1.1

* Fixed bidirectional deletion of records.
* Implemented find_by_id for classes and instances that inherit from other
  models.
* Added several unit tests.

0.1.0

* Initial release.
