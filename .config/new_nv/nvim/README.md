# Neovim config — keymaps

Leader is **Space**. which-key pops up after 300ms on a prefix.

Search live maps with `<leader>fk` (Telescope) or `<leader>?` (buffer-local which-key).

Modes: **n** normal, **i** insert, **v** visual, **x** visual (char), **t** terminal, **o** operator-pending, **s** select.

---

## Leader prefixes

| Prefix | Area |
|---|---|
| `<leader>f` | Find (Telescope) |
| `<leader>g` | Git (Telescope pickers, lazygit, gitsigns `gh` / `gt`) |
| `<leader>l` | LSP / diagnostics |
| `<leader>m` | LSP extras, format, diagnostics float |
| `<leader>b` | Buffers |
| `<leader>w` | Windows |
| `<leader>s` | Splits |
| `<leader>t` | Terminals / spell |
| `<leader>T` | UI toggles |
| `<leader>S` | Sessions |
| `<leader>x` | Run / source / text tweaks |
| `<leader><Tab>` | Vim tabs |

---

## Files, search, Telescope

Loads Telescope on first use.

| Keys | Mode | What it does |
|---|---|---|
| `<leader>ff` / `<leader>F` | n | Find files (dropdown, no preview) |
| `<leader>fd` | n | Find files in current file's directory |
| `<leader>fg` / `<leader>fw` | n | Live grep |
| `<leader>fW` | n | Grep word under cursor |
| `<leader>fb` | n | Buffers |
| `<leader>fr` | n | Recent files |
| `<leader>fh` | n | Help tags |
| `<leader>fR` | n | Resume last picker |
| `<leader>fc` | n | Command history |
| `<leader>fk` | n | Search keymaps |
| `<leader>fm` | n | Marks |
| `<leader>fG` | n | Registers |
| `<leader>fj` | n | Jumplist |
| `<leader>fs` | n | Treesitter symbols |
| `<leader>fH` | n | Highlights |
| `<leader>ft` | n | Grep TODO / FIXME / HACK / NOTE / XXX |
| `<leader>/` | n | Fuzzy find in current buffer |
| `<leader>gf` | n | Git files |
| `<leader>gc` | n | Git commits |
| `<leader>gb` | n | Git branches |
| `<leader>gs` | n | Git status |
| `<leader>md` | n | LSP definitions (Telescope) |
| `<leader>lw` | n | Workspace symbols |
| `<leader>lo` | n | Document symbols (outline) |
| `<leader>lD` | n | Buffer diagnostics (Telescope) |
| `<leader>lW` | n | Workspace diagnostics (Telescope) |

### Inside a Telescope picker

| Keys | Mode | What it does |
|---|---|---|
| `<C-j>` / `<C-k>` | i | Next / previous result |
| `<C-n>` / `<C-p>` | i | Cycle prompt history |
| `<CR>` | i/n | Open |
| `<C-x>` / `<C-v>` / `<C-t>` | i/n | Split / vsplit / tab |
| `<C-u>` / `<C-d>` | i/n | Scroll preview |
| `<Tab>` / `<S-Tab>` | i | Toggle selection |
| `<C-q>` | i | Send to quickfix |
| `<C-c>` | i | Close |
| `<C-_>` | i | Picker which-key (`Ctrl-/`) |
| `j` / `k` / `gg` / `G` | n | Move / top / bottom |
| `<Esc>` | n | Close |
| `?` | n | Picker which-key |

---

## LSP (buffer-local, after a server attaches)

Neovim still maps **`K`** (hover), **`gra`** (code action), **`grn`** (rename), **`grr`** (references), **`gO`** (document symbols), **`[d` / `]d`** (diagnostics). This config does **not** map `gr` or `gi`, so those defaults and restore-insert keep working.

| Keys | Mode | What it does |
|---|---|---|
| `gd` | n | Definition (centered) |
| `gD` | n | Declaration (centered) |
| `gri` | n | Implementation (centered) |
| `<leader>mD` | n | Declaration |
| `<leader>mi` | n | Hover |
| `<leader>mrr` | n | References |
| `<leader>ma` | n | Code actions |
| `<leader>mrn` | n | Rename |
| `<leader>ms` | n | Signature help |
| `<leader>lt` | n | Type definition |
| `<leader>lci` | n | Incoming calls |
| `<leader>lco` | n | Outgoing calls |
| `<leader>lh` | n | Toggle inlay hints |
| `<leader>mp` | n/v | Format file or range (conform) |

### Diagnostics (always available)

`[d` / `]d` are Neovim defaults and also open a float (`jump.on_jump`).

| Keys | Mode | What it does |
|---|---|---|
| `<leader>mf` / `<leader>ml` | n | Floating diagnostics |
| `<leader>mq` | n | Diagnostics → location list |
| `<leader>lp` | n | Previous diagnostic |
| `<leader>lN` | n | Next diagnostic |

---

## Git

Gitsigns maps attach on git buffers. `<leader>gg` loads toggleterm.

| Keys | Mode | What it does |
|---|---|---|
| `<leader>gg` | n | Lazygit |
| `]c` / `[c` | n | Next / previous hunk (or diff change if `'diff'`) |
| `<leader>ghs` | n/v | Stage hunk |
| `<leader>ghr` | n/v | Reset hunk |
| `<leader>ghS` | n | Stage buffer |
| `<leader>ghR` | n | Reset buffer |
| `<leader>ghp` | n | Preview hunk |
| `<leader>ghi` | n | Preview hunk inline |
| `<leader>ghb` | n | Blame line (full) |
| `<leader>ghd` | n | Diff this |
| `<leader>ghD` | n | Diff this against `~` |
| `<leader>ghq` | n | Hunks → quickfix |
| `<leader>ghQ` | n | All hunks → quickfix |
| `<leader>gtb` | n | Toggle line blame |
| `<leader>gtw` | n | Toggle word diff |
| `ih` | o/x | Select hunk (text object) |

Fugitive is command-only: `:G`, `:Git`, `:Gdiffsplit`, `:Gread`, `:Gwrite`.

---

## File explorer, undo, terminal, run

| Keys | Mode | What it does |
|---|---|---|
| `<leader>n` | n | Toggle nvim-tree |
| `<leader>u` | n | Toggle undotree |
| `<C-\>` | n/i | Toggle floating terminal |
| `<leader>tp` | n | Python REPL |
| `<leader>tn` | n | Node REPL |
| `<leader>xf` | n | Run current file (python, node, ts-node, lua, bash, cargo, gcc/g++) |

### Inside the floating terminal

| Keys | Mode | What it does |
|---|---|---|
| `<Esc>` / `jk` | t | Terminal → normal |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | t | Leave terminal and move windows |

### Inside nvim-tree

Defaults stay (`P` = parent, `?` lists them). Custom overlays:

| Keys | What it does |
|---|---|
| `A` | Expand all |
| `?` | Help |
| `C` | CD to node |
| `gy` | Print absolute path |
| `Z` | Open with system handler |

---

## Buffers and tabs

| Keys | Mode | What it does |
|---|---|---|
| `<S-l>` / `<S-h>` | n | Next / previous buffer |
| `<leader>.` / `<leader>,` | n | Next / previous buffer |
| `<leader>1` … `<leader>9` | n | Go to bufferline ordinal 1–9 |
| `<leader>bp` | n | Pick buffer |
| `<leader>bo` | n | Close other buffers |
| `<leader>bl` / `<leader>br` | n | Close buffers left / right |
| `<leader>bd` / `<leader><Esc>` | n | Delete buffer (`:Bdelete`) |
| `<leader>bD` | n | Delete buffer and go previous |
| `<leader>bn` | n | New buffer |
| `<leader><Tab>n` | n | New tab |
| `<leader><Tab>c` | n | Close tab |
| `<leader><Tab>l` / `<leader><Tab>h` | n | Next / previous tab |

---

## Windows and splits

| Keys | Mode | What it does |
|---|---|---|
| `<leader>wh` / `wj` / `wk` / `wl` | n | Move to window |
| `<leader>w<Up>` / `w+` | n | Increase height |
| `<leader>w<Down>` / `w-` | n | Decrease height |
| `<leader>w<Left>` / `<leader>w<Right>` | n | Decrease / increase width |
| `<leader>wm` | n | Maximize |
| `<leader>w=` / `<leader>se` | n | Equalize |
| `<leader>wr` / `<leader>wR` | n | Rotate |
| `<leader>wx` | n | Swap with next |
| `<leader>wo` | n | Close other windows |
| `<leader>sv` / `<leader>sh` | n | Vertical / horizontal split |
| `<leader>sx` | n | Close split |

---

## Save, quit, sessions, config

| Keys | Mode | What it does |
|---|---|---|
| `<leader>ww` | n | Save |
| `<leader>W` | n | Save all |
| `<C-s>` | i | Save (leaves insert) |
| `<leader>q` | n | Quit window |
| `<leader>Q` | n | Quit all |
| `<leader>Ss` | n | Save session (prompt for name) |
| `<leader>Sl` | n | Load session |
| `<leader>xr` | n | `:source` current file |
| `<leader>xx` | n | Reload `$MYVIMRC` |

Ex aliases: `:W` write, `:Q` quit, `:Wq` / `:WQ` write-quit.

---

## Editing (normal / visual)

| Keys | Mode | What it does |
|---|---|---|
| `<A-j>` / `<A-k>` | n | Move line down / up |
| `<A-j>` / `<A-k>` | v | Move selection down / up |
| `<leader>dl` | n | Duplicate line |
| `<leader>dl` | v | Duplicate selection |
| `<leader>o` / `<leader>O` | n | Blank line below / above |
| `<leader>D` | n | Delete line, no yank |
| `<leader>D` | v | Delete selection, no yank |
| `<leader>dw` | n | Delete inner word, no yank |
| `<leader>cw` | n | Change inner word |
| `<leader>p` | x | Paste without yanking replaced text |
| `Y` | n | Yank to end of line |
| `<leader>Y` | n/v | Yank to system clipboard |
| `<leader>yy` | n | Yank line to system clipboard |
| `<leader>y` | n | Yank entire file to clipboard |
| `<leader>P` | n/v | Paste from system clipboard |
| `<leader>a` | n | Select all |
| `J` | n | Join lines, cursor stays |
| `gJ` | n | Join lines (keep spaces) |
| `<` / `>` | v | Indent, stay in visual |
| `<leader>ss` / `<leader>su` | v | Sort / sort unique |
| `<leader>"` `'` `(` `[` `{` | v | Wrap selection |
| `<leader>xc` | n | Swap two characters |
| `<leader>xu` / `xl` / `xt` | n | UPPER / lower / toggle case of word |
| `gp` / `gV` | n | Reselect pasted / last changed text |

### Comments (Comment.nvim)

Plugin defaults `gcc` / `gc` (linewise) and `gbc` / `gb` (block) still work.

| Keys | Mode | What it does |
|---|---|---|
| `<leader>cc` | n/v | Toggle line comment |
| `<C-_>` | n/v | Toggle line comment (`Ctrl-/` on many terminals) |

### Surround (nvim-surround defaults)

| Keys | Mode | What it does |
|---|---|---|
| `ys{motion}` / `yss` | n | Add surround |
| `ds{char}` | n | Delete surround |
| `cs{old}{new}` | n | Change surround |
| `S` | v | Surround selection |

---

## Insert mode

`<C-j>` / `<C-k>` / `<C-e>` move the cursor unless the completion menu is open (then they belong to nvim-cmp).

| Keys | What it does |
|---|---|
| `<C-h>` / `<C-l>` / `<C-j>` / `<C-k>` | Move cursor |
| `<C-e>` / `<C-a>` | End / start of line |
| `<C-s>` | Save |
| `<C-z>` | Undo |
| `<C-;>` / `<C-,>` | `;` / `,` at end of line |
| `<C-BS>` | Delete word backward |
| `<C-Del>` | Delete word forward |
| `,` `.` `;` | Insert character and split undo |

### Completion (nvim-cmp, insert / select)

| Keys | What it does |
|---|---|
| `<C-Space>` | Open completion |
| `<C-j>` / `<Tab>` | Next item (when menu visible; Tab also expands/jumps snippets) |
| `<C-k>` / `<S-Tab>` | Previous item (S-Tab also jumps snippet backward) |
| `<CR>` | Confirm (auto-selects first item) |
| `<C-e>` | Abort menu |
| `<C-b>` / `<C-f>` | Scroll docs |

---

## Navigation and search

| Keys | Mode | What it does |
|---|---|---|
| `<C-d>` / `<C-u>` | n | Scroll, keep cursor centered |
| `n` / `N` | n | Next / previous search match, centered |
| `*` / `#` | n | Search word, centered |
| `*` | v | Search selection, stay |
| `//` | v | Search for selection |
| `<Esc>` | n | Clear search highlight |
| `<leader>rw` | n | Substitute word under cursor |
| `gh` / `gl` | n/v | First non-blank / end of line |
| `g}` / `g{` | n/v | Next / previous paragraph |
| `G` / `gg` | n | End / start of file, centered |
| `'` | n | Jump to mark (exact position, like `` ` ``) |
| `<A-Left>` / `<leader>jo` | n | Jump older (`<C-o>`) |
| `<A-Right>` / `<leader>ji` | n | Jump newer (`<C-i>`) |
| `za` `zo` `zc` `zO` `zC` | n | Folds |

Treesitter incremental selection: `<C-space>` grow, `<bs>` shrink.

---

## Lists, toggles, which-key

| Keys | Mode | What it does |
|---|---|---|
| `<leader>co` / `<leader>cq` | n | Open / close quickfix |
| `]q` / `[q` | n | Next / previous quickfix |
| `]l` / `[l` | n | Next / previous location list |
| `<leader>ts` | n | Toggle spell |
| `<leader>Tr` | n | Toggle relative numbers |
| `<leader>Tn` | n | Toggle line numbers |
| `<leader>Tw` | n | Toggle wrap |
| `<leader>Tl` | n | Toggle list chars |
| `<leader>Tc` | n | Toggle cursorline |
| `<leader>Tv` | n | Toggle virtualedit |
| `<leader>?` | n | Buffer-local which-key |

`q` closes help, lspinfo, man, notify, quickfix, and checkhealth buffers.

---

## Dashboard (empty start)

| Key | What it does |
|---|---|
| `f` | Find file |
| `r` | Recent files |
| `c` | Open `$MYVIMRC` |
| `q` | Quit |
