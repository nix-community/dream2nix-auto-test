{
  outputs = {
    self,
    nixpkgs,
  }: {
    apps.x86_64-linux.default = {
      type = "app";
      program = "${
        with nixpkgs.legacyPackages.x86_64-linux;
          writeShellApplication {
            name = "update";
            text = ''
              make
            '';
            runtimeInputs = [gnumake jq envsubst];
          }
      }/bin/update";
    };
  };
}
