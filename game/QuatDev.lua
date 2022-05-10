--- sx sy sz 起始向量  
--- tx ty tz 目标方向向量
function quatDev(sx,sy,sz,tx,ty,tz)

    --1帧的转动的弧度
    local speed = math.pi / 90;
    -- self.sx = sx;
    -- self.sy = sy;
    -- self.sz = sz;
    -- self.tx = tx;
    -- self.ty = ty;
    -- self.tz = tz;
    --求轴向量
    local ax,ay,az = vec3_normal(vec3_cross(sx,sy,sz,tx,ty,tz));
    -- ax,ay,az = vec3_mult(ax,ay,az,-1);
    local a= vec_to_angle(sx,sy,sz,tx,ty,tz,ax,ay,az);--角度
    ---已知轴向和角度求目标向量

    local c = a/speed;
    print(ax,ay,az,"speed",speed,'a',a,a/math.pi,"c="..c);
    
    -- print('vec3RotatePoint3d:', vec3RotatePoint3d(math.pi*2,ax,ay,az,sx,sy,sz));
end

-- function QuatDev:print()
--     print(self.sx,self.sy,self.sz);
-- end
