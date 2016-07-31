# Docker tests : debian/nginx/mono stack
> A Dockerfile for an Elixir-PostgreSQL-Phoenixframework stack on Debian Jessie with a swiss locale.
Based on soriyath/debian-nodejs5

## Resources
* http://www.mono-project.com/docs/getting-started/install/linux/
* http://www.mono-project.com/docs/web/fastcgi/nginx/
* http://stackoverflow.com/questions/20932357/docker-enter-running-container-with-new-tty
* https://docs.docker.com/userguide/usingdocker/
* http://developer.telerik.com/featured/using-foundation-6-asp-net-core/
* https://docs.asp.net/en/latest/publishing/linuxproduction.html

## Running

### start mono fast-cgi
`fastcgi-mono-server4 /applications=webapp:/:/srv/www/webapp/ /socket=tcp:127.0.0.1:9000`

### reattach running container
docker exec -it [container-id] bash

### do wcf 
1. install [silverlight sdk](http://www.microsoft.com/en-us/download/details.aspx?id=28359)
