=========
Changelog
=========

  displaying dotted underlines. This was unintentional and explicit styling has
  been added to remove them. Credit to Steven Loria.
  </customization>` to break up the now rather long list of "variables and
  lists, to make it a bit easier to find docs for a specific setting.
  badge/url option (visually powered by https://shields.io/) as well as a
  service-specific donation option for `OpenCollective
  <https://opencollective.com>`_.

  We expect this to be followed-up on later with more service-specific options
  for services like Patreon. Thanks to Melanie Crutchfield for the report and
  Steven Loria for the initial patch.
  component, since the actual service has been insolvent since 2017. The
  configuration options remain in place for the time being (to avoid breaking
  backwards compatibility) but no longer do anything. Thanks to Joe Alcorn for
  the report / original patchset.

  .. note::
    See the changelog entry for ``#132``, which re-introduces a more generic
    donation sidebar framework.

  (default is ``None``/unset) adds a small text snippet to the
  ``donate.html`` sidebar component, linking to the given URL string. Thanks
  to Steven Loria for the patch.
  specified ``Deja Vu Sans Mono`` instead of ``DejaVu Sans Mono``. This would
  primarily impact systems lacking the first two fonts (``Consolas`` and
  ``Menlo``) such as Linux desktops. Thanks to Ilya Trukhanov for catch &
  patch.

  - Remove the outright broken Goudy Old Style, plus other mostly Adobe-only
    fonts, from the ``font_family`` config setting; it is now simply ``Georgia,
    serif`` which is what the majority of users were rendering anyways.
  - Clear out the default value of ``head_font_family`` (which contained
    ``Garamond``, a nice but also Adobe only font)
  - Set ``head_font_family`` so it falls back to the value of ``font_family``
    unless a user has explicitly set it themselves.

  .. note::
    You can always go back to the old values by :ref:`explicitly setting
    <theme-options>` ``font_family`` and/or ``head_font_family`` in your
    ``conf.py``'s ``html_theme_options``, e.g.::

        html_theme_options = {
            'description': 'My awesome project',
            'font_family': "goudy old style, minion pro, bell mt, Georgia, Hiragino Mincho Pro, serif",
        }

  .. warning::
    Depending on individual viewers' systems, this change *may* be **visually**
    backwards incompatible if you were not already overriding the font
    settings and those users had the fonts in question (which are not default
    on most systems).

    As seen in the note above, you can **always** override the new defaults to
    go back to the old behavior, using your config file.

- #51 (via #67): Hide Github button if ``github_user`` and ``github_repo``
  aren't set. This is necessary since ``github_button`` defaults to True.
  Thanks to Sam Whited for the report & Dmitry Shachnev for the patch.
- #75: Use SVG version of the Travis-CI button. Thanks to Sebastian Wiesner for
  the patch.
- #41: Update the Github buttons to use a newer linked image & change the link
  to their docs. Thanks to Tomi Hukkalainen.
- #45 (via #46) Tweak styling of nested bullet lists to prevent an issue where
  they all collapse to the same indent level when viewed on smaller display
  sizes. Thanks to Bram Geron for catch & patch, and to Jochen Kupperschmidt
  for review/discussion.
- #44 (partial; via #57) Add an opt-in fixed sidebar behavior for users who
  prefer a sidebar that never scrolls out of view. Credit: Joe Cross.
- #61: Set a small-but-nonzero footnote width to work around a common browser
  display bug. Thanks to Konstantin Molchanov for catch & patch.
- #64: Add config options for font size and caption font size/family. Credit:
  Marçal Solà.
  actual template-related changes will be merged afterwards.)
- #65: Wrap the sidebar's "Navigation" header in Sphinx's translation helper so
  it gets translated if possible. Thanks to ``@uralbash``.
- #77: Fix image link styling to remove a bottom border which appears in some
  situations. Thanks to Eric Holscher for the patch & ``@barbara-sfx`` for the
  report.
- Add some ``margin-bottom`` to ``table.field-list p`` so field lists (e.g.
  Python function parameter lists in docstrings) written as multiple
  paragraphs, look like actual paragraphs instead of all globbing together.
- Fix incorrect notes in README re: renamed ``github_button_*`` options - the
  ``button_`` was dropped but docs did not reflect this. Thanks to Nik Nyby.
- Fix ``sidebar_hr`` setting - stylesheet wasn't correctly referencing the
  right variable name. Thanks to Jannis Leidel.
- Allow configuring body text-align via ``body_text_align``. Credit to Marçal
  Solà.
- Fix a handful of mismatched/unclosed HTML tags in the templates. Thanks to
  Marvin Pinto for catch & patch.
- Update how ``setup.py`` handles the ``README.rst`` file - load it explicitly
  as UTF-8 so the changelog containing non-ASCII characters doesn't generate
  ``UnicodeDecodeError`` in terminal environments whose default encoding is not
  UTF-8 or other Unicode-compatible encodings. Thanks to Arun Persaud for the
  report and Max Tepkeev for the suggested fix.
- Fix left-margin & padding styling for code blocks within list-item elements,
  making them consistent with earlier changes applied to top-level code blocks.
- Expose page & sidebar widths as theme options ``page_width`` and
  ``sidebar_width``. Their defaults are the same as the previously static
  values.
- Honor Sphinx's core ``html_show_copyright`` option when rendering page
  footer. Thanks to Marcin Wojdyr for the report.
- Pre-history versions of Alabaster attempted to remove the "related"
  sub-navigation (typically found as next/previous links in other themes) but
  this didn't work right for mobile-oriented styling.

  This has been fixed by (re-)adding an improved sidebar nav element for these
  links and making its display controllable via the new ``show_related`` theme
  option (which defaults to ``false`` for backwards compatibility).

  .. note::
    To enable the related-links nav, you'll need to set ``show_related`` to
    ``true`` **and** add ``relations.html`` to your ``html_sidebars`` (we've
    updated the example config in this README to indicate this for new
    installs).

  Thanks to Tomi Pieviläinen for the bug report.
- Update the "Fork me on Github" banner image to use an ``https://`` URI so
  sites hosted over HTTPS don't encounter mixed-content errors. Thanks to
  ``@nikolas`` for the patch.
- Remove an orphaned ``</li>`` from the footer 'show source' section. Credit to
  Marcin Wojdyr.
- Add ``code_highlight`` option (which includes general fixes to styling of
  code blocks containing highlighted lines). Thanks to Steven Loria.
- Hide ``shadow`` related styles on bibliography elements, in addition to the
  earlier change re: ``border``. Thanks again to Philippe Dessus.
- Updated CSS stylesheets to apply monospace styling to both ``tt`` and
  ``code`` elements, instead of just to ``tt``. This addresses a change in HTML
  Eric Holscher for the heads up.
- Finally add a changelog. To the README, for now, because a full doc site
  isn't worthwhile just yet.
- Allow configuring a custom Github banner image (instead of simply toggling a
  default on or off). Thanks to Nicola Iarocci for the original patch.
- Update Github button image link to use the newly-available HTTPS version of
  the URL; this helps prevent errors on doc pages served via HTTPS. Thanks to
  Gustavo Narea for the report.
- Add control over the font size & family of code blocks. Credit to Steven
  Loria.
- Allow control over font family of body text and headings. Thanks to Georg
  Brandl.
- Stylize ``.. seealso::`` blocks same as ``.. note::`` blocks for
  consistency's sake (previously, ``.. seealso::`` used the Sphinx default
  styling, which clashed). We may update these again later but for now, this is
  an improvement! Thanks again to Steven Loria.
- Allow control over CSS ``font-style`` for the site description/tagline
  element. Credit: Steven Loria.
- Add styling to disable default cell borders on ``.. bibliography::``
  directives' output. Thanks to Philippe Dessus for the report.
- Make ``.. warn::`` blocks have a pink background (instead of having no
  background, which was apparently an oversight of the themes Alabaster is
  based on) and also make that color configurable.
- Allow hiding the 'powered by' section of the footer.
- Fix outdated name in ``setup.py`` URL field.
- Fix an inaccuracy in the description of ``logo_text_align``.
- Update logo & text styling to be more sensible.
- Improved Python 3 compatibility.
  <https://github.com/bitprophet/releases>`_.
- Display Alabaster version in footers alongside Sphinx version (necessitating
  use of a mini Sphinx extension) plus other footer tweaks.
- Allow control of logo replacement text's alignment.
- Add customized navigation sidebar element.
- Tweak page margins a bit.
- Add a 3rd level of medium-gray to the stylesheet & apply in a few places.
- First tagged/PyPI'd version.
