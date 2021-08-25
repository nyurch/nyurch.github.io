

sudo apt install clipit faenza-icon-theme git mc samba steam wine

sudo apt install gem ruby-dev
sudo gem install jekyll bundler
bundle update

sudo apt install tldr

git config --global user.email "nicolas.yurchuk@gmail.com"
git config --global user.name "nyurch"

sudo apt install gxneur
sudo apt install tilda

https://github.com/madmaxms/iconpack-obsidian
git clone https://github.com/madmaxms/iconpack-obsidian
gtk-update-icon-cache /usr/share/icons/Obsidian-Amber/

sudo apt install conky-all

Світла тема дає контури при використанні Compiz і не тільки. Ставимо Mint-Y-*

ACE Stream
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt update
sudo apt install snapd
sudo snap install acestreamplayer

ACE Stream + Firefox
В профілі у файлі handlers.json в розділ schemes додати
"ace":{"action":4,"ask":true}
Перезавантажити.

Firefox
Щоб заховати title bar переходимо в Налаштування панелі інструментів і зняти галочку зліва внизу.

Рукожопний значок Viber в треї лікується запуском так dbus-launch /opt/viber/Viber або заміною відповідного рядку у ярлику на наступний
Exec=dbus-launch /opt/viber/Viber

Якщо маємо nvme-диски то для моніторингу треба nvme-cli
н.п. sudo nvme smart-log /dev/nvme0n1
chmod u+s nvme якщо треба десь запускати без sudo н.п. в conky
Або можна аналогічно використовувати smartctl

Мій нас з древньою прошивкою пускає по cifs а по gvfs ні.
sudo apt-get install cifs-utils
fstab
//server/share /media/Share cifs username=nnn,password=ppp,uid=1000,vers=1.0,noauto,user 0 0
mount -a перечитати fstab


Steam
Settings -> Steam Play, галочка Enable Steam Play for all titles

https://averagelinuxuser.com/top-5-xfce-themes/

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client


