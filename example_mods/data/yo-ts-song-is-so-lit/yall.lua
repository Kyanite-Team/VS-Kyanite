function onCreate()
setPropertyFromClass('GameOverSubstate', 'characterName', 'deady') --Character json for death animation
setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'dead-kid') --put in mods/sounds/
setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver') --put in mods/music/
setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd') --put in mods/music/
end