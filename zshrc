
# run for interactive shells
# ln -s $POPPY/zshrc ~/.zshrc.local

# settings
export POPPY=/Users/Rex/Projects/Poppy
export TEXMF_LOCAL=/usr/local/texlive/texmf-local/tex/latex/local
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='nano'
export COWPATH="/Users/Rex/.cow"

mapargs () {
    for arg in ${@:2}
    do
        eval "$1 $arg"
    done
}       

splitcue () {
    # $1 .cue $2 .flac
    mkdir split
    shnsplit -o flac -t %n-%t -f $1 $2
    dos2unix $1
    cuetag.sh $1 [0-9]*.flac
    mv [0-9]*.flac split
}

# handy aliases
alias sml="rlwrap sml"
alias ocaml="rlwrap ocaml"
alias zshrc="nano /Users/Rex/.zshrc.local"
alias zshenv="nano /Users/Rex/.zshenv.local"
alias sip="python /Users/Rex/RexYuan.github.io/_pensieve/siphon.py"
alias dep="python /Users/Rex/Ellary-examples/vocab/deposit.py"

# latex shortcuts
alias texmf="cd /usr/local/texlive/texmf-local/tex/latex/local"
alias texmf-bibtex="cd /usr/local/texlive/texmf-local/bibtex/bst/local"

# youtube-dl shortcuts
alias ytdl=youtube-dl
alias dl="ytdl --no-playlist -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"
alias dl-audio="ytdl --extract-audio --audio-format mp3 --audio-quality 0"
alias dl-playlist="ytdl --yes-playlist -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 -i"
alias hqdl="ytdl -f 'bestvideo[ext=webm]+bestaudio[ext=webm]/bestvideo+bestaudio' --merge-output-format webm"
alias hqdl360="hqdl --user-agent \"\""
# run quietly in background
function qdl() { {dl --quiet $1 || echo '❌ this failed: ' $1} & }
function pdl() { {ytdl -f 'bestvideo/best' --quiet $1 || '❌ this failed: ' $1} & }

# convert to mp3
alias to-mp3="ffmpeg -vn -ar 44100 -ac 2 -b:a 192k -f mp3 out.mp3 -i"
# make mp4 from audio and image
function mp3vid() { ffmpeg -loop 1 -i $1 -i $2 -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest out.mp4 }

# convert from flv to mp4
function flv-to-mp4 () { echo $1 | grep -Fq ".flv" && ffmpeg -i $1 -c:v libx264 -crf 19 -strict experimental "$(echo $1 | cut -d '.' -f 1).mp4" }

# convert from big5 to utf8
function big5utf8() { file $1 | grep -Fq "ISO-8859" && iconv -f BIG5 -t UTF-8 $1 > $1.temp && mv $1.temp $1 }
# convert file under $1 with extension $2
function allbig5utf8() {
    for file in $1/**/*(.)$2
    do
        [[ ! -d $file ]] && big5utf8 $file
    done
}

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
