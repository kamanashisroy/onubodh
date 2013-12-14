
function promt()
	local x = 'no'
	return x
end

local conf = assert(io.open("./.config.mk", "w"));
conf:write("PLATFORM=".."linux\n")
-- LUA_INCLUDE=-I/usr/include/lua5.1
-- LUA_LIB=-L/usr/lib/ -llua5.1
-- print("ECHO="..."echo -e")
-- use only echo in mac
conf:write("ECHO=".."echo\n")
-- print("QT_HOME="..."/home/ayaskanti/opt/qt/Desktop/Qt/474/gcc")
conf:write("SHOTODOL_HOME=/media/active/projects/shotodol\n")
conf:write("ONUBODH_HOME=/media/active/projects/onubodh\n")
conf:write("PROJECT_HOME=/media/active/projects/onubodh\n")
conf:write("VALA_HOME=/media/active/projects/aroop\n")
conf:write("CFLAGS+=-ggdb3\n")
assert(conf:close())

