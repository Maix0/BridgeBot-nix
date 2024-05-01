{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        buildApp = pyEnv:
          pyEnv.buildPythonApplication {
            pname = "bridgebot";
            version = "0.0.0";
            pyproject = true;
            src = ./.;
            propagatedBuildInputs = [pyEnv.discordpy pyEnv.python-dotenv pyEnv.setuptools];
          };
        pyApp = buildApp (import nixpkgs {inherit system;}).pkgs.python3Packages;
      in {
        packages.default = pyApp;
        NixosModule = {
          config,
          lib,
          pkgs,
          ...
        }:
          with lib; {
            options = {
              service.bridebot = {
                enable = mkOption {
                  type = types.bool;
                  default = false;
                  description = "Weither to enable the BridgeBot service";
                };
                envFile = mkOption {
                  type = types.path;
                  description = "Path to required environement file";
                };
              };
            };
            config = mkIf config.service.bridgebot.enable {
              systemd.services.bridgebot = {
                wants = "network.target";
                requires = "network.target";
                enable = true;
                description = "";
                serviceConfig = {
                  Start = "${true}";
                };
              };
            };
          };
      }
    );
}
