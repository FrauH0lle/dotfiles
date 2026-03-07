# Symlink Wayland sockets from WSLg into XDG_RUNTIME_DIR
if [ -d /mnt/wslg/runtime-dir ]; then
  ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$(id -u)/ 2>/dev/null
fi
