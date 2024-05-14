# godot-live-debugger

This is a Godot addon in development.

これは開発中のGodotアドオンです。

READMEは書きかけです。

README is a work in progress.

A high-level window for debugging game status.

You can monitor the properties of the nodes you want to view and edit values.

You can edit it as the game window updates in real time as you run it.

You can check variables such as game progress without interfering with operations.

ゲームステータスのデバッグのための高レベルウィンドウです。

表示したいノードのプロパティを監視したり、値を編集したりできます。

ゲーム ウィンドウを実行するとリアルタイムで更新されるので、編集できます。

操作を妨げずにゲーム進行などの変数を確認できます。

[https://x.com/Faultun/status/1790061378310385668](https://x.com/Faultun/status/1790061378310385668)

```gdscript

# 特定のコメント #@Debug の直下のプロパティを監視対象にします
# Monitor the property directly under the specific comment #@Debug

#@Debug
var property_1:int = 300

#---

# 関数を指定することもできます。_processで毎フレーム呼び出されるので注意。
# You can also specify a function.
# Note that _process is called every frame.

#@Debug
func get_str():
	return "abc"

#---

# 「」か''で見やすいように表示のための名前をつけることもできます。
# alias

#@Debug'alias_name'
var property_2:String = ""

#@Debug「別名」

#---

# カテゴリをつけることができます。ツリーアイテムの折りたたみができます。
# add categories. Tree items can be folded/expand. Tree Node.

#@Debug(category_name)
var property_3:Vector2 = Vector2.ZERO

#---

# カテゴリはスラッシュ/でサブカテゴリにできます。折りたたみ。
# Categories can be made into subcategories with /.

#@Debug(cate1/nested_category2)
var property_4:Vector3 = Vector3.ZERO

#---

# プロパティ名指定でプロパティを指定することもできます
# You can also specify the property by specifying the property name.

#@Debug[position]

#---

# プロパティ名指定で別のノードのプロパティを指定することもできます。ただし監視のみで編集不可能です。
# You can also specify the property of another node by specifying the property name.
# However, it can only be monitored and cannot be edited.

#@Debug[./ChildNode:position]

# 内部処理では:の前までをget_node()しているので%も使用できます。
# In internal processing, get_node() is performed up to the point before :,
# so % can also be used.

#@Debug[%ChildNode:position]

#---

# {} で見やすいように色ををつけることができます。

#@Debug{#RED}
var property_5:StringName = &""

#@Debug{#f0f0f0}
var property_6:bool = false

#---


# 複数の指定もできます。順不同。

#@Debug(cate)'alias'{#RED}
var property_7:int = 123

#@Debug{#f0f0f0}
var property_8:bool = false

#---

# #@Debugではなく #@Call で関数を指定すると、ボタンが表示され、押すとその関数を実行します。監視対象にはしません。
# 関数のreturnの結果が値に表示されます。　引数1を値に入力して実行することもできます。
# If you specify a function with #@Call instead of #@Debug, a button will appear and,
# when pressed, execute that function. It will not be monitored.
# The result of the function return is displayed in the value.
# You can also execute it by entering argument 1 as the value.

#@Call
func play() -> String:
	animation_player.play()
	return anim_name

#@Call
func play_animation(anim_name:StringName) -> String:
	animation_player.play(anim_name)
	return anim_name


```

# Project Settings

* is_output_console_log

ja:このアドオンがコンソールログに出力するか  
ko:이 애드온이 콘솔 로그에 출력하는지 여부  
en:Whether this add-on outputs to the console log

* frame_interval
 
ja:何フレームに一度ノードをチェックするかのフレーム値です。パフォーマンスが落ちる場合は値を大きくしてください。  
ko:노드를 확인할 프레임 값입니다. 성능이 떨어지는 경우 값이 커지도록 설정하십시오.  
en:Frame value to check the node. If game performance is degraded, increase the value.

* always_on_top

ja:常に最前面に表示  
ko:항상 최상위에 표시  
en:Always on top

* is_auto_focus_pause

ja:LiveDebuggerをフォーカスしたときに自動的にゲームのSceneTreeをpausedにします  
ko:LiveDebugger에 포커스를 맞추면 자동으로 게임의 SceneTree를 일시 중지합니다  
en:When LiveDebugger is focused, automatically pause the SceneTree of the game

* ignore_script_paths

ja:無視するスクリプトパス(*でワイルドカード指定可能)  
ko:무시할 스크립트 경로 (*로 와일드 카드 지정 가능)  
en:Ignore script paths (* can be wildcard)

* is_add_debugger_to_autoload_singleton

ja:Autoloadシングルトンに Live Debugger ノードを追加するか  
ko:Autoload 싱글톤에 Live Debugger 노드를 추가할 것인가  
en:Whether to add the Live Debugger node to the Autoload singleton

* display_float_decimal

ja:floatの表示桁数  
ko:float의 표시 자릿수  
en:float display decimal

* is_update_when_save_external_data

ja:外部データ保存時に自動更新するか  
ko:외부 데이터 저장시 자동 업데이트 여부  
en:Whether to update automatically when saving external data

