--[[
TODO:
text algo
--]]

local M = {}

-- Load external libs
local moses = require "moses"
local midi = require "luamidi"
local ffi = require "ffi"
local audio = require "proAudioRt"

if not audio.create() then os.exit() end

-- The Seed
math.randomseed(os.clock())

-- local variables
local random = math.random
local xp = xpcall
local wrap = coroutine.wrap
local yield = coroutine.yield
local pattern1, pattern2  = "{(.-)}", "%g+"

local loadf = audio.sampleFromFile
local play = audio.soundPlay

local send_message = midi.sendMessage
local note_on = midi.noteOn

local add_top = moses.addTop
local push = moses.push
local pop = moses.pop
local unshift = moses. unshift

local mt = {} -- The Meta T
local meth = {} -- Another Meta T

-- non-local stuff
M.range = moses.range
M.loop = audio.loop
M.stop = audio.soundStop
-- Load samples
-- Sets a drum kit

-- You can add more samples here!
local s_dir = "../Samples/Sounds/"
local dir = "../Samples/"
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
    for j in n:gmatch(pattern2) do
      t[j..i] = c
      c = c + 1
    end
  end
  return t
end

local function iter_s(a) for v in a do yield(v) end end

local function syn(s)
  local t = {}
  local i, j = 1, 1
  local marked, nested = s:gsub(pattern1, "M"), s:gmatch(pattern1)
  local coro = wrap(iter_s)
  for v in marked:gmatch(pattern2) do
    if v == "M" then
      t[i] = {}
      for e in coro(nested):gmatch(pattern2) do
        t[i][j] = e
        j = j + 1
      end
    else
      t[i] = v
    end
    i = i + 1
    j = 1
  end
  return t
end

local function int_normalize(i, f, t)
  local tr = {}
  local x_max = moses.max(t)
  local x_min = moses.min(t)
  for j = 1, #t do
    tr[j] = math.floor(i + (((t[j] - x_min) * (f - i)) / (x_max - x_min)))
  end
  return tr
end

local function ft_normalize(i, f, t)
  local tr = {}
  local x_max = moses.max(t)
  local x_min = moses.min(t)
  for j = 1, #t do
    tr[j] = i + (((t[j] - x_min) * (f - i)) / (x_max - x_min))
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

local function wor1(v)
  while true do
    for x in v:gmatch"." do
      if x == " "  then
        yield(x)
      else
        yield(x)
      end
    end
  end
end

local function wor2(t)
  while true do
    for i = 1, #t do
      yield(t[i])
    end
  end
end

local function extract(a)
  local t = {}
  local j = 1
  for i = 1, #a do
    if a[i] ~= "." then
      t[j] = a[i]
      j = j + 1
    end
  end
  return t
end


-- Objects

function M.Seq(n) -- notes
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
  setmetatable(t, mt)
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
  setmetatable(t, mt)
  return t
end

function mt.__unm(a) 
  local x = moses.reverse(a) 
  setmetatable(x, mt)
  return x 
end

-- General Functions

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
--

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

function M.choose(...)
  local v = {...}
  return v[random(#v)]
end

-- Audio funcs

function M.sample(s)
  s.disparity = s.disparity or 0
  s.pitch = s.pitch or 1
  s.L = s.L or .5
  s.R = s.R or .5
  local sound = loadf(dire..s.file..".ogg")
  play(sound, s.L, s.R, s.disparity, s.pitch)
end

local function ssplay(sound, left, right, disparity, pitch)
  if sound and type(sound) == "string" and sound ~= "." then
    play(samples[sound], left, right, disparity, pitch)
  end
end

function M.splay(sound, left, right, disparity, pitch)
  if type(sound) == "table" then
    for i = 1, #sound do
      ssplay(sound[i], left, right, disparity, pitch)
    end
  else
    ssplay(sound, left, right, disparity, pitch)
  end
end

-- Midi funcs

M.n = midi_notes()

local function ooff(note, port, channel)
    if note and note ~= "." then
      send_message(port, 128, M.n[note] or note, 0, channel)
    end
end

function M.off(note, port, channel)
  if type(note) == "table" then
    for i = 1, #note do
      ooff(note[i], port,channel)
    end
  else
    ooff(note, port,channel)
  end
end

local function oon(note, vel, port, channel)
  if note and note ~= "." then
    note_on(port, M.n[note] or note, vel, channel)
  end
end

function M.on(note, vel, port, channel)
  if type(note) == "table" then
    for i = 1, #note do
      oon(note[i], vel, port, channel)
    end
  else
    oon(note, vel, port, channel)
  end
end

-- Methods

function meth:shift(a)
  local x
  if a < 0 then
    x = push(self, pop(self, math.abs(a)))
  else
    x = add_top(self, unshift(self, a))
  end
  return x
end

function meth:as_chord(counter, inicial, final, port, vel, channel)
  port = port or 0
  vel = vel or 77
  channel = channel or 0
  if counter == inicial then
    for c, v in ipairs(self) do
      M.on(M.n[v] or v, vel, port, channel)
    end
  elseif counter == final then
    for x, y in ipairs(self) do
      M.off(M.n[y] or v, port, channel)
    end
  end
end

function meth:as_pattern(p, tam)
  local t = {}
  local cor1, cor2 = wrap(wor1), wrap(wor2)
  for i=1, tam do
    if cor1(p) == " " then
      t[i] = "."
    else
      t[i] = cor2(self)
    end
  end
  setmetatable(t, mt)
  return t 
end

function meth:fill()
  local z = moses.clone(self)
  local j = 1
  local x = extract(self)
  if self[1] == "." then
    x = add_top(x, unshift(x, 1))
  end
  local y = push(z, pop(z, 1))
  for i = 1, #self do
    if y[i] ~= "." then
      y[i] = x[j]
      j = j + 1
    end
  end
  setmetatable(y, mt)
  return self, y
end

function meth:keys(l)
  local t = {}
  for k = 1, l do
    t[k] = {}
  end
  for c, v in pairs(self) do
    for m = 1, #v do
      table.insert(t[v[m]], c)
    end
  end
  for o = 1, l do
    if #t[o] == 0 then
      t[o] = "."
    elseif #t[o] == 1 then
      t[o] = t[o][1]
    end
  end
  setmetatable(t, mt)
  return t
end

function meth:shuffle()
  local t = moses.shuffle(self, os.clock())
  return t
end

mt.__index = meth

return M

