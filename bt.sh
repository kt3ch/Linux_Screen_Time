focused_window_id=$(xdotool getwindowfocus)
active_window_id=$(xdotool getactivewindow)
active_window_pid=$(xdotool getwindowpid "$focused_window_id")
ps -p $active_window_pid -o comm=
echo $pidname $active_window_pid
