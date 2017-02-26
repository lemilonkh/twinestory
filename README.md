# TwineStory
A module for the [Godot Engine](http://godotengine.org) for parsing [Twine](http://twinery.org) stories (exported to JSON via [twine_to_json](https://www.npmjs.com/package/twine_to_json)).

This leverages Twine as a story editor for Godot projects.  
You could also use it as a dialog system (example scene will be provided at a later date).  
More complex scripting (global variables, conditional text, text generation via [TraceryCpp](https://www.npmjs.com/package/twine_to_json) is coming (when that library and the corresponding Godot wrapper is ready)!

## Installation
1. Clone this repository
2. Put it into your Godot project (in folder "modules/twine-story")
3. Create a RichTextField in your scene
4. Attach the script `story_label.gd` to your RichTextField
5. If you haven't already, change your Twine 2 Story format to Snowman
6. Export to HTML, then use `twinetojson` to make JSON out of it (don't parse markdown using the `-m` flag):
   `twinetojson -i story_snowman.html -o story.json -p -m`
7. Change the script path in the Inspector to your Twine JSON file
8. ???
9. Profit
