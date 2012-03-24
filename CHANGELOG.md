0.1.10

* Fix issue with sanitizer not allowing relationships to be set when mass
  assignment security is not specified.
* Added unit tests specific to the above issue.

0.1.9

* Remove broken code accidentally included during testing.

0.1.8

* Fix bug where rake commands cannot be run if `inherits_from` or
  `acts_as_superclass` have been called within an ActiveRecord model and the
  model's tables do not already exist.
* Update order of loading test to ensure models can be loaded before tables
  exist.

0.1.7

* Fix bug caused by extraneous super call in sanitizer class.

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
