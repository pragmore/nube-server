#
# Test the app deploy

TH_MYSQL_IS_RUNNING=sudo ps aux | grep -q mysqld | grep -v grep

[ -z "$TH_MYSQL_IS_RUNNING"] && sudo systemctl start mysql.service 
./hook-post-update.sh "test.nube.pragmore.local" "/home/albo/git/nube-test-app.git"
[ -z "$TH_MYSQL_IS_RUNNING"] && sudo systemctl stop mysql.service 
