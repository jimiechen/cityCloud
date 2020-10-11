import 'dart:math';

enum HorizontalOrigentation {
  Left,
  Right,
}

enum PersonActionType {
  Walk,
  Jump,
  Stand,
}

const double PersonScale = 0.1;

const double PersonMoveSpeed = 3; //移动速度
const double PersonShadowWidth = 6; //影子宽
const double PersonShadowHeight = 3; //影子高

const double PersonJumpHeight = 34 * PersonScale; //挑起的高度

const double PersonHandsSpacing = 46 * PersonScale; //双手间距离
const double PersonHandCenterY = (250 - 191) * PersonScale; //手臂中心点位置y距离脚底距离
const double PersonHandWalkRotate = 13 / 180 * pi; //走路手臂摆动幅度
const double PersonHandJumpRotate = 80 / 180 * pi; //跳手臂摆动幅度

const double PersonBodyCenterY = (250 - 199) * PersonScale; //身体中心点位置y距离脚底距离
const double PersonBodyCenterX = 3 * PersonScale; //身体中心点位置x距离脚底中心x距离

const double PersonFaceWidth = 116 * PersonScale; //椭圆脸的宽
const double PersonFaceHeight = 97 * PersonScale; //椭圆脸的高
const double PersonHeadMoveRange = 5 * PersonScale; //头上下移动幅度
const double PersonFaceCenterY = (250 - 126) * PersonScale; //脸中心点位置y距离脚底距离
const double PersonHairCenterXInFace = 6 * PersonScale; //头发中心点相对脸中心点位置x距离
const double PersonHairCenterYInFace = -6 * PersonScale; //头发中心点相对脸中心点位置y距离
const double PersonEyeCenterXInFace = -5 * PersonScale; //眼睛中心点相对脸中心点位置x距离
const double PersonEyeCenterYInFace = 4 * PersonScale; //眼睛中心点相对脸中心点位置y距离
const double PersonNoseCenterXInFace = 7 * PersonScale; //鼻子中心点相对脸中心点位置x距离
const double PersonNoseCenterYInFace = 12 * PersonScale; //鼻子中心点相对脸中心点位置y距离

const double PersonFootsSpacing = 15 * PersonScale; //双脚间距离
const double PersonFootPutUpHeight = 5 * PersonScale; //脚抬起高度
const double PersonFootLength = 42 * PersonScale; //脚长
const double PersonFootWidth = 9 * PersonScale; //脚宽度
const double PersonFootJumpTackBackLength = 5 * PersonScale; //脚抬起高度
