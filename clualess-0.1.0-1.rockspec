package = "clualess"
version = "0.1.0-1"
source = {
	url = "git://github.com/garvitverm-a/clualess",
}
description = {
	homepage = "https://github.com/garvitverm-a/clualess",
	license = "*** please specify a license ***",
}
dependencies = {
	"lua >= 5.2",
	"luafilesystem >= 1.8.0",
	"inspect >= 3.1",
}
build = {
	type = "builtin",
	modules = {
		clualess = "./src/main.lua",
	},
}
