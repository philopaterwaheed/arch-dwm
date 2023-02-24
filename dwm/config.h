/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int baralpha = 0xd0;
static const unsigned int borderalpha = OPAQUE;
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int gappx     = 2;        /* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int minwsz    = 20;       /* Minimal heigt of a client for smfact */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const unsigned int gappih    = 1;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 1;       /* vert inner gap between windows */
static const unsigned int gappoh    = 1;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 1;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 1;        /* 1 means no outer gap when there is only one window */
static const char *fonts[]          ={"Ubuntu-Arabic_B.ttf:size=10"};
static const char dmenufont[]       ="Ubuntu-Arabic_B.tt.ttf:size=12";
static const char col_gray1[]       = "#6b5f60";// tages
static const char col_gray2[]       = "#898C8B";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#1b1b4c"; // font color
static const char col_cyan[]        = "#8a555a"; // the midle 
static const char *colors[][3]      = {
   /*               fg         bg         border   */
   [SchemeNorm] = { col_gray4, col_gray1, col_gray2 },
   [SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};
static const unsigned int alphas[][3]      = {
   /*               fg      bg        border     */
   [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
   [SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};


/* tagging */
static const char *tags[] = { "_", "", "", "", ""};

static const Rule rules[] = {
   /* xprop(1):
    *   WM_CLASS(STRING) = instance, class
    *   WM_NAME(STRING) = title
    */ // rules for programs
   /* class      instance    title       tags mask  iscentered    isfloating   monitor */
   { "Gimp",     NULL,       NULL,       0,          0,        1,           -1 },
   { "St",  NULL,       NULL,       1 << 8,         0,         0, 	-1	},
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const float smfact     = 0.00; /* factor of tiled clients [0.00..0.95] */
#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
   /* symbol     arrange function */
   { "[]=",      tile },    /* first entry is default */ //0
   { "[M]",      monocle }, //1 
	{ "[@]",      spiral }, //2
	{ "[\\]",     dwindle },//3
	{ "H[]",      deck },//4 
	{ "TTT",      bstack },//5
	{ "===",      bstackhoriz },//6
	{ "HHH",      grid },//7
	{ "###",      nrowgrid },//8
	{ "---",      horizgrid },//9
	{ ":::",      gaplessgrid },//10
	{ "|M|",      centeredmaster },//11
	{ ">M>",      centeredfloatingmaster },//12
	{ "><>",      NULL },    /* no layout function means floating behavior *///13
	{ NULL,       NULL },
	
};
void resetlayout (const Arg *arg)
{
Arg defualt_layout={.v=&layouts[0]};
Arg default_mfact ={.f = mfact+1};
setlayout(&defualt_layout);
setmfact(&default_mfact);
}



Layout *last_layout;
void
fullscreen(const Arg *arg)
{
   if (selmon->showbar) {
      for(last_layout = (Layout *)layouts; last_layout != selmon->lt[selmon->sellt]; last_layout++);
      setlayout(&((Arg) { .v = &layouts[1] }));
   } else {
      setlayout(&((Arg) { .v = last_layout }));
   }
   togglebar(arg);
}






void movestack(const Arg *arg) ;





/* key definitions */
#define MODKEY Mod4Mask
#define Alt Mod1Mask
#define TAGKEYS(KEY,TAG) \
   { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
   { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
   { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
   { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/user/local/bin/st", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *fire_fox[]  = {"firefox",NULL};
static const char *re_boot[]  = {"reboot",NULL};
static const char *shut_down[] = {"poweroff",NULL};
static const char *lay_change[] = {"/home/philosan/dwm/layout.sh",NULL};
static const char *Monitor_set [] = {"/home/philosan/dwm/monitor.sh",NULL};
static const char *vs_code[]= {"code",NULL };
static const char *s_shot[]= {"flameshot","gui",NULL };
static const char *vol_up[] = {"pactl" ,"set-sink-volume", "1" , "+5%", NULL};
static const char *vol_down[] = {"pactl" ,"set-sink-volume", "1" , "-5%", NULL};
static const char *vol_mute[] = {"pactl" ,"set-sink-mute", "1" , "toggle", NULL}; 
static Key keys[] = {
   /* modifier                     key        function        argument */
   { MODKEY,                       XK_l,      spawn,          {.v = dmenucmd } },
   { MODKEY,                       XK_t,      spawn,            {.v = termcmd } },
   { ShiftMask,        		   XK_Alt_L,  spawn,      {.v =lay_change} },
   { MODKEY,        		   XK_Print,         spawn,      {.v = s_shot} },
   { MODKEY,                       XK_b,      togglebar,      {0} },
   { MODKEY, 			   XK_s		,togglesticky ,      {0} },
   { MODKEY,                       XK_Left,   focusstack,     {.i = -1 } },
   { MODKEY,                       XK_Right,  focusstack,     {.i = +1 } },
   { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },//change to vertical
   { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },// the same ^^
   { MODKEY|ShiftMask,             XK_Left,      setmfact,       {.f = -0.05} },
   { MODKEY|ShiftMask,             XK_Right,      setmfact,       {.f = +0.05} },
   { MODKEY,                   	   XK_minus,      spawn,      {.v=vol_down} },
   { MODKEY,                       XK_equal,      spawn,      {.v=vol_up} },
   //{ MODKEY|ShiftMask,             XK_Up,      setsmfact,      {.f = +0.05} },
  // { MODKEY|ShiftMask,             XK_Up,      moveresizeedge,      {.v = "t" } },
   { MODKEY|ShiftMask,             XK_Down,      setsmfact,      {.f = -0.05} },
   { MODKEY,                  	   XK_Down,      movestack,      {.i = +1 } },
   { MODKEY,                       XK_Up,    movestack,      {.i = -1 } },
   { MODKEY,                   	   XK_m,      spawn,      {.v = vol_mute } },
   { MODKEY,       	   	   XK_p,      spawn,      {.v = Monitor_set } },
   { MODKEY|ShiftMask,             XK_f,       zoom,           {0} },
   { MODKEY,                       XK_Tab,    view,           {0} },
   { MODKEY,         		   XK_q,     killclient,     {0} },
   { MODKEY|ShiftMask,             XK_l,      setlayout,      {.v = &layouts[0]} },
   { MODKEY|ShiftMask,             XK_e,      setlayout,      {.v = &layouts[1]} },
   { MODKEY|ShiftMask,             XK_m,      setlayout,    {.v = &layouts[2]} },
   { MODKEY,                       XK_space,  setlayout,      {.v = &layouts[0]} },
   { MODKEY|ShiftMask,             XK_space,  togglefloating, {0}},
   { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
   { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
   { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },// chane focus of screen 
   { MODKEY,                       XK_period, focusmon,       {.i = +1 } },// same 
   { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } }, // moves window to the screen 
   { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } }, // same 
   { MODKEY,         XK_r,      resetlayout,      {0} },// resets the sizes 
   { MODKEY,         XK_f,      spawn,      {.v=fire_fox}},
   { MODKEY,         XK_F5,      spawn,      {.v=re_boot}},
   { MODKEY,         XK_Return,  fullscreen,      {0}},
   { MODKEY|ShiftMask,             XK_Return,      togglefullscr,  {0} },
   { MODKEY,         XK_F4,      spawn,      {.v=shut_down}},
   { MODKEY,         XK_c,        spawn,       {.v=vs_code}},
  	
   	{ MODKEY|Mod1Mask,              XK_b,      setlayout,       {.v = &layouts[5]} },
   	{ MODKEY|Mod1Mask,              XK_n,      setlayout,       {.v = &layouts[8]} },
   	{ MODKEY|Mod1Mask,              XK_s,      setlayout,       {.v = &layouts[2]} },
   	{ MODKEY|Mod1Mask,              XK_g,      setlayout,       {.v = &layouts[7]} },
   	{ MODKEY|Mod1Mask,              XK_c,      setlayout,       {.v = &layouts[11]} },
 	{ MODKEY|Mod1Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
   	{ MODKEY|Mod1Mask,              XK_u,      incrgaps,       {.i = +1 } },
	{ MODKEY|Mod1Mask,              XK_i,      incrigaps,      {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_o,      incrogaps,      {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_0,      togglegaps,     {0} },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
   TAGKEYS(                        XK_1,                      0)
   TAGKEYS(                        XK_2,                      1)
   TAGKEYS(                        XK_3,                      2)
   TAGKEYS(                        XK_4,                      3)
   TAGKEYS(                        XK_5,                      4)
   TAGKEYS(                        XK_6,                      5)
   TAGKEYS(                        XK_7,                      6)
   TAGKEYS(                        XK_8,                      7)
   TAGKEYS(                        XK_9,                      8)
   { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
   /* click                event mask      button          function        argument */
   { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
   { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
   { ClkWinTitle,          0,              Button2,        zoom,           {0} },
   { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
   { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
   { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
   { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
   { ClkTagBar,            0,              Button1,        view,           {0} },
   { ClkTagBar,            0,              Button3,        toggleview,     {0} },
   { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
   { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
   /*crop windows */
   { ClkClientWin,         MODKEY|ShiftMask, Button1,      movemouse,      {.i = 1} },
   { ClkClientWin,         MODKEY|ShiftMask, Button3,      resizemouse,    {.i = 1} },
};
