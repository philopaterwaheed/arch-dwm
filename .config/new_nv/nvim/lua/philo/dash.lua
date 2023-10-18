local status_ok, dashboard = pcall(require, "dashboard")
if not status_ok then
	return
end

    dashboard.setup ({
      -- config
     config = {
	packages = { enable = true },
	  shortcut = {
    -- action can be a function type
    { desc = ' ', group = 'DashboardShortCut', key = 'new', action = ':q' },
  },
	theme = 'hyper',
	items = {},
     header = {
"philo was here and made awesomeness",

"───────────────────────────────────────────────────────────────────────",
"██████████████─██████──██████─██████████─██████─────────██████████████─",
"██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░██─██░░██─────────██░░░░░░░░░░██─",
"██░░██████░░██─██░░██──██░░██─████░░████─██░░██─────────██░░██████░░██─",
"██░░██──██░░██─██░░██──██░░██───██░░██───██░░██─────────██░░██──██░░██─",
"██░░██████░░██─██░░██████░░██───██░░██───██░░██─────────██░░██──██░░██─",
"██░░░░░░░░░░██─██░░░░░░░░░░██───██░░██───██░░██─────────██░░██──██░░██─",
"██░░██████████─██░░██████░░██───██░░██───██░░██─────────██░░██──██░░██─",
"██░░██─────────██░░██──██░░██───██░░██───██░░██─────────██░░██──██░░██─",
"██░░██─────────██░░██──██░░██─████░░████─██░░██████████─██░░██████░░██─",
"██░░██─────────██░░██──██░░██─██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─",
"██████─────────██████──██████─██████████─██████████████─██████████████─",
"────────────────────────────────────────────────────────────────────────",

	},
	       

	footer = {
		""	,
		""	,
		"	",	
		"code god is up to work",
		"	",	
		"Throughout Heaven and earth, I alone am the honored one"
	},

},
hide = {
		winbar, 
		--statusline
	},
    })
require("ibl").setup{
	--filetype_exclude = {"dashboard"},
	exclude = { filetypes = {"dashboard"} }
}
local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
  return
end

impatient.enable_profile()
