# godot-live-debugger

This is a Godot addon in development.

これは開発中のGodotアドオンです。

READMEは書きかけです。ProjectSettingsとかまだ書いてない

README is a work in progress. I haven't written ProjectSettings yet.

A high-level window for debugging game status.

You can monitor the properties of the nodes you want to view and edit their values.

You can edit it as the game window updates in real time as you run it.

You can check variables such as game progress without interfering with operations.

ゲームステータスのデバッグのための高レベルウィンドウです。

表示したいノードのプロパティを監視したり、値を編集したりできます。

ゲーム ウィンドウを実行するとリアルタイムで更新されるので、編集できます。

操作を妨げずにゲーム進行などの変数を確認できます。

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

