# run for interactive shells

# settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='nano'
export COWPATH="/Users/Rex/.cow"
export PATH=$(brew --prefix llvm)/bin:$PATH
export PATH="$(brew --prefix homebrew/php/php71)/bin:$PATH"
export PATH=/Users/Rex/.composer/vendor/bin:$PATH

# handy aliases
alias sml="rlwrap sml"
alias ocaml="rlwrap ocaml"
alias dl="youtube-dl --no-playlist -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"
alias dl-audio="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0"
alias zshrc="nano /Users/Rex/.zshrc.local"
alias zshenv="nano /Users/Rex/.zshenv.local"
alias sip="python /Users/Rex/RexYuan.github.io/_pensieve/siphon.py"
alias dep="python /Users/Rex/Ellary-examples/vocab/deposit.py"
alias tf="source ~/tensorflow/bin/activate"
alias texmf="cd /usr/local/texlive/texmf-local/tex/latex/local"

# update helper
mas="echo \"-----🍎 -app-store---------------------------------------------------------------\" && mas upgrade &&"
brew="echo \"-----🍺 -brew--------------------------------------------------------------------\" && brew update && brew upgrade && brew cleanup &&"
apm="echo \"-----☢️ -apm---------------------------------------------------------------------\" && apm upgrade --no-confirm && apm clean &&"
antigen="echo \"-----💉 -antigen-----------------------------------------------------------------\" && antigen update && antigen cleanup --force &&"
npm="echo \"-----🚀 -npm---------------------------------------------------------------------\" && npm update -g &&"
gem="echo \"-----💎 -gem---------------------------------------------------------------------\" && gem update && gem cleanup &&"
pip="echo \"-----🐍 -pip---------------------------------------------------------------------\" && pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip3 install -U -q &&"
done="echo \"-----👍 -done--------------------------------------------------------------------\""
alias update="$mas$brew$apm$done"

# antigen setup
source /usr/local/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle history
antigen bundle osx
antigen bundle nyan
antigen bundle z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# pure theme
PURE_PROMPT_SYMBOL="🍵  ❯"
autoload -U promptinit; promptinit
prompt pure

# fun stuff
fortune -os -n 180 | cowsay -f party-parrot
