import xml.etree.ElementTree as ET
import rapidjson

def as_int(x):
	try:
		return int(x)
	except:
		return None

def as_bool(x):
	x = str(x).lower()
	if x == 'true':
		return True
	elif x == 'false':
		return False
	return None

def autoresult(val):
	rets = [as_int(val), as_bool(val), str(val)]
	for r in rets:
		if r != None:
			return r
	return None

def gen_node(elem):
	node = {}
	for key, val in elem.attrib.items():
		node[key] = autoresult(val)

	# recursively generate a new node as long as the current element has children
	if list(elem):
		for child in elem:
			if not node.get(child.tag):
				node[child.tag] = []
			node[child.tag].append(gen_node(child))

	return node

def convert_file(xml_loc):
	json = []
	tree = ET.parse(xml_loc)
	root = tree.getroot()

	for elem in root:
		json.append(gen_node(elem))

	with open(xml_loc[:xml_loc.find('.')] + '.json', 'w') as f:
		f.write(rapidjson.dumps(json, indent=4))

if __name__ == "__main__":
	convert_file('data/items/items.xml')