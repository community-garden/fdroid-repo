FROM johannesloetzsch/nix-flake

RUN mkdir -p /etc/nixos
COPY . /etc/nixos
RUN nix-channel --add https://nixos.org/channels/nixos-20.09 nixpkgs && nix-channel --update
RUN nix-build '<nixpkgs/nixos>' -A system -I nixos-config=/etc/nixos/configuration.nix
RUN ln -s /nix/store/*-nixos-system-nixos-*/init /sbin/init

CMD /sbin/init

## docker run -ti -p 80:8888 --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm $(docker build -q .)
