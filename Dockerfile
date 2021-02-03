FROM johannesloetzsch/nix-flake

WORKDIR /etc/nixos
COPY flake* configuration.nix *.nix /etc/nixos/
RUN nix build -o /etc/nginx/nginx.conf '.#nixosConfigurations.fdroid-repo.config.environment.etc."nginx/nginx.conf".source'
RUN mkdir -p /run/nginx /var/cache/nginx /var/log/nginx
RUN nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf -t
CMD nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf

COPY fdroid /etc/nixos/fdroid
RUN nix run .#nixosConfigurations.fdroid-repo.config.services.fdroid-repo.package
CMD nix run .#nixosConfigurations.fdroid-repo.config.services.fdroid-repo.package && nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf
