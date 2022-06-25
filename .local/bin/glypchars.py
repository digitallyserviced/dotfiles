#!/usr/bin/python3
from typing import List, Dict, Union, Iterable
from random import randint
import math
from rich.console import Console,Group
from rich.text import Text
from rich.style import Style
from rich.color import Color
from rich.panel import Panel
import functools
import itertools

console = Console()
keys: List[str] = []
chars: List[str] = []
sets: List[List[str]] = []
styles: List[Style] = []
all: List[str] = []
for c in range(0,16):
    styles.append(Style(color=f'color({c})'))
    
def randcolor():
    return styles[randint(0, len(styles)-1)]

def colorize(t: str):
    txt = Text(t,style=randcolor())
    return txt

# for i in range(0x1fb00,0x1fb3b,0x01):
for i in range(0x1fb12,0x1fb81,0x01):
    keys.append(chr(i))
    
for b in range(1, 10):
    one: int = randint(0, len(keys)-1)
    pairs: List[str] = []
    for d in [4,8,12,14,16]:
        comp: int = (one + d) % (len(keys)-1)
        pairs.append(f'{keys[one]}{keys[comp]}')
        all.append(f'{keys[one]}')
        all.append(f'{keys[comp]}')
    sets.append(pairs)
    
def getiter(num: int):
    for i in range(num):
        one: int = randint(0, len(all)-1)
        yield all[one]
        num=num-1
        
shits: List[List[str]] = []
def getone():
    shit = next(getiter(1))
    return str(shit)
def genit(width: int, height: int):    
    tt: str = Text("")    
    ls: List[List[str]] = []
    for i in range(height):
        st: str = ""       
        lss: List[str] = []
        for t in getiter(width):
            lss.append(t)
            st=f'{st}{t}'
            ls.append(lss)
        tt.append(st)
        tt.append("\n")
    
    shits.append(ls)
    return tt

def gens(count: int):
    for c in range(count):
        yield genit(1,1)

def bgen(cw: int, ch: int):
    wides = yield from gens(cw)
    cs = " ".join(list(wides))
    console.print(cs)

def getcol():
    return getone()
    # return colorize(getone())

def doit():
    for i in gens(10):
        # txt = Group(
        #     getcol(),
        #     getcol(),
        #     
        # )
        txt = Text("")
        txt.append(getcol())
        txt.append(getcol())
        txt.append(" ")
        txt.append(getcol())
        txt.append(getcol())
        
        txt.append("\n")
        txt.append(getcol())
        txt.append(getcol())
        txt.append(" ")
        txt.append(getcol())
        txt.append(getcol())
        txt.append("\n")
        txt.append("\n")
        txt.append("\n")
        txt.append("\n")
        console.print(txt)
        
if __name__ == "__main__":
    doit()
else:
    doit()
for i in range(0xe0b0,0xe0d4,0x04):
    ran = randint(1,16)
    color = f"color({ran})"
    style = Style(color=color)
    bgstyle = Style(bgcolor=color)
    uni = Text(chr(i),style=style)
    fill = Text("       ",style=bgstyle)
    uniend = Text(chr(i+0x02),style=style)
    console.print(uniend, fill, uni,sep="",justify="center")
    txt=('𝚨','𝚩','𝚪','𝚫','𝚬','𝚭','𝚮','𝚯','𝚰','𝚱','𝚲','𝚳','𝚴','𝚵','𝚶','𝚷','𝚸','𝚹','𝚺','𝚻','𝚼','𝚽','𝚾',)
    txt=('ᴀ','ᴁ','ᴂ','ᴃ','ᴄ','ᴅ','ᴆ','ᴇ','ᴈ','ᴉ','ᴊ','ᴋ','ᴌ','ᴍ','ᴎ','ᴏ','ᴐ','ᴔ','ᴕ','ᴖ','ᴗ','ᴘ','ᴙ','ᴚ','ᴛ','ᴜ','ᴫ','ᴪ','ᴩ','ᴨ','ᴧ','ᴦ','ᴥ','ᴤ','ᴣ','ᴢ','ᴡ','ᴠ',)
    for c in range(len(txt)):
        console.print(txt[c], justify="center")


# 🮽🮾🮿🮯
# 0x1fba0,0x1fba0+0x0f,0x01
# 🮽🮾🮿🮯  ─━│┃┄┅┆┇┈┉┊┋╌╍╎╏╭╮╯╰╱╲╳╴╶╸╺╼╾╿╽╻╹╷╵╵╌╎╍╏═║⠑⠑⠔⠢⡠⢄⠊⢎⢕⡱⢸⡇⡾⡷⢾⢷⣹⣸⣫⣏⢕⡪⡯⢏⣟⣯⡿    
# 𝞟𝚨𝚩𝚪𝚫𝚬𝚭𝚮𝚯𝚰𝚱𝚲𝚳𝚴𝚵𝚶𝚷𝚸𝚹𝚺𝚻𝚼𝚽𝚾𝚿𝛀𝛁𝛂𝛃𝛄𝛅𝛆𝛇𝛈𝛉𝛊𝛋𝛌𝛍𝛎𝛏𝛐𝛑𝛒𝛓𝛔𝛕𝛖𝛗𝛘𝛙𝛚𝛛𝛜𝛝𝛞𝛟𝛠𝛡𝛢𝛣𝛤𝛥
# 𝛦𝛧𝛨𝛩𝛪𝛫𝛬𝛭𝛮𝛯𝛰𝛱𝛲𝛳𝛴𝛵𝛶𝛷𝛸𝛹𝛺𝛻𝛼𝛽𝛾𝛿𝜀𝜁𝜂𝜃𝜄𝜅𝜆𝜇𝜈𝜉𝜊𝜋𝜌𝜍𝜎𝜏𝜦𝜩𝜋𝜛𝜫𝜭𝜮𝜞𝛺𝛷𝜆𝜉𝜓𝜁𝜇𝝀𝝉𝝈𝝇𝝆𝝅𝝄𝝃𝝂𝝁𝝀𝜿𝜾𝜽𝜼𝜻𝜺𝜹𝜸𝝈𝝉𝝊𝝋𝝌𝝍𝝎
# 𝝏𝝐𝝑𝝒𝝓𝝔𝝖𝝗𝝘𝝙𝝚𝝛𝝜𝝝𝝞𝝟𝝠𝝡𝝢𝝣𝝤𝝥𝝦𝝧𝝨𝝩𝝪𝝫𝝬𝝭𝝮𝝯𝝰𝝱𝝲𝝳𝝴𝝵𝝶𝝷𝝸𝝹𝝺𝝻𝝼𝝽𝝾𝝿𝞀𝞁𝞂𝞃𝞄𝞅𝞆𝞇𝞈𝞉𝞊𝞋𝞌𝞍𝞎𝞏𝞐𝞑𝞒𝞓𝞔𝞕𝞖𝞗𝞘𝞙𝞚𝞛𝞜𝞝𝞞𝞟𝞠𝞡𝞢𝞣
# 𝞤𝞥𝞦𝞧𝞨𝞩𝞪𝞫𝞬𝞭𝞮𝞯𝞰𝞱𝞲𝞳𝞴𝞵𝞶𝞷𝞸𝞺𝞻𝞼𝞽𝞾𝞿𝟀𝟁𝟂𝟃𝟅𝟆𝟇𝟈𝟉𝟊𝟋𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗
# 🮽🮾🮿🮯  ─━│┃┄┅┆┇┈┉┊┋╌╍╎╏╭╮╯╰╱╲╳╴╶╸╺╼╾╿╽╻╹╷╵╵╌╎╍╏═║⠑⠑⠔⠢⡠⢄⠊⢎⢕⡱⢸⡇⡾⡷⢾⢷⣹⣸⣫⣏⢕⡪⡯⢏⣟⣯⡿   
# (ᴀᴁᴂᴃᴄᴅᴆᴇᴈᴉᴊᴋᴌᴍᴎᴏᴐᴔᴕᴖᴗᴘᴙᴚᴛᴜᴫᴪᴩᴨᴧᴦᴥᴤᴣᴢᴡᴠᴰᴱᴲᴳᴴᴵᴶᴷᴸᴹᴺᴻᴼᴽᴾᴿᴯᴮᴭᴬᵏᵎᵍᵌᵋᵊᵉᵈᵇᵆᵅᵄᵃᵂᵁᵀᚠᚡᚢᚣᚤᚥᚦᚧᚨᚩᚪᚫᚬᚭᚮᚯᚰᚱᚲᚳᚴᚵᚶᚷᚸᚹᚺᚻᚼᚽᚾᚿᛀᛁᛂᛃᛄᛅᛆᛇᛈᛉᛊᛋᛌᛍᛎᛏᛐᛑᛒᛓᛔᛕᛖᛗᛘᛙᛚᛛᛜᛝᛞᛟᛠᛡᛢᛣᛤᛥᛦᛧᛨᛩᛪ᛫᛬᛭ᛮᛯᛰᛱᛲᛳᛴᛵᛶᛷᛸ
# 🮠🮡🮢🮣🮤🮥🮦🮧🮨🮩🮪🮫🮬🮭🮮 0🮽🮾🮿🮯  ─━│┃┄┅┆┇┈┉┊┋╌╍╎╏╭╮╯╰╱╲╳╴╶╸╺╼╾╿╽╻╹╷╵╵╌╎╍╏═║⠑⠑⠔⠢⡠⢄⠊⢎⢕⡱⢸⡇⡾⡷⢾⢷⣹⣸⣫⣏⢕⡪⡯⢏⣟⣯⡿   
# 1ᝀᝁᝂᝃᝄᝅᝆᝇᝈᝉᝊᝋᝌᝍᝎᝏᝐᝑᝑᝒᝓᨀᨁᨂᨃᨄᨅᨆᨇᨈᨉᨊᨋᨌᨍᨎᨏᨐᨑᨒᨓᨔᨕᨖᨘᨗᨙᨚ᨞᨟𞤐𞤑𞤁𞤀𞤁𞤂𞤃𞤄𞤅𞤆𞤇𞤈𞤇𞤇ＡＡＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾⚸𞤗𞤧𞤷𞥇    ⚸⚳⚴⚵⚶⚲⚶⚷⯓⯔⯕⯖⯗⯘⯙⯚⯛⯜⯝⯞⯟⯠⯡⯢⯣⯤⯥⯦⯧⯨⯩⯪⯫⯄⯅
