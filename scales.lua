--[[
TODO: función weighted choose;
--]]
local escalas = {}

math.randomseed(os.clock())

local random = math.random

local scales = 
{
  major_pentatonic = {0, 2, 3, 7, 9},
  new_pentatonic = {0, 2, 3, 6, 9},
  japanese = {0, 1, 5, 7, 8},
  balinese = {0, 1, 5, 6, 8},
  pelog = {0, 1, 3, 7, 10},
  hemitonic_pentatonic = {0, 2, 3, 7, 11},
  variation_pentatonic = {0, 4, 7, 9, 10},
  harmonic_minor = {0, 2, 3, 5, 7, 8, 10},
  melodic_minor = {0, 2, 3, 5, 7, 9, 11},
  whole_tone = {0, 2, 4, 6, 8, 10}, 
  augmented = {0, 3, 4, 6, 8, 11},
  diminished = {0, 2, 3, 5, 6, 8, 9, 11} ,
  enigmatic = {0, 1, 4, 6, 8, 10, 11}, 
  byzantine = {0, 1, 4, 5, 7, 8, 11},
  locrian = {0, 2, 4, 5, 6, 8, 10},
  persian = {0, 1, 4, 5, 7, 10, 11},
  spanish = {0, 1, 3, 4, 5, 6, 8, 10}, 
  hungarian = {0, 2, 3, 6, 7, 8, 10},
  nativeamerican = {0, 2, 4, 6, 9, 11},
  bebop = {0, 2, 4, 5, 7, 8, 9, 11},
  barbershop1  = {0, 2, 4, 5, 7, 11, 14, 17, 19, 23},
  barbershop2 = {0, 7, 12, 16, 19, 23},
  rain = {10, 14, 16, 18, 20, 24, 26, 30, 32},
  crystalline = {0, 7, 11, 15, 19, 26, 27, 34, 38, 42, 46, 53, 54, 61, 65, 69},
  popularblues = {0, 3, 5, 6, 7, 10},
  blues = {0, 3, 4, 7, 8, 15, 19},
  disharmony = {0, 1, 4, 5, 7, 8, 11, 12, 14, 15, 18, 19, 21, 22, 25, 26},
  gracemajor = {0, 5, 8, 13, 17, 19, 25, 30},
  eblues = {0, 2, 4, 7, 8, 6, 13, 17},
  ["+2"] = { 0, 2, },
  ["+3"] = { 0, 4, },
  ["+4"] = { 0, 6, },
  ["+b3"] = { 0, 3, },
  ["5"] = { 0, 7, },
  ["b5"] = { 0, 6, },
  ["6sus4(-5)"] = { 0, 6, 9, },
  ["aug"] = { 0, 4, 8, },
  ["dim"] = { 0, 3, 6, },
  ["dim5"] = { 0, 4, 6, },
  ["maj"] = { 0, 4, 7, },
  ["min"] = { 0, 3, 7, },
  ["sus2"] = { 0, 2, 7, },
  ["sus2sus4(-5)"] = { 0, 2, 6, },
  ["sus4"] = { 0, 6, 7, },
  ["6"] = { 0, 4, 7, 9, },
  ["6sus2"] = { 0, 2, 7, 9, },
  ["6sus4"] = { 0, 6, 7, 9, },
  ["7"] = { 0, 4, 7, 10, },
  ["7#5"] = { 0, 4, 8, 10, },
  ["7b5"] = { 0, 4, 6, 10, },
  ["7sus2"] = { 0, 2, 7, 10, },
  ["7sus4"] = { 0, 6, 7, 10, },
  ["add2"] = { 0, 2, 4, 7, },
  ["add4"] = { 0, 4, 6, 7, },
  ["add9"] = { 0, 4, 7, 14, },
  ["dim7"] = { 0, 3, 6, 9, },
  ["dim7susb13"] = { 0, 3, 9, 20, },
  ["madd2"] = { 0, 2, 3, 7, },
  ["madd4"] = { 0, 3, 6, 7, },
  ["madd9"] = { 0, 3, 7, 14, },
  ["mmaj7"] = { 0, 3, 7, 11, },
  ["m6"] = { 0, 3, 7, 9, },
  ["m7"] = { 0, 3, 7, 10, },
  ["m7#5"] = { 0, 3, 8, 10, },
  ["m7b5"] = { 0, 3, 6, 10, },
  ["maj7"] = { 0, 4, 7, 11, },
  ["maj7#5"] = { 0, 4, 8, 11, },
  ["maj7b5"] = { 0, 4, 6, 11, },
  ["maj7sus2"] = { 0, 2, 7, 11, },
  ["maj7sus4"] = { 0, 6, 7, 11, },
  ["sus2sus4"] = { 0, 2, 6, 7, },
  ["6/7"] = { 0, 4, 7, 9, 10, },
  ["6add9"] = { 0, 4, 7, 9, 14, },
  ["7#5b9"] = { 0, 4, 8, 10, 13, },
  ["7#9"] = { 0, 4, 7, 10, 15, },
  ["7#9b5"] = { 0, 4, 6, 10, 15, },
  ["7/11"] = { 0, 4, 7, 10, 18, },
  ["7/13"] = { 0, 4, 7, 10, 21, },
  ["7add4"] = { 0, 4, 6, 7, 10, },
  ["7b9"] = { 0, 4, 7, 10, 13, },
  ["7b9b5"] = { 0, 4, 6, 10, 13, },
  ["7sus4/13"] = { 0, 6, 7, 10, 21, },
  ["9"] = { 0, 4, 7, 10, 14, },
  ["9#5"] = { 0, 4, 8, 10, 14, },
  ["9b5"] = { 0, 4, 6, 10, 14, },
  ["9sus4"] = { 0, 7, 10, 14, 18, },
  ["m maj9"] = { 0, 3, 7, 11, 14, },
  ["m6/7"] = { 0, 3, 7, 9, 10, },
  ["m6/9"] = { 0, 3, 7, 9, 14, },
  ["m7/11"] = { 0, 3, 7, 10, 18, },
  ["m7add4"] = { 0, 3, 6, 7, 10, },
  ["m9"] = { 0, 3, 7, 10, 14, },
  ["m9/11"] = { 0, 3, 10, 14, 18, },
  ["m9b5"] = { 0, 3, 6, 10, 14, },
  ["maj6/7"] = { 0, 4, 7, 9, 11, },
  ["maj7/11"] = { 0, 4, 7, 11, 18, },
  ["maj7/13"] = { 0, 4, 7, 11, 21, },
  ["maj9"] = { 0, 4, 7, 11, 14, },
  ["maj9#5"] = { 0, 4, 8, 11, 14, }
}

local function chus(...)
  local var = {...}
  return var[random(#var)]
end

local function midi_notes()
  local a = "c c# d d# e f f# g g# a a# b"
  local t = {}
  local c = 0
  for i = -1, 8 do
    for _ in a:gmatch'%g+' do
      t[_..i] = c
      c = c + 1
    end
  end
  return t
end

local notes = midi_notes()

-- args: root, name, inver, weight
function escalas.set(s)
  s.inver = s.inver or false
  s.weight = s.weight or 0
  local t = {}
  local sc = scales[s.name]
  local raiz  = notes[s.root] or s.root 

  if not s.inver then
    for i = 1, #sc do
      t[i] = sc[i] + raiz
    end
  else
    for i = 1, #sc do
      if random() <= s.weight then  
        t[i] = chus((sc[i] + raiz) - 12, (sc[i] + raiz) + 12)
      else
        t[i] = sc[i] + raiz
      end
    end
  end
  return t
end

return escalas
