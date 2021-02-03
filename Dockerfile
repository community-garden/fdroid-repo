FROM johannesloetzsch/nix-flake

WORKDIR /etc/nixos
COPY flake* configuration.nix *.nix /etc/nixos/
RUN nix build -o /etc/nginx/nginx.conf '.#nixosConfigurations.fdroid-repo.config.environment.etc."nginx/nginx.conf".source'
RUN mkdir -p /run/nginx /var/cache/nginx /var/log/nginx
RUN nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf -t
CMD nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf

## We copy the parent directory of the optionally existing ./fdroid/ repository.
## This yields a docker container with a builtin copy of ./fdroid/
COPY . /etc/nixos
RUN nix run .#nixosConfigurations.fdroid-repo.config.services.fdroid-repo.package

## On a production system you want ./fdroid/ to be a volume
#CMD nix run .#nixosConfigurations.fdroid-repo.config.services.fdroid-repo.package && nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf
