unused_args = false
std = "luajit"
-- ignore implicit self
self = false

globals = {
    "G_reader_settings",
    "G_defaults",
    "table.pack",
    "table.unpack",
    "_",
}

read_globals = {
    "_ENV",
}


-- https://luacheck.readthedocs.io/en/stable/warnings.html
-- 211 - Unused local variable
-- 631 - Line is too long
ignore = {
    "211",
    "631",
    "311",
    "dummy",
}
