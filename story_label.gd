extends RichTextLabel

var TwineScript = preload("res://modules/twine-story/twine_script.gd")

export(String, FILE, "*.json") var scriptPath = "res://story/intro.json"

var script
var currentPassage = 0
var currentParagraph = 0

func _ready():
	script = TwineScript.new(scriptPath)
	script.parse()
	currentPassage = script.get_start_node()
	show_paragraph(currentPassage, currentParagraph)

	set_process_input(true)
	print("Story: ", script.get_story_name())
	print("Passage names: ", script.get_passage_names())

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		currentParagraph += 1
		if(!show_paragraph(currentPassage, currentParagraph)):
			currentParagraph -= 1

func show_paragraph(pid, paragraph):
	var passage
	if(script.has_passage(pid)):
		passage = script.get_passage(pid)
	else:
		passage = script.get_passage(1)

	if(paragraph < passage.paragraphs.size()):
		set_bbcode(passage.paragraphs[paragraph])
		return true
	else:
		return false

func _on_story_meta_clicked(meta):
	print("Link clicked: ", meta)
	var sectionId = int(meta.split('_')[1])
	currentPassage = sectionId
	currentParagraph = 0
	show_paragraph(currentPassage, currentParagraph)