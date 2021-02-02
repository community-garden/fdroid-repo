FROM johannesloetzsch/nix-flake

RUN mkdir -p /etc/nixos
COPY . /etc/nixos
RUN nix-channel --add https://nixos.org/channels/nixos-20.09 nixpkgs && nix-channel --update
RUN nix-build '<nixpkgs/nixos>' -A system -I nixos-config=/etc/nixos/configuration.nix
RUN ln -s /nix/store/*-nixos-system-nixos-*/init /sbin/init
CMD /sbin/init

RUN mkdir -p /run/nginx /var/cache/nginx /var/log/nginx
RUN /nix/store/*-nginx-*/bin/nginx -c /nix/store/*-nginx.conf -t
CMD /nix/store/*-nginx-*/bin/nginx -c /nix/store/*-nginx.conf
