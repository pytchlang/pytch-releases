Changelog
=========

This page outlines what's changed as we've released new versions of
Pytch.


v0.0.13 (2021-05-15)
--------------------

* Add ``ask_and_wait_for_answer()`` syscall, and corresponding method
  on ``Sprite`` and ``Stage``.
* Minor improvements to developer docs and scripts.
* Enable search (Ctrl-F) and search/replace (Ctrl-H) in code editor.
* Minor bugfix: Make ``say_for_seconds()`` only cancel its own speech.


v0.0.12 (2021-04-03)
--------------------

* Allow user to create a project by uploading a previously-downloaded
  zipfile.


v0.0.11 (2021-03-16)
--------------------

* Provide immediate feedback when creating demo from Featured Project.


v0.0.10 (2021-03-16)
--------------------

* Add ability to launch *demo* of tutorial, which creates a project
  with code as of the completed tutorial, and not connected to that
  tutorial.
* Add a two-stop tour of the buttons required to build and green-flag
  a project.  Enabled when first creating a project as a demo of a
  tutorial.
* Re-organise front page with "Featured projects", and information
  about how to use Pytch.
* Add instructions (as code comment) to the three tutorials included
  as featured projects.


v0.0.9 (2021-03-03)
-------------------

* Bugfix: With the stage at a non-default size (as happens when the
  user drags the divider), the location of a mouse click was computed
  incorrectly, leading to wrong ``when_this_sprite_clicked``
  behaviour.  Click coordinates are now computed correctly.


v0.0.8 (2021-02-26)
-------------------

* Show richer auto-complete information in code editor.
* Update to new Skulpt.
* Add support for Safari browser.
* (Internal developer-experience fixes.)


v0.0.7 (2021-02-16)
-------------------

* (Internal build system improvements.)
* Add documentation outlining how to get started with Pytch
  development.


v0.0.6 (2021-01-20)
-------------------

* (Internal build system improvements.)
* Add new costume/backdrop methods/properties to auto-completion list.


v0.0.5 (2021-01-12)
-------------------

* Allow user to vertically drag the horizontal separator between (code
  and stage) and info-pane.  If user's screen is vertically short,
  this lets them see more of the tutorial.  (Thanks to Eoin Condron
  for report.)


v0.0.4 (2021-01-08)
-------------------

* Add methods ``Sprite.next_costume()`` and ``Stage.next_backdrop()``.
* Extend methods ``Sprite.switch_costume()`` and
  ``Stage.switch_backdrop()`` to accept a zero-based integer for
  the costume or backdrop to switch to, as an alternative to the
  existing string name.
* Add attributes ``Sprite.costume_number``, ``Sprite.costume_name``,
  ``Stage.backdrop_number``, and ``Stage.backdrop_name``.


v0.0.1–v0.0.3
-------------

Initial experimental releases.
