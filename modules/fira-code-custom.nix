{ config, lib, pkgs, ... }:

let
  cfg = config.fonts.firaCodeCustom;
in {
  options.fonts.firaCodeCustom = {
    enable = lib.mkEnableOption "Enable custom-built Fira Code";

    withFeatures = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "ss01" "cv14" "zero" ];
      description = "List of OpenType features to bake into Fira Code.";
    };

    fontFamilyName = lib.mkOption {
      type = lib.types.str;
      default = "features";
      example = "Fira Code Customized";
      description = "Name to give the built font family. Use default of 'features' to generate based on selected stylistic sets.";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      (pkgs.callPackage ../pkgs/fira-code-custom.nix {
        withFeatures = cfg.withFeatures;
        fontFamilyName = cfg.fontFamilyName;
      })
    ];
  };
}
