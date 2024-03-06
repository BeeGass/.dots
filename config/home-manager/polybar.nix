{ pkgs, ... }:

{
services.polybar = {
    enable = true;
    script = ''
	polybar centerbar &
	polybar leftbar &
	polybar rightbar &
    '';
  };
}
