local fold = getenv();--对应test.c的GAME_LUA_PATH
--增加脚本扩展路径
package.path=package.path..";"..fold.."\\lua\\?.lua"..";"..fold.."\\lua\\src\\?.lua";
--package.path=string.format("%s;%s%s",package.path,fold,"\\ui\\src\\?.lua");
package.path = string.format("%s;%s%s",package.path,fold,"\\ui\\?.lua");
package.path = string.format("%s;%s%s",package.path,fold,"\\game\\?.lua");
print("getenv() is:"..fold);