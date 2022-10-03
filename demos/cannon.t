% Turing demo program
% Cannon ball time-step simulation from APSC 143
% Jim Cordy, June 2020

include "include/screen.i"

% size of screen, zero-origin
const maxRow := 39
const maxCol := 119

% initialize angle and wind velocity (STAGE 1)
const angleInit := 45.0
var angle := angleInit
var vWind := 0.0

% angle and wind incremements
const angleDelta := 1.0	% cannon angle increment (deg)
const vWindDelta := 0.1	% wind velocity increment (m/s)

% simulation parameters
const xInit := 0.0	% initial x position (m)
const yInit := 2.0	% initial y position (m)
const vInit := 40.0	% muzzle velocity (m/s)
const dt := 0.025	% time-step (s)
const kDrag := 0.005	% drag parameter
const m := 0.25		% ball mass
const g := 9.81		% gravity

% clear screen
cls
setscreen (GAME)

% run indefinitely (infinite loop)
loop
    % check for a button push
    var key : string (1) := ""
    if hasch then
	getch (key)
    end if

    % clear to reinitialize
    if key = '\n' then
	cls
	angle := angleInit
	vWind := 0.0
    end if

    % update parameters (STAGE 2)
    % increment angle
    if key = UPARROW then
        angle := angle + angleDelta
    elsif key = DOWNARROW then
        angle := angle - angleDelta
    end if

    % reset angle to 0 if above 90
    if angle < angleDelta then
        angle := 0.0
    elsif angle > 90 then
        angle := 90
    end if

    % if right button pressed, increase wind velocity (+x), else if left
    % button pressed, decrease wind velocity (-x)
    if key = RIGHTARROW then
        vWind := vWind + vWindDelta
    elsif key = LEFTARROW then
        vWind := vWind - vWindDelta
    end if

    % print buttons (STAGE 1), angle, and wind velocity (STAGE 2)
    locate (1, 1)
    put "Angle := ", angle, " deg, Wind = ", vWind, " m/s    " ..
    
    % exit if more than one button pressed at once (STAGE 1)
    if key = "q" then
        exit
    end if
    
    % clear figure and plot cannon and wind vector
    % ground
    const groundRow := maxRow - 2
    locate (groundRow, 1)
    put repeat ("_", maxCol) ..
    const instructions := "Up/Down arrow - angle    L/R arrow - wind    SP - fire!    CR - reset"
    put repeat (" ", (maxCol - length (instructions) - 1) div 2), instructions ..

    % barrel
    const barrelRow := groundRow - 1
    const angleoffset := round (4 * (cosd (angle)))
    for i : 0 .. 2
	locate (barrelRow - i, 1)
	put "               " ..
	locate (barrelRow - i, 2 + angleoffset * i)
	put "//" ..
    end for
    const barrelCol := 2 + angleoffset * 2

    % wind arrow
    const windRow := 4
    const windCol := maxCol - 10
    locate (windRow, windCol)
    if vWind < 0 then
	put "<" ..
    end if
    const windoffset := min (round (abs (vWind)), 5)
    put repeat ("=",  windoffset) ..
    if vWind > 0 then
	put ">" ..
    end if
    put "      " ..

    % fire cannon if bottom button pressed (run simulation) (STAGE 3)
    if key = " " then

	% initialize parameters
	var x_prev := xInit 
	var y_prev := yInit 
	var vx_prev := vInit * cosd(angle)
	var vy_prev := vInit * sind(angle)

	var x := x_prev
	var y := y_prev
	var vx := vx_prev
	var vy := vy_prev

	% keep running simulation while ball above ground
	loop
	    exit when y_prev <= 0

	    % forces:
	    const F_grav := -g*m
	    const F_drag_x := -kDrag*((vx - vWind)**2)*sign((vx - vWind))
	    const F_drag_y := -kDrag*(vy**2)*sign(vy)
	    const F_net_x := F_drag_x
	    const F_net_y := F_drag_y + F_grav

	    % accelerations:
	    const ax := F_net_x/m
	    const ay := F_net_y/m

	    % update velocities:
	    vx := vx_prev + ax*dt
	    vy := vy_prev + ay*dt

	    % get average velocities:
	    const vx_ave := 0.5*(vx + vx_prev)
	    const vy_ave := 0.5*(vy + vy_prev)

	    % update positions:
	    x := x_prev + vx_ave*dt
	    y := y_prev + vy_ave*dt

	    % plot ball (cumulative)
	    locate (barrelRow - round (y), barrelCol + round (x))
	    put "o" ..

	    % update previous values:
	    x_prev := x
	    y_prev := y
	    vx_prev := vx
	    vy_prev := vy

	    locate (1, maxCol)  % park cursor
	    delay (25)
	end loop
    end if

    locate (1, maxCol)  % park cursor
    delay (100)
end loop

% close figure window
locate (maxRow, 1)
setscreen (NORMAL)
