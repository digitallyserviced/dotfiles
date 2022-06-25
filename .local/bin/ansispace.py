#!/usr/bin/python3
# ▚▘▚▞▆│─━┄┅┈┉╌╍╴╶╸╺╼╽╾═⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿‐‑‒–—―․‥…‧›‹※⁌⁍⁖⁗⁘⁙⁚⁛⁜⁝⁞⁎⁈⁅⁆‣⁃▪▫▬▭▮▯▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟◠◡◢◣◤◥◦◧◨◩◪◫◬◭◮◯◰◱◲◳◴◵◶◷◸◹◺◻◼◽◾◿🞁🞂🞃🞄🞅🞆🞇🞈🞉🞊🞋🞌🞍🞎🞏🞐🞑🞒🞓🞔🞕🞖🞗🞘🞙🞚🞛🞜🞝🞞🞟🞠🞡🞢🞣🞤🞥🞦🞧🞨🞩🞪🞫🞬🞭🞮🞯🞰🞱🞲🞳🞴🞵🞶🞷🞸𐊔𐊅𐊏𐊎𐊍𐊌𐊋𐊛𐊜𐊚𐊙𐊘𐊔᠆᠇᠊ꡀꡁꡂꡃꡄꡅꡆꡇꡈꡉꡊꡚꡙꡘꡨꡧꡦꡖ⤒
import io
import re
from rich import console
from rich import live_render
from rich.box import HORIZONTALS, ROUNDED, SIMPLE, Box
from rich.padding import PaddingDimensions
from rich.pretty import pprint
from rich.panel import Panel
from rich.live import Live
from rich.console import Console, ConsoleDimensions, JustifyMethod, OverflowMethod, ScreenContext
from rich.live_render import LiveRender
from rich.text import Text
# f=io.open("/home/chris/.cache/cap.ans",'r')
# console=Console(ScreenContext.update())
# live = LiveRender(console, screen=True)
f=io.open("/dev/stdin",'r')
text=f.read()
matches=re.finditer(r"(\x1b\[[0-9;]+m?)", text)
prev=0
newtext=u""
# replacetext="🞅"
replacetext="▪" # ▪▫
for num, m in enumerate(matches):
    loc = m.span()
    if prev != loc[0]:
        padlen=loc[0]-prev
        cur=text[prev:loc[0]]
        spil=cur.partition("\n")
        padding=[]
        if spil[1]=="\n":
            spil=(spil[0],"",spil[2])
        
        # padding=['■'*len(spil[0]),'■'*len(spil[2])]
        rchar=replacetext
        if (" "*len(spil[0]))==spil[0]:
            rchar=" "
        else:
            rchar=replacetext
        padding.append(rchar*len(spil[0]))
        if (" "*len(spil[2]))==spil[2]:
            rchar=" "
        else:
            rchar=replacetext
            
        padding.append(rchar*len(spil[2]))
                
        # padding=[replacetext*len(spil[0]),replacetext*len(spil[2])]
        padding=spil[1].join(padding)
        newtext+=padding
    newtext+=text[loc[0]:loc[1]]
    prev=loc[1]
if prev < len(text):
    newtext+=text[prev:]
# print(newtext)

# panel = Panel(, padding=(0,0), box=HORIZONTALS, title=None, subtitle=None)
# from rich.text import DEFAULT_JUSTIFY
console = Console(soft_wrap=False,safe_box=True,force_terminal=True)
# console.soft_wrap = False
txt = Text(newtext,justify="left",overflow="crop",no_wrap=True)
with Live(Panel(txt, box=SIMPLE, expand=True, border_style="none", padding=0), console=console, screen=True, transient=True,vertical_overflow="crop", refresh_per_second=1, auto_refresh=False) as live:
    while True:
        live.update(txt)
#
#
#
#     pass
# live.update(panel)
# input("Press Enter to continue...")
