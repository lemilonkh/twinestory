extends Object

var passages = {}
var data = {}
var scriptPath

func _init(jsonPath):
	scriptPath = jsonPath

func parse():
	data = load_json(scriptPath)
	
	var newPassage
	
	for passage in data["passages"]:
		newPassage = passage
		newPassage.pid = passage.pid
		
		var links = {}
		
		while(passage.links.size() > 0):
			var link = passage.links.front()
			passage.links.pop_front()
			
			links[link.id] = {
				label = link.label,
				passageId = link.passageId
			}

		newPassage.text = parse_text(passage.text, links)
		newPassage.paragraphs = parse_paragraphs(newPassage.text)
		newPassage.links = links
		passages[int(passage.pid)] = newPassage

func load_json(json_path):
	var data = {}
	var jsonFile = File.new()
	jsonFile.open(json_path, jsonFile.READ)
	
	if(jsonFile.get_error()):
		print("Error while reading: ", json_path)
		return data
	
	var text = jsonFile.get_as_text()
	data.parse_json(text)
	jsonFile.close()
	return data

func parse_text(text, links):
	var result = text
	result = parse_links(result, links)
	return result

func parse_links(text, links):
	var linkRegex = "<\\%= links\\['([0-9a-f]*)'\\] \\%>"
	var startStr = "<%= links['"
	var endStr = "'] %>"
	var reg = RegEx.new()
	reg.compile(linkRegex)
	
	if(!reg.is_valid()):
		print("Invalid regex: ", linkRegex)
		return
	
	var match = reg.search(text)
	
	# no links found
	if(match == null):
		return text
	
	while(match && match.get_start() >= 0):
		var linkId = match.get_group_array()[0] # TODO capture 0?
		var linkText
		var linkPid
		if(links.has(linkId)):
			linkText = links[linkId].label
			linkPid = links[linkId].passageId
		else:
			linkText = "Link not found: " + linkId
			linkPid = 1

		var newLink = "[url=section_%s]%s[/url]" % [str(linkPid), linkText]
		text = text.replace(startStr+linkId+endStr, newLink)
		#text = reg.sub(text, newLink, true)
		
		match = reg.search(text)
	
	return text

func parse_paragraphs(text):
	var paragraphs = text.split("\n\n")
	var tagRegex = RegEx.new()
	tagRegex.compile("\\[(a-zA-Z0-9)\\]")
	
	var result = []
	
	for para in paragraphs:
		var lines = para.split("\n")
		var match = tagRegex.search(lines[0])
		
		# if this is a tag, remove tag from text
		if(match != null):
			var tagName = match.get_string()
			result.append({"text": lines.slice(1), "type": tagName})
		else:
			result.append({"text": para, "type": "text"})
	
	return paragraphs

func get_story_name():
	return data["name"]

func get_passages():
	return passages

func get_passage_names():
	var passageNames = []
	for pid in passages:
		var passage = passages[pid]
		if(passage.has("name")):
			passageNames.append(passage["name"])
		else:
			passageNames.append("Name not found!")
	return passageNames

func get_passage(pid):
	if(passages.has(pid)):
		return passages[pid]
	else:
		return {"text": "Error: Passage #"+str(pid)+" not found"}

func has_passage(pid):
	return passages.has(pid)

func get_start_node():
	return data["startNode"]