FROM johannesloetzsch/nix-flake

WORKDIR /etc/nixos
COPY flake* configuration.nix /etc/nixos/
RUN nix build -o /etc/nginx/nginx.conf '.#nixosConfigurations.fdroid-repo.config.environment.etc."nginx/nginx.conf".source'
RUN mkdir -p /run/nginx /var/cache/nginx /var/log/nginx
RUN nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf -t
CMD nix run .#pkgs.nginx -- -c /etc/nginx/nginx.conf

COPY . /etc/nixos
