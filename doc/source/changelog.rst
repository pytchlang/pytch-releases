Changelog
=========

This page outlines what's changed as we've released new versions of
Pytch.


v0.0.36 (2022-MM-DD)
--------------------

* Update developer set-up documentation.


v0.0.35 (2022-09-29)
--------------------

* Divide help sidebar into collapsible sections.


v0.0.34 (2022-09-15)
--------------------

* When copying code from a "Change your code like this" section of a
  tutorial, convert ``"·"`` characters back into spaces.
* Add support for controlling the volume of sounds played by sprites
  or the stage.
* Add *Multiple choice quiz* tutorial.


v0.0.33 (2022-08-19)
--------------------

* Fix bug whereby attempting to use an unsupported sound asset made
  app hang.
* Give more useful error if user's Stage has no ``Backdrops``.
* Fix bug whereby rapidly deleting and creating clones could sometimes
  lead to an unhelpful error.  (Thanks to Olus Education student Leo
  Mirolo for the report.)
* Detect very-long-running ``while`` or ``for`` loops when importing
  user's code and raise an error.
* Minor updates to user-level documentation.
* Update to current upstream Skulpt.
* Fix inconsistent reporting and go-to-location behaviour for errors.


v0.0.32 (2022-07-18)
--------------------

* Fix minor bug whereby undo history in editor contains "loading"
  text.
* Disable "overwrite" mode in code editor.


v0.0.31 (2022-07-12)
--------------------

* Add ability to make a copy of a project.
* Fix bug whereby attempting to add a corrupt image asset made app
  hang.


v0.0.30 (2022-06-16)
--------------------

* Make messages for syntax errors more helpful, by means of Tiger
  Python.
* Simplify the *Catch the apple* tutorial.
* Exit full-screen mode if an error occurs.


v0.0.29 (2022-06-03)
--------------------

* Fix bug whereby specifying ``Sounds`` as a non-list crashed app.
* Allow tutorial authors to include Scratchblocks code.  (Thanks to
  Justine Moulin for contributing this work.)


v0.0.28 (2022-05-19)
--------------------

* Add "blue invaders" tutorial.
* Improve organisation of some tutorials.


v0.0.27 (2022-05-16)
--------------------

* Add challenges to "hello world" tutorial.
* Add difficulty tags to tutorial summary cards.  (Thanks to Justine
  Moulin for contributing this work.)
* Add ability to create "bare-bones" project (with no example code).
* Provide default name when creating a new project.


v0.0.26 (2022-03-12)
--------------------

* Add icons to green-flag and red-stop buttons.
* Add ability to select multiple projects and then delete them all at
  once.


v0.0.25 (2022-03-04)
--------------------

* Add "shoot the fruit" tutorial.


v0.0.24 (2022-02-28)
--------------------

* Add full-screen layout.
* Improve presentation of "Change your code like this" sections in
  tutorials.  Add pop-up help panel explaining how changes are shown.
* Expand documentation on development set-up; improve checks in
  script.  Make development scripts more robust and portable.  Improve
  developer docs.  Update various dependencies.
* Give better error messages (trying to set a sprite's ``direction``;
  giving ``say_for_seconds()`` a non-numeric duration argument; giving
  ``say()`` a non-string, non-numeric content argument).
* Add ``pytch.stop_all()`` function.
* Replace "MyStuff" with "home" button in IDE.
* Make browser window title contain more useful information.
* Fix minor bug allowing deleted assets to still be used.
* Add "catch the apple" tutorial.


v0.0.23 (2021-09-15)
--------------------

* Bring Bunner tutorial up-to-date for ``Sprite.direction`` property.


v0.0.22 (2021-09-14)
--------------------

* Fix race-condition bug in ``qbert`` tutorial.
* Experimental: Allow easing functions in ``Sprite.glide_to_xy()``.
* Add ability to rename a project.
* Add ability to upload multiple project zipfiles at once.
* Show version tag in navigation banner.


v0.0.21 (2021-09-08)
--------------------

* Minor wording changes in text content of site.
* Add ``Sprite.size`` property.
* Experimental: Add mechanism for suggesting a demo.


v0.0.20 (2021-09-03)
--------------------

* Support rotation of Sprites.  (Touch- and click-detection is not yet
  aware of rotation and so will be inaccurate for rotated Sprites.)


v0.0.19 (2021-08-26)
--------------------

* Allow adding more than one asset (graphic / sound file) at once.
  Forbid adding unknown asset types.
* **Remove BUILD button** — the green flag now builds then sends
  green-flag event.  Update tutorials accordingly.
* Allow building by keyboard command from editor (``Ctrl-Enter`` and
  ``Ctrl-Shift-Enter``).
* Bugfixes: Multi-hunk patches in tutorials were not displayed
  correctly.  Tooltip was not positioned correctly when changing IDE
  layout.


v0.0.18 (2021-07-27)
--------------------

* Update language acknowledging origin of ticket vending machine
  tutorial.


v0.0.17 (2021-07-22)
--------------------

* Provide more helpful errors if certain Pytch functions (e.g.,
  ``pytch.wait_seconds()``) are called at top-level of user's program.
* Add URL route to suggest a particular tutorial.
* Update front page content.
* Show full tracebacks for build errors.
* Include "show/hide variable" in help sidebar.
* Support images in tutorial content.
* Show friendlier error page for unknown route.
* Add *Ticket Vending Machine* tutorial.


v0.0.16 (2021-07-07)
--------------------

* **Breaking:** Rename some Sprite and Stage methods to be closer to
  Scratch conventions.

  * The method ``self.get_x()`` has been replaced by the property
    ``self.x_position``.
  * The method ``self.get_y()`` has been replaced by the property
    ``self.y_position``.
  * The function ``pytch.key_is_pressed()`` has been renamed to
    ``pytch.key_pressed()``.
  * The method ``self.move_to_front_layer()`` has been renamed to
    ``self.go_to_front_layer()``.
  * The method ``self.move_to_back_layer()`` has been renamed to
    ``self.go_to_back_layer()``.
  * The method ``self.move_forward_layers()`` has been renamed to
    ``self.go_forward_layers()``.
  * The method ``self.move_backward_layers()`` has been renamed to
    ``self.go_backward_layers()``.
  * The method ``self.ask_and_wait_for_answer()`` has been renamed to
    ``self.ask_and_wait()``.

* **Breaking:** Remove the method ``self.say_nothing()``.  To remove a
  Sprite's speech bubble, use ``self.say("")`` instead.

* Update documentation and tutorials to reflect above changes.

* Improve and extend documentation.

* Experimental: Add variable watchers — ``pytch.show_variable(obj,
  attr_name)``.

* Add a help sidebar to the IDE, summarising available Pytch methods
  and functions, with examples and Scratch equivalents.


v0.0.15 (2021-06-04)
--------------------

* Update *Bunner* tutorial.
* Fix minor layout, documentation, and developer-script problems.


v0.0.14 (2021-05-21)
--------------------

* Improve developer docs and scripts.
* Update Welcome page.


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
