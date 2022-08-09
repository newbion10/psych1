function onCreate()
	-- background shit
	makeLuaSprite('libary', 'libary', -1800, -700);
	setScrollFactor('libary', 0.9, 0.9);
	scaleObject('libary', 3.1, 3.1);

	makeLuaSprite('pensil', 'pensil', 500, 700);
	setScrollFactor('pensil', 0.9, 0.9);
	scaleObject('pensil', 1.2, 1.2);
	

	addLuaSprite('libary', false);
	addLuaSprite('pensil', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end