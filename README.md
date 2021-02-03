This repository provides all you need for an easy setup of an [F-Droid Repository](https://f-droid.org/docs/Setup_an_F-Droid_App_Repo/) using nix.

The logic is implemented in `fdroid-repo-update.nix`, but you should not need to look too deep into it.

When you want setup a new repository, simply set your preferences in `configuration.nix`.

You can also run it in docker:

```
docker build . && docker run -ti -p 80:8888 $(docker build -q .)
```

The configured virtual host should now be reachable:

```
curl --resolve fdroid2.pergola.gra.one:8888:127.0.0.1 http://fdroid2.pergola.gra.one -I
```

Be aware, that the F-Droid client expects the server to serve via https.
Please configure the webserver for your setup.
You may want use the nixos config option [`services.nginx.virtualHosts.<name>.enableACME`](https://nixos.wiki/wiki/Nginx) or setup a reverse proxy to terminate tls.
