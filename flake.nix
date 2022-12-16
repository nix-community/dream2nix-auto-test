{
  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
  };

  outputs = inp:
    (inp.dream2nix.lib.makeFlakeOutputsForIndexes {
      source = ./.;
      systems = ["x86_64-linux"];
      indexes = builtins.fromJSON (builtins.readFile ./indexes.json);
      packageOverrides = {
        "^.*$".disable-build = {
          buildScript = ":";
        };
      };
    })
    // {
      checks = inp.self.packages;
    };
}
