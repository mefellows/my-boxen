# Load dotfiles
FILES=`find ~/dotfiles -type f`

for dotfile in ${FILES[@]}; do
  . $dotfile
done

# load boxen environment
source /opt/boxen/env.sh