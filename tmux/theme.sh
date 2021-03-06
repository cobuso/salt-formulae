# Default Theme

if patched_font_in_use; then
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁"
else
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'235'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'255'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info 33 0" \
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"hostname 33 0" \
		{% if in_cloud %}
		"wan_ip 24 255" \
		{% else %}
		"lan_ip 24 255" \
		{% endif %}
		{% if gunicorn %}
		"gunicorn 22 255" \
		{% endif %}
		{% if celeryd %}
		"celeryd 52 255" \
		{% endif %}
		{% for segment_name, colours in custom_segments.iteritems() %}
		"{{ segment_name }} {{ colours }}" \
		{% endfor %}
		"load 237 167" \
		{% if weather %}
		"weather 37 255" \
		{% endif %}
		"date_day 235 136" \
		"date 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		"time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
	)
fi
