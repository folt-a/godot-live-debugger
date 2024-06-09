@tool
extends EditorPlugin

#const debug_infomations_json_path = "res://addons/godot_live_debugger/debug_informations.json"
const debug_informations_json_path = "user://debug_informations.json"

const NODE_LIVE_DEBUGGER_TSCN_PATH:String = "res://addons/godot-live-debugger/node_live_debugger.tscn"


# setting list

# Cate debugger_window

# * always_on_top
# ja:常に最前面に表示
# ko:항상 최상위에 표시
# en:Always on top
const always_on_top_initial_value:int = 0
const order_always_on_top:int = 10
# * debugger_window_position_type
# ja:デバッガーのウィンドウの位置の種別
# ko:디버거 창 위치 유형
# en:Debugger window position type
const debugger_window_position_type_initial_value:int = 0
const order_debugger_window_position_type = 20
# * is_debugger_window_height_adjust_monitor_height
# ja:デバッガーのウィンドウの高さをモニターの高さに合わせるか
# ko:디버거 창 높이를 모니터 높이에 맞추시겠습니까?
# en:Do you want to adjust the height of the debugger window to the height of the monitor?
const is_debugger_window_height_adjust_monitor_height_initial_value:bool = true
const order_is_debugger_window_height_adjust_monitor_height = 30
# * debugger_window_position_offset
# ja:デバッガーのウィンドウの位置のオフセット（位置をずらす）
# ko:디버거 창 위치 오프셋
# en:Debugger window position offset
const debugger_window_position_offset_initial_value:Vector2i = Vector2i.ZERO
const order_debugger_window_position_offset = 40
# * debugger_window_absolute_position
# ja:デバッガーのウィンドウの絶対位置 (typeが絶対位置指定の場合のみ有効)
# ko:디버거 창의 절대 위치 (type이 절대 위치 지정인 경우에만 유효)
# en:Absolute position of the debugger window (valid only when type is absolute position)
const debugger_window_absolute_position_initial_value:Vector2i = Vector2i.ZERO
const order_debugger_window_absolute_position = 50
# * debugger_window_size
# ja:デバッガーのウィンドウのサイズ
# ko:디버거 창 크기
# en:Debugger window size
const debugger_window_size_initial_value:Vector2i = Vector2i(800, 800)
const order_debugger_window_size = 60

# Cate debugger

# * frame_interval
# ja:何フレームに一度ノードをチェックするかのフレーム値です。パフォーマンスが落ちる場合は値を大きくしてください。
# ko:노드를 확인할 프레임 값입니다. 성능이 떨어지는 경우 값이 커지도록 설정하십시오.
# en:Frame value to check the node. If game performance is degraded, increase the value.
const frame_interval_initial_value:int = 1
const order_frame_interval = 70

# * is_auto_focus_pause
# ja:LiveDebuggerをフォーカスしたときに自動的にゲームのSceneTreeをpausedにします
# ko:LiveDebugger에 포커스를 맞추면 자동으로 게임의 SceneTree를 일시 중지합니다
# en:When LiveDebugger is focused, automatically pause the SceneTree of the game
const is_auto_focus_pause_initial_value:bool = false
const order_is_auto_focus_pause = 80

# * display_float_decimal
# ja:floatの表示桁数
# ko:float의 표시 자릿수
# en:float display decimal
const display_float_decimal_initial_value:int = 2
const order_display_float_decimal = 90

# Cate Editor

# * is_output_console_log
# ja:このアドオンがコンソールログに出力するか
# ko:이 애드온이 콘솔 로그에 출력하는지 여부
# en:Whether this add-on outputs to the console log
const is_output_console_log_initial_value:bool = true
const order_is_output_console_log = 100
# * ignore_script_paths
# ja:無視するスクリプトパス(*でワイルドカード指定可能)
# ko:무시할 스크립트 경로 (*로 와일드 카드 지정 가능)
# en:Ignore script paths (* can be wildcard)
const ignore_script_paths_initial_value:Array = []
const order_ignore_script_paths = 110
# * is_add_debugger_to_autoload_singleton
# ja:Autoloadシングルトンに Live Debugger ノードを追加するか
# ko:Autoload 싱글톤에 Live Debugger 노드를 추가할 것인가
# en:Whether to add the Live Debugger node to the Autoload singleton
const is_add_debugger_to_autoload_singleton_initial_value:bool = true
const order_is_add_debugger_to_autoload_singleton = 120
# * is_update_when_save_external_data
# ja:外部データ保存時に自動更新するか
# ko:외부 데이터 저장시 자동 업데이트 여부
# en:Whether to update automatically when saving external data
const is_update_when_save_external_data_initial_value:bool = true
const order_is_update_when_save_external_data = 130


var before_is_add_debugger_to_autoload_singleton:bool

var _is_ja:bool = false
var _is_ko:bool = false

var _is_output_console_log:bool

var _ignore_paths:Array[String] = []

func _init():
	_is_ja = TranslationServer.get_locale()\
		.contains("ja")
	_is_ko = TranslationServer.get_locale()\
		.contains("ko")

func _enter_tree() -> void:
	add_tool_menu_item("Update LiveDebugger Data", update)
	
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
	_add_user_dir_icon("Remove")
	_add_user_dir_icon("Info")
	
	_add_user_dir_icon("Pause")
	
	_add_user_dir_icon("GuiTreeArrowDown")
	_add_user_dir_icon("GuiTreeArrowRight")
	
	# プロジェクト設定変更をチェックする
	if not ProjectSettings.settings_changed.is_connected(_on_changed_project_settings):
		ProjectSettings.settings_changed.connect(_on_changed_project_settings)

	if ProjectSettings.get_setting("display/window/subwindows/embed_subwindows"):
		ProjectSettings.set_setting("display/window/subwindows/embed_subwindows", false)
		if _is_output_console_log:
			if _is_ja:
				print_rich("[godot_live_debugger][color=LIME_GREEN][b]プロジェクト設定の「サブウィンドウを埋め込む」をオンにしました。[/b][/color]")
			elif _is_ko:
				printerr("[godot-live-debugger][color=LIME_GREEN][b]프로젝트 설정의 '서브 윈도우를 포함'을 켰습니다.[/b][/color]")
			else:
				printerr("[godot-live-debugger][color=LIME_GREEN][b]Turned on 'Embed Subwindows' in Project Settings.[/b][/color]")

	var de = ""
	if _is_ja:
		de = "↓説明"
	elif _is_ko:
		de = "↓설명"
	else:
		de = "↓Description"

	# デバッガーのウィンドウの位置の種別
	if not ProjectSettings.has_setting("godot_live_debugger/debugger_window/debugger_window_position_type"):
		ProjectSettings.set("godot_live_debugger/debugger_window/debugger_window_position_type", debugger_window_position_type_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/debugger_window_position_type", debugger_window_position_type_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/debugger_window_position_type", order_debugger_window_position_type + 1)
		if _is_ja:
			ProjectSettings.add_property_info({
			"name": "godot_live_debugger/debugger_window/debugger_window_position_type",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "ゲーム右隣接,ゲーム左隣接,画面右隣接,画面左隣接,絶対位置指定"
			})
		elif _is_ko:
			ProjectSettings.add_property_info({
			"name": "godot_live_debugger/debugger_window/debugger_window_position_type",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "게임 오른쪽 인접,게임 왼쪽 인접,화면 오른쪽 인접,화면 왼쪽 인접,절대 위치 지정"
			})
		else:
			ProjectSettings.add_property_info({
			"name": "godot_live_debugger/debugger_window/debugger_window_position_type",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Game Window Right,Game Window Left,Screen Right,Screen Left, Absolute Position"
			})
		
		var description = ""
		if _is_ja:
			description = "デバッガーのウィンドウの位置の種別"
		elif _is_ko:
			description = "디버거 창 위치 유형"
		else:
			description = "Debugger window position type"
		
		ProjectSettings.set("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_type", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_type", description)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_type", order_debugger_window_position_type)
		_add_description_prop("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_type")
		ProjectSettings.save()

	# デバッガーのウィンドウの高さをモニターの高さに合わせるか
	if not ProjectSettings.has_setting("godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height"):
		ProjectSettings.set("godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height", is_debugger_window_height_adjust_monitor_height_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height", is_debugger_window_height_adjust_monitor_height_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height", order_is_debugger_window_height_adjust_monitor_height + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height",
		"type": TYPE_BOOL
		})
		var description = ""
		if _is_ja:
			description = "デバッガーのウィンドウの高さをモニターの高さに合わせるか"
		elif _is_ko:
			description = "디버거 창 높이를 모니터 높이에 맞추시겠습니까?"
			description = "adjust the height of the debugger window to the height of the monitor?"
		
		ProjectSettings.set("godot_live_debugger/debugger_window/" + de + "_is_debugger_window_height_adjust_monitor_height", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/" + de + "_is_debugger_window_height_adjust_monitor_height", description)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/" + de + "_is_debugger_window_height_adjust_monitor_height", order_is_debugger_window_height_adjust_monitor_height)
		_add_description_prop("godot_live_debugger/debugger_window/" + de + "_is_debugger_window_height_adjust_monitor_height")
		ProjectSettings.save()

	# デバッガーのウィンドウの位置のオフセット（位置をずらす）
	if not ProjectSettings.has_setting("godot_live_debugger/debugger_window/debugger_window_position_offset"):
		ProjectSettings.set("godot_live_debugger/debugger_window/debugger_window_position_offset", debugger_window_position_offset_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/debugger_window_position_offset", debugger_window_position_offset_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/debugger_window_position_offset", order_debugger_window_position_offset + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger_window/debugger_window_position_offset",
		"type": TYPE_VECTOR2I
		})
		var description = ""
		if _is_ja:
			description = "デバッガーのウィンドウの位置のオフセット（位置をずらす）"
		elif _is_ko:
			description = "디버거 창 위치 오프셋"
		else:
			description = "Debugger window position offset"
		
		ProjectSettings.set("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_offset", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_offset", description)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_offset", order_debugger_window_position_offset)
		_add_description_prop("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_offset")
		ProjectSettings.save()

	# デバッガーのウィンドウのサイズ
	if not ProjectSettings.has_setting("godot_live_debugger/debugger_window/debugger_window_size"):
		ProjectSettings.set("godot_live_debugger/debugger_window/debugger_window_size", debugger_window_size_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/debugger_window_size", debugger_window_size_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/debugger_window_size", order_debugger_window_size + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger_window/debugger_window_size",
		"type": TYPE_VECTOR2I
		})
		var description = ""
		if _is_ja:
			description = "デバッガーのウィンドウのサイズ"
		elif _is_ko:
			description = "디버거 창 크기"
		else:
			description = "Debugger window size"
		
		ProjectSettings.set("godot_live_debugger/debugger_window/" + de + "_debugger_window_size", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/" + de + "_debugger_window_size", description)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/" + de + "_debugger_window_size", order_debugger_window_size)
		_add_description_prop("godot_live_debugger/debugger_window/" + de + "_debugger_window_size")
		ProjectSettings.save()

	# デバッガーのウィンドウの絶対位置
	if not ProjectSettings.has_setting("godot_live_debugger/debugger_window/debugger_window_absolute_position"):
		ProjectSettings.set("godot_live_debugger/debugger_window/debugger_window_absolute_position", debugger_window_absolute_position_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/debugger_window_absolute_position", debugger_window_absolute_position_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/debugger_window_absolute_position", order_debugger_window_absolute_position + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger_window/debugger_window_absolute_position",
		"type": TYPE_VECTOR2I
		})
		var description = ""
		if _is_ja:
			description = "デバッガーのウィンドウの絶対位置"
		elif _is_ko:
			description = "디버거 창의 절대 위치"
		else:
			description = "Absolute position of the debugger window"
		
		ProjectSettings.set("godot_live_debugger/debugger_window/" + de + "_debugger_window_absolute_position", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/" + de + "_debugger_window_absolute_position", description)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/" + de + "_debugger_window_absolute_position", order_debugger_window_absolute_position)
		_add_description_prop("godot_live_debugger/debugger_window/" + de + "_debugger_window_absolute_position")
		ProjectSettings.save()


	# 最前面
	if not ProjectSettings.has_setting("godot_live_debugger/debugger_window/always_on_top"):
		ProjectSettings.set("godot_live_debugger/debugger_window/always_on_top", always_on_top_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/always_on_top", always_on_top_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/always_on_top", order_always_on_top + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger_window/always_on_top",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Always on top,Show when main window focused,None"
		})
		var description = ""
		if _is_ja:
			description = "LiveDebuggerのウィンドウを常に最前面に表示します。"
		elif _is_ko:
			description = "LiveDebugger 창을 항상 최상위에 표시합니다."
		else:
			description = "Always display the LiveDebugger window on top."
		
		ProjectSettings.set("godot_live_debugger/debugger_window/" + de + "_always_on_top", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger_window/" + de + "_always_on_top", description)
		ProjectSettings.set_order("godot_live_debugger/debugger_window/" + de + "_always_on_top", order_always_on_top)
		_add_description_prop("godot_live_debugger/debugger_window/" + de + "_always_on_top")
		ProjectSettings.save()
	
	# フォーカス時に自動ポーズ
	if not ProjectSettings.has_setting("godot_live_debugger/debugger/is_auto_focus_pause"):
		ProjectSettings.set("godot_live_debugger/debugger/is_auto_focus_pause", is_auto_focus_pause_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger/is_auto_focus_pause", is_auto_focus_pause_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger/is_auto_focus_pause", order_is_auto_focus_pause + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger/is_auto_focus_pause",
		"type": TYPE_BOOL
		})
		var description = ""
		if _is_ja:
			description = "LiveDebuggerをフォーカスしたときに自動的にゲームのSceneTreeをpausedにします"
		elif _is_ko:
			description = "LiveDebugger에 포커스를 맞추면 자동으로 게임의 SceneTree를 일시 중지합니다"
		else:
			description = "When LiveDebugger is focused, automatically pause the SceneTree of the game"
		
		ProjectSettings.set("godot_live_debugger/debugger/" + de + "_is_auto_focus_pause", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger/" + de + "_is_auto_focus_pause", description)
		ProjectSettings.set_order("godot_live_debugger/debugger/" + de + "_is_auto_focus_pause", order_is_auto_focus_pause)
		_add_description_prop("godot_live_debugger/debugger/" + de + "_is_auto_focus_pause")
		ProjectSettings.save()

	# フレーム間隔
	if not ProjectSettings.has_setting("godot_live_debugger/debugger/frame_interval"):
		ProjectSettings.set("godot_live_debugger/debugger/frame_interval", frame_interval_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger/frame_interval", frame_interval_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger/frame_interval", order_frame_interval + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/debugger/frame_interval",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,60"
		})
		var description = ""
		if _is_ja:
			description = "何フレームに一度ノードをチェックするかのフレーム値です。パフォーマンスが落ちる場合は値を大きくしてください。"
		elif _is_ko:
			description = "노드를 확인할 프레임 값입니다. 성능이 떨어지는 경우 값이 커지도록 설정하십시오."
		else:
			description = "Frame value to check the node. If game performance is degraded, increase the value."
		
		ProjectSettings.set("godot_live_debugger/debugger/" + de + "_frame_interval", description)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger/" + de + "_frame_interval", description)
		ProjectSettings.set_order("godot_live_debugger/debugger/" + de + "_frame_interval", order_frame_interval)
		_add_description_prop("godot_live_debugger/debugger/" + de + "_frame_interval")
		ProjectSettings.save()

	# コンソールログ
	if not ProjectSettings.has_setting("godot_live_debugger/editor/is_output_console_log"):
		ProjectSettings.set("godot_live_debugger/editor/is_output_console_log", is_output_console_log_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/is_output_console_log", is_output_console_log_initial_value)
		ProjectSettings.set_order("godot_live_debugger/editor/is_output_console_log", order_is_output_console_log + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/editor/is_output_console_log",
		"type": TYPE_BOOL
		})
		var description = ""
		if _is_ja:
			description = "このアドオンがコンソールログに出力するか"
		elif _is_ko:
			description = "이 애드온이 콘솔 로그에 출력하는지 여부"
		else:
			description = "Whether this add-on outputs to the console log"
		
		ProjectSettings.set("godot_live_debugger/editor/" + de + "_is_output_console_log", description)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/" + de + "_is_output_console_log", description)
		ProjectSettings.set_order("godot_live_debugger/editor/" + de + "_is_output_console_log", order_is_output_console_log)
		_add_description_prop("godot_live_debugger/editor/" + de + "_is_output_console_log")
		ProjectSettings.save()
	_is_output_console_log = ProjectSettings.get_setting("godot_live_debugger/editor/is_output_console_log") as bool
	
	# 無視するスクリプトパス
	if not ProjectSettings.has_setting("godot_live_debugger/editor/ignore_script_paths"):
		ProjectSettings.set("godot_live_debugger/editor/ignore_script_paths", ignore_script_paths_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/ignore_script_paths", ignore_script_paths_initial_value)
		ProjectSettings.set_order("godot_live_debugger/editor/ignore_script_paths", order_ignore_script_paths + 1)
		ProjectSettings.add_property_info({
		"name": "godot_live_debugger/editor/ignore_script_paths",
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": "String"
		})
		var description = ""
		if _is_ja:
			description = "無視するスクリプトパス"
		elif _is_ko:
			description = "무시할 스크립트 경로"
		else:
			description = "Ignore script paths"
		
		ProjectSettings.set("godot_live_debugger/editor/" + de + "_ignore_script_paths", description)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/" + de + "_ignore_script_paths", description)
		ProjectSettings.set_order("godot_live_debugger/editor/" + de + "_ignore_script_paths", order_ignore_script_paths)
		_add_description_prop("godot_live_debugger/editor/" + de + "_ignore_script_paths")
		ProjectSettings.save()

	# Autoloadシングルトンにデバッガを追加するか
	if not ProjectSettings.has_setting("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton"):
		ProjectSettings.set("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton", is_add_debugger_to_autoload_singleton_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton", is_add_debugger_to_autoload_singleton_initial_value)
		ProjectSettings.set_order("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton", order_is_add_debugger_to_autoload_singleton + 1)
		ProjectSettings.add_property_info({
			"name": "godot_live_debugger/editor/is_add_debugger_to_autoload_singleton",
			"type": TYPE_BOOL
		})
		var description = ""
		if _is_ja:
			description = "Autoloadシングルトンに Live Debugger ノードを追加するか"
		elif _is_ko:
			description = "Autoload 싱글톤에 Live Debugger 노드를 추가할 것인가"
		else:
			description = "Whether to add the Live Debugger node to the Autoload singleton"

		ProjectSettings.set("godot_live_debugger/editor/" + de + "_is_add_debugger_to_autoload_singleton", description)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/" + de + "_is_add_debugger_to_autoload_singleton", description)
		ProjectSettings.set_order("godot_live_debugger/editor/" + de + "_is_add_debugger_to_autoload_singleton", order_is_add_debugger_to_autoload_singleton)
		_add_description_prop("godot_live_debugger/editor/" + de + "_is_add_debugger_to_autoload_singleton")
		
		add_autoload_singleton("LiveDebugger", NODE_LIVE_DEBUGGER_TSCN_PATH)#initial_value
		
		ProjectSettings.save()
		
	if not ProjectSettings.has_setting("godot_live_debugger/debugger/display_float_decimal"):
		ProjectSettings.set("godot_live_debugger/debugger/display_float_decimal", display_float_decimal_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/debugger/display_float_decimal", display_float_decimal_initial_value)
		ProjectSettings.set_order("godot_live_debugger/debugger/display_float_decimal", order_display_float_decimal + 1)
		ProjectSettings.add_property_info({
			"name": "godot_live_debugger/debugger/display_float_decimal",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,10"
		})
		var description = ""
		if _is_ja:
			description = "floatの表示桁数"
		elif _is_ko:
			description = "float의 표시 자릿수"
		
		if _is_ja or _is_ko:
			ProjectSettings.set("godot_live_debugger/debugger/" + de + "_display_float_decimal", description)
			ProjectSettings.set_initial_value("godot_live_debugger/debugger/" + de + "_display_float_decimal", description)
			ProjectSettings.set_order("godot_live_debugger/debugger/" + de + "_display_float_decimal", order_display_float_decimal)
			_add_description_prop("godot_live_debugger/debugger/" + de + "_display_float_decimal")
		ProjectSettings.save()

	if not ProjectSettings.has_setting("godot_live_debugger/editor/is_update_when_save_external_data"):
		ProjectSettings.set("godot_live_debugger/editor/is_update_when_save_external_data", is_update_when_save_external_data_initial_value)
		ProjectSettings.set_initial_value("godot_live_debugger/editor/is_update_when_save_external_data", is_update_when_save_external_data_initial_value)
		ProjectSettings.set_order("godot_live_debugger/editor/is_update_when_save_external_data", order_is_update_when_save_external_data + 1)
		ProjectSettings.add_property_info({
			"name": "godot_live_debugger/editor/is_update_when_save_external_data",
			"type": TYPE_BOOL
		})
		var description = ""
		if _is_ja:
			description = "外部データ保存時に自動更新するか"
		elif _is_ko:
			description = "외부 데이터 저장시 자동 업데이트 여부"
		
		if _is_ja or _is_ko:
			ProjectSettings.set("godot_live_debugger/editor/" + de + "_is_update_when_save_external_data", description)
			ProjectSettings.set_initial_value("godot_live_debugger/editor/" + de + "_is_update_when_save_external_data", description)
			ProjectSettings.set_order("godot_live_debugger/editor/" + de + "_is_update_when_save_external_data", order_is_update_when_save_external_data)
			_add_description_prop("godot_live_debugger/editor/" + de + "_is_update_when_save_external_data")
		ProjectSettings.save()
	
	before_is_add_debugger_to_autoload_singleton = ProjectSettings.get_setting("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton")

func _add_description_prop(disp_prop_name:String):
	ProjectSettings.add_property_info({
		"name": disp_prop_name,
		"type": TYPE_STRING,
	})

func _on_changed_project_settings():
	# Autoloadへの登録の切り替え
	if not ProjectSettings.has_setting("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton"):
		ProjectSettings.set_setting("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton", false)
	var current_is_add_debugger_to_autoload_singleton = ProjectSettings.get_setting("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton")
	
	if before_is_add_debugger_to_autoload_singleton != current_is_add_debugger_to_autoload_singleton:
		before_is_add_debugger_to_autoload_singleton = current_is_add_debugger_to_autoload_singleton
		if current_is_add_debugger_to_autoload_singleton:
			add_autoload_singleton("LiveDebugger", NODE_LIVE_DEBUGGER_TSCN_PATH)
		else:
			remove_autoload_singleton("LiveDebugger")

func _save_external_data():
	update()

func _exit_tree() -> void:
	remove_tool_menu_item("Update LiveDebugger Data")
	if ProjectSettings.has_setting("autoload/LiveDebugger"):
		remove_autoload_singleton("LiveDebugger")
	
	#var de = ""
	#if _is_ja:
		#de = "↓説明"
	#elif _is_ko:
		#de = "↓설명"
	#else:
		#de = "↓Description"
	#
	#ProjectSettings.clear("godot_live_debugger/debugger_window/debugger_window_position_type")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_type")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/is_debugger_window_height_adjust_monitor_height")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/" + de + "_is_debugger_window_height_adjust_monitor_height")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/debugger_window_position_offset")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/" + de + "_debugger_window_position_offset")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/debugger_window_size")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/" + de + "_debugger_window_size")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/debugger_window_absolute_position")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/" + de + "_debugger_window_absolute_position")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/always_on_top")
	#ProjectSettings.clear("godot_live_debugger/debugger_window/" + de + "_always_on_top")
	#ProjectSettings.clear("godot_live_debugger/debugger/is_auto_focus_pause")
	#ProjectSettings.clear("godot_live_debugger/debugger/" + de + "_is_auto_focus_pause")
	#ProjectSettings.clear("godot_live_debugger/debugger/frame_interval")
	#ProjectSettings.clear("godot_live_debugger/debugger/" + de + "_frame_interval")
	#ProjectSettings.clear("godot_live_debugger/editor/is_output_console_log")
	#ProjectSettings.clear("godot_live_debugger/editor/" + de + "_is_output_console_log")
	#ProjectSettings.clear("godot_live_debugger/editor/ignore_script_paths")
	#ProjectSettings.clear("godot_live_debugger/editor/" + de + "_ignore_script_paths")
	#ProjectSettings.clear("godot_live_debugger/editor/is_add_debugger_to_autoload_singleton")
	#ProjectSettings.clear("godot_live_debugger/editor/" + de + "_is_add_debugger_to_autoload_singleton")
	#ProjectSettings.clear("godot_live_debugger/debugger/display_float_decimal")
	#ProjectSettings.clear("godot_live_debugger/editor/" + de + "_display_float_decimal")
	#ProjectSettings.clear("godot_live_debugger/editor/is_update_when_save_external_data")
	#ProjectSettings.clear("godot_live_debugger/editor/" + de + "_is_update_when_save_external_data")
	#return

func update():
	var is_ja:bool = EditorInterface.get_editor_settings()\
		.get_setting("interface/editor/editor_language")\
		.contains("ja")
	var is_ko:bool = EditorInterface.get_editor_settings()\
		.get_setting("interface/editor/editor_language")\
		.contains("ko")

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
		
		var line_count:int = 0
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
					var colon_index = var_name.find(":")
					if colon_index != -1:
						var_result = var_name.substr(0, var_name.find(":")).replace(" ","")
					if var_result == "":
						#var\sの後ろの文字列の最初の空白文字までを取得
						var_result = var_name.substr(0, var_name.find(" "))
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
						if _is_output_console_log:
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
						if _is_output_console_log:
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
				
				# 特定のノード名以外は無視する用
				# #@DebugNode(NodeName1,NodeName2)
				if line.begins_with("#@debugnode") or line.begins_with("#@DebugNode") or line.begins_with("#@DEBUG_NODE")\
				:
					debug_info = {}
					debug_info["path"] = path
					
					#()の中を取得する
					var reg_results = regex_maru_kakko.search_all(line)
					#print("regex_maru_kakko ",result)
					if not reg_results.is_empty():
						for result in reg_results:
							var maru_kakko:String = result.get_string().trim_prefix("(").trim_suffix(")")
							
							if maru_kakko == "":continue#空かっこは無視、[func_name()]の関数かっこも無視
							debug_info["debugnode"] = maru_kakko.split("/")
					results.append(debug_info)
				
				elif line.begins_with("#@debug") or line.begins_with("#@Debug") or line.begins_with("#@DEBUG")\
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
							var maru_kakko:String = result.get_string().trim_prefix("(").trim_suffix(")")
							
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
							if _is_output_console_log:
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
	var funcs_count = results.filter(func(d): return d.has("func")).size()
	
	if _is_output_console_log:
		if is_ja:
			print_rich("[godot_live_debugger][color=LIME_GREEN][b]全てのスクリプト情報を更新しました。対象スクリプトgdの数="+str(script_file_count)+", 対象プロパティの数=" + str(props_count) + ", 対象関数の数=" + str(funcs_count) + "[/b][/color]")
		elif is_ko:
			print_rich("[godot_live_debugger][color=LIME_GREEN][b]모든 스크립트 정보를 업데이트했습니다. 대상 스크립트 gd 수="+str(script_file_count)+", 대상 프로퍼티 수=" + str(props_count) + ", 대상 함수 수=" + str(funcs_count) + "[/b][/color]")
		else:
			print_rich("[godot_live_debugger][color=LIME_GREEN][b]All scripts Informations updated. Debug script gd count="+str(script_file_count)+", Debug property count=" + str(props_count) + ", Debug function count=" + str(funcs_count) + "[/b][/color]")

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
	
	_ignore_paths = Array(ProjectSettings.get_setting("godot_live_debugger/editor/ignore_script_paths"), TYPE_STRING,&"",null)
	
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
				var filepath:String = dir.get_current_dir().path_join(file_name)
				if _ignore_paths.find(filepath) == -1:
					scripts.append(filepath)
		file_name = dir.get_next()
