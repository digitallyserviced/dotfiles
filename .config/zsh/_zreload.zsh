trap - 
reload (){
  $(sleep 5 && trap - & ) 
  {
    trap 'print $LINENO $ERR' ZERR
    # trap 'print $LINENO $ZSH_DEBUG_CMD' DEBUG
    trap 'read -p fuck; print FINISHED' EXIT
    { source $HOME/.zshrc >> /tmp/test } && print "OK" || print "ERR: " 
  } always {
    trap -;
  }
}
rm ~/.zshrc.zwc
cd $(dirname $0)
rm -f *.zwc
reload
trap - 
