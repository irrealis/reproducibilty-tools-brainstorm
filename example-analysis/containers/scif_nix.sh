echo "Running '$0'..."

# I hope that when SCIF is run without an appname, these will be undefined.
# In that case, the following shouldn't run.
if [ -n "$SCIF_APPROOT" ] && [ -n "$SCIF_APPNAME" ]; then
  # These will be temporarily altered, but restored at the end of this script.
  __saved_user="$USER"
  __saved_home="$HOME"

  # SCIF doesn't reset its environment between app installs.
  # This means NIX_PATHS, which is appended to in /etc/profile.d/nix.sh,
  # accumulates incorrect paths unless we unset it here.
  unset NIX_PATH

  # Don't want /etc/profile.d/nix.sh to run yet.
  # Unsetting USER and HOME will prevent nix.sh from automatically running.
  unset USER HOME

  # The system would normally run /etc/profile.d/nix.sh from /etc/profile.
  # Note: /etc/profile should only be run once.
  # Normally, ENV is set to /etc/profile,
  # and the system runs `$ENV` upon executing the shell.
  # So elsewhere during SCIF build, ENV is instead set to this script (scif_nix.sh).
  source /etc/profile

  # For SCIF, nix.sh should substitute USER with the app name, and HOME with the app root.
  export USER="$SCIF_APPNAME"
  export HOME="$SCIF_APPROOT"

  # Normally, /etc/profile.d/nix.sh will setup Nix channels to initially point
  # to `nixpgs-unstable` if "$HOME/.nix-channels" is missing. But which
  # channels to use should be specified by each SCIF app, so here we create an
  # empty ".nix-channels" file.
  if [ ! -e "$HOME/.nix-channels" ]; then
    touch "$HOME/.nix-channels"
  fi

  # Now run nix.sh using revised USER and HOME.
  source /etc/profile.d/nix.sh

  # NIX_PROFILE needs to be agree with the temporary variable NIX_LINK used in nix.sh.
  export NIX_PROFILE="$SCIF_APPROOT/.nix-profile"

  # Install Nix into new, empty profile.
  if [ "`which nix-env`" == "`echo`" ]; then
    echo "Installing Nix for SCIF app '$SCIF_APPNAME' at '$NIX_PROFILE'..."
    "$NIX_PROFILES_DIR/default/bin/nix-env" --profile "$NIX_PROFILE" --install --attr nixos.nixStable
  fi

  # Restore USER and HOME to their expected values.
  export USER="$__saved_user"
  export HOME="$__saved_home"

  # Clear temporary variables.
  unset __saved_user __saved_home
fi
