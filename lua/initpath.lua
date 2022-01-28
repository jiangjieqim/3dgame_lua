local fold = getenv();--对应test.c的GAME_LUA_PATH
--增加脚本扩展路径
package.path=package.path..";"..fold.."\\lua\\?.lua"..";"..fold.."\\lua\\src\\?.lua";
-- print("fold:"..fold);