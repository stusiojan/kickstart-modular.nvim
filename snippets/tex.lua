-- LaTeX snippets (Castel / Mastnak style)
-- Autotrigger via LuaSnip's enable_autosnippets = true
local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

-- Context helpers
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end
tex.in_comment = function()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
tex.in_env = function(name)
  local is_inside = vim.fn['vimtex#env#is_inside'](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

local function auto(trig, nodes, opts)
  opts = opts or {}
  opts.trig = trig
  opts.snippetType = 'autosnippet'
  opts.wordTrig = opts.wordTrig ~= false
  return s(opts, nodes)
end

local M = {}
local A = {}

-- ===== Structure =====
table.insert(M, s({ trig = 'beg', dscr = 'begin/end environment' }, fmta(
  [[
  \begin{<>}
      <>
  \end{<>}
  ]], { i(1), i(2), rep(1) }
)))

table.insert(M, s({ trig = 'template', dscr = 'thesis skeleton' }, fmta(
  [[
  \documentclass[12pt,a4paper]{article}
  \usepackage[utf8]{inputenc}
  \usepackage[T1]{fontenc}
  \usepackage[polish]{babel}
  \usepackage{amsmath,amssymb,amsthm}
  \usepackage{graphicx}
  \usepackage{hyperref}
  \usepackage{cleveref}

  \title{<>}
  \author{<>}
  \date{\today}

  \begin{document}
  \maketitle

  <>

  \end{document}
  ]], { i(1, 'Tytuł'), i(2, 'Jan Stusio'), i(0) }
)))

-- Sections
table.insert(M, s({ trig = 'sec', dscr = 'section' }, fmta([[\section{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'ssec', dscr = 'subsection' }, fmta([[\subsection{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'sssec', dscr = 'subsubsection' }, fmta([[\subsubsection{<>}<>]], { i(1), i(0) })))

-- Environments
for _, env in ipairs {
  { 'eq',   'equation' },
  { 'eq*',  'equation*' },
  { 'align', 'align' },
  { 'align*', 'align*' },
  { 'item', 'itemize' },
  { 'enum', 'enumerate' },
  { 'fig',  'figure' },
  { 'tbl',  'table' },
  { 'thm',  'theorem' },
  { 'lem',  'lemma' },
  { 'defi', 'definition' },
  { 'prf',  'proof' },
} do
  local trig, name = env[1], env[2]
  table.insert(M, s({ trig = trig, dscr = name .. ' env' },
    fmta([[\begin{<>}
    <>
\end{<>}]], { t(name), i(1), t(name) })))
end

-- Citations & refs
table.insert(M, s({ trig = 'cit', dscr = 'cite' }, fmta([[\cite{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'cref', dscr = 'cref' }, fmta([[\cref{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'lbl', dscr = 'label' }, fmta([[\label{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'fref', dscr = 'figure ref block' }, fmta(
  [[
  \begin{figure}[<>]
      \centering
      \includegraphics[width=<>\textwidth]{<>}
      \caption{<>}
      \label{fig:<>}
  \end{figure}
  ]], { i(1, 'h'), i(2, '0.8'), i(3, 'path'), i(4, 'caption'), i(5, 'label') }
)))

-- ===== Math mode switchers (autosnippets) =====
table.insert(A, auto('mk', fmta([[$<>$<>]], { i(1), i(0) }), { condition = tex.in_text }))
table.insert(A, auto('dm', fmta([[
\[
    <>
\]
<>]], { i(1), i(0) }), { condition = tex.in_text, wordTrig = true }))

-- ===== Math autosnippets (only in math) =====
table.insert(A, auto('//', fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }), { condition = tex.in_mathzone }))
table.insert(A, auto('sr', t '^2', { condition = tex.in_mathzone, wordTrig = false }))
table.insert(A, auto('cb', t '^3', { condition = tex.in_mathzone, wordTrig = false }))
table.insert(A, auto('td', fmta([[^{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone, wordTrig = false }))
table.insert(A, auto('__', fmta([[_{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone, wordTrig = false }))
table.insert(A, auto('sq', fmta([[\sqrt{<>}<>]], { i(1), i(0) }), { condition = tex.in_mathzone }))
table.insert(A, auto('EE', t '\\exists ', { condition = tex.in_mathzone }))
table.insert(A, auto('AA', t '\\forall ', { condition = tex.in_mathzone }))
table.insert(A, auto('inn', t '\\in ', { condition = tex.in_mathzone }))
table.insert(A, auto('notin', t '\\not\\in ', { condition = tex.in_mathzone }))
table.insert(A, auto('sub', t '\\subset ', { condition = tex.in_mathzone }))
table.insert(A, auto('sube', t '\\subseteq ', { condition = tex.in_mathzone }))
table.insert(A, auto('cup', t '\\cup ', { condition = tex.in_mathzone }))
table.insert(A, auto('cap', t '\\cap ', { condition = tex.in_mathzone }))
table.insert(A, auto('==', t '&= ', { condition = tex.in_mathzone }))
table.insert(A, auto('!=', t '\\neq ', { condition = tex.in_mathzone }))
table.insert(A, auto('<=', t '\\leq ', { condition = tex.in_mathzone }))
table.insert(A, auto('>=', t '\\geq ', { condition = tex.in_mathzone }))
table.insert(A, auto('->', t '\\to ', { condition = tex.in_mathzone }))
table.insert(A, auto('=>', t '\\implies ', { condition = tex.in_mathzone }))
table.insert(A, auto('<->', t '\\leftrightarrow ', { condition = tex.in_mathzone }))

-- Sums/integrals
table.insert(A, auto('sum', fmta([[\sum_{<>}^{<>} <>]], { i(1, 'i=1'), i(2, 'n'), i(0) }), { condition = tex.in_mathzone }))
table.insert(A, auto('int', fmta([[\int_{<>}^{<>} <> \, d<>]], { i(1), i(2), i(3), i(4) }), { condition = tex.in_mathzone }))
table.insert(A, auto('lim', fmta([[\lim_{<> \to <>} <>]], { i(1, 'n'), i(2, '\\infty'), i(0) }), { condition = tex.in_mathzone }))

-- Greek (regex-like: semicolon prefix)
local greek = {
  { ';a', '\\alpha' }, { ';b', '\\beta' }, { ';g', '\\gamma' }, { ';G', '\\Gamma' },
  { ';d', '\\delta' }, { ';D', '\\Delta' }, { ';e', '\\epsilon' }, { ';ve', '\\varepsilon' },
  { ';z', '\\zeta' }, { ';h', '\\eta' }, { ';th', '\\theta' }, { ';Th', '\\Theta' },
  { ';i', '\\iota' }, { ';k', '\\kappa' }, { ';l', '\\lambda' }, { ';L', '\\Lambda' },
  { ';m', '\\mu' }, { ';n', '\\nu' }, { ';x', '\\xi' }, { ';X', '\\Xi' },
  { ';p', '\\pi' }, { ';P', '\\Pi' }, { ';r', '\\rho' }, { ';s', '\\sigma' },
  { ';S', '\\Sigma' }, { ';t', '\\tau' }, { ';u', '\\upsilon' }, { ';ph', '\\phi' },
  { ';Ph', '\\Phi' }, { ';vp', '\\varphi' }, { ';c', '\\chi' }, { ';ps', '\\psi' },
  { ';Ps', '\\Psi' }, { ';o', '\\omega' }, { ';O', '\\Omega' },
}
for _, g in ipairs(greek) do
  table.insert(A, auto(g[1], t(g[2] .. ' '), { condition = tex.in_mathzone, wordTrig = false }))
end

-- Text formatting
table.insert(M, s({ trig = 'bf', dscr = 'textbf' }, fmta([[\textbf{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'it', dscr = 'textit' }, fmta([[\textit{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'tt', dscr = 'texttt' }, fmta([[\texttt{<>}<>]], { i(1), i(0) })))
table.insert(M, s({ trig = 'emph', dscr = 'emph' }, fmta([[\emph{<>}<>]], { i(1), i(0) })))

return M, A
