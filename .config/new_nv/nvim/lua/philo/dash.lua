--[[
  Dashboard Configuration
  
  Custom start screen with ASCII art and quick shortcuts
  Also configures indent-blankline (ibl)
--]]

local status_ok, dashboard = pcall(require, "dashboard")
if not status_ok then
  return
end

dashboard.setup({
  theme = "hyper",
  config = {
    packages = { enable = true },
    shortcut = {
      { desc = " Find File", group = "DashboardShortCut", key = "f", action = "Telescope find_files" },
      { desc = " Recent", group = "DashboardShortCut", key = "r", action = "Telescope oldfiles" },
      { desc = " Config", group = "DashboardShortCut", key = "c", action = "e $MYVIMRC" },
      { desc = " Quit", group = "DashboardShortCut", key = "q", action = "qa" },
    },
    header = {
      "",
      "philo was here and made awesomeness",
      "",
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
      "",
    },
    footer = {
      "",
      "code god is up to work",
      "",
      "Throughout Heaven and earth, I alone am the honored one",
    },
  },
  hide = {
    statusline = false,
    tabline = false,
    winbar = false,
  },
})
