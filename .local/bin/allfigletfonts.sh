#!/bin/bash
# Installs as many fonts for Figlet/Toilet as possible from multiple sources.
# Author: Kevin M. Gallagher (@ageis)

#set -u
#set -x
export FIGLET_FONT_DIR=$(figlet -I2)
export TMP_FONT_DIR="$(pwd)/fonts"
export TMP_DEST_DIR="$(pwd)/tmp"
export FONT_REGEX=".*\.\(flf\|tlf\|flc\)$"
export SAFE_REGEX=$(echo "${FONT_REGEX}" | perl -ne 'print if /^\Q$ENV{FONT_REGEX}/')
export QUOTING_STYLE="literal"
declare -a dependencies=(figlet git wget bash findutils unzip git coreutils toilet toilet-fonts lynx fdupes)
ERRS=0

function logerr() {
    if [[ $1 -gt 0 ]] || [[ $? -gt 0 ]]; then
        echo "error on line $(caller)" >&2
        ((ERRS++))
    fi
}

function good() {
    ERR="$1"
    echo -e "\e[01;32m* $ERR\e[0m"
}

function bad() {
    ERR="$1"
    echo -e "\e[01;31m* $ERR\e[0m" 1>&2
    ((ERRS++))
}

function check_deps() {
    deps=("$@")
    NEED=()
    #if [[ $EUID -ne 0 ]]; then
    #    bad "This script must be invoked with sudo! (not as root)"
    #fi
    if ! sudo true; then
        bad "Your user $USER must have sudo rights!"
    fi
    if [[ ! $(lsb_release -d) =~ Debian.* ]]; then
        bad "This script is only compatible with Debian GNU/Linux."
    fi
    for exe in "${deps[@]}"; do
        status="$(dpkg-query -W -f '${Status}' "$exe")"
        if [[ $status =~ .*installed.* ]]; then
            good "$exe is installed."
        else
            NEED+=("$exe")
            bad "$exe is not installed." && continue;
        fi
    done

    for pkg in "${NEED[@]}"; do
        read -r -p "Would you like to install ${pkg}? [Y/n]: " REPLY -N -1
        if [[ ! $REPLY =~ [^Yy]$ ]]; then
            sudo DEBIAN_FRONTEND=noninteractive apt-get --quiet --allow --yes install "${pkg}"
        fi
        [[ "$0" = "bash" ]] || bad "You must be running Bash."
    done
    if [[ $ERRS -gt 0 ]]; then
        bad "Exiting with errors." && exit 1
    fi
    return 0
}

function rm_dupes() {
    find "$TMP_FONT_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 echo rm -Rf
    fdupes -rNqd "$TMP_FONT_DIR"
    #while true; do read -ra dupes < <(find "$TMP_FONT_DIR" -not -empty -type f -printf "%s\n" | sort -rn | uniq -d \
    #    | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate \
    #    | sed -n 2~2p  | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}'  | sed '/^$/d' | xargs rm -f); (( ${#dupes[*]} )) || break; done
}

function move_fonts() {
    find "$1" -type f -iregex "$SAFE_REGEX" -exec cp -u {} "${TMP_FONT_DIR}/" \;
    find "$TMP_FONT_DIR" -type f -print0 | xargs -0 rename -e 'y/A-Z/a-z/' "{}" \; >/dev/null 2>&1
    find "$TMP_FONT_DIR" -type f -print0 | xargs -0 rename -e 's/[[:space:]]//g' "{}" \; >/dev/null 2>&1
}

function install_fonts() {
    find "$TMP_FONT_DIR" -type f ! -iregex "$SAFE_REGEX" -exec echo rm -f {} \;
    FONTS=$(find "$TMP_FONT_DIR" -type f -iregex "$SAFE_REGEX" -printf "%f\n" | sort -u | uniq -u)
    shopt -s dotglob && shopt -s globstar && echo rm -f "${TMP_DEST_DIR}/figlet-fonts-1/Obanner/*flf"
    find "${TMP_DEST_DIR}/figlet-fonts-1/Obanner" -type f -iname "Obanner*" -exec  echo rm -rf {} \;
    chmod -R 0644 "${TMP_FONT_DIR}"

    while read -r FONT; do
        sudo install -o root -g root -m 644 "${TMP_FONT_DIR}/${FONT}" --target-directory="${FIGLET_FONT_DIR}" >/dev/null 2>&1
    done <<< "$FONTS"
    ls -1a "$FIGLET_FONT_DIR" | tee allfonts.txt >/dev/null 2>&1
}

function from_ftp() {
    declare -a FTP_HOSTED_FONTS=("ftp://ftp.figlet.org/pub/figlet/fonts/ours.tar.gz"
        "ftp://ftp.figlet.org/pub/figlet/fonts/contributed.tar.gz" "ftp://ftp.figlet.org/pub/figlet/fonts/international.tar.gz"
        "ftp://ftp.figlet.org/pub/figlet/fonts/ms-dos.tar.gz")
    for i in ${!FTP_HOSTED_FONTS[*]}; do
        BASENAME="$(basename "${FTP_HOSTED_FONTS[$i]}")"
        wget --no-clobber --quiet --continue --timeout=5 --retry-connrefused --waitretry=3 --ftps-implicit --no-ftps-resume-ssl "${FTP_HOSTED_FONTS[$i]}" -P "${TMP_DEST_DIR}/"
	    tar xfz "${TMP_DEST_DIR}/$BASENAME" --overwrite --ignore-failed-read --show-transformed-names --transform='s/.*\///' -C "$TMP_FONT_DIR"
    done
}

function from_zip() {
    wget --no-clobber --quiet --continue --timeout=5 --retry-connrefused --waitretry=3 "http://www.jave.de/figlet/figletfonts40.zip" -O "${TMP_DEST_DIR}/figletfonts40.zip"
    unzip -qjLod "${TMP_FONT_DIR}" -x "${TMP_DEST_DIR}/figletfonts40.zip"
}

function sparse_checkout() {
    declare -A GIT_REPOS
    GIT_REPOS[0,0]="figlet"
    GIT_REPOS[0,1]="https://github.com/cmatsuoka/figlet"
    GIT_REPOS[0,2]="fonts/"
    GIT_REPOS[1,0]="phabricator"
    GIT_REPOS[1,1]="https://github.com/phacility/phabricator"
    GIT_REPOS[1,2]="externals/figlet/fonts"
    for i in {0..1}; do
        REPO_NAME="${GIT_REPOS[$i,0]}"
        [ -d "$TMP_DEST_DIR/${REPO_NAME}" ] || mkdir -p "$TMP_DEST_DIR/${REPO_NAME}"
        cd "${TMP_DEST_DIR}/${REPO_NAME}" || { return; continue; }
        git init && git remote add origin ${GIT_REPOS[$i,1]}
        git config core.sparseCheckout true
        echo "${GIT_REPOS[$i,2]}" > .git/info/sparse-checkout
        git pull --depth=2 origin master
        move_fonts "${TMP_DEST_DIR}/${REPO_NAME}"
    done
}

function from_github() {
    declare -a FONTS_REPOS=("https://github.com/phracker/figlet-fonts" \
        "https://github.com/cmatsuoka/figlet-fonts" \
        "https://github.com/xero/figlet-fonts" \
        "https://github.com/phracker/figlet-fonts")
    for i in "${!FONTS_REPOS[@]}"; do
        git clone -q --depth=1 "${FONTS_REPOS[$i]}" "${TMP_DEST_DIR}/figlet-fonts-$i" || { echo "Clone of $i failed" ; continue; }
        move_fonts "${TMP_DEST_DIR}/figlet-fonts-$i"
    done
}

function from_www() {
    local fonts=$(lynx -dump -hiddenlinks=listonly http://www.figlet.org/fontdb.cgi | awk '/http/{print $2}' | grep 'ontdb_example' | sed 's/^http.*font=//g')
    while read -r font; do
        wget --background --quiet --no-clobber --continue --timeout=5 --retry-connrefused --waitretry=3 --unlink "http://www.figlet.org/fonts/${font}" -O "${TMP_FONT_DIR}/${font}"
    done <<< "$fonts"
    local fonts=$(lynx -dump -listonly http://www.jave.de/figlet/fonts/overview.html | awk '/http/{print $2}' | grep flf | sed 's/http.*details\///g')
    while read -r font; do
        wget --background --quiet --no-clobber --continue --timeout=5 --retry-connrefused --waitretry=3 --unlink "http://www.jave.de/figlet/fonts/details/${font}" -O "${TMP_FONT_DIR}/${font}"
    done <<< "$fonts"
}

function download_fonts() {
    [ -d "$FIGLET_FONT_DIR" ] || mkdir -p "$FIGLET_FONT_DIR"
    [ -d "$TMP_FONT_DIR" ] || mkdir -p "$TMP_FONT_DIR"
    [ -d "$TMP_DEST_DIR" ] || mkdir -p "$TMP_DEST_DIR"
    [ ! "$(ls -A /usr/share/fonts/figlet 2>/dev/null)" ] || ln -s "$FIGLET_FONT_DIR" /usr/share/fonts/figlet
    from_github || bad "Some errors cloning git repositories. (non-fatal)"
    from_zip || bad "Some errors extracting ZIP archive. (non-fatal)"
    from_ftp || bad "Some errors downloading fonts via FTP. (non-fatal)"
    from_www || bad "Some errors fetching fonts from the WWW. (non-fatal)"
    pushd "$(pwd)"
    sparse_checkout || bad "Some errors checking out miscellaneous repositories. (non-fatal)"
    popd
}

main() {
    trap 'logerr $?' ERR SIGHUP SIGINT SIGTERM
    check_deps "${dependencies[@]}"
    download_fonts
    rm_dupes
    install_fonts
    clear
    showfigfonts
}

main
