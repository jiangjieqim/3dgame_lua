require("core");
require("ui")
local core = core;


-- https://www.jianshu.com/p/22b2e158d895

--[[

// -- GL_ZERO： 表示使用0.0作为因子，实际上相当于不使用这种颜色参与混合运算。
// -- GL_ONE： 表示使用1.0作为因子，实际上相当于完全的使用了这种颜色参与混合运算。
// -- GL_SRC_ALPHA：表示使用源颜色的alpha值来作为因子。
// -- GL_DST_ALPHA：表示使用目标颜色的alpha值来作为因子。
// -- GL_ONE_MINUS_SRC_ALPHA：表示用1.0减去源颜色的alpha值来作为因子。
// -- GL_ONE_MINUS_DST_ALPHA：表示用1.0减去目标颜色的alpha值来作为因子。 除此以外，还有GL_SRC_COLOR（把源颜色的四个分量分别作为因子的四个分量）


深度绘制和混合同时存在的场景绘制顺序：

1、打开 深度蒙版glDepthMask( GL_TRUE )
2、以任何顺序绘制所有不透明的对象
3、关闭深度遮罩glDepthMask( GL_FALSE )
4、打开BLEND_MODE
5、绘制从最远到最近排序的半透明对象
void Draw {
   /**开启深度测试*/ 
   glEnable( GL_DEPTH_TEST );
  /**开启深度遮罩*/ 
  glDepthMask( GL_TRUE );
 /**绘制不透明对象*/
  DrawA();
  DrawB();  
 /**关闭深度遮罩*/
  glDepthMask( GL_FALSE );
 
 /**开启混合*/  
  glEnable( GL_BLEND );
/**混合方程*/
  glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  
/**绘制从最远到最近排序的半透明对象*/
  DrawC(); 
  DrawD();
  /**关闭混合*/ 
   glDisable( GL_BLEND );  
}
]]


require("utils/kittools");

core.init("//resource//texture//1");
kit.keyLis();




-- require("BauulAvatar");


local function createPlane(scale,res)

    local ps = [[
        #version 110
        uniform sampler2D texture1;
        varying vec2 out_texcoord;
        void main(void){
            vec4 finalColor=texture2D(texture1, out_texcoord);
            if(finalColor.r == 1.0 && finalColor.g == 0.0 && finalColor.b == 1.0){
                discard;//丢弃紫色的像素
            }
            gl_FragColor = finalColor;
        }
    ]];

    local vs=[[
        #version 110
        attribute vec3 _Position;
        attribute vec2 _TexCoord;
        varying vec2 out_texcoord;
        uniform mat4 _mat1;
        uniform float _mUvScale;
        void main(){
            out_texcoord =vec2(_TexCoord.x * _mUvScale,_TexCoord.y*_mUvScale);
            gl_Position = _mat1*vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    
    shader_updateVal(_mater,"_mUvScale",1);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\horse.bmp");
    local floor = UnitBase:new();
    floor:loadvbo("\\resource\\obj\\"..(res or "plane")..".obj",_mater,scale or 1);
    floor:reverse_face();
    -- floor:double_face();
    core.add(floor);
    return floor;
end

local function createBox(res)

    local ps = [[
        #version 110
        uniform sampler2D texture1;
        varying vec2 out_texcoord;
        uniform float mAlpha;
        void main(void){
            vec4 finalColor=texture2D(texture1, out_texcoord);
            if(finalColor.r == 1.0 && finalColor.g == 0.0 && finalColor.b == 1.0){
                discard;//丢弃紫色的像素
            }
            finalColor.a = mAlpha;//设置alpha
            gl_FragColor = finalColor;
        }
    ]];

    local vs=[[
        #version 110
        attribute vec3 _Position;
        attribute vec2 _TexCoord;
        varying vec2 out_texcoord;
        uniform mat4 _mat1;
        void main(){
            out_texcoord =vec2(_TexCoord.x,_TexCoord.y);
            gl_Position = _mat1*vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\wall.tga");
    -- core.meterial.setAlpha(_mater,0.5);

    
    local floor = UnitBase:new();
    floor:loadvbo("\\resource\\obj\\"..(res or "box")..".obj",_mater,1);
    -- floor:set_position(0,-1,0);
    floor:double_face();
    -- floor:reverse_face();
    core.add(floor);
    return floor;
end



local plane = createPlane(2);


local box = createBox("box");
box:set_position(0,0,1);
---------------------------------------------
core.cam:set_pos(0,-2,-2);
core.cam:setTarget(box);
core.cam:refresh();

local function onLookAtEvt()
    local v= core.get_time()/1000;
    -- print();
    local alpha = (math.sin(v)+1)/2;--  0-1
    core.meterial.setAlpha( box:getMaterial(),alpha);

    box:rotate_vec(v,0,1,0);
end
core.frameloop(1000/20,onLookAtEvt);

