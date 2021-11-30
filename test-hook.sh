#
# Test the app deploy

TH_MYSQL_IS_RUNNING=sudo ps aux | grep -q mysqld | grep -v grep

[ -z "$TH_MYSQL_IS_RUNNING"] && sudo systemctl start mysql.service 
cd /home/albo/projects/nube-test-app
message="Test on $(date)"
echo $message >> 'test.log'
git add .
git commit -m "$message"
git push prod
[ -z "$TH_MYSQL_IS_RUNNING"] && sudo systemctl stop mysql.service 
