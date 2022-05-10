
BauulAvatar = {

}
BauulAvatar.EStatus = {
    Stand = 1,
    Run = 2,
}
BauulAvatar.Res = {
    ---恶魔
    Bauul = 1,
    ---哥布林
    Gobin = 2,
    ---立方体盒
    Box = 3,
}

BauulAvatar.__index = BauulAvatar;
setmetatable(BauulAvatar , UnitBase);

---isBox是否时候一个立方盒子
function BauulAvatar:new(res)
    local s = UnitBase:new();
    setmetatable(s,BauulAvatar);
    self:create(res or BauulAvatar.Res.Box);
    -- self:addRotateBox();
    return s;
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
            end
        end
        self._status = v;
    end
end

function BauulAvatar:create(res)
    local avatar = self;

    local url;
    local mat;
    local scale = 1;
    local line = false;
    local hasAni = true;--是否有动画对象
    if(res == BauulAvatar.Res.Box) then
        url = "\\resource\\obj\\box.obj";
        mat = "\\resource\\material\\shape.mat";
        line = true;
        hasAni = false;
    elseif(res == BauulAvatar.Res.Gobin)then
         --哥布林
        url = "\\resource\\md2\\gobin.md2";
        mat = "\\resource\\material\\gobin.mat";
        scale = 0.1;
    elseif(res == BauulAvatar.Res.Bauul) then
        --恶魔
        url = "\\resource\\md2\\bauul.md2";
        mat = "\\resource\\material\\bauul.mat";
        scale = 0.1;
    end

        avatar:loadvbo(url,mat,scale); avatar:iAxis(math.pi/2,1,0,0);
        self:drawPloygonLine(line);
        -- avatar:set_position(0,0.5/scale,0);
        --avatar:get_anim():pause();

    if(self:has_anim())then
        local anim = avatar:get_anim();
        -- print(">>>"..avatar:get_name());

        if(anim) then
            anim:push("stand",0,39);
            anim:push("run",40,45);
            anim:push("jump",66,71);
        end
        -- anim:play("run");
        -- avatar:setStatus(BauulAvatar.EStatus.Stand);

        -- avatar:loadvbo("\\resource\\md2\\triangle.md2","\\resource\\material\\bauul2.mat",1.0); 
        -- avatar:iAxis(math.pi/2,1,0,0);
        -- local anim = avatar:get_anim();
        -- print("total:"..anim:total());
        -- anim:push("stand",1,4);
        -- anim:play("stand");
        -- anim:set_fps(3);

        -- avatar:loadvbo("\\resource\\obj\\arrow.obj","\\resource\\material\\bauul.mat",2); 
        
        
        -- self:disable_cullface();

        -- print("total:",avatar:get_anim():total());
        -- print("get_pos:",avatar:get_pos());
        --]]
        self:setStatus(BauulAvatar.EStatus.Stand);
    end
    core.add(avatar);

end

--增加一个环绕的球
function BauulAvatar:addRotateBox()
    local box = UnitBase:new();
    box:loadvbo("\\resource\\obj\\sphere.obj","\\resource\\material\\bauul2.mat");
    core.meterial.setPolyMode(box:getMaterial(),GL.GL_LINE);
    core.meterial.setCullface(box:getMaterial(),GL.CULL_FACE_DISABLE);
    core.add(box);
    local ax = 0;
    local ay = 1;
    local az = 0;
    local sx = 1;
    local sy = 0;
    local sz = 1;
    local p1;
    local distance = 2.5;--距离圆心的距离
    local speed = math.pi/45;
    local curTheta = 0;

    local function loopfrender()
        curTheta = curTheta +speed;
        local x,y,z=vec3RotatePoint3d(curTheta,ax,ay,az,sx,sy,sz);
        x,y,z = vec3_mult(x,y,z,distance);
        local tx,ty,tz = self:get_pos();
        box:set_position(tx+x,ty+y,tz+z);
    end
    p1 = core.frameloop(1000/30,loopfrender);
    -- core.clearTimeout(p1);
end

function BauulAvatar:dispose()

end