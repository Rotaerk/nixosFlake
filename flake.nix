{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      amaethon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./common.nix ./amaethon/configuration.nix ];
      };
      taliesin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./common.nix ./taliesin/configuration.nix ];
      };
    };
  };
}
