# Live Debugger

Live Debugger is Godot 4 addon.

A high-level window for debugging game status. 

You can monitor and edit the properties of nodes you want to display. 

It updates in real-time when you run the game window, so you can edit it.

You can check node status such as game progress without interfering with game debug play.

## Installation and Usage

1. Download or clone the repository to your local PC.

2. Move/copy it to your Godot project so that it becomes addons/godot-live-debugger.

3. In Godot, go to "Project Settings" → "Plugins" and check ✅ godot-live-debugger.

4. The LiveDebugger scene is automatically registered in "AutoLoad".

5. Set up the script of the node you want to monitor as shown below.

6. Launch the game.

```gdscript

# Property directly below #@Debug will be monitored

#@Debug
var property_1:int = 300

#---

# function too.
# Note that _process is called every frame.

#@Debug
func get_str():
	return "abc"

#---

# alias name surrounded ''

#@Debug'alias_name'
var property_2:String = ""

#@Debug「別名」

#---

# assign categories. Tree items can be collapsed. Tree Node.

#@Debug(category_name)
var property_3:Vector2 = Vector2.ZERO

#---

# Categories can be made into subcategories with /.

#@Debug(cate1/nested_category2)
var property_4:Vector3 = Vector3.ZERO

#---

# specify properties by property name

#@Debug[position]

#---

# another node's properyy by property name.
# However, it can only be monitored and cannot be edited.

#@Debug[./ChildNode:position]

# Internally, get_node() is used up to the : character, 
# so % can also be used.

#@Debug[%ChildNode:position]

#---

# You can assign colors for better readability using {}.

#@Debug{#RED}
var property_5:StringName = &""

#@Debug{#f0f0f0}
var property_6:bool = false

#---


# Multiple settings

#@Debug(cate)'alias'{#RED}
var property_7:int = 123

#@Debug{#f0f0f0}
var property_8:bool = false

#---

# function with #@Call instead of #@Debug, a button will appear.
# when pressed, execute that function. It will not be monitored.
# The result of the function return is displayed in the value.
# You can also execute it by edit string as argument 1.

#@Call
func play() -> String:
	animation_player.play()
	return anim_name

#@Call
func play_animation(anim_name:StringName) -> String:
	animation_player.play(anim_name)
	return anim_name

```

## Project Settings

### Debug Window

* always_on_top

Always display the debugger window on top

* debugger_window_position_type

- Adjacent to game on the right
- Adjacent to game on the left
- Adjacent to screen on the right
- Adjacent to screen on the left
- Absolute position

* is_debugger_window_height_adjust_monitor_height

Whether to adjust the height of the debugger window to the monitor height

The window height will extend to the full monitor height.

Ignores the Y value of debugger_window_size.

If you lower the position by offsetting the Y value of debugger_window_position_offset, it will become smaller by that amount.

Ignored when using absolute position.

* debugger_window_position_offset

Offset of the debugger window position (shift position)
Shifts the window position.

Ignored when using absolute position.

*debugger_window_absolute_position

Absolute position of the debugger window Only valid when using absolute position.

In the case of multi-monitors, all monitor positions will affect it, so it tends to extend off the screen. Be careful.

* debugger_window_size

Size of the debugger window The Y value is ignored if is_debugger_window_height_adjust_monitor_height is on.

## Debugger Settings

* frame_interval

Frame value for how often to check nodes.

If performance drops, increase this value.

Default:1, so every frame.

* is_auto_focus_pause

Automatically pauses the game's SceneTree when the debugger window is focused

* display_float_decimal

Limit on the number of decimal places displayed for floats.

It's only for display, so if you input more digits and reflect it, it will be properly reflected. 

The display digits are limited.

Default:2 digits.

1.123456 → Displayed as 1.12

* is_output_console_log

Whether this addon outputs logs to the console

If off, this addon will not print.

Logs will appear every time it checks all scripts to find targets when updating external data.

* ignore_script_paths

Script paths to ignore (* can be used for wildcard specification)

* is_add_debugger_to_autoload_singleton

Whether to add the Live Debugger node to "AutoLoad" (Autoload singleton)

If on, it will be registered. If off, it will be unregistered.

You can also add or remove it from the project's "AutoLoad".

This addon will check all nodes regardless of where it is placed.

If you want to check only specific scenes, you can also add the LiveDebugger.tscn scene as a node in the tree.

* is_update_when_save_external_data

Whether to automatically update when saving external data

When external data is updated, it checks all scripts to find targets.

It is called every time something is updated, so turn it off if it becomes low performance.

In that case, execute "Project" → "Tools" → "Update LiveDebugger Data" instead.


## Contributing
Contributions are welcome! 

If you have any suggestions, bug reports, or improvements, feel free to submit a pull request or open an issue on the repository.

## License

MIT License.

# Donate

If this addon helped you develop your game project, please donate.

# Live Debugger 日本語README （Japanese translation README）

ゲームステータスのデバッグのための高レベルウィンドウです。

表示したいノードのプロパティを監視したり、値を編集したりできます。

ゲーム ウィンドウを実行するとリアルタイムで更新されるので、編集できます。

操作を妨げずにゲーム進行などの変数を確認できます。

## インストール、使い方

1. downloadかGitのcloneをしてローカルPCに入れます。

2. addons/godot-live-debugger となるようにあなたのGodotプロジェクトに移動/コピーします。

3. Godot 「プロジェクト設定」→「プラグイン」で**godot-live-debugger**を✅します。

4. 自動的に「自動読み込み」に **LiveDebugger** シーンが登録されています。

5. ↓のように監視したいノードのスクリプトに設定をします。

6. ゲームを起動します。


## スクリプトへの設定

```gdscript

# 特定のコメント #@Debug の直下のプロパティを監視対象にします

#@Debug
var property_1:int = 300

#---

# 関数を指定することもできます。_processで毎フレーム呼び出されるので注意。

#@Debug
func get_str():
	return "abc"

#---

# 「」か''で見やすいように表示のための名前をつけることもできます。

#@Debug'alias_name'
var property_2:String = ""

#@Debug「別名」

#---

# カテゴリをつけることができます。ツリーアイテムの折りたたみができます。

#@Debug(category_name)
var property_3:Vector2 = Vector2.ZERO

#---

# カテゴリはスラッシュ/でサブカテゴリにできます。折りたたみ。

#@Debug(cate1/nested_category2)
var property_4:Vector3 = Vector3.ZERO

#---

# プロパティ名指定でプロパティを指定することもできます

#@Debug[position]

#---

# プロパティ名指定で別のノードのプロパティを指定することもできます。ただし監視のみで編集不可能です。

#@Debug[./ChildNode:position]

# 内部処理では:の前までをget_node()しているので%も使用できます。

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

#@Call
func play() -> String:
	animation_player.play()
	return anim_name

#@Call
func play_animation(anim_name:StringName) -> String:
	animation_player.play(anim_name)
	return anim_name


```

## Project Settings プロジェクトの設定

### Debug Window デバッグウィンドウの設定

* always_on_top

デバッガウィンドウで常に最前面に表示

* debugger_window_position_type

デバッガーのウィンドウの位置の種別

- ゲーム右隣接
- ゲーム左隣接
- 画面右隣接
- 画面左隣接
- 絶対位置指定

* is_debugger_window_height_adjust_monitor_height

デバッガーのウィンドウの高さをモニターの高さに合わせるか

ウィンドウの高さがモニターいっぱいまで伸びます。
debugger_window_sizeのYを無視します。
debugger_window_position_offsetのYをずらして位置を下げるとそのぶん小さくなります

絶対位置指定の場合は無視されます。

* debugger_window_position_offset

デバッガーのウィンドウの位置のオフセット（位置をずらす）

ウィンドウの位置をずらします。 

絶対位置指定の場合は無視されます。

* debugger_window_absolute_position

デバッガーのウィンドウの絶対位置

絶対位置指定の場合のみ有効です。

マルチモニターの場合はすべてのモニター位置が影響するので、画面外に飛び出しがち。注意。

* debugger_window_size

デバッガーのウィンドウのサイズ

is_debugger_window_height_adjust_monitor_heightがオンの場合はYは無視されます。

### デバッガー設定

* frame_interval
 
何フレームに一度ノードをチェックするかのフレーム値です。

パフォーマンスが落ちる場合は値を大きくしてください。  

デフォルトは1なので毎フレームです。

* is_auto_focus_pause

デバッガーウィンドウをフォーカスしたときに自動的にゲームのSceneTreeをpausedにします  

* display_float_decimal

floatの表示桁数の制限です。

表示だけなので、それ以上の桁数を入力して反映させるとちゃんと反映されます。表示桁数は制限されます。

デフォルトは2桁です。 1.123456 → 1.12　と表示されます

* is_output_console_log

このアドオンがコンソールログにログを出力するか  

オフにするとこのアドオンはprintしなくなります。

外部データ更新時に全スクリプトをチェックして対象を探すので、ログが毎回でます。

* ignore_script_paths

無視するスクリプトパス(*でワイルドカード指定可能)  

* is_add_debugger_to_autoload_singleton

「自動読み込み」（Autoloadシングルトン）に Live Debugger ノードを追加するか  

オンにすると登録されます。オフにすると登録解除されます。

プロジェクトの「自動読み込み」から追加削除してもかまいません。

このアドオンはどこに置いてもすべてのノードをチェックします。

特定のシーンだけチェックしたい場合は`LiveDebugger.tscn`シーンをノードとしてツリーに追加することもできます。

* is_update_when_save_external_data

外部データ保存時に自動更新するか  

外部データ更新時に全スクリプトをチェックして対象を探します。

なにか更新するたびに呼ばれてしまうので、重くなる場合はオフにしてください。

その場合は、代わりに

「プロジェクト」→「ツール」→「Update LiveDebugger Data」を実行してください。

## Contributing

要望・提案・バグレポートください。

Issue, PullRequestなどお待ちしております。

（全部対応できるとは限りません）

## License

MITライセンスです。

# 寄付

便利だなあとなったらどうぞお願いします