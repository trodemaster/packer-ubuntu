#!/bin/bash
exit 0
declare -r XFCE_PANEL_DIRECTORY="${HOME}"'/.config/xfce4/panel'
declare -ar IP_LINKS=($(ip -brief link | sed --regexp-extended --quiet --expression='/^lo\b/! s/[[:space:]].*$//p' | sort))

declare -ar XFCE_PANELS=('TOP_PANEL' 'BOTTOM_PANEL')

declare -ar TOP_PANEL=('TOP_PANEL_PROPERTIES' 'TOP_PANEL_PLUGINS')
declare -ar BOTTOM_PANEL=('BOTTOM_PANEL_PROPERTIES' 'BOTTOM_PANEL_PLUGINS')

declare -ar TOP_PANEL_PROPERTIES=('TOP_PANEL_PROPERTIES_POSITION' 'COMMON_PANEL_PROPERTIES')
declare -ar BOTTOM_PANEL_PROPERTIES=('BOTTOM_PANEL_PROPERTIES_POSITION' 'COMMON_PANEL_PROPERTIES')

declare -ar TOP_PANEL_PROPERTIES_POSITION=(
    'PANEL_PROPERTY_POSITION_TOP'
)
declare -ar BOTTOM_PANEL_PROPERTIES_POSITION=(
    'PANEL_PROPERTY_POSITION_BOTTOM'
)
declare -ar COMMON_PANEL_PROPERTIES=(
    'PANEL_PROPERTY_AUTOHIDE_BEHAVIOR'
    'PANEL_PROPERTY_BACKGROUND_ALPHA'
    'PANEL_PROPERTY_BACKGROUND_STYLE'
    'PANEL_PROPERTY_DISABLE_STRUTS'
    'PANEL_PROPERTY_ENTER_OPACITY'
    'PANEL_PROPERTY_LEAVE_OPACITY'
    'PANEL_PROPERTY_LENGTH'
    'PANEL_PROPERTY_LENGTH_ADJUST'
    'PANEL_PROPERTY_MODE'
    'PANEL_PROPERTY_NROWS'
    'PANEL_PROPERTY_POSITION_LOCKED'
    'PANEL_PROPERTY_SIZE'
    'PANEL_PROPERTY_SPAN_MONITORS'
)

declare -ar PANEL_PROPERTY_AUTOHIDE_BEHAVIOR=('autohide-behavior' 'int' '0')
declare -ar PANEL_PROPERTY_BACKGROUND_ALPHA=('background-alpha' 'int' '80')
declare -ar PANEL_PROPERTY_BACKGROUND_STYLE=('background-style' 'int' '0')
declare -ar PANEL_PROPERTY_DISABLE_STRUTS=('disable-struts' 'bool' 'false')
declare -ar PANEL_PROPERTY_ENTER_OPACITY=('enter-opacity' 'int' '100')
declare -ar PANEL_PROPERTY_LEAVE_OPACITY=('leave-opacity' 'int' '100')
declare -ar PANEL_PROPERTY_LENGTH=('length' 'int' '100')
declare -ar PANEL_PROPERTY_LENGTH_ADJUST=('length-adjust' 'bool' 'false')
declare -ar PANEL_PROPERTY_MODE=('mode' 'int' '0')
declare -ar PANEL_PROPERTY_NROWS=('nrows' 'int' '1')
declare -ar PANEL_PROPERTY_POSITION_BOTTOM=('position' 'string' 'p=8;x=0;y=0')
declare -ar PANEL_PROPERTY_POSITION_LOCKED=('position-locked' 'bool' 'true')
declare -ar PANEL_PROPERTY_POSITION_TOP=('position' 'string' 'p=6;x=0;y=0')
declare -ar PANEL_PROPERTY_SIZE=('size' 'int' '24')
declare -ar PANEL_PROPERTY_SPAN_MONITORS=('span-monitors' 'bool' 'false')

declare -ar TOP_PANEL_PLUGINS=(
    'PANEL_PLUGIN_WHISKER_MENU'
    'PANEL_PLUGIN_APPLICATIONS_MENU'
    'PANEL_PLUGIN_PLACES'
    'PANEL_PLUGIN_DIRECTORY_MENU'
    'PANEL_PLUGIN_SCREENSHOT'
    'PANEL_PLUGIN_LAUNCHER_WEB_BROWSER'
    'PANEL_PLUGIN_LAUNCHER_HOSTS_FILE_VIEWER'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_WRITER'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_CALC'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_IMPRESS'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_DRAW'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_BASE'
    'PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_MATH'
    'PANEL_PLUGIN_SEPARATOR_EXPANDING'
    'PANEL_PLUGIN_NOTIFICATION_AREA'
    'PANEL_PLUGIN_PULSEAUDIO'
    'PANEL_PLUGIN_BATTERY'
    'PANEL_PLUGIN_WEATHER_UPDATE'
    'PANEL_PLUGIN_SEPARATOR_TRANSPARENT'
    'PANEL_PLUGIN_CLOCK'
    'PANEL_PLUGIN_ACTION_BUTTONS'
)
declare -ar BOTTOM_PANEL_PLUGINS=(
    'PANEL_PLUGIN_SHOW_DESKTOP'
    'PANEL_PLUGIN_SEPARATOR_DOTS'
    'PANEL_PLUGIN_WINDOW_MENU'
    'PANEL_PLUGIN_SEPARATOR_DOTS'
    'PANEL_PLUGIN_WINDOW_BUTTONS'
    'PANEL_PLUGIN_SEPARATOR_EXPANDING'
    'PANEL_PLUGIN_WORKSPACE_SWITCHER'
    'PANEL_PLUGIN_CPU_GRAPH'
    'PANEL_PLUGIN_NETWORK_MONITOR'
    'PANEL_PLUGIN_TRASH_APPLET'
)

declare -ar PANEL_PLUGIN_ACTION_BUTTONS=('actions' 'PluginProperties' 'ACTION_BUTTONS_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_APPLICATIONS_MENU=('applicationsmenu' 'PluginProperties' 'APPLICATIONS_MENU_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_BATTERY=('battery' 'PluginResources' 'BATTERY_PLUGIN_RESOURCES')
declare -ar PANEL_PLUGIN_CLOCK=('clock' 'PluginProperties' 'CLOCK_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_CPU_GRAPH=('cpugraph' 'PluginResources' 'CPU_GRAPH_PLUGIN_RESOURCES')
declare -ar PANEL_PLUGIN_DIRECTORY_MENU=('directorymenu' 'PluginProperties' 'DIRECTORY_MENU_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_LAUNCHER_HOSTS_FILE_VIEWER=('launcher' 'PluginLauncher' 'LAUNCHER_HOSTS_FILE_VIEWER_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_BASE=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_BASE_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_CALC=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_CALC_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_DRAW=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_DRAW_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_IMPRESS=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_IMPRESS_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_MATH=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_MATH_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_LIBREOFFICE_WRITER=('launcher' 'PluginLauncher' 'LAUNCHER_LIBREOFFICE_WRITER_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_LAUNCHER_WEB_BROWSER=('launcher' 'PluginLauncher' 'LAUNCHER_WEB_BROWSER_PLUGIN_SETUP')
declare -ar PANEL_PLUGIN_NETWORK_MONITOR=('netload' 'PluginNetLoad' 'NETWORK_MONITOR_PLUGIN_TEMPLATE_RC')
declare -ar PANEL_PLUGIN_NOTIFICATION_AREA=('systray' 'PluginProperties' 'NOTIFICATION_AREA_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_PLACES=('places' 'PluginProperties' 'PLACES_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_PULSEAUDIO=('pulseaudio' 'PluginProperties' 'PULSEAUDIO_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_SCREENSHOT=('screenshooter' 'PluginResources' '')
declare -ar PANEL_PLUGIN_SEPARATOR_DOTS=('separator' 'PluginProperties' 'SEPARATOR_DOTS_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_SEPARATOR_EXPANDING=('separator' 'PluginProperties' 'SEPARATOR_EXPANDING_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_SEPARATOR_TRANSPARENT=('separator' 'PluginProperties' 'SEPARATOR_TRANSPARENT_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_SHOW_DESKTOP=('showdesktop' '' '')
declare -ar PANEL_PLUGIN_TRASH_APPLET=('thunar-tpa' '' '')
declare -ar PANEL_PLUGIN_WEATHER_UPDATE=('weather' 'PluginResources' 'WEATHER_PLUGIN_RESOURCES')
declare -ar PANEL_PLUGIN_WHISKER_MENU=('whiskermenu' 'PluginResources' '')
declare -ar PANEL_PLUGIN_WINDOW_BUTTONS=('tasklist' 'PluginProperties' 'WINDOW_BUTTONS_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_WINDOW_MENU=('windowmenu' 'PluginProperties' 'WINDOW_MENU_PLUGIN_PROPERTIES')
declare -ar PANEL_PLUGIN_WORKSPACE_SWITCHER=('pager' 'PluginProperties' 'WORKSPACE_SWITCHER_PLUGIN_PROPERTIES')

declare -ar ACTION_BUTTONS_PLUGIN_PROPERTIES=(
    'ACTION_BUTTONS_APPEARANCE'
    'ACTION_BUTTONS_ASK_CONFIRMATION'
    'ACTION_BUTTONS_INVERT_ORIENTATION'
    'ACTION_BUTTONS_ITEMS'
)
declare -ar APPLICATIONS_MENU_PLUGIN_PROPERTIES=(
    'APPLICATIONS_MENU_BUTTON_ICON'
    'APPLICATIONS_MENU_BUTTON_TITLE'
    'APPLICATIONS_MENU_CUSTOM_MENU'
    'APPLICATIONS_MENU_CUSTOM_MENU_FILE'
    'APPLICATIONS_MENU_SHOW_BUTTON_TITLE'
    'APPLICATIONS_MENU_SHOW_GENERIC_NAMES'
    'APPLICATIONS_MENU_SHOW_MENU_ICONS'
    'APPLICATIONS_MENU_SHOW_TOOLTIPS'
)
declare -ar CLOCK_PLUGIN_PROPERTIES=(
    'CLOCK_DIGITAL_FORMAT'
    'CLOCK_FLASH_SEPARATORS'
    'CLOCK_FUZZINESS'
    'CLOCK_MODE'
    'CLOCK_SHOW_GRID'
    'CLOCK_SHOW_INACTIVE'
    'CLOCK_SHOW_MERIDIEM'
    'CLOCK_SHOW_MILITARY'
    'CLOCK_SHOW_SECONDS'
    'CLOCK_TIMEZONE'
    'CLOCK_TOOLTIP_FORMAT'
    'CLOCK_TRUE_BINARY'
)
declare -ar DIRECTORY_MENU_PLUGIN_PROPERTIES=(
    'DIRECTORY_MENU_BASE_DIRECTORY'
    'DIRECTORY_MENU_FILE_PATTERN'
    'DIRECTORY_MENU_HIDDEN_FILES'
    'DIRECTORY_MENU_ICON_NAME'
)
declare -ar NOTIFICATION_AREA_PLUGIN_PROPERTIES=(
    'NOTIFICATION_AREA_NAMES_VISIBLE'
    'NOTIFICATION_AREA_SHOW_FRAME'
    'NOTIFICATION_AREA_SIZE_MAX'
)
declare -ar PLACES_PLUGIN_PROPERTIES=(
    'PLACES_BUTTON_LABEL'
    'PLACES_MOUNT_OPEN_VOLUMES'
    'PLACES_SEARCH_CMD'
    'PLACES_SHOW_BOOKMARKS'
    'PLACES_SHOW_BUTTON_TYPE'
    'PLACES_SHOW_ICONS'
    'PLACES_SHOW_RECENT'
    'PLACES_SHOW_RECENT_CLEAR'
    'PLACES_SHOW_VOLUMES'
)
declare -ar PULSEAUDIO_PLUGIN_PROPERTIES=(
    'PULSEAUDIO_ENABLE_KEYBOARD_SHORTCUTS'
    'PULSEAUDIO_MIXER_COMMAND'
    'PULSEAUDIO_SHOW_NOTIFICATIONS'
)
declare -ar SEPARATOR_DOTS_PLUGIN_PROPERTIES=(
    'SEPARATOR_EXPAND_NO'
    'SEPARATOR_STYLE_DOTS'
)
declare -ar SEPARATOR_EXPANDING_PLUGIN_PROPERTIES=(
    'SEPARATOR_EXPAND_ON'
    'SEPARATOR_STYLE_TRANSPARENT'
)
declare -ar SEPARATOR_TRANSPARENT_PLUGIN_PROPERTIES=(
    'SEPARATOR_EXPAND_NO'
    'SEPARATOR_STYLE_TRANSPARENT'
)
declare -ar WINDOW_BUTTONS_PLUGIN_PROPERTIES=(
    'WINDOW_BUTTONS_FLAT_BUTTONS'
    'WINDOW_BUTTONS_GROUPING'
    'WINDOW_BUTTONS_INCLUDE_ALL_MONITORS'
    'WINDOW_BUTTONS_INCLUDE_ALL_WORKSPACES'
    'WINDOW_BUTTONS_MIDDLE_CLICK'
    'WINDOW_BUTTONS_SHOW_HANDLE'
    'WINDOW_BUTTONS_SHOW_LABELS'
    'WINDOW_BUTTONS_SHOW_ONLY_MINIMIZED'
    'WINDOW_BUTTONS_SHOW_WIREFRAMES'
    'WINDOW_BUTTONS_SORT_ORDER'
    'WINDOW_BUTTONS_SWITCH_WORKSPACE_ON_UNMINIMIZE'
    'WINDOW_BUTTONS_WINDOW_SCROLLING'
)
declare -ar WINDOW_MENU_PLUGIN_PROPERTIES=(
    'WINDOW_MENU_ALL_WORKSPACES'
    'WINDOW_MENU_STYLE'
    'WINDOW_MENU_URGENCY_NOTIFICATION'
    'WINDOW_MENU_WORKSPACE_ACTIONS'
    'WINDOW_MENU_WORKSPACE_NAMES'
)
declare -ar WORKSPACE_SWITCHER_PLUGIN_PROPERTIES=(
    'WORKSPACE_SWITCHER_ROWS'
    'WORKSPACE_SWITCHER_WORKSPACE_SCROLLING'
)

declare -ar ACTION_BUTTONS_APPEARANCE=('appearance' 'int' '0')
declare -ar ACTION_BUTTONS_ASK_CONFIRMATION=('ask-confirmation' 'bool' 'true')
declare -ar ACTION_BUTTONS_INVERT_ORIENTATION=('invert-orientation' 'bool' 'false')
declare -ar ACTION_BUTTONS_ITEMS=('items' 'array' 'ACTION_BUTTONS_ITEMS_ARRAY')

declare -ar APPLICATIONS_MENU_BUTTON_ICON=('button-icon' 'string' 'debian-swirl')
declare -ar APPLICATIONS_MENU_BUTTON_TITLE=('button-title' 'string' 'Applications')
declare -ar APPLICATIONS_MENU_CUSTOM_MENU=('custom-menu' 'bool' 'false')
declare -ar APPLICATIONS_MENU_CUSTOM_MENU_FILE=('custom-menu-file' 'string' '')
declare -ar APPLICATIONS_MENU_SHOW_BUTTON_TITLE=('show-button-title' 'bool' 'true')
declare -ar APPLICATIONS_MENU_SHOW_GENERIC_NAMES=('show-generic-names' 'bool' 'false')
declare -ar APPLICATIONS_MENU_SHOW_MENU_ICONS=('show-menu-icons' 'bool' 'true')
declare -ar APPLICATIONS_MENU_SHOW_TOOLTIPS=('show-tooltips' 'bool' 'true')

declare -ar CLOCK_DIGITAL_FORMAT=('digital-format' 'string' '%a %F %R')
declare -ar CLOCK_FLASH_SEPARATORS=('flash-separators' 'bool' 'false')
declare -ar CLOCK_FUZZINESS=('fuzziness' 'int' '')
declare -ar CLOCK_MODE=('mode' 'int' '2')
declare -ar CLOCK_SHOW_GRID=('show-grid' 'bool' '')
declare -ar CLOCK_SHOW_INACTIVE=('show-inactive' 'bool' '')
declare -ar CLOCK_SHOW_MERIDIEM=('show-meridiem' 'bool' '')
declare -ar CLOCK_SHOW_MILITARY=('show-military' 'bool' '')
declare -ar CLOCK_SHOW_SECONDS=('show-seconds' 'bool' '')
declare -ar CLOCK_TIMEZONE=('timezone' 'string' '')
declare -ar CLOCK_TOOLTIP_FORMAT=('tooltip-format' 'string' '%A, %-d %B %Y%t%T %Z (%z)%nDay %Y.%j%nWeek %G.%V')
declare -ar CLOCK_TRUE_BINARY=('true-binary' 'bool' '')

declare -ar DIRECTORY_MENU_BASE_DIRECTORY=('base-directory' 'string' "${HOME}")
declare -ar DIRECTORY_MENU_FILE_PATTERN=('file-pattern' 'string' '')
declare -ar DIRECTORY_MENU_HIDDEN_FILES=('hidden-files' 'bool' 'false')
declare -ar DIRECTORY_MENU_ICON_NAME=('icon-name' 'string' 'user-home')

declare -ar NOTIFICATION_AREA_NAMES_VISIBLE=('names-visible' 'array' '')
declare -ar NOTIFICATION_AREA_SHOW_FRAME=('show-frame' 'bool' 'false')
declare -ar NOTIFICATION_AREA_SIZE_MAX=('size-max' 'int' '22')

declare -ar PLACES_BUTTON_LABEL=('button-label' 'string' 'Places')
declare -ar PLACES_MOUNT_OPEN_VOLUMES=('mount-open-volumes' 'bool' 'false')
declare -ar PLACES_SEARCH_CMD=('search-cmd' 'string' '')
declare -ar PLACES_SHOW_BOOKMARKS=('show-bookmarks' 'bool' 'true')
declare -ar PLACES_SHOW_BUTTON_TYPE=('show-button-type' 'int' '2')
declare -ar PLACES_SHOW_ICONS=('show-icons' 'bool' 'true')
declare -ar PLACES_SHOW_RECENT=('show-recent' 'bool' 'true')
declare -ar PLACES_SHOW_RECENT_CLEAR=('show-recent-clear' 'bool' 'true')
declare -ar PLACES_SHOW_VOLUMES=('show-volumes' 'bool' 'true')

declare -ar PULSEAUDIO_ENABLE_KEYBOARD_SHORTCUTS=('enable-keyboard-shortcuts' 'bool' 'true')
declare -ar PULSEAUDIO_MIXER_COMMAND=('mixer-command' 'string' 'pavucontrol')
declare -ar PULSEAUDIO_SHOW_NOTIFICATIONS=('show-notifications' 'bool' 'true')

declare -ar SEPARATOR_EXPAND_NO=('expand' 'bool' 'false')
declare -ar SEPARATOR_EXPAND_ON=('expand' 'bool' 'true')
declare -ar SEPARATOR_STYLE_TRANSPARENT=('style' 'int' '0')
declare -ar SEPARATOR_STYLE_DOTS=('style' 'int' '3')

declare -ar WINDOW_BUTTONS_FLAT_BUTTONS=('flat-buttons' 'bool' 'false')
declare -ar WINDOW_BUTTONS_GROUPING=('grouping' 'int' '0')
declare -ar WINDOW_BUTTONS_INCLUDE_ALL_MONITORS=('include-all-monitors' 'bool' 'true')
declare -ar WINDOW_BUTTONS_INCLUDE_ALL_WORKSPACES=('include-all-workspaces' 'bool' 'false')
declare -ar WINDOW_BUTTONS_MIDDLE_CLICK=('middle-click' 'int' '0')
declare -ar WINDOW_BUTTONS_SHOW_HANDLE=('show-handle' 'bool' 'false')
declare -ar WINDOW_BUTTONS_SHOW_LABELS=('show-labels' 'bool' 'true')
declare -ar WINDOW_BUTTONS_SHOW_ONLY_MINIMIZED=('show-only-minimized' 'bool' 'false')
declare -ar WINDOW_BUTTONS_SHOW_WIREFRAMES=('show-wireframes' 'bool' 'false')
declare -ar WINDOW_BUTTONS_SORT_ORDER=('sort-order' 'int' '4')
declare -ar WINDOW_BUTTONS_SWITCH_WORKSPACE_ON_UNMINIMIZE=('switch-workspace-on-unminimize' 'bool' 'true')
declare -ar WINDOW_BUTTONS_WINDOW_SCROLLING=('window-scrolling' 'bool' 'false')

declare -ar WINDOW_MENU_ALL_WORKSPACES=('all-workspaces' 'bool' 'true')
declare -ar WINDOW_MENU_STYLE=('style' 'int' '1')
declare -ar WINDOW_MENU_URGENCY_NOTIFICATION=('urgentcy-notification' 'bool' 'true')
declare -ar WINDOW_MENU_WORKSPACE_ACTIONS=('workspace-actions' 'bool' 'false')
declare -ar WINDOW_MENU_WORKSPACE_NAMES=('workspace-names' 'bool' 'true')

declare -ar WORKSPACE_SWITCHER_ROWS=('rows' 'int' '1')
declare -ar WORKSPACE_SWITCHER_WORKSPACE_SCROLLING=('workspace-scrolling' 'bool' 'false')

declare -ar ACTION_BUTTONS_ITEMS_ARRAY=('string'
    '+lock-screen' '+logout-dialog' '+restart' '+shutdown' '+logout'
    '-hibernate' '-suspend' '-switch-user' '-separator' '-separator' '-separator')

declare -r BATTERY_PLUGIN_RESOURCES="$(
    cat <<-'//*EOF_QUOTED'
	display_label=false
	display_icon=false
	display_power=false
	display_percentage=true
	display_bar=true
	display_time=false
	tooltip_display_percentage=true
	tooltip_display_time=true
	low_percentage=10
	critical_percentage=5
	action_on_low=1
	action_on_critical=1
	hide_when_full=0
	colorA=#8888FF
	colorH=#00FF00
	colorL=#FFFF00
	colorC=#FF0000
	command_on_low=
	command_on_critical=
	//*EOF_QUOTED
)"

declare -r CPU_GRAPH_PLUGIN_RESOURCES="$(
    cat <<-'//*EOF_QUOTED'
	UpdateInterval=3
	TimeScale=0
	Size=32
	Mode=0
	Frame=0
	Border=0
	Bars=1
	TrackedCore=0
	Command=xfce4-taskmanager
	InTerminal=0
	StartupNotification=1
	ColorMode=0
	Foreground1=#0000ffff0000
	Foreground2=#ffff00000000
	Foreground3=#00000000ffff
	Background=#444444444444
	//*EOF_QUOTED
)"

declare -r NETWORK_MONITOR_PLUGIN_TEMPLATE_RC="$(
    cat <<-'//*EOF_QUOTED'
	Use_Label=false
	Show_Values=false
	Show_Bars=true
	Colorize_Values=false
	Color_In=#FF4F00
	Color_Out=#FFE500
	Text=
	Network_Device=
	Max_In=4096
	Max_Out=4096
	Auto_Max=true
	Update_Interval=1000
	Values_As_Bits=false
	//*EOF_QUOTED
)"
declare NETWORK_MONITOR_PLUGIN_RESOURCES

declare -r WEATHER_PLUGIN_RESOURCES="$(
    cat <<-'//*EOF_QUOTED'
	loc_name=Antwerpen, Vlaanderen
	lat=51.248329
	lon=4.757375
	msl=18
	timezone=Europe/Brussels
	cache_file_max_age=172800
	power_saving=true
	units_temperature=0
	units_pressure=0
	units_windspeed=0
	units_precipitation=0
	units_altitude=0
	model_apparent_temperature=0
	round=true
	single_row=true
	tooltip_style=1
	forecast_layout=1
	forecast_days=5
	scrollbox_animate=false
	theme_dir=/usr/share/xfce4/weather/icons/liquid
	show_scrollbox=true
	scrollbox_lines=1
	scrollbox_color=#000000000000
	scrollbox_use_color=false
	label0=3
	//*EOF_QUOTED
)"

declare -ar LAUNCHER_HOSTS_FILE_VIEWER_PLUGIN_SETUP=('LAUNCHER_HOSTS_FILE_VIEWER_PLUGIN_PROPERTIES' 'LAUNCHER_HOSTS_FILE_VIEWER_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_SETUP=('LAUNCHER_LIBREOFFICE_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_BASE_PLUGIN_SETUP=('LAUNCHER_LIBREOFFICE_BASE_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_BASE_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_CALC_PLUGIN_SETUP=('LAUNCHER_LIBREOFFICE_CALC_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_CALC_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_DRAW_PLUGIN_SETUP=('LAUNCHER_LIBREOFFICE_DRAW_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_DRAW_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_IMPRESS_PLUGIN_SETUP=('LAUNCHER_LIBREOFFICE_IMPRESS_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_IMPRESS_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_MATH_PLUGIN_SETUP=('LAUNCHER_LIBREOFFICE_MATH_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_MATH_PLUGIN_ITEMS')
declare -ar LAUNCHER_LIBREOFFICE_WRITER_PLUGIN_SETUP=('LAUNCHER_LIBREOFFICE_WRITER_PLUGIN_PROPERTIES' 'LAUNCHER_LIBREOFFICE_WRITER_PLUGIN_ITEMS')
declare -ar LAUNCHER_WEB_BROWSER_PLUGIN_SETUP=('LAUNCHER_WEB_BROWSER_PLUGIN_PROPERTIES' 'LAUNCHER_WEB_BROWSER_PLUGIN_ITEMS')

declare -ar LAUNCHER_PROPERTIES_UNSET=(
    'LAUNCHER_ARROW_POSITION_UNSET'
    'LAUNCHER_DISABLE_TOOLTIPS_UNSET'
    'LAUNCHER_MOVE_FIRST_UNSET'
    'LAUNCHER_SHOW_LABEL_UNSET'
)

declare -ar LAUNCHER_ARROW_POSITION_UNSET=('arrow-position' 'int' '')
declare -ar LAUNCHER_DISABLE_TOOLTIPS_UNSET=('disable-tooltips' 'bool' '')
declare -ar LAUNCHER_MOVE_FIRST_UNSET=('move-first' 'bool' '')
declare -ar LAUNCHER_SHOW_LABEL_UNSET=('show-label' 'bool' '')

declare -nr LAUNCHER_HOSTS_FILE_VIEWER_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_BASE_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_CALC_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_DRAW_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_IMPRESS_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_MATH_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_LIBREOFFICE_WRITER_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'
declare -nr LAUNCHER_WEB_BROWSER_PLUGIN_PROPERTIES='LAUNCHER_PROPERTIES_UNSET'

declare -ar LAUNCHER_HOSTS_FILE_VIEWER_PLUGIN_ITEMS=('LAUNCHER_HOSTS_FILE_VIEWER_ITEM')
declare -ar LAUNCHER_LIBREOFFICE_PLUGIN_ITEMS=(
    'LAUNCHER_LIBREOFFICE_ITEM'
    'LAUNCHER_LIBREOFFICE_BASE_ITEM'
    'LAUNCHER_LIBREOFFICE_CALC_ITEM'
    'LAUNCHER_LIBREOFFICE_DRAW_ITEM'
    'LAUNCHER_LIBREOFFICE_IMPRESS_ITEM'
    'LAUNCHER_LIBREOFFICE_MATH_ITEM'
    'LAUNCHER_LIBREOFFICE_WRITER_ITEM'
)
declare -ar LAUNCHER_LIBREOFFICE_BASE_PLUGIN_ITEMS=('LAUNCHER_LIBREOFFICE_BASE_ITEM')
declare -ar LAUNCHER_LIBREOFFICE_CALC_PLUGIN_ITEMS=('LAUNCHER_LIBREOFFICE_CALC_ITEM')
declare -ar LAUNCHER_LIBREOFFICE_DRAW_PLUGIN_ITEMS=('LAUNCHER_LIBREOFFICE_DRAW_ITEM')
declare -ar LAUNCHER_LIBREOFFICE_IMPRESS_PLUGIN_ITEMS=('LAUNCHER_LIBREOFFICE_IMPRESS_ITEM')
declare -ar LAUNCHER_LIBREOFFICE_MATH_PLUGIN_ITEMS=('LAUNCHER_LIBREOFFICE_MATH_ITEM')
declare -ar LAUNCHER_LIBREOFFICE_WRITER_PLUGIN_ITEMS=('LAUNCHER_LIBREOFFICE_WRITER_ITEM')
declare -ar LAUNCHER_WEB_BROWSER_PLUGIN_ITEMS=('LAUNCHER_WEB_BROWSER_ITEM')

declare -ar LAUNCHER_HOSTS_FILE_VIEWER_ITEM=('LauncherSourceString' 'LAUNCHER_HOSTS_FILE_VIEWER_SOURCE_STRING')
declare -ar LAUNCHER_LIBREOFFICE_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-startcenter.desktop')
declare -ar LAUNCHER_LIBREOFFICE_BASE_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-base.desktop')
declare -ar LAUNCHER_LIBREOFFICE_CALC_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-calc.desktop')
declare -ar LAUNCHER_LIBREOFFICE_DRAW_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-draw.desktop')
declare -ar LAUNCHER_LIBREOFFICE_IMPRESS_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-impress.desktop')
declare -ar LAUNCHER_LIBREOFFICE_MATH_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-math.desktop')
declare -ar LAUNCHER_LIBREOFFICE_WRITER_ITEM=('LauncherSourceFile' '/usr/share/applications/libreoffice-writer.desktop')
declare -ar LAUNCHER_WEB_BROWSER_ITEM=('LauncherSourceFile' '/usr/share/applications/exo-web-browser.desktop')

declare -r LAUNCHER_HOSTS_FILE_VIEWER_SOURCE_STRING="$(
    cat <<-'//*EOF_QUOTED'
	[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Hosts File Viewer
	Comment=View the /etc/hosts configuration file
	Exec=whiptail --scrolltext --textbox /etc/hosts 20 72
	Icon=text-x-preview
	//*EOF_QUOTED
)
$(
    cat <<-//*EOF_UNQUOTED
	Path=${HOME}
	//*EOF_UNQUOTED
)
$(
    cat <<-'//*EOF_QUOTED'
	Terminal=true
	StartupNotify=false
	//*EOF_QUOTED
)"

declare -r PERL_GENERATE_XFCE_DESKTOP_FILE="$(
    cat <<-'//*EOF_QUOTED'
	#!/usr/bin/perl

	use Glib ;

	$x_xfce_source = $ARGV [ 0 ] ;
	$x_xfce_dest   = $ARGV [ 1 ] ;

	$keyfile =  Glib::KeyFile -> new ;
	$keyfile -> load_from_file ( $x_xfce_source , 'G_KEY_FILE_NONE' ) ;
	$keyfile -> set_string     ( 'Desktop Entry', 'X-XFCE-Source'   , Glib -> filename_to_uri ( $x_xfce_source , undef ) ) ;

	open  OUTPUT_FILE , '>' . $x_xfce_dest   or   exit (  4 ) ;
	print OUTPUT_FILE $keyfile -> to_data  ;
	close OUTPUT_FILE ;
	//*EOF_QUOTED
)"

declare -i PANEL_COUNT=0
declare PANEL_XFCONF_PATH
declare -i PANEL_FIRST_PLUGIN

declare -i PLUGIN_COUNT=0
declare PLUGIN_XFCONF_PATH

declare -a LAUNCHER_ITEMS
declare LAUNCHER_ITEMS_DESKTOP_DIRECTORY_PATH
declare -i LAUNCHER_ITEM_DESKTOP_FILENAME_HI="$(date +'%s')"
declare -i LAUNCHER_ITEM_DESKTOP_FILENAME_LO='0'
declare LAUNCHER_ITEM_DESKTOP_FILENAME
declare LAUNCHER_ITEM_DESKTOP_FILE_FULL_PATH

function xfce_restart_panel_instance() {

    echo 'NOTE: Restarting the XFCE panel instance.'
    xfce4-panel --restart
    sleep 1

}

function xfce_open_panel() {

    PANEL_XFCONF_PATH='/panels/panel-'"$((++PANEL_COUNT))"
    PANEL_FIRST_PLUGIN="$((PLUGIN_COUNT + 1))"
    echo '      This is panel number '"${PANEL_COUNT}"', property hierarchy '"'${PANEL_XFCONF_PATH}'"'.'

}

function xfce_close_panel() {

    xfconf-query --channel 'xfce4-panel' --property '/panels' --create --force-array $(seq --format='--type int --set %.0f' --separator=' ' ${PANEL_COUNT})
    xfce_restart_panel_instance

}

function xfce_open_panel_plugin() {

    local PLUGIN_NAME="${1}"

    PLUGIN_XFCONF_PATH='/plugins/plugin-'"$((++PLUGIN_COUNT))"
    xfconf-query --channel 'xfce4-panel' --property "${PLUGIN_XFCONF_PATH}" --create --type 'string' --set "${PLUGIN_NAME}"
    echo '      This is plugin number '"${PLUGIN_COUNT}"', property hierarchy '"'${PLUGIN_XFCONF_PATH}'"', value '"'${PLUGIN_NAME}'"'.'

}

function xfce_close_panel_plugin() {

    xfconf-query --channel 'xfce4-panel' --property "${PANEL_XFCONF_PATH}"'/plugin-ids' --create --force-array $(seq --format '--type int --set %.0f' --separator=' ' ${PANEL_FIRST_PLUGIN} ${PLUGIN_COUNT})

}

function xfce_open_launcher_plugin() {

    LAUNCHER_ITEMS=()
    LAUNCHER_ITEMS_DESKTOP_DIRECTORY_PATH="${XFCE_PANEL_DIRECTORY}"'/launcher-'"${PLUGIN_COUNT}"
    mkdir --verbose "${LAUNCHER_ITEMS_DESKTOP_DIRECTORY_PATH}"

}

function xfce_close_launcher_plugin() {

    :

}

function xfce_open_launcher_item() {

    LAUNCHER_ITEM_DESKTOP_FILENAME="$((++LAUNCHER_ITEM_DESKTOP_FILENAME_HI))$((++LAUNCHER_ITEM_DESKTOP_FILENAME_LO))"'.desktop'
    LAUNCHER_ITEM_DESKTOP_FILE_FULL_PATH="${LAUNCHER_ITEMS_DESKTOP_DIRECTORY_PATH}"'/'"${LAUNCHER_ITEM_DESKTOP_FILENAME}"
    LAUNCHER_ITEMS+=("${LAUNCHER_ITEM_DESKTOP_FILENAME}")

}

function xfce_close_launcher_item() {

    xfconf-query --channel 'xfce4-panel' --property "${PLUGIN_XFCONF_PATH}"'/items' --create --force-array$(printf ' --type string --set %s' "${LAUNCHER_ITEMS[@]}")

}

function xfce_set_plugin_property() {

    local -nr __PLUGIN_PROPERTY__="${1}"
    local -r PROPERTY_NAME="${__PLUGIN_PROPERTY__[0]}"
    local -r PROPERTY_TYPE="${__PLUGIN_PROPERTY__[1]}"
    local -r PROPERTY_VALUE="${__PLUGIN_PROPERTY__[2]}"

    if [ -n "${PROPERTY_TYPE}" ] && [ -n "${PROPERTY_VALUE}" ]; then
        if [ "${PROPERTY_TYPE}" == 'array' ]; then
            {

                local -nr __VALUE_ARRAY__="${PROPERTY_VALUE}"

                echo 'NOTE: Setting plugin property '"'${PROPERTY_NAME}'"' of type '"'${__VALUE_ARRAY__[0]}'"' array to value ('"$(printf " '%s'" "${__VALUE_ARRAY__[@]:1}")"' ).'
                xfconf-query --channel 'xfce4-panel' --property "${PLUGIN_XFCONF_PATH}"'/'"${PROPERTY_NAME}" --create --force-array$(printf ' --type '"${__VALUE_ARRAY__[0]}"' --set %s' "${__VALUE_ARRAY__[@]:1}")

            }
        else
            echo 'NOTE: Setting plugin property '"'${PROPERTY_NAME}'"' of type '"'${PROPERTY_TYPE}'"' to value '"'${PROPERTY_VALUE}'"'.'
            xfconf-query --channel 'xfce4-panel' --property "${PLUGIN_XFCONF_PATH}"'/'"${PROPERTY_NAME}" --create --type "${PROPERTY_TYPE}" --set "${PROPERTY_VALUE}"
        fi
    else
        echo 'NOTE: Clearing plugin property '"'${PROPERTY_NAME}'"'.'
        xfconf-query --channel 'xfce4-panel' --property "${PLUGIN_XFCONF_PATH}"'/'"${PROPERTY_NAME}" --reset
    fi

}

function xfce_set_plugin_properties() {

    local -nr __PLUGIN_PROPERTIES__="${1}"
    local PLUGIN_PROPERTY

    for PLUGIN_PROPERTY in "${__PLUGIN_PROPERTIES__[@]}"; do
        xfce_set_plugin_property "${PLUGIN_PROPERTY}"
    done

}

function xfce_set_plugin_resources() {

    local -r PLUGIN_NAME="${1}"
    local -nr PLUGIN_RESOURCES="${2}"
    local -r RESOURCE_FILE="${XFCE_PANEL_DIRECTORY}"'/'"${PLUGIN_NAME}"'-'"${PLUGIN_COUNT}"'.rc'

    echo 'NOTE: Saving plugin configuration to resource file '"'${RESOURCE_FILE}'"'.'
    echo "${PLUGIN_RESOURCES}" >"${RESOURCE_FILE}"

}

function xfce_setup_launcher_item() {

    local -nr __LAUNCHER_ITEM__="${1}"
    local -r ITEM_TYPE="${__LAUNCHER_ITEM__[0]}"
    local -r ITEM_VALUE="${__LAUNCHER_ITEM__[1]}"

    echo 'NOTE: Creating launcher item '"'${1}'"'.'
    xfce_open_launcher_item
    case "${ITEM_TYPE}" in

    'LauncherSourceFile')

        echo '      Launcher item configuration source file is '"'${ITEM_VALUE}'"'.'
        echo '      Saving launcher item configuration to file '"'${LAUNCHER_ITEM_DESKTOP_FILE_FULL_PATH}'"'.'
        perl -e "${PERL_GENERATE_XFCE_DESKTOP_FILE}" "${ITEM_VALUE}" "${LAUNCHER_ITEM_DESKTOP_FILE_FULL_PATH}"

        ;;

    'LauncherSourceString')

        {

            local -nr LAUNCHER_ITEM_DESKTOP_CONTENTS="${ITEM_VALUE}"

            echo '      Saving launcher item configuration to file '"'${LAUNCHER_ITEM_DESKTOP_FILE_FULL_PATH}'"'.'
            echo "${LAUNCHER_ITEM_DESKTOP_CONTENTS}" >"${LAUNCHER_ITEM_DESKTOP_FILE_FULL_PATH}"

        }

        ;;

    esac
    xfce_close_launcher_item

}

function xfce_setup_launcher_items() {

    local -nr __LAUNCHER_ITEMS__="${1}"
    local LAUNCHER_ITEM

    echo 'NOTE: Processing launcher item set '"'${1}'"'.'
    for LAUNCHER_ITEM in "${__LAUNCHER_ITEMS__[@]}"; do
        xfce_setup_launcher_item "${LAUNCHER_ITEM}"
    done

}

function xfce_setup_launcher_plugin() {

    local -nr __PLUGIN_SETUP__="${1}"
    local -r PLUGIN_PROPERTIES="${__PLUGIN_SETUP__[0]}"
    local -r PLUGIN_ITEMS="${__PLUGIN_SETUP__[1]}"

    xfce_open_launcher_plugin
    xfce_set_plugin_properties "${PLUGIN_PROPERTIES}"
    xfce_setup_launcher_items "${PLUGIN_ITEMS}"
    xfce_close_launcher_plugin

}

function xfce_create_panel_plugin() {

    local -nr __PANEL_PLUGIN__="${1}"
    local -r PLUGIN_NAME="${__PANEL_PLUGIN__[0]}"
    local -r PLUGIN_CONFTYPE="${__PANEL_PLUGIN__[1]}"
    local -r PLUGIN_CONF="${__PANEL_PLUGIN__[2]}"

    if [ "${PLUGIN_CONFTYPE}" == 'PluginNetLoad' ]; then
        {

            local IP_LINK
            local -nr __CONFIG_TEMPLATE__="${PLUGIN_CONF}"
            local -r CONFIG_NAME="${PLUGIN_CONF%TEMPLATE_RC}"'RESOURCES'
            local -n __CONFIG__="${CONFIG_NAME}"

            for IP_LINK in "${IP_LINKS[@]}"; do
                echo 'NOTE: Creating panel plugin '"'${1}'"' for '"'"'Network_Device='"${IP_LINK}'"'.'
                xfce_open_panel_plugin "${PLUGIN_NAME}"
                __CONFIG__="$(sed --regexp-extended --expression='s/(Network_Device=)$/\1'"${IP_LINK}"'/' <<<"${__CONFIG_TEMPLATE__}")"
                xfce_set_plugin_resources "${PLUGIN_NAME}" "${CONFIG_NAME}"
                xfce_close_panel_plugin
            done

        }
    else
        echo 'NOTE: Creating panel plugin '"'${1}'"'.'
        xfce_open_panel_plugin "${PLUGIN_NAME}"
        [ -z "${PLUGIN_CONFTYPE}" ] ||
            [ -z "${PLUGIN_CONF}" ] ||
            case "${PLUGIN_CONFTYPE}" in

            'PluginLauncher')

                xfce_setup_launcher_plugin "${PLUGIN_CONF}"

                ;;

            'PluginProperties')

                xfce_set_plugin_properties "${PLUGIN_CONF}"

                ;;

            'PluginResources')

                if [ -n "${PLUGIN_CONF}" ]; then
                    xfce_set_plugin_resources "${PLUGIN_NAME}" "${PLUGIN_CONF}"
                fi

                ;;

            esac
        xfce_close_panel_plugin
    fi

}

function xfce_set_panel_property() {

    local -nr __PANEL_PROPERTY__="${1}"
    local -r PROPERTY_NAME="${__PANEL_PROPERTY__[0]}"
    local -r PROPERTY_TYPE="${__PANEL_PROPERTY__[1]}"
    local -r PROPERTY_VALUE="${__PANEL_PROPERTY__[2]}"

    if [ -n "${PROPERTY_TYPE}" ] && [ -n "${PROPERTY_VALUE}" ]; then
        echo 'NOTE: Setting panel property '"'${PROPERTY_NAME}'"' of type '"'${PROPERTY_TYPE}'"' to value '"'${PROPERTY_VALUE}'"'.'
        xfconf-query --channel 'xfce4-panel' --property "${PANEL_XFCONF_PATH}"'/'"${PROPERTY_NAME}" --create --type "${PROPERTY_TYPE}" --set "${PROPERTY_VALUE}"
    else
        echo 'NOTE: Clearing panel property '"'${PROPERTY_NAME}'"'.'
        xfconf-query --channel 'xfce4-panel' --property "${PANEL_XFCONF_PATH}"'/'"${PROPERTY_NAME}" --reset
    fi

}

function xfce_set_panel_properties() {

    local -nr __PANEL_PROPERTIES__="${1}"
    local PANEL_PROPERTY

    echo 'NOTE: Processing panel property set '"'${1}'"'.'
    for PANEL_PROPERTY in "${__PANEL_PROPERTIES__[@]}"; do
        xfce_set_panel_property "${PANEL_PROPERTY}"
    done

}

function xfce_create_panel() {

    local -nr __PANEL__="${1}"
    local -nr __PANEL_PROPERTY_SETS__="${__PANEL__[0]}"
    local -nr __PANEL_PLUGINS__="${__PANEL__[1]}"
    local PANEL_PROPERTY_SET
    local PANEL_PLUGIN

    echo 'NOTE: Creating panel '"'${1}'"'.'
    xfce_open_panel
    for PANEL_PROPERTY_SET in "${__PANEL_PROPERTY_SETS__[@]}"; do
        xfce_set_panel_properties "${PANEL_PROPERTY_SET}"
    done
    for PANEL_PLUGIN in "${__PANEL_PLUGINS__[@]}"; do
        xfce_create_panel_plugin "${PANEL_PLUGIN}"
    done
    xfce_close_panel

}

function xfce_create_panels() {

    local -nr __PANELS__="${1}"
    local PANEL

    for PANEL in "${__PANELS__[@]}"; do
        xfce_create_panel "${PANEL}"
    done

}

function xfce_clear_panels() {

    echo 'NOTE: Clearing the XFCE panels.'
    xfconf-query --channel 'xfce4-panel' --property '/panels' --reset --recursive
    xfconf-query --channel 'xfce4-panel' --property '/panels' --create --force-array --type int --set 1
    xfce_restart_panel_instance
    xfconf-query --channel 'xfce4-panel' --property '/plugins' --reset --recursive
    rm --force --recursive --verbose "${XFCE_PANEL_DIRECTORY}"
    mkdir --parents --verbose "${XFCE_PANEL_DIRECTORY}"

}

function desktop_is_xfce() {

    [ "${XDG_CURRENT_DESKTOP}" == 'XFCE' ]

}

function system_is_debian() {

    [ "$(command lsb_release --id --short 2>/dev/null)" == 'Ubuntu' ]

}

#*****************************
#*                           *
#*  Bash Script Entry Point  *
#*                           *
#*****************************
echo "starting"
{

    system_is_debian && echo 'NOTE: This is a Ubuntu system.'

} &&
    {

        desktop_is_xfce && echo 'NOTE: The current desktop environment is XFCE.'

    } &&
    {

        xfce_clear_panels && xfce_create_panels 'XFCE_PANELS'

    }
