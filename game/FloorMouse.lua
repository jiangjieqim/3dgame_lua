local core = core;
FloorMouse = {

}
FloorMouse.__index = FloorMouse;
setmetatable(FloorMouse , UnitBase);

function FloorMouse:new()
    local s = UnitBase:new();
    setmetatable(s,FloorMouse);
    local ps = [[
        #version 110
        uniform sampler2D texture1;//½çÃæÌùÍ¼
        varying vec2 out_texcoord;
        void main(void){
            vec4 finalColor=texture2D(texture1, out_texcoord);
            
            
            //finalColor = texture2D(texture1, mod(out_texcoord, vec2(3.0, 9.0)) * vec2(0.75, 0.5625));

            if(finalColor.r == 1.0 && finalColor.g == 0.0 && finalColor.b == 1.0){
                discard;//¶ªÆú×ÏÉ«µÄÏñËØ
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

        void main(){
            out_texcoord = _TexCoord;
            // out_texcoord.x = out_texcoord.x/2;
            // out_texcoord.y = out_texcoord.y/2;

            gl_Position = _mat1*vec4(_Position, 1.0);
        }
    ]];
    local p = core.p3d_create(vs,ps);
    
    local _mater = tmat_create_empty();
    core.p3d_set(_mater,p);
    tmat_pushTexUrl(_mater,"\\resource\\texture\\floor_mouse.bmp");
    -- local mat = [[<mat shader="simple;vboDiffuse" tex0="\resource\texture\floor_mouse.bmp"/>]];
    s:loadvbo( "\\resource\\obj\\plane.obj",_mater,2.5);
    s:reverse_face();
    core.add(s);
    
    s:startRotate();
    return s;
end

function FloorMouse:startRotate()
    local v = 0;
    local dir = Vec3:new(0,1,0);
    local function frender()
        v=v + core.delayTime()/512;
        self:rotate_vec(v,dir.x,dir.y,dir.z);
    end

    core.frameloop(16.6,frender);
end
