# A-better-show-desktop-of-Xfce
A better show-desktop .sh script of Xfce4, depending on xdotool and only supporting X11 but not Wayland now. There is plan to add Wayland support but not very soon maybe. 
Command as
  Filename --sd <time>      to show desktop
  Filename --sw <time>      to reactivate the windows minimized by --sd before
  Filename --auto <time>    to automaticly change between two status above
<time> is waiting time scale in second wich I recommend to set as serveral times 0.01. Default time scale will be used if no input. For more detail y please use Filename --help
Outcomes of this script:
  1、Support kwin_x11 and (guessing) many other WM, while some other show-desktop program of xfce4 (including the official one) many have some bugs if not using Xfwm.
  2、Can use keyboard or terminal more easily than official one.
  3、Can reactivate windows.
 For any bugs, please email me at 1700011628@pku.edu.cn rather than on Github.

