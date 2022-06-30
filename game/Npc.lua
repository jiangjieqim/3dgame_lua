local core = core;
Npc = {
    -- lc
    -- lis
}
Npc.__index = Npc;

setmetatable(Npc , BauulAvatar);

function Npc:new()
    local s = BauulAvatar:new();
    setmetatable(s,Npc);
    return s;
end

function Npc:ai(avatar)

    local lis;
    local npc = self;
    local x,y,z = npc:get_pos();
    local checkLen = 8;
    local lc = LineCircle:new(x,y,z,checkLen,15);
    self.lc = lc;
    local function loopfrender()
        local x,y,z = npc:get_pos();
        local x1,y1,z1 = avatar:get_pos();

        local len = vec3_distance(x,y,z,x1,y1,z1);

        if(len <= checkLen) then
            -- print("open ui");
            npc:look_at(x1,y1,z1);
            
            -- print("status:",self:getStatus());
            if(self:getStatus() == BauulAvatar.EStatus.Stand) then
                kit.playText("you In!",4000);
            end
            
            self:setStatus(BauulAvatar.EStatus.Jump);
            -- self:dispose();
            -- doSometing();
            
        else
            if(self:getStatus() == BauulAvatar.EStatus.Jump) then
                kit.playText("you Out!",4000);
            end

            self:setStatus(BauulAvatar.EStatus.Stand);
        end
    end
    self.lis = core.frameloop(1000,loopfrender);
end

function Npc:dispose()
    self.lc:dispose();
    core.clearTimeout(self.lis);
    core.super(self,"dispose");
    func_clearTableItem(self);
end