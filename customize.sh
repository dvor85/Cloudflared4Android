  ui_print " "
  ui_print "*******************************"
  ui_print "*    Cloudflared-dns-proxy    *"
  ui_print "*        Magisk Module        *"
  ui_print "*******************************"
  ui_print "*        v1.0.1               *"
  ui_print "*  created by demon           *"
  ui_print "*******************************"
  ui_print " "

  if [ "$ARCH" == "arm" ];then
    BINARY_PATH=$TMPDIR/binary/cloudflared-linux-arm
  elif [ "$ARCH" == "arm64" ];then
    BINARY_PATH=$TMPDIR/binary/cloudflared-linux-arm64
  fi

  unzip -o "$ZIPFILE" 'binary/*' -d $TMPDIR

  ui_print "* Creating binary path"
  mkdir -pv $MODPATH/system/bin

  if [ -f "$BINARY_PATH" ]; then
    ui_print "* Copying binary for $ARCH"
    cp -afv $BINARY_PATH $MODPATH/system/bin/cloudflared
  else
    abort "Binary file for $ARCH is missing!"
  fi

  set_perm_recursive $MODPATH 0 0 0755 0755
  set_perm $MODPATH/system/bin/cloudflared 0 0 0755
