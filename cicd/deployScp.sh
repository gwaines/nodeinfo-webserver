#!/usr/bin/expect -f
#  ./deployScp.exp <ipAddress> <userid> <password> <srcFile> <dstFile>...
set server [lrange $argv 0 0]
set name [lrange $argv 1 1]
set pass [lrange $argv 2 2]
set srcFile  [lrange $argv 3 3]
set dstFile  [lrange $argv 4 4]

spawn scp $srcFile $name@$server:$dstFile
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
expect eof

