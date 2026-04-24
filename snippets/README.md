# LaTeX workflow — nvim + VimTeX + Skim + LuaSnip

## Kompilacja
- `<leader>ll` — toggle continuous compile (latexmk, build/ folder)
- `<leader>lv` — forward search do Skim
- `<leader>le` — lista błędów
- `<leader>lc` — sprzątanie aux
- `<leader>lC` — sprzątanie aux + PDF
- `<leader>lt` — TOC (spis treści)
- `<leader>ls` — stop compile

VimTeX prefix: `<localleader>` = `<Space>` (leader == localleader). Pełna lista: `:help vimtex-default-mappings`.

## Skim — forward/inverse search

**Forward** (nvim → PDF): `<leader>lv` po `<leader>ll`.

**Inverse** (PDF → nvim): `Cmd+Shift+click` w Skim.

Konfiguracja Skim (jednorazowa, przez GUI):
1. Skim → Preferences → Sync
2. Preset: **Custom**
3. Command: `nvr`
4. Arguments: `--remote-silent +"%line" "%file"`
5. Check: "Check for file changes"

## Snippety

Autosnippety (rozwijają się bez Tab):
- `mk` → `$ $` inline math (tylko w tekście)
- `dm` → display math block
- `//` → `\frac{}{}` (tylko math)
- `sr`/`cb`/`td` → `^2`/`^3`/`^{}`
- `__` → `_{}`
- `sq` → `\sqrt{}`
- `;a`/`;b`/`;g`/... → `\alpha`/`\beta`/`\gamma`/...
- `==`/`!=`/`<=`/`>=`/`->`/`=>` → operatory

Trigger snippety (wymagają Tab):
- `beg` → environment
- `template` → szkielet pracy magisterskiej (babel polish)
- `sec`/`ssec`/`sssec` → sekcje
- `eq`/`align`/`item`/`enum`/`fig`/`thm`/`lem`/`defi`/`prf` → środowiska
- `cit`/`cref`/`lbl` → cite/cref/label
- `fref` → pełny figure block
- `sum`/`int`/`lim` → suma/całka/limit

## Pisownia
Auto: `spelllang=pl,en_us`. `z=` — propozycje poprawki na słowie.

## Conceal
`\alpha` wyświetla się jako α. Wyłącz: `:set conceallevel=0`.

## Nowy projekt — start

```
cd ~/thesis
nvim main.tex
```

W nvim: wpisz `template` → Tab → szkielet. Potem `<leader>ll` → compile leci w tle.
