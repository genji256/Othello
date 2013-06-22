#coding:utf-8

require 'tk'

#盤面
$boardImg = TkPhotoImage.new("file" => "./pic/green.gif")
#黒
$blackImg = TkPhotoImage.new("file" => "./pic/black.gif")
#白
$whiteImg = TkPhotoImage.new("file" => "./pic/white.gif")

#盤面の配列
$boardArray = [[], [], [], [], [], [], [], []]

#順番：1なら黒-1なら白の番
$turn = 1

#1マスの中心座標
$centerPoint = []

TkRoot.new do
	title("オセロ")
end

#フレームのおおもと
fRoot = TkFrame.new do
	pack
end

#オセロの盤面表示用
f1 = TkFrame.new(fRoot) do
	width 256
	height 256
	pack "side" => "left"
end

#メニュー用
f2 = TkFrame.new(fRoot) do
	pack "side" => "left"
end
lx = TkLabel.new(f2, "relief" => "ridge") do
	text "0"
	width 6
	pack
end


ly = TkLabel.new(f2, "relief" => "ridge") do
	text "0"
	width 6
	pack 
end

$c = TkCanvas.new(f1) do
	width 256
	height 256
	background "#f0f0f0"
	bind(
		"Button", 
		proc do |x, y| 
			lx.text(x.to_s)
			ly.text(y.to_s)
			setChessman(x , y)
		end,
		"%x %y"
	)
	pack
end

def init
	i = 0
	x = 17

	while 8 > i
		$centerPoint[i] = x
		j = 0
		y = 17
		while 8 > j
			if 3 == i && 3 == j || 4 == i && 4 == j
				$boardArray[i][j] = 1
				TkcImage.new($c, x, y) do
					image $whiteImg
				end
			elsif 3 == i && 4 == j || 4 == i && 3 == j
				$boardArray[i][j] = -1
				TkcImage.new($c, x, y) do
					image $blackImg
				end
			else
				$boardArray[i][j] = 0
				TkcImage.new($c, x,y) do
					image $boardImg
				end
			end
			y += 32
			j += 1
		end
		x += 32
		i += 1
	end
end

#座標から配列のインデックスを割り出す
def convertPoint(p)
	if 33 > p
		i = 0
	elsif 65 > p
		i = 1
	elsif 97 > p
		i = 2
	elsif 129 > p
		i = 3
	elsif 161 > p
		i = 4
	elsif 193 > p
		i = 5
	elsif 225 > p
		i = 6
	else 
		i = 7
	end

	return i
end

#座標から各マスの中心座標を割り出す
def getCenterPoint(p)
	if 33 > p
		i = $centerPoint[0]
	elsif 65 > p
		i = $centerPoint[1]
	elsif 97 > p
		i = $centerPoint[2]
	elsif 129 > p
		i = $centerPoint[3]
	elsif 161 > p
		i = $centerPoint[4]
	elsif 193 > p
		i = $centerPoint[5]
	elsif 225 > p
		i = $centerPoint[6]
	else 
		i = $centerPoint[7]
	end

	return i
end

def setChessman(x, y)
	cX = getCenterPoint(x)
	cY = getCenterPoint(y)
	#Tk.messageBox("message" => "#{cX},#{cY}")
	if 1 == $turn
		TkcImage.new($c, cX, cY) do
			image $blackImg
		end
		$turn = -1
	else 
		TkcImage.new($c, cX, cY) do
			image $whiteImg
		end
		$turn = 1
	end

end

init

Tk.mainloop
