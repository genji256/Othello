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

#色
$BLACK = 1
$WHITE = -1

#順番
$turn = $BLACK

#1マスの中心座標
$centerPoint = []

#プレイヤー
$playar = ["黒", "白"]

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

resetButton = TkButton.new(f2) do
	text "最初から"
	width = 7
	command(proc do
		init
	end)
	pack
end

#黒のコマの数ラベルをまとめたフレーム
blackNumFrame = TkFrame.new(f2) do
	pack
end

TkLabel.new(blackNumFrame) do
	text "黒:"
	width 3
	pack "side" => "left"
end

$blackNum = TkLabel.new(blackNumFrame) do
	text "2"
	width 3
	pack "side" => "left"
end

#白のコマの数ラベルをまとめたフレーム
whiteNumFrame = TkFrame.new(f2) do
	pack
end

TkLabel.new(whiteNumFrame) do
	text "白:"
	width 3
	pack "side" => "left"
end

$whiteNum = TkLabel.new(whiteNumFrame) do
	text "2"
	width 3
	pack "side" => "left"
end

#どちらの順番かを表示するラベルのフレーム
turnFrame = TkFrame.new(f2) do
	pack
end

lt = TkLabel.new(turnFrame) do
	text "ターン"
	width 4
	pack "side" => "left"
end

$lp = TkLabel.new(turnFrame) do
	text $playar[0]
	width 3
	pack "side" => "left"
end

TkButton.new(f2) do
	text "パス"
	width 3
	command(proc do
		if $turn == $BLACK
			$turn = $WHITE
			$lp.text = $playar[1]
		else
			$turn = $BLACK
			$lp.text = $playar[0]
		end
	end)
	pack
end

#盤面のキャンバス
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
	$boardArray = [[], [], [], [], [], [], [], []]
	$turn = $BLACK
	i = 0
	x = 17

	while 8 > i
		$centerPoint[i] = x
		j = 0
		y = 17
		while 8 > j
			if 3 == i && 3 == j || 4 == i && 4 == j
				$boardArray[i][j] = $WHITE
				TkcImage.new($c, x, y) do
					image $whiteImg
				end
			elsif 3 == i && 4 == j || 4 == i && 3 == j
				$boardArray[i][j] = $BLACK
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
		c = $centerPoint[0]
	elsif 65 > p
		c = $centerPoint[1]
	elsif 97 > p
		c = $centerPoint[2]
	elsif 129 > p
		c = $centerPoint[3]
	elsif 161 > p
		c = $centerPoint[4]
	elsif 193 > p
		c = $centerPoint[5]
	elsif 225 > p
		c = $centerPoint[6]
	else 
		c = $centerPoint[7]
	end

	return c
end

#コマを置く
def setChessman(x, y)
	cX = getCenterPoint(x)
	cY = getCenterPoint(y)
	i = getIndex(x)
   	j = getIndex(y)	
	if 0 != $boardArray[i][j]
		return
	end

	if !revers(i, j)
		return
	end

	if $BLACK == $turn
		TkcImage.new($c, cX, cY) do
			image $blackImg
		end
		$boardArray[i][j] = $BLACK
		$turn = $WHITE
		$lp.text = $playar[1]
	else 
		TkcImage.new($c, cX, cY) do
			image $whiteImg
		end
		$boardArray[i][j] = $WHITE
		$turn = $BLACK
		$lp.text = $playar[0]
	end

	countBlackAndWhite

end

#コマをひっくり返せるかの判定
#ひっくり返せるならひっくり返す
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
						image $turn == $BLACK ? $blackImg : $whiteImg
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

#コマの数を数える
def countBlackAndWhite
	countBlack = 0
	countWhite = 0
	i = 0
	while 8 > i
		j = 0
		while 8 > j
			if $boardArray[i][j] == $BLACK
				countBlack += 1
			elsif $boardArray[i][j] == $WHITE
				countWhite += 1
			end
			j += 1
		end
		i += 1
	end
	$blackNum.text = countBlack
	$whiteNum.text = countWhite
end

init

Tk.mainloop
