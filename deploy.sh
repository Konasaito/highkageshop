git add . &&
git commit -m "$1" &&
git push origin master &&
ssh root@193.70.38.32 <<EOF
cd highkageshop &&
git pull origin master &&
stack build &&
lsof -i:443 -Fp | sed 's/^p//' | head -n -1 | xargs kill -9;
nohup stack exec highkageshop > /dev/null 
echo "deploy finished"
EOF
