enum HorizontalOrigentation {
  Left,
  Right,
}

const double _scale = 0.4;

const double MoveSpeed = 5; //移动速度

const double FootSpacing = 2 * _scale; //两脚之间距离
const double FootSpeed = 10 * _scale; //抬脚速度
const double FootPutUpHeight = 2; //脚抬起的高度
const double FootHeight = 8 * _scale; //脚的高度
const double FootWidth = FootHeight * 9 /42; //脚的宽度

const double HandHeight = 18 * _scale; //手臂的高度
const double HandWidth = HandHeight * 9 /47; //手臂的宽度
const double HandSpacing = 8 * _scale; //手臂的间隔
const double HandRotateSpeed = 1; //手臂旋转速度
const double HandRotateRadians = 0.5; //手臂旋转的弧度

const double BodyWidth = 20 * _scale; //身体宽度
const double BodyHeight = BodyWidth * 55 / 58; //身体高度
const double BodyOffset = BodyWidth * 0.1; //因为身体有屁股，所以要设置偏移

const double HeadHeight = 28 * _scale; //头高
const double HeadWidth = 36 * _scale; //头宽
const double HeadMoveDistance = 6 * _scale; //头上下移动的偏移量

const double EyeHeight = EyeWidth * 0.43; //眼睛宽度
const double EyeWidth = 26 * _scale; //眼睛高度
const double EyeCloseSpeed = 15 * _scale; //眨眼睛速度
const double EyeCloseTimeInterval = 6 * _scale; //眨眼睛时间间隔

const double NoseWidth = 30 * _scale; //头发宽度
const double NoseHeight = NoseWidth * 95 / 115; //头发宽度

const double HairWidth = 50 * _scale; //头发宽度
const double HairHeight = 50 * _scale; //头发高度

const double ShadowWidth = 16 * _scale; //影子宽
const double ShadowHeight = 8 * _scale; //影子高