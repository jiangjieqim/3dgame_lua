LineCross = {


};
LineCross.__index = LineCross;
function LineCross:new(r)
    local _self = {lx,ly,lz,r};
    setmetatable(_self, LineCross);

    local lx = LineNode:new(2);
    lx:push(0,0,0);
    lx:push(0,0,0);
    lx:graphics_end();
    core.add(lx);
    local ly = LineNode:new(2);
    ly:push(0,0,0);
    ly:push(0,0,0);
    ly:graphics_end();
    core.add(ly);
    local lz = LineNode:new(2);
    lz:push(0,0,0);
    lz:push(0,0,0);
    lz:graphics_end();
    core.add(lz);
    _self.lx = lx;
    _self.ly = ly;
    _self.lz = lz;
    _self.r = r or 1;
    return _self;
end

function LineCross:setPos(x,y,z)
    
end

