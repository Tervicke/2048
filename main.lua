gameBoard = {
	{0,0,0,0},
	{0,0,0,0},
	{0,0,0,0},
	{0,0,0,0},
}

gameOver = false
gameScore = 0
squareSize = 80

function love.load()
	love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
	love.window.setMode(320,380)
	love.window.setTitle(2048)
	local icon = love.image.newImageData("icon.png")
	love.window.setIcon(icon)
end

function love.keypressed(key)
	if key == "up" or key == "w" then
		gameBoard = rotateTable()
		leftShift()
		gameBoard = rotateTable()	
		addElement()
	end
	if key == "down" or key == "s" then
		gameBoard = rotateTable()
		rightShift()
		gameBoard = rotateTable()	
		addElement()
	end
	if key == "left" or key == "a" then
		leftShift()
		addElement()
	end
	if key == "right" or key == "d" then
		rightShift()
		addElement()
	end
end

function love.draw()
	if not gameOver then
		-- drawing the 
		local scoreText = "Score " .. gameScore
		local font = love.graphics.newFont("Roboto_Light.ttf",32)
		love.graphics.setFont(font)	
		local textWidth = font:getWidth(scoreText)
		local textHeight= font:getHeight(scoreText)

		local textX =  (320 - textWidth) / 2
		local textY =  (60 - textHeight) / 2
		love.graphics.setColor(love.math.colorFromBytes({173,216,230}))
		love.graphics.print(scoreText,textX,textY)

		--drawing the game board
		for i = 1, #gameBoard do
			local row = gameBoard[i]
				for j = 1, #row do
					local rectX = (j - 1) * 80 
					local rectY = (  (i - 1) * 80 ) + 60

					--love.graphics.setColor({math.random(),math.random(),math.random(),})
					--love.graphics.setColor( 0xBBADA0FF )
					love.graphics.setColor( love.math.colorFromBytes( setColorByValue( row[j] ) ) )

					love.graphics.rectangle("fill",rectX,rectY , squareSize , squareSize)
					love.graphics.setColor({1,1,1})	

					love.graphics.setColor(0, 0, 0)  -- Set border color to black
					local borderWidth = 1  -- Adjust border width as needed
					love.graphics.rectangle("line", rectX - borderWidth, rectY - borderWidth, squareSize + 2 * borderWidth, squareSize + 2 * borderWidth)

					if row[j] ~= 0 then
						local text = tostring( row[j] )
						local font = love.graphics.newFont(30)
						love.graphics.setFont(font)
						--local font = love.graphics.getFont()

						local textWidth = font:getWidth(text)
						local textHeight= font:getHeight(text)

						local textX = rectX + (squareSize - textWidth) / 2
						local textY = rectY + (squareSize - textHeight) / 2
						love.graphics.print(text, textX , textY)
					end

				end
		end
	else
		local scoreText = "Score " .. gameScore
		local font = love.graphics.newFont("Roboto_Light.ttf",32)
		love.graphics.setFont(font)	
		local textWidth = font:getWidth(scoreText)
		local textHeight= font:getHeight(scoreText)

		local textX =  (320 - textWidth) / 2
		local textY =  (320 - textHeight) / 2
		love.graphics.setColor(love.math.colorFromBytes({173,216,230}))
		love.graphics.print(scoreText,textX,textY)
	end
end


function setColorByValue(value)
    if value == 2 then
        return {187, 173, 160}  -- Light Gray
    elseif value == 4 then
				return {210, 165, 112}  -- peach
    elseif value == 8 then
        return {242, 177, 121}  -- Pastel Yellow
    elseif value == 16 then
        return {205, 221, 120}  -- Pastel Green
    elseif value == 32 then
        return {189, 218, 239}  -- Pastel Blue
    elseif value == 64 then
        return {230, 175, 235}  -- Pastel Purple
    elseif value == 128 then
        return {240, 141, 84}   -- Light Orange
    elseif value == 256 then
        return {241, 210, 90}   -- Light Yellow
    elseif value == 512 then
        return {204, 222, 80}   -- Light Green
    elseif value == 1024 then
        return {135, 208, 238}  -- Light Blue
    elseif value == 2048 then
        return {236, 128, 204}  -- Light Purple
    else
        return {207, 193,180 }  -- Default color (white)
    end
end

function leftShift()
	for i = 1, #gameBoard do
		--make a row and use it
		local row = gameBoard[i]

		row = shift(row,"left")

		local updatedrow = {0,0,0,0} 
		local skipped = false
		local lastSkipped  = false
		local index = 1

		for j = 1, #row do
			--debug
			if j ~= 4 then 

				if not skipped then
					if row[j] == row[j+1] and row[j] ~= 0 then
						if j == 3 then
							lastSkipped = true
						else
							lastSkipped = false
						end
						updatedrow[index] = row[j]*2
						gameScore = gameScore + row[j]
						index = index + 1
						skipped = true
					else
						updatedrow[index] = row[j]
						index = index + 1
					end
				else
					skipped = false
				end

			else

				if not lastSkipped then
					updatedrow[index] = row[j]
					index = index + 1
				end

			end
		

		end

		--updatedrow = shift(updatedrow,"left")
		gameBoard[i] = updatedrow
	end

end

function rightShift()
	for i = 1, #gameBoard	do 
		local row = gameBoard[i]
		row = shift(row,"right")
		local updatedrow = {0,0,0,0}
		local skipped = false
		local lastSkipped = false
		for j = 1,#row do
			if j ~= 4 then
				if not skipped then
					if row[j] == row[j+1] then
						if (j+1) == 4 then
							lastSkipped = true
						end
						updatedrow[j+1] = row[j]*2
						gameScore = gameScore + row[j]
						skipped = true
					else
						updatedrow[j] = row[j]
					end
				else
					skipped = false
				end
			else
				if lastSkipped then
					updatedrow[j] = row[j]*2
					gameScore = gameScore + row[j]
				else
					updatedrow[j] = row[j]
				end
					
				lastSkipped = false
			end
		end
		gameBoard[i] = updatedrow
	end
end

function shift(row,dir)
	local temprow= {0,0,0,0}
	if dir == "left" then
		local index = 1
		for i = 1,#row do
			if row[i] ~= 0 then
				temprow[index] = row[i]
				index = index + 1
			end
		end
	end
	if dir == "right" then
		local index = 4
		for i = 4 , 1,-1 do
			if row[i] ~= 0 then
				temprow[index] = row[i]
				index = index - 1 
			end
		end
	end
	return temprow
end

function printT(row)
	
	for i = 1,#row do
		io.write(row[i])
		io.write(" ")
	end

end

function rotateTable()
	local newtable = {
		{0,0,0,0},
		{0,0,0,0},
		{0,0,0,0},
		{0,0,0,0},
	}
	for i = 1, #gameBoard do
		for k = 1,#gameBoard[i] do
			newtable[k][i] = gameBoard[i][k]
		end
	end
	return newtable
end

function getAvailableCoords()
    local available_coords = {}
    local index = 1
    for i = 1, #gameBoard do
        for j = 1, #gameBoard[i] do
            if gameBoard[i][j] == 0 then
                available_coords[index] = {i, j}
                index = index + 1
            end
        end
    end
    return available_coords 
end

function addElement()
	coords = getAvailableCoords()
	totalValues = #coords 
	if totalValues == 0 then
		print("game over")
		gameOver = true 
	else
		randomValue = math.random(1,totalValues)
		local x = coords[randomValue][1] 
		local y = coords[randomValue][2]
		gameBoard[x][y] = 2
	end
end

addElement()
addElement()
