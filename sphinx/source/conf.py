from datetime import datetime


extensions = []
templates_path = ["_templates"]
source_suffix = ".rst"
master_doc = "index"

project = u"VideoSR"
year = datetime.now().year
copyright = u"%d WeiLi fdu" % year

exclude_patterns = ["_build"]

html_theme = "alabaster"
html_sidebars = {
    "**": [
        "about.html",
        "navigation.html",
        "relations.html",
        "searchbox.html",
        "donate.html",
    ]
}
html_theme_options = {
    "description": "Some model of video sr implemented by tensorflow",
    "github_user": "liweifdu",
    "github_repo": "VideoSR",
    "fixed_sidebar": True,
#"tidelift_url": "https://tidelift.com/subscription/pkg/pypi-alabaster?utm_source=pypi-alabaster&utm_medium=referral&utm_campaign=docs",  # noqa
}

