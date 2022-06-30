---@class BauulAvatar : UnitBase
BauulAvatar = {

}
BauulAvatar.EStatus = {
    Stand = 1,
    Run = 2,
    Jump = 3,
}
BauulAvatar.Res = {
    ---恶魔
    Bauul = 1,
    ---哥布林
    Gobin = 2,
    ---立方体盒
    Box = 3,
    ---茶壶
    Teapot = 4,
}

BauulAvatar.__index = BauulAvatar;
setmetatable(BauulAvatar , UnitBase);

---isBox是否时候一个立方盒子
function BauulAvatar:new()
    local s = UnitBase:new();
    setmetatable(s,BauulAvatar);
    return s;
end
--- 注意:在new里面不要使用self对象
--- 用外部对象调用init对象
function BauulAvatar:init(p)
    -- self:addRotateBox();
    if(p~=nil) then
        self:create(p.res or BauulAvatar.Res.Box);
        self:set_position(p.x or 0,p.y or 0,p.z or 0);
        self:scale(p.scale or 1);
    end
end

function BauulAvatar:getStatus()
    return self._status;
end

--设置状态机
function BauulAvatar:setStatus(v)
    if(self._status ~= v) then
        if(self:has_anim())then
            local anim = self:get_anim();
            if(v == BauulAvatar.EStatus.Run)then
                anim:play("run");
            elseif(v == BauulAvatar.EStatus.Stand)then
                anim:play("stand");
            elseif(v == BauulAvatar.EStatus.Jump)then
                anim:play("jump");
            
            end
        end
        self._status = v;
    end
end
function BauulAvatar:setColor(r,g,b)
    core.shaderUpdateParam(self:getMaterial(),"r",r or 0,"g",g or 0,"b",b or 0);
end
function BauulAvatar:createObj(res)
    local url;
    local mat;
    local scale = 1;
    url = "\\resource\\obj\\"..res..".obj";
    mat = "\\resource\\material\\shape.mat";
    -- line = true;
    self:loadvbo(url,mat,scale); 
    -- self:iAxis(math.pi/2,1,0,0);
    self:setColor(1,1,0);
    self:drawPloygonLine(true);
    self:double_face();
end
function BauulAvatar:create(res)
    -- local avatar = self;

    local url;
    local mat;
    local scale = 1;
    if(res == BauulAvatar.Res.Box) then
        self:createObj("box");
    elseif(res == BauulAvatar.Res.Teapot) then
        self:createObj("teapot");
    elseif(res == BauulAvatar.Res.Gobin)then
         --哥布林
        url = "\\resource\\md2\\gobin.md2";
        mat = "\\resource\\material\\gobin.mat";
        scale = 0.1;
        self:loadvbo(url,mat,scale); self:iAxis(math.pi/2,1,0,0);

    elseif(res == BauulAvatar.Res.Bauul) then
        --恶魔
        url = "\\resource\\md2\\bauul.md2";
        mat = "\\resource\\material\\bauul.mat";
        scale = 0.1;
        self:loadvbo(url,mat,scale); self:iAxis(math.pi/2,1,0,0);
    end

    if(self:has_anim())then
        local anim = self:get_anim();
        -- print(">>>"..avatar:get_name());

        if(anim) then
            anim:push("stand",0,39);
            anim:push("run",40,45);
            anim:push("jump",66,71);
        end
        self:setStatus(BauulAvatar.EStatus.Stand);
    end
    core.add(self);

end

--增加一个环绕的球
function BauulAvatar:addRotateBox()
    local box = UnitBase:new();
    box:loadvbo("\\resource\\obj\\sphere.obj","\\resource\\material\\bauul2.mat");
    core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    -- core.meterial.setCullface(box:getMaterial(),GL.CULL_FACE_DISABLE);
    box:double_face();
    core.add(box);
    local ax = 0;
    local ay = 1;
    local az = 0;
    local sx = 1;
    local sy = 0;
    local sz = 1;
    local p1;
    local distance = 2.5;--距离圆心的距离
    local curTheta = 0;
    -- box:setParent(self);
    local o = {speed=math.pi/180};
    
    -- box:set_position(0,0,5);

    local function loopfrender()
        curTheta = curTheta +o.speed;
        local x,y,z=vec3RotatePoint3d(curTheta,ax,ay,az,sx,sy,sz);
        x,y,z = vec3_mult(x,y,z,distance);
        -- local tx,ty,tz = self:get_pos();
       box:set_position(x,y,z);
        --print(x,y,z);
        -- core.cam:refresh();
    end
    p1 = core.frameloop(1000/30,loopfrender);
    -- core.clearTimeout(p1);
    return o;
end

function BauulAvatar:dispose()
    core.super(self,"dispose");
end