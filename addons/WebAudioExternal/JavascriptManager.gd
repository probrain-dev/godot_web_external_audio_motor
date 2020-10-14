extends Node
class_name JavascriptManage

func init(compile_files_js):
	for _file in compile_files_js:
		JavaScript.eval(loadFile(_file),true)


func loadFile(_file):
	var file = File.new()
	file.open(_file, file.READ)
	var content = file.get_as_text()
	file.close()
	return content


func _js_property_call(_object,properties):
	var prop = ""
	if properties.size()>0:
		for p in properties:
			if prop == "":
				prop = "."+str(p);
			else:
				prop = prop +"['"+str(p)+"']"
	
	return _run(_object+prop)

func _js_method_call(_object,_method,_arg=[]):
	var args = _args_to_js(_arg)
	
	var ret = _run(_object+"['"+_method+"']("+args+")")
	return ret

func _args_to_js(_arg):
	var args = ""
	if _arg.size()>0:
		for a in _arg:
			var tmp_new_var = a
			if typeof(tmp_new_var) == TYPE_INT:
				tmp_new_var = (tmp_new_var)
			elif typeof(tmp_new_var) == TYPE_BOOL:
				if tmp_new_var:
					tmp_new_var = "true"
				else:
					tmp_new_var = "false"
				
			elif typeof(tmp_new_var) == TYPE_REAL:
				tmp_new_var = (tmp_new_var)
				if tmp_new_var == 0:
					tmp_new_var = "0"
			elif typeof(tmp_new_var) == TYPE_STRING:
				tmp_new_var = "'"+tmp_new_var+"'"
				
			elif typeof(tmp_new_var) == TYPE_DICTIONARY:
				var _new_object = "{";
				var keys = tmp_new_var.keys();
				if keys.size()>0:
					var last_key = tmp_new_var.keys()[-1]
					for key in tmp_new_var:
						_new_object =_new_object+ "'"+key+"'"
						var _txt = _args_to_js([tmp_new_var[key]])
						_new_object =_new_object+ ":"+_txt
						if last_key != key:
							_new_object = _new_object+","
					
				_new_object = _new_object+"}"
				tmp_new_var = _new_object
				
			elif typeof(tmp_new_var) == TYPE_ARRAY:
				tmp_new_var = "["+_args_to_js(tmp_new_var)+"]"
				
			if args == "":
				args = str(tmp_new_var)
			else:
				args = args +","+str(tmp_new_var)
	return args;


func _run(string):
	return JavaScript.eval(string,true)
