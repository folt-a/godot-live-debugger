@tool
extends EditorPlugin

#const debug_infomations_json_path = "res://addons/godot-live-debugger/debug_informations.json"
const debug_informations_json_path = "user://debug_informations.json"

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_tool_menu_item("Update Debug Informations", update)

func _save_external_data():
	update()
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_tool_menu_item("Update Debug Informations")

func update():
	var is_ja:bool = EditorInterface.get_editor_settings()\
		.get_setting("interface/editor/editor_language")\
		.contains("ja")
	var is_ko:bool = EditorInterface.get_editor_settings()\
		.get_setting("interface/editor/editor_language")\
		.contains("ko")

	# 使うアイコンをuserdirに投入
	_add_user_dir_icon("MemberMethod")
	_add_user_dir_icon("Callable")
	_add_user_dir_icon("Play")
	_add_user_dir_icon("String")
	_add_user_dir_icon("StringName")
	_add_user_dir_icon("float")
	_add_user_dir_icon("int")
	_add_user_dir_icon("bool")
	_add_user_dir_icon("Array")
	_add_user_dir_icon("Dictionary")
	_add_user_dir_icon("Object")
	_add_user_dir_icon("Vector2")
	_add_user_dir_icon("Vector2i")
	_add_user_dir_icon("Vector3")
	_add_user_dir_icon("Vector3i")
	_add_user_dir_icon("Transform2D")
	_add_user_dir_icon("Transform3D")
	_add_user_dir_icon("NodePath")
	_add_user_dir_icon("Rect2")
	_add_user_dir_icon("Rect2i")
	_add_user_dir_icon("Color")
	
	_add_user_dir_icon("GuiVisibilityVisible")
	_add_user_dir_icon("GuiVisibilityHidden")
	_add_user_dir_icon("Info")


	#バッチ処理で全てのスクリプトを走査する
	#「ツール」から実行する。
	#
	#バッチ内容
	var results:Array[Dictionary] = []
	var script_file_count:int = 0
	#１すべての.gdへget_property_listでNodeのプロパティを取得する。　プロパティなければ終了
	for path in get_all_script_paths():
		if path.contains("godot-live-debugger"):continue
		var script:GDScript = load(path)
		if not script: continue
		var is_script_file_counted:bool = false
		var props:Array[Dictionary] = script.get_script_property_list()
		var funcs:Array[Dictionary] = script.get_script_method_list()
		
		# extendsしているプロパティを追加する。 スクリプトのほうに同名プロパティがあれば追加しない。
		var base_class_name:StringName = script.get_instance_base_type()
		for extends_builtinprop in ClassDB.class_get_property_list(base_class_name):
			#if not props.any(func(d): return d.name == extends_builtinprop.name):
			props.append(extends_builtinprop)
		
		# 画像データをuserフォルダにぶちこんでしまう(許して！)
		if not FileAccess.file_exists("user://".path_join(base_class_name + ".png")):
			var tex:=EditorInterface.get_editor_theme().get_icon(base_class_name,"EditorIcons")
			tex.get_image().save_png("user://".path_join(base_class_name + ".png"))
		
		
		
		#- name is the property's name, as a String;
		#- class_name is an empty StringName, unless the property is TYPE_OBJECT and it inherits from a class;
		#- type is the property's type, as an int (see Variant.Type);
		#- hint is how the property is meant to be edited (see PropertyHint);
		#- hint_string depends on the hint (see PropertyHint);
		#- usage is a combination of PropertyUsageFlags.
		if not props or props.is_empty(): continue
		
		#- name is the name of the method, as a String;
		#- args is an Array of dictionaries representing the arguments;
		#- default_args is the default arguments as an Array of variants;
		#- flags is a combination of MethodFlags;
		#- id is the method's internal identifier int;
		
		#var code:String = FileAccess.get_file_as_string(path)
		var file:FileAccess = FileAccess.open(path, FileAccess.READ)
		var is_matched:bool = false
		var is_call:bool = false
		var debug_info:Dictionary = {}
		var regex = RegEx.new()
		regex.compile(".*var\\s")
		
		var regex_func = RegEx.new()
		regex_func.compile(".*func\\s")

		# ()
		var regex_maru_kakko = RegEx.new()
		regex_maru_kakko.compile("\\(.*\\)")

		# []
		var regex_kaku_kakko = RegEx.new()
		regex_kaku_kakko.compile("\\[.*\\]")
		
		# 「」または“”、''を判定する
		var regex_kaku_jpko_kakko = RegEx.new()
		regex_kaku_jpko_kakko.compile("[“|「|'].*[”|」|']")
		
		# {}を判定する
		var regex_color = RegEx.new()
		regex_color.compile("{.*}")
		
		#２上からlineをくるくるする
		while file.get_position() < file.get_length():
			var sort_index:int = 0
			var line:String = file.get_line()
			
			if is_matched:
				#その下判定　コメント、空行、インデント、空白文字は無視。その下テキストがプロパティ正規にマッチプロパティでなければ終了
				
				# 先頭からの空白を削除
				line = line.lstrip("\t").lstrip(" ")
				if line.length() < 1:continue
				
				# varがあるか判定
				var result = regex.search(line)
				if result:
					#var\sの後ろの文字列を取得
					var var_name:String = line.substr(result.get_end())
					var var_result:String = ""
					
					#var\sの後ろの文字列の最初の:までを取得
					var_result = var_name.substr(0, var_name.find(":")).replace(" ","")
					if var_result == "":
						#var\sの後ろの文字列の最初の空白文字までを取得
						var_name = var_name.substr(0, var_name.find(" "))
					if var_result == "":
						continue
					#print("V(" + var_result + ")V")

					#プロパティ名が一致したら
					if props.any(func(p): return p["name"] == var_result):
						#プロパティ情報を取得
						var prop_info:Dictionary = props.filter(func(p): return p["name"] == var_result)[0]
						debug_info["prop"] = var_result
						debug_info["type"] = prop_info["type"]
						debug_info["usage"] = prop_info["usage"]
						debug_info["node_icon"] = base_class_name
						debug_info["icon"] = _dic_type_icon(int(prop_info["type"]))
						debug_info["sort_index"] = sort_index
						sort_index += 1
						results.append(debug_info)
						is_script_file_counted = true
						is_matched = false
						continue
					else:
						if is_ja:
							printerr("プロパティ名が一致しませんでした。")
							printerr("ファイルパス：" + path)
							printerr("ベースクラス：" + base_class_name)
							printerr("プロパティ名：" + var_result)
						elif is_ko:
							printerr("프로퍼티 이름이 일치하지 않습니다.")
							printerr("파일 경로：" + path)
							printerr("베이스 클래스：" + base_class_name)
							printerr("프로퍼티 이름：" + var_result)
						else:
							printerr("Property name does not match.")
							printerr("File path：" + path)
							printerr("Base class：" + base_class_name)
							printerr("Property name：" + var_result)
					
					is_matched = false
					is_call = false
				
				# funcがあるか判定
				var result_func = regex_func.search(line)
				if result_func:
					#func\sの後ろの文字列を取得
					var func_name:String = line.substr(result_func.get_end())
					var func_result:String = ""
					
					#func\sの後ろの文字列の最初の(までを取得
					func_result = func_name.substr(0, func_name.find("(")).replace(" ","")
					if func_result == "":
						continue
					#プロパティ名が一致したら
					if funcs.any(func(f): return f["name"] == func_result):
						#プロパティ情報を取得
						var func_info:Dictionary = funcs.filter(func(p): return p["name"] == func_result)[0]
						debug_info["func"] = func_result
						#- name is the name of the method, as a String;
						#- args is an Array of dictionaries representing the arguments;
						#- default_args is the default arguments as an Array of variants;
						#- flags is a combination of MethodFlags;
						#- id is the method's internal identifier int;
						debug_info["args"] = func_info["args"]
						debug_info["default_args"] = func_info["default_args"]
						debug_info["flags"] = func_info["flags"]
						debug_info["call"] = is_call
						debug_info["id"] = func_info["id"]
						debug_info["node_icon"] = base_class_name
						debug_info["sort_index"] = sort_index
						sort_index += 1
						results.append(debug_info)
						is_script_file_counted = true
						is_matched = false
						is_call = false
						continue
					else:
						if is_ja:
							printerr("関数名が一致しませんでした。")
							printerr("ファイルパス：" + path)
							printerr("ベースクラス：" + base_class_name)
							printerr("関数名：" + func_result)
						elif is_ko:
							printerr("함수 이름이 일치하지 않습니다.")
							printerr("파일 경로：" + path)
							printerr("베이스 클래스：" + base_class_name)
							printerr("함수 이름：" + func_result)
						else:
							printerr("Function name does not match.")
							printerr("File path：" + path)
							printerr("Base class：" + base_class_name)
							printerr("Function name：" + func_result)
					
					is_matched = false
					is_call = false
			
			if not is_matched:
				#３指定したコメントがあればその下のプロパティをマークする
				#@call
				#@debug(aaa/BBB)
				#@debug[position]
				#@debug[position](aaa/BBB)
				
				# 先頭からの空白を削除
				line = line.lstrip("\t").lstrip(" ")
				
				if line.begins_with("#@debug") or line.begins_with("#@Debug") or line.begins_with("#@DEBUG")\
				or line.begins_with("#@call") or line.begins_with("#@Call") or line.begins_with("#@CALL")\
				:
					is_call = line.begins_with("#@call") or line.begins_with("#@Call") or line.begins_with("#@CALL")
					if is_call:
						line = line.substr(6)
					else:
						line = line.substr(5)
					debug_info = {}
					debug_info["path"] = path
					#print("debug_info ",debug_info)
					
					#()の中を取得する
					var reg_results = regex_maru_kakko.search_all(line)
					#print("regex_maru_kakko ",result)
					if not reg_results.is_empty():
						for result in reg_results:
							var maru_kakko:String = result.get_string().trim_prefix("(").trim_prefix(")")
							
							if maru_kakko == "":continue#空かっこは無視、[func_name()]の関数かっこも無視
							
							#print("M(" + maru_kakko + ")M")
							debug_info["cates"] = maru_kakko.split("/")
					
					#「」か“”の中を取得する
					var result:= regex_kaku_jpko_kakko.search(line)
					if result:
						var kaku_jpko_kakko:String = result.get_string()\
						.trim_prefix("「")\
						.trim_prefix("“")\
						.trim_prefix("'")\
						.trim_suffix("」")\
						.trim_suffix("”")\
						.trim_suffix("'")
						#print("K(" + kaku_jpko_kakko + ")K")
						debug_info["display_name"] = kaku_jpko_kakko
					else:
						debug_info["display_name"] = ""

					#{}の中を取得する
					result = regex_color.search(line)
					if result:
						var color:String = result.get_string().trim_prefix("{").trim_suffix("}")
						#print("C(" + color + ")C")
						debug_info["color"] = color

					#[]の中を取得する
					result = regex_kaku_kakko.search(line)
					if result:
						var kaku_kakko:String = result.get_string().trim_prefix("[").trim_suffix("]")
						
						# : が含まれている場合はNodePath:プロパティと判断する
						if kaku_kakko.contains(":"):
							
							if kaku_kakko.split(":")[1].contains("("):
								# [..node1/node2:func()]
								debug_info["func"] = kaku_kakko.split(":")[1].replace("(","").replace(")","")
								# TODO ARGSもできるといいかもしれませんね、めんどくさ〜 )]で判定できそう
								debug_info["call"] = false
								
								debug_info["node_icon"] = base_class_name
								debug_info["node_path"] = kaku_kakko.split(":")[0]
								debug_info["icon"] = "Info"
								debug_info["type"] = -1
								debug_info["sort_index"] = sort_index
								sort_index += 1
								results.append(debug_info)
								is_script_file_counted = true
							else:
								# [..node1/node2:prop]
								debug_info["prop"] = kaku_kakko.split(":")[1]
								debug_info["node_icon"] = base_class_name
								debug_info["node_path"] = kaku_kakko.split(":")[0]
								debug_info["icon"] = "Info"
								debug_info["type"] = -1
								debug_info["sort_index"] = sort_index
								sort_index += 1
								results.append(debug_info)
								is_script_file_counted = true
							
						elif props.any(func(p): return p["name"] == kaku_kakko):
							#print("K(" + kaku_kakko + ")K")
							#プロパティ情報を取得
							var prop_info:Dictionary = props.filter(func(p): return p["name"] == kaku_kakko)[0]
							debug_info["prop"] = kaku_kakko
							debug_info["type"] = prop_info["type"]
							debug_info["usage"] = prop_info["usage"]
							debug_info["node_icon"] = base_class_name
							debug_info["icon"] = _dic_type_icon(int(prop_info["type"]))
							debug_info["sort_index"] = sort_index
							sort_index += 1
							results.append(debug_info)
							is_script_file_counted = true
						else:
							if is_ja:
								printerr("プロパティ名が一致しませんでした。")
								printerr("ファイルパス：" + path)
								printerr("ベースクラス：" + base_class_name)
								printerr("プロパティ名：" + kaku_kakko)
							elif is_ko:
								printerr("프로퍼티 이름이 일치하지 않습니다.")
								printerr("파일 경로：" + path)
								printerr("베이스 클래스：" + base_class_name)
								printerr("프로퍼티 이름：" + kaku_kakko)
							else:
								printerr("Property name does not match.")
								printerr("File path：" + path)
								printerr("Base class：" + base_class_name)
								printerr("Property name：" + kaku_kakko)
					else:
						
						is_matched = true
		
		if is_script_file_counted:
			script_file_count += 1
		
		file.close()
	
	#４マークしたプロパティ情報をファイルに保存する
	var result_json_file:=FileAccess.open(debug_informations_json_path,FileAccess.WRITE)
	result_json_file.store_string(JSON.stringify(results,"\t",true))
	
	var props_count = results.filter(func(d): return d.has("prop")).size()
	var funcs_count = results.filter(func(d): return d.has("prop")).size()
	
	if is_ja:
		print_rich("[godot-live-debugger][color=LIME_GREEN][b]全てのスクリプト情報を更新しました。対象スクリプトgdの数="+str(script_file_count)+", 対象プロパティの数=" + str(props_count) + ", 対象関数の数=" + str(funcs_count) + "[/b][/color]")
	elif is_ko:
		print_rich("[godot-live-debugger][color=LIME_GREEN][b]모든 스크립트 정보를 업데이트했습니다. 대상 스크립트 gd 수="+str(script_file_count)+", 대상 프로퍼티 수=" + str(props_count) + ", 대상 함수 수=" + str(funcs_count) + "[/b][/color]")
	else:
		print_rich("[godot-live-debugger][color=LIME_GREEN][b]All scripts Informations updated. Debug script gd count="+str(script_file_count)+", Debug property count=" + str(props_count) + ", Debug function count=" + str(funcs_count) + "[/b][/color]")

func _add_user_dir_icon(icon_name:String):
	if not FileAccess.file_exists("user://".path_join(icon_name + ".png")):
		var tex_func:=EditorInterface.get_editor_theme().get_icon(icon_name,"EditorIcons")
		tex_func.get_image().save_png("user://".path_join(icon_name + ".png"))

func _dic_type_icon(type:int) -> String:
	if type == TYPE_STRING:
		return "String"
	if type == TYPE_INT:
		return "int"
	if type == TYPE_FLOAT:
		return "float"
	if type == TYPE_BOOL:
		return "bool"
	if type == TYPE_STRING_NAME:
		return "Stringname"
	if type == TYPE_VECTOR2:
		return "Vector2"
	if type == TYPE_VECTOR2I:
		return "Vector2i"
	if type == TYPE_VECTOR3:
		return "Vector3"
	if type == TYPE_VECTOR3I:
		return "Vector3i"
	if type == TYPE_RECT2:
		return "Rect2"
	if type == TYPE_RECT2I:
		return "Rect2i"
	if type == TYPE_COLOR:
		return "Color"
	if type == TYPE_CALLABLE:
		return "Callable"
	if type == TYPE_NODE_PATH:
		return "NodePath"
	if type == TYPE_OBJECT:
		return "Object"
	if type == TYPE_DICTIONARY:
		return "Dictionary"
	if type == TYPE_ARRAY:
		return "Array"
	if type == TYPE_TRANSFORM2D:
		return "Transform2D"
	if type == TYPE_TRANSFORM3D:
		return "Transform3D"
	
	return "Object"


func get_all_script_paths() -> Array[String]:
	var scripts:Array[String] = []
	var dir_paths:Array[String] = []
	var dir:DirAccess = DirAccess.open("res://")
	if dir.get_open_error() == OK:
		get_dir(dir, scripts, dir_paths)
	
	while not dir_paths.is_empty():
		if dir.change_dir(dir_paths[0]) == OK:
			get_dir(dir, scripts, dir_paths)
		dir_paths.pop_front()
	return scripts


func get_dir(dir: DirAccess, scripts: Array[String], dir_paths: Array[String]) -> void:
	dir.include_navigational = false
	dir.include_hidden = false
	dir.list_dir_begin()
	var file_name : String = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			if file_name == ".import" or file_name == ".mono":
				pass
			else:
				dir_paths.append(dir.get_current_dir().path_join(file_name))
		else:
			if file_name.ends_with(".gd"):
				if dir.get_current_dir() == "res://":
					scripts.append(dir.get_current_dir().path_join(file_name))
				else:
					scripts.append(dir.get_current_dir().path_join(file_name))
		file_name = dir.get_next()
