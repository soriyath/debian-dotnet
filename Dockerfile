FROM soriyath/debian-postgresql94
MAINTAINER Sumi Straessle

RUN	DEBIAN_FRONTEND=noninteractive set -ex \
	&& apt-get update \
	&& apt-get install -y --fix-missing wget build-essential \ 
	&& echo "nameserver 8.8.8.8" >> /etc/resolv.conf

RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
	&& echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list \
	&& echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
	&& echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list \
	&& apt-get update \
	&& apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing mono-complete mono-devel mono-complete referenceassemblies-pcl ca-certificates-mono mono-fastcgi-server4 mono-xsp4 mono-xsp4-base fsharp mono-vbnc nuget nginx vim mlocate curl libunwind8 gettext supervisor

ADD nginx.conf /etc/nginx/sites-available/default
# ADD fastcgi_param.conf /etc/nginx/fastcgi_params
ADD webappmvc.conf /etc/supervisor/conf.d/webappmvc.conf

WORKDIR /usr/local/src
RUN DEBIAN_FRONTEND=noninteractive curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=827530 \
	&& mkdir -p /opt/dotnet \
	&& tar zxf dotnet.tar.gz -C /opt/dotnet \
	&& ln -s /opt/dotnet/dotnet /usr/local/bin

# We need npm (and NodeJS) for bower
RUN DEBIAN_FRONTEND=noninteractive wget https://nodejs.org/dist/v6.6.0/node-v6.6.0.tar.gz \
	&& tar -xzvf node-v6.6.0.tar.gz && rm -f node-v6.6.0.tar.gz \
	&& cd node-v6.6.0 \
	&& ./configure \
	&& make -j $(cat /proc/cpuinfo | grep processor | wc -l)\
	&& make install

# Upgrade npm
RUN DEBIAN_FRONTEND=noninteractive npm install -g bower

# Updating npm doesn't work yet, please do this when running the container
# See : https://github.com/npm/npm/issues/9863
# RUN DEBIAN_FRONTEND=noninteractive npm install -g npm

RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000
WORKDIR /srv/webapp

CMD  ["service postgresql start"]
# service supervisor start