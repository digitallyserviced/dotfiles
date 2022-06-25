local class = require('lib.lupy')
class [[ FormatItem ]]
  top = ''
  name = ''
  other = nil
  function __init__(self, n)
    self.name = n or name
  end
  function __call(self, t)
    out = {}
    out[self.name] = t
    return out
  end
  function __add(self, o)
    self.other = o
  end
_end()
class [[ Attribute < FormatItem ]]
  function __init__(self, n)
    self.top = 'Attribute'
  end
_end()
class [[ Underline < Attribute ]]
  function __init__(self, n)
    self.name = n or ""
  end
_end()
class [[ Text < FormatItem ]]
  function __init__(self)
    super('Text')
  end
_end()

