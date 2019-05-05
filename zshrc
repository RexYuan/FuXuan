
# run for interactive shells
# ln -s $POPPY/zshrc ~/.zshrc.local

# settings
export POPPY=/Users/Rex/Projects/Poppy
export TEXMF_LOCAL=/usr/local/texlive/texmf-local/tex/latex/local
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='nano'
export COWPATH="/Users/Rex/.cow"

unalias run-help
autoload run-help
alias help=run-help

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

pdf_gutter () {
    # pdf_gutter <[-m]argin offset in cm> <[-r]ight binding> <[-R]esize>
    #            <[-o]utput file name <[-s]cale down> <input file name>
    # usual 1cm left binding non-scaling command:
    #     pdf_gutter -m 1 input.pdf
    # add alternating margin to existing pdf
    # modified from https://superuser.com/questions/904332/add-gutter-binding-margin-to-existing-pdf-file

    cm_in_point=28

    # check for flags
    while getopts ':m:rRo:s' arg; do
        case $arg in
            m) local margin_size=$OPTARG ;;
            r) local right_binding=true ;;
            R) ;; # unimplemented
            o) local output=$OPTARG ;;
            s) local scale=true ;;
            \?) echo "Invalid option: -$OPTARG" ;;
            \:) echo "Option -$OPTARG requires an argument." ;;
        esac
    done

    # default setting
    [[ ! -v margin_size ]]   && local margin_size=1
    [[ ! -v right_binding ]] && local right_binding=""
    [[ ! -v output ]]        && local output="guttered.pdf"
    [[ ! -v scale ]]         && local scale=false
    [[ ! -v right_binding ]] && local right_binding=false

    # abort if file already exists
    [[ -e $output ]] && {echo "$output already exists" >&2; return 1}

    local offset_point=$(($margin_size * $cm_in_point))
    # widen the page for scaling down
    [[ $scale = true ]] && local width_point=$((595 + $offset_point))\
                        || local width_point=595
    # if scaling, only add offset to one of even/odd pages
    local odd_pages=""
    local even_pages=""
    if [[ $scale = true ]]; then
        if [[ $right_binding = true ]]; then
            local odd_pages="$offset_point 0 translate"
        else
            local even_pages="$offset_point 0 translate"
        fi
    # if not scaling, add proper offset to both even and odd pages
    # (first page starting as odd 1)
    else
        if [[ $right_binding = true ]]; then
            local even_pages="-$offset_point 0 translate"
            local odd_pages="$offset_point 0 translate"
        else
            local even_pages="$offset_point 0 translate"
            local odd_pages="-$offset_point 0 translate"
        fi
    fi
    # local resize="0.9550 1 scale"
    # TODO: figure out a way to properly resize back to original text size
    # problem is it scale in reference to lower left corner so pages shifted
    # right need to be moved right some more after scale
    local resize=""
    # assemble command
    local post_script_command="\"<< /CurrPageNum 1 def\
        /Install {/CurrPageNum CurrPageNum 1 add def\
        $resize CurrPageNum 2 mod 1 eq {$odd_pages}\
        {$even_pages} ifelse } bind  >> setpagedevice\""

    # shift off the options
    shift $((OPTIND-1))

    echo "RUNNING: gs -q -sDEVICE=pdfwrite -dBATCH -dNOPAUSE -sOutputFile=$output\
        -dDEVICEWIDTHPOINTS=$width_point -dDEVICEHEIGHTPOINTS=842 -dFIXEDMEDIA\
        -c $post_script_command -f \"$1\"\n" | tr -s " "

    gs -q -sDEVICE=pdfwrite -dBATCH -dNOPAUSE -sOutputFile=$output\
        -dDEVICEWIDTHPOINTS=$width_point -dDEVICEHEIGHTPOINTS=842 -dFIXEDMEDIA\
        -c $post_script_command -f $1

    echo "$output created"
    return 1
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
alias dlall="mapargs dl"
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
