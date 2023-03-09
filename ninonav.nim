import ninowin
import ninotext

let 
  roboto = readTypeface("fonts\\Roboto-Regular_1.ttf")
  batch = (100,50,1600,850)

var 
  dataLines:seq[string]
  idx = 0

func offsetArea(a:Area,offset:int): Area = (a.x+offset,a.y+offset,a.w,a.h)

func areaShadows(area:Area,offset:int): tuple[shadowRight:Area,shadowBottom:Area] =
  ((area.x+area.w,area.y+offset,offset,area.h),
  (area.x+offset,area.y+area.h,area.w-offset,offset))

proc drawAreaShadow(b:var Boxy,area:Area,offset:int,color:Color) =
  let areaShadows = area.areaShadows(offset)
  b.drawRect(areaShadows.shadowRight.toRect,color)
  b.drawRect(areaShadows.shadowBottom.toRect,color)

proc drawBatch(b:var Boxy,area:Area,color:Color) =
  b.drawRect(area.toRect,color)
  b.drawAreaShadow(area,3,color(255,255,255,100))

proc drawBatchText(b:var Boxy) =
  let
    offset = offsetArea(batch,5)
  for i,line in dataLines[idx..(idx+20)]:
    b.drawText(
      line[0..3],
      offset.x.toFloat,
      offset.y.toFloat+(i.toFloat*20),
      line,
      fontFace(roboto,20,color(0,0,0))
    )

proc keyboard (k:KeyEvent) =
  if k.button == ButtonUnknown:
    echo "Rune: ",k.rune
  else:
    echo k.button

proc mouse (m:MouseEvent) =
  if mouseClicked(m.keyState):
    echo "ninonav says: hello world"

proc draw (b:var Boxy) =
  b.drawBatch(batch,color(1,1,1))
  b.drawBatchText()

proc initNinoNav*() =
  addCall(newCall("ninonav",keyboard,mouse,draw,nil))

for line in lines("nina34matrix.txt"): 
  dataLines.add line
  echo line
