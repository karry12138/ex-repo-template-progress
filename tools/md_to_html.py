#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""md_to_html.py - render Markdown to readable HTML."""

import os, re, sys, html as _h
from pathlib import Path
from markdown_it import MarkdownIt

try:
    from pygments import highlight
    from pygments.lexers import get_lexer_by_name, guess_lexer
    from pygments.formatters import HtmlFormatter
    HAVE_PYGMENTS = True
except Exception:
    HAVE_PYGMENTS = False

HERE = os.path.dirname(os.path.abspath(__file__))
def _css():
    p = os.path.join(HERE, "_html_style.css")
    return open(p, encoding="utf-8").read() if os.path.exists(p) else ""


def slugify(text):
    s = re.sub(r"[^a-zA-Z0-9\u4e00-\u9fa5]+", "-", text or "").strip("-")
    return s.lower() or "sec"


def _hl(code, lang, attrs=None):
    if not (HAVE_PYGMENTS and lang):
        return "<pre><code>" + _h.escape(code) + "</code></pre>"
    try:
        lex = get_lexer_by_name(lang)
    except Exception:
        try:
            lex = guess_lexer(code)
        except Exception:
            lex = None
    if lex is None:
        return "<pre><code>" + _h.escape(code) + "</code></pre>"
    return highlight(code, lex, HtmlFormatter(nowrap=True))


def _toc(tokens):
    toc = []
    for i, tok in enumerate(tokens):
        if tok.type == "heading_open" and tok.tag in ("h1", "h2", "h3"):
            nxt = tokens[i + 1] if i + 1 < len(tokens) else None
            txt = nxt.content if (nxt and nxt.type == "inline") else ""
            toc.append((int(tok.tag[1]), txt))
    return toc


def markdown_to_html(source, title):
    md = MarkdownIt("commonmark", {"html": True, "linkify": True}).enable(["table"])
    md.options["highlight"] = _hl
    tokens = md.parse(source)
    body = md.render(source)

    toc_html = ""
    toc = _toc(tokens)
    if toc:
        items = []
        for level, txt in toc:
            cls = ("class=\"l%d\"" % level) if level > 1 else ""
            items.append(f"<li {cls}><a href=\"#{slugify(txt)}\">{_h.escape(txt)}</a></li>")
        toc_html = "<div class=\"toc\"><strong>目录</strong><ul>" + "".join(items) + "</ul></div>"

    html_out = "".join([
        "<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"utf-8\">\n",
        "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n",
        f"<title>{_h.escape(title)}</title>\n",
        "<style>" + _css() + "</style>\n</head>\n<body>\n",
        "<div class=\"topbar\"><div class=\"topbar-inner\"><span class=\"br\">MD→HTML</span>",
        f"<span>{_h.escape(title)}</span></div></div>\n",
        "<div class=\"wrap\">",
        "<article>" + toc_html + body + "</article>",
        "<div class=\"footer\">由 md_to_html.py 生成 · 阅读用 · 原始 markdown 仍为执行依据</div>",
        "</div>\n</body>\n</html>",
    ])
    return html_out


def convert(path):
    p = Path(path)
    if not p.exists():
        print(f"[skip] not found: {p}", file=sys.stderr); return None
    src = p.read_text(encoding="utf-8")
    out = p.with_suffix(".html")
    out.write_text(markdown_to_html(src, p.stem), encoding="utf-8")
    print(f"[ok]   {p} -> {out}")
    return out


def main():
    args = [a for a in sys.argv[1:]]
    all_docs = "--all-docs" in args
    files = [a for a in args if a != "--all-docs"]
    if all_docs:
        root = Path("docs")
        files = [str(p) for p in sorted(root.rglob("*.md")) if ".git" not in p.parts]
    if not files:
        print("usage: md_to_html.py <file.md> ... | --all-docs"); return 1
    for f in files:
        convert(f)
    return 0


if __name__ == "__main__":
    sys.exit(main())
