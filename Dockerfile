FROM johannesloetzsch/nix-flake

RUN mkdir -p /etc/nixos
COPY . /etc/nixos
#RUN nix build /etc/nixos#nixosConfigurations.fdroid-repo.config.system.build.toplevel
#RUN ln -s /nix/store/*-nixos-system-nixos-*/init /sbin/init
#CMD /sbin/init

RUN nix build '/etc/nixos#nixosConfigurations.fdroid-repo.config.system.build.units."nginx.service".unit'
RUN mkdir -p /run/nginx /var/cache/nginx /var/log/nginx
RUN /nix/store/*-nginx-*/bin/nginx -c /nix/store/*-nginx.conf -t
CMD /nix/store/*-nginx-*/bin/nginx -c /nix/store/*-nginx.conf
