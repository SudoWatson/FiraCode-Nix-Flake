# Fira Code Custom Nix Flake

This flake allows you to make a **custom build of Fira Code** easily in your NixOS config to bake OpenType features directly into the font.

> [!NOTE]
> This is my first Nix Flake. There may be issues with results, performance, or other. If you notice any problems, please open an issue and feel free to help in anyway.

---

## Features

- Build Fira Code with arbitrary OpenType stylistic sets.
- Fully reproducible via Nix.
- Allows custom font family name for easy fontconfig management.

---

## Usage (NixOS)
Add flake input
```nix
inputs = {
  fira-code-flake.url = "github:SudoWatson/FiraCode-Nix-Flake"; 
};
```

Add flake module
```nix
nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
  modules = [
    fira-code-flake.nixosModules.firaCodeCustom
  ];
};
```

Then in you NixOS configuration
```nix
fonts.firaCodeCustom = {
  enable = true;
  withFeatures = [ "ss01" "cv14" "zero" ];
  fontFamilyName = "Fira Code Custom";
};
```

`withFeatures` - List of OpenType features to enable. Optional. See https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets for the features available. Any program that uses the built font will use the selected features (ligatures still dependent on ligature support by program)

`fontFamilyName` - Name used in fontconfig to identify the font. Optional. Defaults to "features" which appends the chosen features onto the name.


The font will be installed and available just as any other font in your system.
