# Live Debugger

[日本語READMEはこちら japanese readme is here](#jpreadme)

[한국어 README korean readme is here](#koreadme)

Live Debugger is Godot 4 addon.

A high-level window for debugging game status. 

You can monitor and edit the properties of nodes you want to display. 

It updates in real-time when you run the game window, so you can edit it.

You can check node status such as game progress without interfering with game debug play.

![image](https://github.com/folt-a/godot-live-debugger/assets/32963227/785a2186-7db4-4932-88a1-0e0c2a0cfc9f)


https://github.com/folt-a/godot-live-debugger/assets/32963227/34007610-16cc-4119-96eb-e75c755f1413


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

- Always on top
- Show when main window focused
- None

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

Script paths to ignore

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

---

# jpreadme
# Live Debugger 日本語README （Japanese translation README）

ゲームステータスのデバッグのための高レベルウィンドウです。

表示したいノードのプロパティを監視したり、値を編集したりできます。

ゲーム ウィンドウを実行するとリアルタイムで更新されるので、編集できます。

操作を妨げずにゲーム進行などの変数を確認できます。

![image](https://github.com/folt-a/godot-live-debugger/assets/32963227/479576e4-a448-4df9-9853-03a0d39c6f79)

https://github.com/folt-a/godot-live-debugger/assets/32963227/34007610-16cc-4119-96eb-e75c755f1413

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

- Always on top :常に最前面に表示します。
- Show when main window focused :ゲームのメインウィンドウをフォーカスしたときに前にでてきます。
- None :しません。

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

無視するスクリプトパス

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

---

# koreadme
# Live Debugger 한국어 README （Korean translation README）

게임 상태를 디버깅하기 위한 고수준 윈도우입니다.

표시하고 싶은 노드의 속성을 모니터링하거나 값을 편집할 수 있습니다.

게임 윈도우를 실행하면 실시간으로 업데이트되므로 편집할 수 있습니다.

조작을 방해하지 않고 게임 진행 등의 변수를 확인할 수 있습니다.

![image](https://github.com/folt-a/godot-live-debugger/assets/32963227/01bfb9a3-9af8-45d9-aefc-501c33f74f75)

https://github.com/folt-a/godot-live-debugger/assets/32963227/34007610-16cc-4119-96eb-e75c755f1413

## 설치 및 사용 방법

1. 다운로드 또는 Git 클론을 통해 로컬 PC에 넣습니다.

2. addons/godot-live-debugger가 되도록 당신의 Godot 프로젝트로 이동/복사합니다.

3. Godot의 "프로젝트 설정" → "플러그인"에서 godot-live-debugger를 ✅합니다.

4. 자동으로 "자동 로드"에 LiveDebugger 씬이 등록되어 있습니다.

5. 아래와 같이 모니터링하고 싶은 노드의 스크립트에 설정을 합니다.

6. 게임을 시작합니다.


## 스크립트 설정

```gdscript

#@Debug 주석 바로 아래의 속성을 모니터링 대상으로 합니다.

#@Debug
var property_1:int = 300

#---

# 함수를 지정할 수도 있습니다. _process에서 매 프레임 호출되므로 주의하세요.

#@Debug
func get_str():
	return "abc"

#---

# 「」나 ''로 보기 좋게 표시를 위한 이름을 붙일 수도 있습니다.

#@Debug'alias_name'
var property_2:String = ""

#@Debug「別名」

#---

# 카테고리를 붙일 수 있습니다. 트리 아이템을 접을 수 있습니다.

#@Debug(category_name)
var property_3:Vector2 = Vector2.ZERO

#---

# 카테고리는 슬래시 /로 하위 카테고리로 만들 수 있습니다. 접기 가능.

#@Debug(cate1/nested_category2)
var property_4:Vector3 = Vector3.ZERO

#---

# 속성 이름 지정으로 속성을 지정할 수도 있습니다.

#@Debug[position]

#---

# 속성 이름 지정으로 다른 노드의 속성을 지정할 수도 있습니다. 단, 모니터링만 가능하고 편집은 불가능합니다.

#@Debug[./ChildNode:position]

# 내부 처리에서는 : 앞까지 get_node()하므로 %도 사용 가능합니다.

#@Debug[%ChildNode:position]

#---

# {}로 보기 좋게 색상을 지정할 수 있습니다.

#@Debug{#RED}
var property_5:StringName = &""

#@Debug{#f0f0f0}
var property_6:bool = false

#---


# 여러 지정도 가능합니다. 순서는 상관없습니다.

#@Debug(cate)'alias'{#RED}
var property_7:int = 123

#@Debug{#f0f0f0}
var property_8:bool = false

#---

# #@Debug 대신 #@Call로 함수를 지정하면 버튼이 표시되고, 누르면 해당 함수를 실행합니다. 모니터링 대상으로 하지 않습니다.
# 함수의 return 결과가 값으로 표시됩니다. 인수 1개를 값으로 입력하여 실행할 수도 있습니다.

#@Call
func play() -> String:
	animation_player.play()
	return anim_name

#@Call
func play_animation(anim_name:StringName) -> String:
	animation_player.play(anim_name)
	return anim_name


```

## Project Settings 프로젝트 설정

### Debug Window 디버그 윈도우 설정

* always_on_top

디버거 윈도우를 항상 최상위에 표시

- Always on top : 항상 맨 앞면에 표시합니다.
- Show when main window focused : 게임의 메인 윈도우를 포커스 할 때 앞으로 나옵니다.
- None : None.

* debugger_window_position_type

디버거 윈도우의 위치 종류

- 디버거 윈도우의 위치 종류
- 게임 왼쪽 인접
- 화면 오른쪽 인접
- 화면 왼쪽 인접
- 절대 위치 지정

* is_debugger_window_height_adjust_monitor_height

디버거 윈도우의 높이를 모니터의 높이에 맞출지 여부

윈도우의 높이가 모니터 전체까지 늘어납니다.
debugger_window_size의 Y를 무시합니다.
debugger_window_position_offset의 Y를 이동하여 위치를 내리면 그만큼 작아집니다.

절대 위치 지정일 경우 무시됩니다.

* debugger_window_position_offset

디버거 윈도우 위치의 오프셋 (위치 이동)

윈도우의 위치를 이동합니다.

절대 위치 지정일 경우 무시됩니다.

* debugger_window_absolute_position

디버거 윈도우의 절대 위치

절대 위치 지정일 경우에만 유효합니다.

멀티 모니터일 경우 모든 모니터 위치가 영향을 미치므로 화면 밖으로 튀어나가기 쉽습니다. 주의하세요.

* debugger_window_size

디버거 윈도우의 크기

is_debugger_window_height_adjust_monitor_height가 켜져 있을 경우 Y는 무시됩니다.

### Debugger 디버거 설정

* frame_interval
 
몇 프레임마다 노드를 체크할지에 대한 프레임 값입니다.

성능이 떨어질 경우 값을 크게 해주세요.

기본값은 1이므로 매 프레임입니다.

* is_auto_focus_pause

디버거 윈도우에 포커스되었을 때 자동으로 게임의 SceneTree를 일시 정지합니다.

* display_float_decimal

float의 표시 자릿수 제한입니다.

표시만 제한되므로, 그 이상의 자릿수를 입력하여 반영시키면 제대로 반영됩니다. 표시 자릿수는 제한됩니다.

기본값은 2자리입니다. 1.123456 → 1.12로 표시됩니다.

* is_output_console_log

이 애드온이 콘솔 로그에 로그를 출력할지 여부

끄면 이 애드온은 print하지 않습니다.

외부 데이터 업데이트 시 모든 스크립트를 체크하여 대상을 찾으므로 로그가 매번 출력됩니다.

* ignore_script_paths

무시할 스크립트 경로

* is_add_debugger_to_autoload_singleton

"자동 로드" (Autoload 싱글톤)에 Live Debugger 노드를 추가할지 여부

켜면 등록됩니다. 끄면 등록 해제됩니다.

프로젝트의 "자동 로드"에서 추가/삭제해도 됩니다.

이 애드온은 어디에 두어도 모든 노드를 체크합니다.

특정 씬만 체크하고 싶은 경우 LiveDebugger.tscn 씬을 노드로서 트리에 추가할 수도 있습니다.

* is_update_when_save_external_data

외부 데이터 저장 시 자동 업데이트 여부

외부 업데이트 시 모든 스크립트를 체크하여 대상을 찾습니다.

무언가 업데이트할 때마다 호출되므로 무거워질 경우 꺼주세요.

그 경우 대신에

"프로젝트" → "도구" → "Update LiveDebugger Data"를 실행해주세요.

## Contributing 기여

요청, 제안, 버그 리포트를 해주세요.

이슈, 풀 리퀘스트 등 기다리고 있습니다.

## License 라이선스

MIT 라이선스입니다.

# Donate 기부

편리하다고 생각되면 부탁드립니다.
