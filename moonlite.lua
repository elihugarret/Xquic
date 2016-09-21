--[[
TODO:


--]]


local M = {}

-- Load external libs
local moses = require "moses"
local midi = require "luamidi"
local ffi = require "ffi"
local audio = require "proAudioRt"

-- The Seed
math.randomseed(os.clock())

-- local variables
local loadf = audio.sampleFromFile
local xp = xpcall
local mt = {} -- The Meta T
local meth  = {} -- The Meths
-- Load samples

-- Sets a drum kit
M.kit = ""
-- You can add more samples here!
local dir = "../Samples/"..M.kit
local kick = loadf(dir.."kick.ogg")
local snare = loadf(dir.."snare.ogg")
local openhat = loadf(dir.."openhat.ogg")
local hat = loadf(dir.."hat.ogg")
local robot = loadf(dir.."robot.ogg")
local velcro = loadf(dir.."velcro.ogg")
local iron = loadf(dir.."iron.ogg")
local exhale = loadf(dir.."exhale.ogg")
local air = loadf(dir.."air.ogg")
local ice = loadf(dir.."ice.ogg")
local kitkick = loadf(dir.."kitkick.ogg")
local metal = loadf(dir.."metal.ogg")
local tin = loadf(dir.."tin.ogg")
local tam = loadf(dir.."tam.ogg")
local mar = loadf(dir.."mar.ogg")
local cab = loadf(dir.."mar.ogg")
local req = loadf(dir.."reg.ogg")
local pan = loadf(dir.."pan.ogg")
local woo = loadf(dir.."woo.ogg")
local sna = loadf(dir.."sna.ogg")

-- Assign a letter to a sample
local samples = {
  k = kick, s = snare, o = openhat, h = hat, r = robot, v = velcro, i = iron, e = exhale,
  a = air, c = ice, t = kitkick, m = metal, n = tin, p = tam, q = mar, b = cab, u = req,
  v = pan, w = woo, y = sna
}

-- Local Functions

local function midi_notes()
  local n = "c c# d d# e f f# g g# a a# b"
  local t = {}
  local c = 0
  for i = -1, 8 do
    for j in n:gmatch"%g+" do
      t[j..i] = c
      c = c + 1
    end
  end
  return t
end

M.n = midi_notes()

local function syn(s)
  local t = {}
  local i, j = 1, 1
  local w
  for v in s:gmatch"%g+" do
    if v:match"%:" then
      t[i] = {}
      w = v:gsub("[%:%(%)]+", " ")
      for b in w:gmatch"%g+" do
        t[i][j] = b
        j = j + 1
      end
    else
      t[i] = v
    end
    i = i + 1
  end
  return t
end

local function normalize(i, f, t)
  local tr = {}
  local x_max = moses.max(t)
  local x_min = moses.min(t)
  for j = 1, #t do
    tr[j] = floor(i + (((t[j] - x_min) * (f - i)) / (x_max - x_min)))
  end
  return tr
end

local function specific_normal(t1, t2)
  local tq = {}
  local n = normalize(1, #t1, t2)
  for c, v in ipairs(n) do
    tq[c] = t1[v]
  end
  return tq
end

-- Objects

function M.N(n)
  if type(n) == "table" then
    setmetatable(n, mt)
    return n
  elseif type(n) == "string" then
    local o = syn(n)
    setmetatable(o, mt)
    return o
  end
end

-- Meta T

function mt.__add(a, b)
  local t = {}
  local x, y
  for i = 1, #a do
    x = M.n[a[i]]
    y = a[i]
    if x then
      t[i] = x + b
    elseif type(y) == "number" then
      t[i] = y + b
    else
      t[i] = "."
    end
  end
  return t
end

function mt.__sub(a, b)
  local t = {}
  local x, y
  for i = 1, #a do
    x = M.n[a[i]]
    y = a[i]
    if x then
      t[i] = x - b
    elseif type(y) == "number" then
      t[i] = y - b
    else
      t[i] = "."
    end
  end
  return t
end

function mt.__unm(a) return moses.reverse(a) end

-- Methods

function meth:shift(a)
  local x
  if a < 0 then
    x = moses.push(self, moses.pop(self, math.abs(a)))
  else
    x = moses.addTop(self, moses.unshift(self, a))
  end
  return x
end


mt.__index = meth

-- General Functions

function M.init(file)
  while true do
    local luna = xp(
    function () return require(file) end,
    function ()
      print "YOU SCREWED IT!!"
      M.sleep(1)
    end)
    package.loaded[file] = nil
  end
end

function M.c_wrap(c, l)
  local v = c % l
  if v == 0 then
    return l
  else
    return v
  end
end

-- Time Functions

ffi.cdef[[
  void Sleep(int ms);
  int poll(struct pollfd *fds, unsigned long nfds, int timeout);
]]

if ffi.os == "Windows" then
  function M.sleep(s) ffi.C.Sleep(s*1000) end
else
  function M.sleep(s) ffi.C.poll(nil, 0, s*1000) end
end

function M.bpm(beats) return (60/b) / 2 end


return M
