# build image:
```
$ docker build -t fedora-workspace .
```

# data volume usage:
```
$ docker create -d convoy --opt o=size5GB --name mydatavol
$ docker create -d convoy --opt o=size100MB --name mygcloudconfigvol
$ docker run -v mydatavol:/data -v mygcloudconfigvol:/home/luser/.config/gcloud [-v c:/Users/James/Docker/data/Gitlab/home/.ssh:/home/luser/.ssh] --name myworkspace -it ipv1337/fedora-workspace
```
# data volume container usage:
```
$ docker create -v /data --name data-volume fedora /bin/true
$ docker create -v /home/luser/.config/gcloud --name gcloud-config-volume fedora /bin/true
$ docker run --volumes-from data-volume --volumes-from gcloud-config-volume [-v c:/Users/<username>/Docker/data/Gitlab/home/.ssh:/home/luser/.ssh] --name workspace -it ipv1337/fedora-workspace
```

# relaunch:
```
$ docker start workspace
$ docker attach workspace
```
or
```
$ docker-compose run workspace /bin/bash
```

# backup volume:
```
$ docker run --rm --volumes-from data-volume -v $(pwd):/backup fedora tar cvf /backup/data-volume.tar /data
$ docker run --rm --volumes-from gcloud-config-volume -v $(pwd):/backup fedora tar cvf /backup/gcloud-config-volume.tar /home/luser/.config/gcloud
```
# restore volume:
```
$ docker run --rm --volumes-from myworkspace -v C:/Users/James/Downloads:/backup fedora bash -c "cd /data && tar xvf /backup/data-volume.tar --strip 1"
$ docker run --rm --volumes-from myworkspace -v C:/Users/James/Downloads:/backup fedora bash -c "cd /home && tar xvf /backup/gcloud-config-volume.tar --strip 1"
```

# find unused volumes:
```
$ docker volume ls -f dangling=true
```
