#01. @tool

#02. class_name

#03. extends
extends Window
#04. # docstring

## デバッグ用ウィンドウノードです。
## ゲーム内に存在している全ての対象スクリプトをもつノードの状態を毎フレーム呼び出します。
## このノードを追加するだけでゲームに存在するノードを監視します。

#region Signal, Enum, Const
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------



#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------



#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------

const debug_informations_json_path = "user://debug_informations.json"
const node_live_debugger_settings_path = "user://node_live_debugger_settings.json"


#endregion
#-----------------------------------------------------------

#region Variable
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

@export var columns:int = 3


#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------



#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _debug_information_lists:Array[Dictionary]

var _debug_path_mapping_dir:Dictionary

# <path:String, nodenames:Array[String]>
var _debug_node_dir:Dictionary = {}

var _target_nodes:Array

# 他のノードプロパティ指定のノードをキャッシュ <n:Node,Dictionary<node_path:StringName,other_node:Node>>
var _target_node_other_nodes:Dictionary = {}

var _root_item:TreeItem

var _is_ja:bool = false

var _is_ko:bool = false

var icon_textures:Dictionary = {}

var _is_focus_pause:bool = false

var _is_auto_focus_pause:bool = false

# setting list
var _debugger_window_position_type:int
var _is_debugger_window_height_adjust_monitor_height:bool
var _debugger_window_position_offset:Vector2i
var _debugger_window_size:Vector2i
var _debugger_window_absolute_position:Vector2i
var _is_output_console_log:bool
var _frame_interval:int
var _always_on_top:int
var _ignore_script_paths:Array[String]
var _is_add_debugger_to_autoload_singleton:bool
var _display_float_decimal:int
var _is_update_when_save_external_data:bool

var _debugger_enabled:bool = true

# ja:デバッガーのウィンドウの位置の種別
const debugger_window_position_type_initial_value:int = 0
# ja:デバッガーのウィンドウの高さをモニターの高さに合わせるか
const is_debugger_window_height_adjust_monitor_height_initial_value:bool = true
# ja:デバッガーのウィンドウの位置のオフセット（位置をずらす）
const debugger_window_position_offset_initial_value:Vector2i = Vector2i.ZERO
# ja:デバッガーのウィンドウのサイズ
const debugger_window_size_initial_value:Vector2i = Vector2i(800, 800)
# ja:デバッガーのウィンドウの絶対位置
const debugger_window_absolute_position_initial_value:Vector2i = Vector2i.ZERO

# ja:このアドオンがコンソールログに出力するか
const is_output_console_log_initial_value:bool = true
# ja:フレーム間隔
const frame_interval_initial_value:int = 1
# ja:常に最前面に表示
const always_on_top_initial_value:int = 0
# ja:自動ポーズ
const is_auto_focus_pause_initial_value:bool = false
# ja:無視するスクリプトパス(*でワイルドカード指定可能)
const ignore_script_paths_initial_value:Array = []
# ja:Autoloadシングルトンに Live Debugger ノードを追加するか
const is_add_debugger_to_autoload_singleton_initial_value:bool = true
# ja:floatの表示桁数
const display_float_decimal_initial_value:int = 2
# ja:外部データ保存時に自動更新するか
const is_update_when_save_external_data_initial_value:bool = true

#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var tree:SceneTree = get_tree()
@onready var list_tree:Tree = %ListTree

@onready var pause_toggle_button:Button = %PauseToggleButton
@onready var auto_pause_toggle_check_box:CheckBox = %AutoPauseToggleCheckBox
@onready var debugger_enabled_toggle_button:Button = %DebuggerEnabledToggleButton
@onready var framerate_label:Label = %FramerateLabel

#endregion
#-----------------------------------------------------------

#region _init, _ready
#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

func _init() -> void:
	_is_ja = TranslationServer.get_locale()\
		.contains("ja")
	_is_ko = TranslationServer.get_locale()\
		.contains("ko")
	
	var json_txt:String = FileAccess.get_file_as_string(debug_informations_json_path)
	_debug_information_lists = Array(JSON.parse_string(json_txt),TYPE_DICTIONARY,&"",null)
	for d in _debug_information_lists:
		if d.has("debugnode"):
			# <path:String, nodenames:Array[String]>
			_debug_node_dir[d.path] = d.debugnode
		elif not _debug_path_mapping_dir.has(d.path):
			_debug_path_mapping_dir[d.path] = d.path
	_debugger_window_position_type = ProjectSettings.get_setting("godot_live_debugger/debugger_window/debugger_window_position_type", debugger_window_position_type_initial_value)
	_is_debugger_window_height_adjust_monitor_height = ProjectSettings.get_setting("godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height", is_debugger_window_height_adjust_monitor_height_initial_value)
	_debugger_window_position_offset = ProjectSettings.get_setting("godot_live_debugger/debugger_window/debugger_window_position_offset", debugger_window_position_offset_initial_value)
	_debugger_window_size = ProjectSettings.get_setting("godot_live_debugger/debugger_window/debugger_window_size", debugger_window_size_initial_value)
	_debugger_window_absolute_position = ProjectSettings.get_setting("godot_live_debugger/debugger_window/debugger_window_absolute_position", debugger_window_absolute_position_initial_value)

	_is_output_console_log = ProjectSettings.get_setting("godot_live_debugger/editor/is_output_console_log", is_output_console_log_initial_value)
	_frame_interval = ProjectSettings.get_setting("godot_live_debugger/debugger/frame_interval", frame_interval_initial_value)
	_always_on_top = ProjectSettings.get_setting("godot_live_debugger/debugger_window/always_on_top", always_on_top_initial_value)
	always_on_top = _always_on_top == 0
	_is_auto_focus_pause = ProjectSettings.get_setting("godot_live_debugger/debugger/is_auto_focus_pause", is_auto_focus_pause_initial_value)
	#_ignore_script_paths = Array(ProjectSettings.get_setting("godot_live_debugger/ignore_script_paths",ignore_script_paths_initial_value),TYPE_STRING,&"",null)
	#_is_add_debugger_to_autoload_singleton = ProjectSettings.get_setting("godot_live_debugger/is_add_debugger_to_autoload_singleton") as bool
	_display_float_decimal = ProjectSettings.get_setting("godot_live_debugger/debugger/display_float_decimal", display_float_decimal_initial_value)


#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func _ready():
	if ProjectSettings.get_setting("display/window/subwindows/embed_subwindows"):
		if _is_output_console_log:
			if _is_ja:
				printerr("[godot-live-debugger]有効にするには、プロジェクト設定の「サブウィンドウを埋め込む」をオフにする必要があります。")
				printerr("[godot-live-debugger]display/window/subwindows/embed_subwindows")
			elif _is_ko:
				printerr("[godot-live-debugger]사용하려면 프로젝트 설정의 '서브 윈도우를 임베드'를 끄어야합니다.")
				printerr("[godot-live-debugger]display/window/subwindows/embed_subwindows")
			else:
				printerr("[godot-live-debugger]To use this, you need to turn off 'Embed Subwindows' in the project settings.")
				printerr("[godot-live-debugger]display/window/subwindows/embed_subwindows")
		queue_free()
	
	list_tree.columns = columns
	await tree.process_frame
	await tree.process_frame
	await tree.process_frame

	
	game_window_id = tree.root.get_window_id()

	var screen:int = DisplayServer.window_get_current_screen(game_window_id)
	
	var game_screen_position:Vector2i = DisplayServer.screen_get_position(screen)
	var game_screen_size:Vector2i = DisplayServer.screen_get_size(screen)
	
	# ウィンドウの位置を設定
	# ゲーム右隣接=0,ゲーム左隣接=1,画面右隣接=2,画面左隣接=3,絶対位置指定=4
	if _debugger_window_position_type == 0:
		# メインゲームウィンドウの右端にくっつけて表示する
		if _is_debugger_window_height_adjust_monitor_height:
			# 高さぴったり
			self.size = Vector2(_debugger_window_size.x, game_screen_size.y - _debugger_window_position_offset.y)
			self.position = tree.root.position + Vector2i(tree.root.size.x,0) + Vector2i(_debugger_window_position_offset.x, 0)
			self.position.y = game_screen_position.y + _debugger_window_position_offset.y
		else:
			self.size = _debugger_window_size
			self.position = tree.root.position + Vector2i(tree.root.size.x, 0) + _debugger_window_position_offset

	elif _debugger_window_position_type == 1:
		# メインゲームウィンドウの左端にくっつけて表示する
		if _is_debugger_window_height_adjust_monitor_height:
			# 高さぴったり
			self.size = Vector2(_debugger_window_size.x, game_screen_size.y - _debugger_window_position_offset.y)
			self.position = tree.root.position - Vector2i(_debugger_window_size.x, 0)
			self.position.y = game_screen_position.y + _debugger_window_position_offset.y
		else:
			self.size = _debugger_window_size
			self.position = tree.root.position - Vector2i(_debugger_window_size.x, 0) + _debugger_window_position_offset
	
	elif _debugger_window_position_type == 2:
		# 画面右端にくっつけて表示する
		if _is_debugger_window_height_adjust_monitor_height:
			# 高さぴったり
			self.size = Vector2(_debugger_window_size.x, game_screen_size.y - _debugger_window_position_offset.y)
			self.position = Vector2i(game_screen_position.x + game_screen_size.x - _debugger_window_size.x, game_screen_position.y) + _debugger_window_position_offset
		else:
			self.size = _debugger_window_size
			self.position = Vector2i(game_screen_position.x + game_screen_size.x - _debugger_window_size.x, game_screen_position.y) + _debugger_window_position_offset
	
	elif _debugger_window_position_type == 3:
		# 画面左端にくっつけて表示する
		if _is_debugger_window_height_adjust_monitor_height:
			# 高さぴったり
			self.size = Vector2(_debugger_window_size.x, game_screen_size.y - _debugger_window_position_offset.y)
			self.position = Vector2i(game_screen_position.x, game_screen_position.y + _debugger_window_position_offset.y)
		else:
			self.size = _debugger_window_size
			self.position = Vector2i(game_screen_position.x, game_screen_position.y) + _debugger_window_position_offset
	
	elif _debugger_window_position_type == 4:
		# 絶対位置指定
		self.size = _debugger_window_size
		self.position = _debugger_window_absolute_position
	
	
	
	pause_toggle_button.icon = _load_icon("Pause")
	pause_toggle_button.add_theme_color_override(&"icon_normal_color", Color.CORAL)
	pause_toggle_button.add_theme_color_override(&"icon_hover_color", Color.CORAL)
	pause_toggle_button.add_theme_color_override(&"icon_hover_pressed_color", Color.CORAL)
	pause_toggle_button.add_theme_color_override(&"icon_pressed_color", Color.CORAL)
	pause_toggle_button.add_theme_color_override(&"icon_focus_color", Color.CORAL)
	
	debugger_enabled_toggle_button.icon = _load_icon("Pause")
	debugger_enabled_toggle_button.add_theme_color_override(&"icon_normal_color", Color.CORAL)
	debugger_enabled_toggle_button.add_theme_color_override(&"icon_hover_color", Color.CORAL)
	debugger_enabled_toggle_button.add_theme_color_override(&"icon_hover_pressed_color", Color.CORAL)
	debugger_enabled_toggle_button.add_theme_color_override(&"icon_pressed_color", Color.CORAL)
	debugger_enabled_toggle_button.add_theme_color_override(&"icon_focus_color", Color.CORAL)
	
	var arrow_tex:=_load_icon("GuiTreeArrowDown")
	arrow_tex.set_size_override(Vector2(24, 24))
	
	var arrow_collapsed_tex:=_load_icon("GuiTreeArrowRight")
	arrow_collapsed_tex.set_size_override(Vector2(24, 24))
	
	list_tree.add_theme_icon_override(&"arrow", arrow_tex)
	list_tree.add_theme_icon_override(&"arrow_collapsed", arrow_collapsed_tex)
	
	list_tree.set_column_expand_ratio(0,Control.SIZE_FILL)
	list_tree.set_column_expand_ratio(1,Control.SIZE_FILL)
	list_tree.set_column_expand_ratio(2,Control.SIZE_EXPAND_FILL)
	list_tree.set_column_expand(2,true)
	
	auto_pause_toggle_check_box.button_pressed = _is_auto_focus_pause
	
	if _is_ja:
		list_tree.set_column_title(0,"ノード名")
		list_tree.set_column_title(1,"プロパティ名/関数名")
		list_tree.set_column_title(2,"値")
		
		pause_toggle_button.text = "ゲーム"
		pause_toggle_button.tooltip_text = "ポーズ\n(ゲームのSceneTreeをpausedにします)"
		
		debugger_enabled_toggle_button.text = "デバッガ"
		
		auto_pause_toggle_check_box.text = "自動ポーズ"
		auto_pause_toggle_check_box.tooltip_text = "LiveDebuggerをフォーカスしたときに\n自動的にゲームのSceneTreeをpausedにします"
	elif _is_ko:
		list_tree.set_column_title(0,"Node 이름")
		list_tree.set_column_title(1,"속성 이름/메서드 이름")
		list_tree.set_column_title(2,"값")
		
		pause_toggle_button.text = "게임"
		pause_toggle_button.tooltip_text = "일시정지\n(게임의 SceneTree를 일시정지합니다)"
		
		debugger_enabled_toggle_button.text = "디버거"
		
		
		auto_pause_toggle_check_box.text = "자동 일시정지"
		auto_pause_toggle_check_box.tooltip_text = "LiveDebugger를 포커스했을 때\n자동으로 게임의 SceneTree를 일시정지합니다"
		
	else:
		list_tree.set_column_title(0,"Node Name")
		list_tree.set_column_title(1,"Property/Function")
		list_tree.set_column_title(2,"Value")
		
		pause_toggle_button.text = "Game"

		pause_toggle_button.tooltip_text = "Pause\n(Pause the SceneTree of the game)"
		
		debugger_enabled_toggle_button.text = "Debugger"

		auto_pause_toggle_check_box.text = "Auto Pause"
		auto_pause_toggle_check_box.tooltip_text = "Automatically pause the SceneTree of the game\nwhen LiveDebugger is focus_entered"
		
	
	#list_tree.cell_selected.connect(_on_cell_selected)
	list_tree.button_clicked.connect(_on_button_clicked)
	list_tree.item_edited.connect(_on_item_edited)
	refresh()

	self.focus_entered.connect(_on_focus_entered)
	self.focus_exited.connect(_on_focus_exited)
	
	self.close_requested.connect(_on_close_requested)

	if _always_on_top == 1:
		get_tree().root.focus_entered.connect(_on_main_window_focus_entered)
	
	# 起動時にゲームのウィンドウのフォーカスをとってしまうので
	# がんばってお返しする
	var count_for_clash:int = 0
	while not DisplayServer.window_is_focused(game_window_id):
		await tree.process_frame
		DisplayServer.window_move_to_foreground()
		count_for_clash += 1
		if count_for_clash > 1000:
			break

var is_lock:bool = false
func _on_main_window_focus_entered():
	if _always_on_top != 1: return
	if is_lock:return
	self.grab_focus()
	is_lock = true
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().root.grab_focus()
	await get_tree().create_timer(0.5).timeout
	is_lock = false

func _on_close_requested():
	queue_free()

var game_window_id:int

func _on_focus_entered():
	if _is_auto_focus_pause:
		_is_focus_pause = true
		toggle_main_window_pause()
	
func toggle_main_window_pause():
	change_pause_toggle_view()
	tree.root.gui_disable_input = _is_focus_pause
	tree.paused = _is_focus_pause

func _on_focus_exited():
	await tree.process_frame
	if not DisplayServer.window_is_focused(game_window_id):return
	if _is_auto_focus_pause:
		_is_focus_pause = false
		toggle_main_window_pause()

func _load_icon(icon_name:String) -> ImageTexture:
	if icon_textures.has(icon_name):return icon_textures[icon_name]
	var image = Image.load_from_file(OS.get_user_data_dir().path_join(icon_name+".png"))
	icon_textures[icon_name] = ImageTexture.create_from_image(image)
	return icon_textures[icon_name]

func refresh():
	tree = get_tree()
	
	_target_nodes = []
	list_tree.clear()
	_root_item = list_tree.create_item()
	
	var nodes := get_all_children(tree.root)
	var index:int = 0
	for n in nodes:
		if _is_target_node(n):
			_target_nodes.append(n)
			_add_list(n)
			index+=1
	
	if not tree.node_added.is_connected(_on_node_added):
		tree.node_added.connect(_on_node_added)
		tree.node_removed.connect(_on_node_removed)

func _process(delta: float) -> void:
	if _is_focus_pause:return
	if not _debugger_enabled: return
	framerate_label.text = str(Performance.get_monitor(Performance.TIME_FPS))
	if _frame_interval == 1:
		update()
	else:
		if Engine.get_frames_drawn() % _frame_interval == 0:
			update()


func update() -> void:
	if !_root_item: return
	var enable_list_indexes:Array[int] = []
	for n in _target_nodes:
		if not is_instance_valid(n):
			_target_nodes.erase(n)
		for child_item in _root_item.get_children():
			if child_item.get_metadata(0) == n.get_instance_id():
				_update_node(n, child_item)
	#if enable_list_indexes.size() == 1:
		#var item:TreeItem = _root_item.get_child(enable_list_indexes[0])
		#item.set_custom_bg_color(1,Color.DARK_GRAY)
	#if enable_list_indexes.size() > 1:
		#for ind in enable_list_indexes:
			#var item:TreeItem = _root_item.get_child(ind)
			#item.set_custom_bg_color(1,Color.DARK_GOLDENROD)

func _update_node(n:Node, item:TreeItem):
	if item.has_meta(&"cate") or item.has_meta(&"root"):
		for child_item in item.get_children():
			_update_node(n, child_item)
	else:
		var d:Dictionary = item.get_metadata(1)
		# 他ノードプロパティの場合はget_pathする
		if d.has("node_path"):
			# キャッシュして毎フレームget_nodeを避ける
			# 他のノードプロパティ指定のノードをキャッシュ <nid:int,Dictionary<node_path:StringName,other_node_id:int>>
			if not _target_node_other_nodes[n.get_instance_id()].has(d.node_path):
				var other_n:Node = n.get_node_or_null(d.node_path)
				if other_n:
					_target_node_other_nodes[n.get_instance_id()][d.node_path] = other_n.get_instance_id()
					n = other_n
			else:
				n = instance_from_id(_target_node_other_nodes[n.get_instance_id()][d.node_path])
			
			if not n:return
		if d.has("prop"):
			
			# BOOLはチェックボックスなので文字列に変換する必要なし
			if d.type == TYPE_BOOL:
				item.set_checked(2, n.get(d.prop))
				return
			elif d.type == TYPE_VECTOR2:
				# Vector2はfloatなので設定の表示桁数に準じる
				var x_str:String = str(n.get(d.prop).x)
				x_str = x_str.pad_decimals(_display_float_decimal) if x_str.contains(".") else x_str
				var y_str:String = str(n.get(d.prop).y)
				y_str = y_str.pad_decimals(_display_float_decimal) if y_str.contains(".") else y_str
				item.set_text(2, x_str + ", " + y_str)
				return
			elif d.type == TYPE_VECTOR3:
				# Vector3はfloatなので設定の表示桁数に準じる
				var x_str:String = str(n.get(d.prop).x)
				x_str = x_str.pad_decimals(_display_float_decimal) if x_str.contains(".") else x_str
				var y_str:String = str(n.get(d.prop).y)
				y_str = y_str.pad_decimals(_display_float_decimal) if y_str.contains(".") else y_str
				var z_str:String = str(n.get(d.prop).z)
				z_str = z_str.pad_decimals(_display_float_decimal) if z_str.contains(".") else z_str
				item.set_text(2, x_str + ", " + y_str + ", " + z_str)
				return
			
			var s:String = str(n.get(d.prop))
			
			# Floatは設定の表示桁数に準じる
			if d.type == TYPE_FLOAT:
				s = s.pad_decimals(_display_float_decimal) if s.contains(".") else s
				item.set_text(2, s)
				return
			elif d.type == TYPE_VECTOR2I\
			or d.type == TYPE_VECTOR3I:
				s = s.substr(1,s.length() - 2)
				item.set_text(2, s)
				
			
			item.set_text(2, s)
			#print(n.get(d.prop))
		if d.has("call") and not d.call:
			item.set_text(2, str(n.call(d.func)))

#endregion
#-----------------------------------------------------------

#region _virtual Function
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _on_node_added(n:Node):
	if _is_target_node(n) and _target_nodes.find(n) == -1:
		_target_nodes.append(n)
		_add_list(n)

func _on_node_removed(n:Node):
	if _is_target_node(n) and _target_nodes.find(n) != -1:
		_target_nodes.erase(n)
		
		if _target_node_other_nodes.has(n.get_instance_id()):
			_target_node_other_nodes[n.get_instance_id()].clear()
			_target_node_other_nodes.erase(n.get_instance_id())
		var nid:int = n.get_instance_id()
		for item_n in _root_item.get_children():
			if item_n.get_metadata(0) == nid:
				_root_item.remove_child(item_n)
				break

func _is_target_node(n:Node) -> bool:
	var scr:Script = n.get_script()
	if not scr: return false
	if not scr.resource_path or scr.resource_path == "": return false
	return _debug_path_mapping_dir.has(scr.resource_path)\
	and (not _debug_node_dir.has(scr.resource_path) or _debug_node_dir[scr.resource_path].find(n.name) != -1)
	# ノード名指定がないか、ノード名指定にノード名が含まれているなら対象にする


func _add_list(n:Node):
	var scr:Script = n.get_script()
	var debug_infos:Array[Dictionary] = _debug_information_lists.filter(func(d): return d.path == scr.resource_path and not d.has("debugnode"))
	debug_infos.sort_custom(func(a,b): return a.sort_index > b.sort_index)
	var debug_infos_cate_dic:Dictionary = {}
	var item_for_dir_root:= list_tree.create_item(_root_item)
	item_for_dir_root.set_meta(&'root',true)
	item_for_dir_root.set_metadata(0, n.get_instance_id())
	item_for_dir_root.set_text(0,n.name)
	item_for_dir_root.set_tooltip_text(0,str(n.get_path()))
	
	if n is CanvasItem or n is Node3D:
		if n.visible:
			item_for_dir_root.add_button(0, _load_icon("GuiVisibilityVisible"))
		else:
			item_for_dir_root.add_button(0, _load_icon("GuiVisibilityHidden"))
	
	item_for_dir_root.add_button(2, _load_icon("Remove"))
	item_for_dir_root.set_button_color(2, 0, Color.RED)
	item_for_dir_root.set_text_alignment(2, HORIZONTAL_ALIGNMENT_RIGHT)
	
	if not _target_node_other_nodes.has(n.get_instance_id()):
		_target_node_other_nodes[n.get_instance_id()] = {}
	
	item_for_dir_root.set_icon(0, _load_icon(debug_infos[0].node_icon))
	
	
	for d in debug_infos:
		var item:TreeItem
		
		if d.has("cates"):
			# カテゴリの折りたたみをなければ作る、あれば追加
			var cate_item:= _add_cates(d.cates, item_for_dir_root)
			item = cate_item.create_child()
		else:
			# カテゴリ指定がなければノードのおりたたみ直下に追加
			item = list_tree.create_item(item_for_dir_root)
		item.set_metadata(0, n.get_instance_id())
		
		if d.has("color"):
			item.set_custom_color(0,Color.from_string(d.color,Color.WHITE))
			var image:Image = Image.create(24,24,false,Image.FORMAT_RGB8)
			image.fill(Color.from_string(d.color,Color.WHITE))
			item.set_icon(0,ImageTexture.create_from_image(image))
			item.set_text_alignment(0,HORIZONTAL_ALIGNMENT_RIGHT)
			
			item.set_custom_color(1,Color.from_string(d.color,Color.WHITE))
			item.set_custom_color(2,Color.from_string(d.color,Color.WHITE))
		
		if d.has("prop"):
			# プロパティ
			d.prop = StringName(d.prop)
			if d.display_name == "":
				item.set_text(1, str(d.prop))
			else:
				item.set_text(1, d.display_name)
			
			if d.type == TYPE_INT or \
				d.type == TYPE_FLOAT or \
				d.type == TYPE_BOOL or \
				d.type == TYPE_STRING or \
				d.type == TYPE_STRING_NAME or \
				d.type == TYPE_VECTOR2 or \
				d.type == TYPE_VECTOR2I or \
				d.type == TYPE_VECTOR3 or \
				d.type == TYPE_VECTOR3I:
				#item.set_icon(1,list_tree.theme.get_icon())
				
				item.set_editable(2, true)
				item.set_custom_bg_color(2,Color.GRAY,true)
			
			if d.type == TYPE_BOOL:
				item.set_cell_mode(2, TreeItem.CELL_MODE_CHECK)
			else:
				item.set_autowrap_mode(2, TextServer.AUTOWRAP_ARBITRARY)
				item.set_text_overrun_behavior(2, TextServer.OVERRUN_NO_TRIMMING)
			
			item.set_icon(1, _load_icon(d.icon))
			item.set_metadata(1, d)
		else:
			# 関数
			
			if d.display_name == "":
				item.set_text(1,d.func)
			else:
				item.set_text(1, d.display_name)
			item.set_icon(1, _load_icon("Callable"))
			if d.call:
				item.add_button(1, _load_icon("Play"))
				item.set_metadata(1, d)
				if d.has("args") and not d.args.is_empty():
					var s = ", ".join(Array(d.args.map(func(arg): return arg.name + ":" + _type_arg_string(arg.type)),TYPE_STRING,&"",null))
					item.set_tooltip_text(2, s)
				
				item.set_editable(2, true)
				item.set_custom_bg_color(2,Color.GRAY,true)
			else:
				d.func = StringName(d.func)
				item.set_metadata(1, d)
				#item.set_custom_as_button(2,true)
				#item.set_custom_draw_callback(2,func(item:TreeItem, rect:Rect2): print(rect))
				item.set_autowrap_mode(2, TextServer.AUTOWRAP_ARBITRARY)
				item.set_text_overrun_behavior(2, TextServer.OVERRUN_NO_TRIMMING)
			
		#item.set_tooltip_text(0,str(n.get_path()))
		#item.set_cell_mode(ENABLED_COLUMN_INDEX,TreeItem.CELL_MODE_CHECK)
		#item.set_checked(ENABLED_COLUMN_INDEX,n.is_menu_enable)
		#item.set_cell_mode(LOCK_COLUMN_INDEX,TreeItem.CELL_MODE_CHECK)
		#item.set_checked(LOCK_COLUMN_INDEX,n.is_lock)
		#item.set_text(3, _get_focusing_btn_name(n))
		#item.set_text(4, _get_focusing_btn_id(n))

func _add_cates(cates:Array, item_for_dir_root:TreeItem) -> TreeItem:
	# カテゴリの折りたたみをなければ作る、あれば追加
	var parent:TreeItem = item_for_dir_root
	for cate_s in cates:
		var is_exists:bool = false
		for p in item_for_dir_root.get_children():
			if not p.has_meta(&"cate"): continue
			if p.get_meta(&"cate") == cate_s:
				parent = p
				is_exists = true
				break
		if not is_exists:
			# 一致なし＝追加する
			parent = parent.create_child()
			parent.set_meta(&"cate", cate_s)
			parent.set_text(0,cate_s)
	return parent


func _get_focusing_btn_id(cmd:Node) -> String:
	if cmd.focusing_button:
		return str(cmd.focusing_button.id)
	return ""


func _get_focusing_btn_name(cmd:Node) -> String:
	if cmd.focusing_button:
		return str(cmd.focusing_button.name)
	return ""


func _get_item_index(item:TreeItem) ->int:
	var index:int = 0
	for _item in _root_item.get_children():
		if item == _item:
			return index
		index += 1
	return -1


#func _on_cell_selected():
	#var item:TreeItem = list_tree.get_selected()
	#var column:int = list_tree.get_selected_column()
	#if column == ENABLED_COLUMN_INDEX or column == LOCK_COLUMN_INDEX:
		#_on_check(item, column)

func _on_button_clicked(item:TreeItem, column:int, id:int, mouse_button_index:int):
	if mouse_button_index != MOUSE_BUTTON_LEFT: return
	var nid:int = item.get_metadata(0)
	if not is_instance_id_valid(nid): return
	var instance:Node = instance_from_id(nid)
	
	# NodeのVisible切り替えボタン
	if column == 0:
		instance.visible = not instance.visible
		if instance.visible:
			item.set_button(0, 0, _load_icon("GuiVisibilityVisible"))
		else:
			item.set_button(0, 0, _load_icon("GuiVisibilityHidden"))
		return
	elif column == 2:
		# 削除ボタン
		instance.queue_free()
		return
	
	var d:Dictionary = item.get_metadata(1)
	
	# まだFUNCだけなので判定なし　今後追加するかも
	#{ "args": [{ "class_name": "", "hint": 0, "hint_string": "", "name": "anim_name", "type": 21, "usage": 0 }], 
		#"call": true, 
		#"default_args": [], 
		#"display_name": "アニメーション変更",
		 #"flags": 1, 
		#"func": "play_animation", 
		#"id": 0, 
		#"node_icon": "Node2D", 
		#"path": "res://scene/game/battle/card_ui/card_view.gd", 
		#"sort_index": 0 
	#}
	
	# FUNCのCall
	if d.has("args") and not d.args.is_empty():
		# 引数あり
		var args:Array = []
		var arg_s_values:Array = item.get_text(2).split(",")
		var index:int = 0
		for arg in d.args:
			# ,で分けるタイプ #Columnでもわけれるようにする？
			
			if arg_s_values.size()>= index:
				args.append(_str_to_type_val_or_null(arg_s_values[index], arg.type))
			
			index += 1
		var result = await instance.callv(d.func,args)
		if result:
			item.set_text(2,str(result))
	else:
		var result = await instance.call(d.func)
		if result:
			item.set_text(2,str(result))

func _on_item_edited():
	var item:TreeItem = list_tree.get_selected()
	var column:int = list_tree.get_selected_column()
	_on_edited(item, column)

func _on_edited(item: TreeItem,column:int):
	var d:Dictionary = item.get_metadata(1)
	if not d.has("prop"): return
	#print(item.get_text(column))
	#print(d)
	var new_val_string:String = item.get_text(column)
	var id:int = item.get_metadata(0)
	if not is_instance_id_valid(id): return
	var instance:Node = instance_from_id(id)
	
	
	if d.type == TYPE_BOOL:
		instance.set(d.prop, item.is_checked(column))
	else:
		instance.set(d.prop, _str_to_type_val_or_null(new_val_string,d.type))


func _on_check(item: TreeItem, column: int):
	#var checked:bool = item.is_checked(column)
	#item.set_checked(column, true)
	#var index:int = item.get_index()
	#if column == ENABLED_COLUMN_INDEX:
		#if !checked:
			#_target_nodes[index].show_list()
		#else:
			#_target_nodes[index].disable_list()
	#elif column == LOCK_COLUMN_INDEX:
		#_target_nodes[index].is_lock = !checked
	pass

#endregion
#-----------------------------------------------------------

#region Public Function
#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------


#endregion
#-----------------------------------------------------------

#region _private Function
#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

func _str_to_type_val_or_null(s:String, type:int) -> Variant:
	if type == TYPE_INT:
		if not s.is_valid_int():return null
		return s.to_int()
	elif type == TYPE_FLOAT:
		if not s.is_valid_float():return null
		return s.to_float()
	elif type == TYPE_BOOL:
		return s == "true"
	elif type == TYPE_STRING:
		return s
	elif type == TYPE_STRING_NAME:
		return StringName(s)
	elif type == TYPE_VECTOR2:
		if s.split(",").size() != 2:return null
		var splited:PackedStringArray = s.split(",")
		if not splited[0].replace(" ","").is_valid_float():return null
		if not splited[1].replace(" ","").is_valid_float():return null
		var vec2:Vector2 = Vector2(splited[0].to_float(),splited[1].to_float())
		return vec2
	elif type == TYPE_VECTOR2I:
		if s.split(",").size() != 2:return null
		var splited:PackedStringArray = s.split(",")
		if not splited[0].replace(" ","").is_valid_int():return null
		if not splited[1].replace(" ","").is_valid_int():return null
		var vec2:Vector2i = Vector2(splited[0].to_int(),splited[1].to_int())
		return vec2
	elif type == TYPE_VECTOR3:
		if s.split(",").size() != 3:return null
		var splited:PackedStringArray = s.split(",")
		if not splited[0].replace(" ","").is_valid_float():return null
		if not splited[1].replace(" ","").is_valid_float():return null
		if not splited[2].replace(" ","").is_valid_float():return null
		var vec3:Vector3 = Vector3(splited[0].to_float(),splited[1].to_float(),splited[2].to_float())
		return vec3
	elif type == TYPE_VECTOR3I:
		if s.split(",").size() != 3:return null
		var splited:PackedStringArray = s.split(",")
		if not splited[0].replace(" ","").is_valid_int():return null
		if not splited[1].replace(" ","").is_valid_int():return null
		if not splited[2].replace(" ","").is_valid_int():return null
		var vec3:Vector3i = Vector3(splited[0].to_int(),splited[1].to_int(),splited[2].to_int())
		return vec3
	elif type == TYPE_ARRAY:
		return null
	elif type == TYPE_OBJECT:
		return null
	elif type == TYPE_NODE_PATH:
		return null
	
	return null

static func get_all_children(in_node:Node) -> Array[Node]:
	var children = in_node.get_children()
	var ary:Array[Node] = []
	while not children.is_empty():
		var node = children.pop_back()
		children.append_array(node.get_children())
		ary.append(node)
	ary.reverse()
	return ary

func _is_colored_type(type:int) -> bool:
	if type == TYPE_STRING:
		return true
	if type == TYPE_INT:
		return true
	if type == TYPE_FLOAT:
		return true
	if type == TYPE_BOOL:
		return true
	if type == TYPE_STRING_NAME:
		return true
	if type == TYPE_VECTOR2:
		return true
	if type == TYPE_VECTOR2I:
		return true
	if type == TYPE_VECTOR3:
		return true
	if type == TYPE_VECTOR3I:
		return true
	if type == TYPE_RECT2:
		return true
	if type == TYPE_RECT2I:
		return true
	if type == TYPE_COLOR:
		return true
	if type == TYPE_CALLABLE:
		return false
	if type == TYPE_NODE_PATH:
		return true
	if type == TYPE_OBJECT:
		return false
	if type == TYPE_DICTIONARY:
		return true
	if type == TYPE_ARRAY:
		return false
	if type == TYPE_TRANSFORM2D:
		return true
	if type == TYPE_TRANSFORM3D:
		return true
	
	return false

func _type_arg_string(type:int) -> String:
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


#endregion
#-----------------------------------------------------------


func _on_auto_pause_toggle_check_box_toggled(toggled_on:bool):
	_is_auto_focus_pause = toggled_on
	if _is_auto_focus_pause:
		_is_focus_pause = toggled_on
		toggle_main_window_pause()


func _on_pause_toggle_button_pressed():
	var toggled_on:bool = !_is_focus_pause
	_is_focus_pause = toggled_on
	toggle_main_window_pause()

func change_pause_toggle_view():
	if _is_focus_pause:
		pause_toggle_button.icon = _load_icon("Play")
		pause_toggle_button.add_theme_color_override(&"icon_normal_color", Color.AQUAMARINE)
		pause_toggle_button.add_theme_color_override(&"icon_hover_color", Color.AQUAMARINE)
		pause_toggle_button.add_theme_color_override(&"icon_hover_pressed_color", Color.AQUAMARINE)
		pause_toggle_button.add_theme_color_override(&"icon_pressed_color", Color.AQUAMARINE)
		pause_toggle_button.add_theme_color_override(&"icon_focus_color", Color.AQUAMARINE)
	else:
		pause_toggle_button.icon = _load_icon("Pause")
		pause_toggle_button.add_theme_color_override(&"icon_normal_color", Color.CORAL)
		pause_toggle_button.add_theme_color_override(&"icon_hover_color", Color.CORAL)
		pause_toggle_button.add_theme_color_override(&"icon_hover_pressed_color", Color.CORAL)
		pause_toggle_button.add_theme_color_override(&"icon_pressed_color", Color.CORAL)
		pause_toggle_button.add_theme_color_override(&"icon_focus_color", Color.CORAL)


func _on_debugger_enabled_toggle_button_pressed():
	_debugger_enabled = not _debugger_enabled
	if not _debugger_enabled:
		debugger_enabled_toggle_button.icon = _load_icon("Play")
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_normal_color", Color.AQUAMARINE)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_hover_color", Color.AQUAMARINE)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_hover_pressed_color", Color.AQUAMARINE)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_pressed_color", Color.AQUAMARINE)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_focus_color", Color.AQUAMARINE)
	else:
		debugger_enabled_toggle_button.icon = _load_icon("Pause")
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_normal_color", Color.CORAL)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_hover_color", Color.CORAL)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_hover_pressed_color", Color.CORAL)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_pressed_color", Color.CORAL)
		debugger_enabled_toggle_button.add_theme_color_override(&"icon_focus_color", Color.CORAL)
