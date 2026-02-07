function onCreate()
  makeLuaSprite('sky', nil, -1200, -1000)
  makeGraphic('sky', 3300, 1700, '77D4FF')
  setScrollFactor('sky', 0, 0)
  addLuaSprite('sky', false)

  makeLuaSprite('house', 'stages/NovelloHouse/Inside', -1100, -1000)
  addLuaSprite('house', false)
  setProperty('house.scale.x', 0.85)
  setProperty('house.scale.y', 0.85)

  makeLuaSprite('sofa', 'stages/NovelloHouse/Sofa', -950, -1150)
  addLuaSprite('sofa', false)
  setProperty('sofa.scale.x', 0.85)
  setProperty('sofa.scale.y', 0.85)

  makeLuaSprite('trash', 'stages/NovelloHouse/trash_can', -1300, -1000)
  addLuaSprite('trash', true)
  setProperty('trash.scale.x', 1.1)
  setProperty('trash.scale.y', 1.1)
  setScrollFactor('trash', 0.8, 0.8)
end