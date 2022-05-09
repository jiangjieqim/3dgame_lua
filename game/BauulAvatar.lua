
BauulAvatar = {

}
BauulAvatar.EStatus = {
    Stand = 1,
    Run = 2,
}
BauulAvatar.__index = BauulAvatar;
setmetatable(BauulAvatar , UnitBase);

function BauulAvatar:new()
    local s = UnitBase:new();
    setmetatable(s,BauulAvatar);
    self:init(); 
    return s;
end

--设置状态机
function BauulAvatar:setStatus(v)
    if(self._status ~= v) then
        local anim = self:get_anim();
        if(v == BauulAvatar.EStatus.Run)then
            anim:play("run");
        elseif(v == BauulAvatar.EStatus.Stand)then
            anim:play("stand");
        end
        -- print("set status...",v);
        self._status = v;
    end
end

function BauulAvatar:init()
    local avatar = self;

    avatar:loadvbo("\\resource\\md2\\bauul.md2","\\resource\\material\\bauul.mat",0.1); avatar:iAxis(math.pi/2,1,0,0);
    --avatar:get_anim():pause();
    local anim = avatar:get_anim();
    -- print(">>>"..avatar:get_name());


    anim:push("stand",0,39);
    anim:push("run",40,45);
    anim:push("jump",66,71);
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
    core.meterial.setCullface(avatar:getMaterial(),GL.CULL_FACE_DISABLE);
    -- print("total:",avatar:get_anim():total());
    core.add(avatar);
    -- print("get_pos:",avatar:get_pos());
    --]]
    self:setStatus(BauulAvatar.EStatus.Stand);
end