{ config, lib, pkgs, ... }:

let
  cfg = config.fonts.firaCodeCustom;
in {
  options.fonts.firaCodeCustom = {
    enable = lib.mkEnableOption "Enable custom-built Fira Code";

    withFeatures = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "ss01" "ss03" "zero" ];
      description = "List of OpenType features to bake into Fira Code.";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      (pkgs.callPackage ../pkgs/fira-code-custom.nix { withFeatures = cfg.withFeatures; })
    ];
  };
}
