/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
#include "colors.h"
/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 1;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 1;       /* vert inner gap between windows */
static const unsigned int gappoh    = 1;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 1;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 1;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrainsMono Nerd Font:size=10" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font:size=10";
static const unsigned int baralpha = 0xd0;
static const unsigned int borderalpha = OPAQUE;
static const char normmarkcolor[]   = "#FF44C6";	/*border color for marked client*/
static const char selmarkcolor[]    = "#8BE9FD";	/*border color for marked client on focus*/

static const char *colors[][4]      = {
	/*            	 	fg      bg     border     mark   */
	[SchemeNorm]       = { gray4,  black,  gray2 ,normmarkcolor },
	[SchemeSel]        = { blue,  black,   blue  , selmarkcolor  },
};
static const unsigned int alphas[][4]      = {
    /*               fg      bg        border*/
  [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha},
};

/* tagging */
static const char *tags[] = { "_", "", "", "", ""};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "com-sun-tools-javac-launcher-Main",     NULL,       NULL,       0,            1,           -1 },
        { "App_luncher",    NULL,       NULL,       0,            1,        -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

/* mouse scroll resize */
static const int scrollsensetivity = 15; /* 1 means resize window by 1 pixel for each scroll event */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define Alt Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]        = { "dmenu", NULL };
static const char *termcmd[]         = { "st", NULL };
static const char *rebootcmd[]       = { "reboot",NULL };
static const char *poweroffcmd[]     = { "poweroff",NULL };

/* apps */
static const char *browser[]         = { "zen-browser", NULL };
static const char *nvimcmd[]         = { "st", "-e", "nvim", NULL };
static const char *vscodecmd[]       = { "code", NULL };
static const char *lockcmd[]         = { "slock", NULL };
static const char *filemgr[]         = { "thunar", NULL };
static const char *dunsthist[]       = { "dunstctl", "history-pop", NULL };
static const char *dunstpause[]      = { "dunstctl", "set-paused", "toggle", NULL };

/* menus / scripts */
static const char *rofi_launcher[]   = { "/home/philosan/dwm/scripts/rofi_launcher", NULL };
static const char *rofi_runner[]     = { "/home/philosan/dwm/scripts/rofi_runner", NULL };
static const char *rofi_window[]     = { "/home/philosan/dwm/scripts/rofi_window", NULL };
static const char *rofi_killer[]     = { "/home/philosan/dwm/scripts/rofi_process_killer", NULL };
static const char *rofi_screenshot[] = { "/home/philosan/dwm/scripts/rofi_screenshot", NULL };
static const char *rofi_mount[]      = { "/home/philosan/dwm/scripts/rofi_mount", NULL };
static const char *search[]          = { "/home/philosan/dwm/scripts/selector_search", NULL };
static const char *ocr[]             = { "/home/philosan/dwm/scripts/ocr", NULL };
static const char *translate[]       = { "/home/philosan/dwm/scripts/translate", NULL };
static const char *screenshot[]      = { "flameshot", "gui", NULL };
static const char *kbdlayout[]       = { "/home/philosan/dwm/layout.sh", NULL };
static const char *monitorcmd[]      = { "/home/philosan/dwm/monitor.sh", NULL };
static const char *picomcmd[]        = { "/home/philosan/dwm/scripts/dwm_picom", NULL };

/* media */
static const char *vol_up[]          = { "/home/philosan/dwm/scripts/volume", "--inc", NULL };
static const char *vol_down[]        = { "/home/philosan/dwm/scripts/volume", "--dec", NULL };
static const char *vol_mute[]        = { "/home/philosan/dwm/scripts/volume", "--toggle", NULL };
static const char *mic[]             = { "/home/philosan/dwm/scripts/volume", "--toggle-mic", NULL };
static const char *briup[]           = { "/home/philosan/dwm/scripts/dwmbrightness", "--inc", NULL };
static const char *bridown[]         = { "/home/philosan/dwm/scripts/dwmbrightness", "--dec", NULL };

#include "exitdwm.c"

/* Super+Space, then a letter — works with Super still held or released */
#define LKEY(KEY, IDX) \
	{ 0,      KEY, setlayout, {.v = &layouts[IDX]} }, \
	{ MODKEY, KEY, setlayout, {.v = &layouts[IDX]} },

static const Key layoutkeys[] = {
	/* second key          layout */
	LKEY(XK_t,      0)  /* tile          []=  */
	LKEY(XK_space,  0)
	LKEY(XK_m,      1)  /* monocle       [M]  */
	LKEY(XK_s,      2)  /* spiral        [@]  */
	LKEY(XK_w,      3)  /* dwindle       [\]  */
	LKEY(XK_d,      4)  /* deck          H[]  */
	LKEY(XK_b,      5)  /* bstack        TTT  */
	LKEY(XK_h,      6)  /* bstackhoriz   ===  */
	LKEY(XK_g,      7)  /* grid          HHH  */
	LKEY(XK_n,      8)  /* nrowgrid      ###  */
	LKEY(XK_r,      9)  /* horizgrid     ---  */
	LKEY(XK_a,     10)  /* gaplessgrid   :::  */
	LKEY(XK_c,     11)  /* centered      |M|  */
	LKEY(XK_v,     12)  /* centeredfloat >M>  */
	LKEY(XK_f,     13)  /* floating      ><>  */
	{ 0,      XK_Tab, setlayout, {0} }, /* last layout */
	{ MODKEY, XK_Tab, setlayout, {0} },
	{0},
};

static const Key keys[] = {
	/* modifier                     key            function                  argument */

	/* launchers — Super+; is next to Enter, Shift for run-command */
	{ MODKEY,                       XK_semicolon,  spawn,                    {.v = rofi_launcher } },
	{ MODKEY|ShiftMask,             XK_semicolon,  spawn,                    {.v = rofi_runner } },
	{ MODKEY,                       XK_w,          spawn,                    {.v = rofi_window } },
	{ MODKEY|ShiftMask,             XK_q,          spawn,                    {.v = rofi_killer } },
	{ MODKEY,                       XK_u,          spawn,                    {.v = rofi_mount } },

	/* apps */
	{ MODKEY,                       XK_t,          spawn,                    {.v = termcmd } },
	{ MODKEY,                       XK_f,          spawn,                    {.v = browser } },
	{ MODKEY,                       XK_c,          spawn,                    {.v = nvimcmd } },
	{ MODKEY|ShiftMask,             XK_c,          spawn,                    {.v = vscodecmd } },
	{ MODKEY|ShiftMask,             XK_f,          spawn,                    {.v = filemgr } },
	{ MODKEY,                       XK_m,          spawn,                    {.v = vol_mute } },
	{ MODKEY,                       XK_n,          spawn,                    {.v = dunsthist } },
	{ MODKEY|ShiftMask,             XK_n,          spawn,                    {.v = dunstpause } },

	/* search / capture */
	{ MODKEY,                       XK_g,          spawn,                    {.v = search } },
	{ MODKEY|ShiftMask,             XK_g,          spawn,                    {.v = ocr } },
	{ MODKEY|ControlMask,           XK_g,          spawn,                    {.v = translate } },
	{ 0,                            XK_Print,      spawn,                    {.v = screenshot } },
	{ MODKEY,                       XK_Print,      spawn,                    {.v = screenshot } },
	{ MODKEY|ShiftMask,             XK_Print,      spawn,                    {.v = rofi_screenshot } },

	/* system */
	{ MODKEY,                       XK_p,          spawn,                    {.v = monitorcmd } },
	{ MODKEY|ShiftMask,             XK_p,          spawn,                    {.v = picomcmd } },
	{ ShiftMask,                    XK_Alt_L,      spawn,                    {.v = kbdlayout } },
	{ MODKEY|ShiftMask,             XK_x,          spawn,                    {.v = lockcmd } },
	{ MODKEY,                       XK_F5,         spawn,                    {.v = rebootcmd } },
	{ MODKEY,                       XK_F4,         spawn,                    {.v = poweroffcmd } },
	{ MODKEY,                       XK_Escape,     exitdwm,                  {0} },

	/* focus / stack  (hjkl, vim-style) */
	{ MODKEY,                       XK_j,          focusstack,               {.i = +1 } },
	{ MODKEY,                       XK_k,          focusstack,               {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,          movestack,                {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,          movestack,                {.i = -1 } },
	{ MODKEY,                       XK_h,          setmfact,                 {.f = -0.05} },
	{ MODKEY,                       XK_l,          setmfact,                 {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,          setcfact,                 {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_l,          setcfact,                 {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,          setcfact,                 {.f =  0.00} },
	{ MODKEY,                       XK_i,          incnmaster,               {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_i,          incnmaster,               {.i = -1 } },
	{ MODKEY,                       XK_z,          zoom,                     {0} },
	{ MODKEY|ControlMask,           XK_c,          movecenter,               {0} },

	/* window state */
	{ MODKEY,                       XK_q,          killclient,               {0} },
	{ MODKEY,                       XK_s,          togglesticky,             {0} },
	{ MODKEY|ShiftMask,             XK_s,          togglealwaysontop,        {0} },
	{ MODKEY,                       XK_x,          togglecanfocusfloating,   {0} },
	{ MODKEY|ShiftMask,             XK_m,          togglemark,               {0} },
	{ MODKEY,                       XK_e,          swapfocus,                {0} },
	{ MODKEY,                       XK_r,          swapclient,               {0} },
	{ MODKEY,                       XK_Return,     fullscreen,               {0} },
	{ MODKEY|ShiftMask,             XK_Return,     togglefullscr,            {0} },
	{ MODKEY,                       XK_b,          togglebar,                {0} },

	/* layouts — Super+Space then a letter (see layoutkeys) */
	{ MODKEY,                       XK_space,      keypress_other,           {.v = layoutkeys } },
	{ MODKEY|ShiftMask,             XK_space,      togglefloating,           {0} },

	/* gaps — Super+Alt+u all, i inner, o outer; 0 toggle */
	{ MODKEY|Mod1Mask,              XK_u,          incrgaps,                 {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_u,          incrgaps,                 {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_i,          incrigaps,                {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_i,          incrigaps,                {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_o,          incrogaps,                {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_o,          incrogaps,                {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_0,          togglegaps,               {0} },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_0,          defaultgaps,              {0} },

	/* tags */
	{ MODKEY,                       XK_Tab,        view,                     {0} },
	{ MODKEY,                       XK_0,          view,                     {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          tag,                      {.ui = ~0 } },
	TAGKEYS(                        XK_1,                                    0)
	TAGKEYS(                        XK_2,                                    1)
	TAGKEYS(                        XK_3,                                    2)
	TAGKEYS(                        XK_4,                                    3)
	TAGKEYS(                        XK_5,                                    4)
	TAGKEYS(                        XK_6,                                    5)
	TAGKEYS(                        XK_7,                                    6)
	TAGKEYS(                        XK_8,                                    7)
	TAGKEYS(                        XK_9,                                    8)

	/* monitors */
	{ MODKEY,                       XK_comma,      focusmon,                 {.i = -1 } },
	{ MODKEY,                       XK_period,     focusmon,                 {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,      tagmon,                   {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,     tagmon,                   {.i = +1 } },

	/* media — hardware keys, plus Super +/- and [ ] when those are missing */
	{ 0,                            XF86XK_AudioRaiseVolume, spawn,          {.v = vol_up } },
	{ 0,                            XF86XK_AudioLowerVolume, spawn,          {.v = vol_down } },
	{ 0,                            XF86XK_AudioMute,        spawn,          {.v = vol_mute } },
	{ 0,                            XF86XK_AudioMicMute,     spawn,          {.v = mic } },
	{ 0,                            XF86XK_MonBrightnessUp,  spawn,          {.v = briup } },
	{ 0,                            XF86XK_MonBrightnessDown,spawn,          {.v = bridown } },
	{ MODKEY,                       XK_equal,      spawn,                    {.v = vol_up } },
	{ MODKEY,                       XK_minus,      spawn,                    {.v = vol_down } },
	{ MODKEY|ShiftMask,             XK_minus,      spawn,                    {.v = vol_mute } },
	{ MODKEY,                       XK_bracketright, spawn,                  {.v = briup } },
	{ MODKEY,                       XK_bracketleft,  spawn,                  {.v = bridown } },

	{0},
};

/* resizemousescroll direction argument list */
static const int scrollargs[][2] = {
	/* width change         height change */
	{ +scrollsensetivity,	0 },
	{ -scrollsensetivity,	0 },
	{ 0, 				  	+scrollsensetivity },
	{ 0, 					-scrollsensetivity },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
 	{ ClkClientWin,         MODKEY,         Button4,        resizemousescroll, {.v = &scrollargs[0]} },
	{ ClkClientWin,         MODKEY,         Button5,        resizemousescroll, {.v = &scrollargs[1]} },
	{ ClkClientWin,         MODKEY,         Button6,        resizemousescroll, {.v = &scrollargs[2]} },
	{ ClkClientWin,         MODKEY,         Button7,        resizemousescroll, {.v = &scrollargs[3]} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
  { ClkClientWin,         MODKEY|ShiftMask, Button1,      movemouse,      {.i = 1} },
  { ClkClientWin,         MODKEY|ShiftMask, Button3,      resizemouse,    {.i = 1} },
};

