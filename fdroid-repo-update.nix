{ config, pkgs, jdk ? pkgs.openjdk8}:
let
  fdroid = "${pkgs.fdroidserver}/bin/fdroid";
  sed = "${pkgs.gnused}/bin/sed";
  tr = "${pkgs.coreutils}/bin/tr";

  update-config = with config.services.fdroid-repo; (pkgs.writeScriptBin "update-config" ''
  #!${pkgs.runtimeShell} -e

  sed_multiline_i() {
    ## for inline replacements with mulitline-patterns
    SED_EXPR=$1
    FILE=$2
    cp $FILE $FILE~
    cat $FILE~ | ${tr} '\n' '\t' | ${sed} "$SED_EXPR" | ${tr} '\t' '\n' > $FILE
  }

  expr() {
    VAR=$1
    VALUE=$2
    QUOTE=$3
    ANY='[^"]*'
    EXPR="$(echo 's@'$VAR$ANY'='$ANY$QUOTE$ANY$QUOTE'@'$VAR' = "'$VALUE'"@')"
  }

  replace_python_str_value() {
    VAR=$1
    VALUE=$2
    FILE=$3
    expr $VAR "$VALUE" '"""' && sed_multiline_i "$EXPR" $FILE
    expr $VAR "$VALUE" '"' && ${sed} -i "$EXPR" $FILE
  }

  replace_python_str_value repo_url "${repo_url}" config.py
  replace_python_str_value repo_name "${repo_name}" config.py
  replace_python_str_value repo_description "${repo_description}" config.py
  '');

in
(pkgs.writeScriptBin "fdroid-repo-update" ''
  #!${pkgs.runtimeShell} -e
  PATH="$PATH:${pkgs.stdenv.lib.makeBinPath [jdk]}"

  ## This command is an idempotent version of https://f-droid.org/docs/Setup_an_F-Droid_App_Repo/#overview

  [ ! -d fdroid ] && mkdir fdroid
  cd fdroid
  [ ! -f config.py ] && ${fdroid} init

  echo 'Feel free to edit ./fdroid/config.py yourself.'
  echo 'Be aware that fdroid-repo-update overwrites the variables defined in configuration.nix'
  ${update-config}/bin/update-config

  [ ! -d repo ] &&  mkdir repo
  if ! ls repo/*.apk ; then
    echo 'Please put APK files into ./fdroid/repo/'
    exit
  fi

  ${fdroid} update -c
'')
