git add . &&
git commit -m "Auto deploy" &&
git push origin master &&
ssh -t root@193.70.38.32 <<EOF
git pull origin master &&
stack build &&
lsof -i:443 -Fp | sed 's/^p//' | head -n -1 | xargs kill -9;
nohup stack exec highkageshop > /dev/null 
echo "deploy finished"
EOF
