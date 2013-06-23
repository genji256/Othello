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

#プレイヤー
$playar = ["player1", "player2"]

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


lt = TkLabel.new(f2, "relief" => "ridge") do
	text "ターン"
	width 7
	pack
end


$lp = TkLabel.new(f2, "relief" => "ridge") do
	text $playar[0]
	width 7
	pack 
end

$c = TkCanvas.new(f1) do
	width 256
	height 256
	background "#f0f0f0"
	bind(
		"Button", 
		proc do |x, y| 
			setChessman(x , y)
		end,
		"%x %y"
	)
	pack
end

#盤面を初期化
def init
	i = 0
	x = 17

	while 8 > i
		$centerPoint[i] = x
		j = 0
		y = 17
		while 8 > j
			if 3 == i && 3 == j || 4 == i && 4 == j
				$boardArray[i][j] = -1
				TkcImage.new($c, x, y) do
					image $whiteImg
				end
			elsif 3 == i && 4 == j || 4 == i && 3 == j
				$boardArray[i][j] = 1
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
def getIndex(p)
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
	i = getIndex(x)
   	j = getIndex(y)	
	#Tk.messageBox("message" => "#{cX},#{cY}")
	if 0 != $boardArray[i][j]
		return
	end

	if !revers(i, j)
		return
	end

	if 1 == $turn
		TkcImage.new($c, cX, cY) do
			image $blackImg
		end
		$boardArray[i][j] = 1
		$turn = -1
		$lp.text = $playar[1]
	else 
		TkcImage.new($c, cX, cY) do
			image $whiteImg
		end
		$boardArray[i][j] = -1
		$turn = 1
		$lp.text = $playar[0]
	end

end

def revers(i, j)
	#左　右　上　下　左上　右上　右下　左下
	w = [-1,1,0, 0,-1, 1,1,-1]
	h = [ 0,0,-1,1,-1,-1,1, 1]
	f = false	#ひっくり返す場所があるかのフラグ
	c = 0
	while 8 > c
		ii = i
		jj = j
		while true
			ii += w[c]
			jj += h[c]
			if 0 > ii || 0 > jj || 7 < ii || 7 < jj
				break
			end

			#隣が同じ色もしくは何も無ければ何もしない
			if $boardArray[ii][jj] == $turn && ii == i + w[c] && jj == j + h[c] || 0 == $boardArray[ii][jj]
				break
			end

			#2度めにターンプレイヤーの色が出たらひっくり返す
			if $boardArray[ii][jj] == $turn
				f = true
				#Tk.messageBox("message" => "#{ii},#{jj}")
				iii = i
				jjj = j
				while true
					iii += w[c]
					jjj += h[c]
					if iii == ii && jjj == jj
						break
					end
					TkcImage.new($c, $centerPoint[iii], $centerPoint[jjj]) do
						image $turn == 1 ? $blackImg : $whiteImg
					end
					$boardArray[iii][jjj] = $turn
				end
				break
			end
		end
		c += 1
	end	

	return f
end

def changeTurn(t)
	$turn = t
end

init

Tk.mainloop
