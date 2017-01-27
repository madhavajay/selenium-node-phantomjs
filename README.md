# PhantomJS 2.1.1 Docker Container + Remote Selenium Hub
A Docker Container with phantomjs 2.1.1 + patched ghostdriver working with Remote Selenium Hub! YES. For real! 🎉

# Why?
To run as many PhantomJS instances as possible using Docker and able to connect to a remote Selenium Grid. Most containers only use the local --link option to allow connectivity. The Ghostdriver lacks the ability to specify a different return host and port than the binding host and port which won't work for Docker.

NOTE: Chrome uses more memory and requires a standalone selenium server jar instance for every node so this quickly gets out of hand, even when Chrome supports --headless it may still require the chromedriver and selenium so its a heavy way to do bulk browser testing. The Ghostdriver implements the WebDriver protocol for Selenium Server and therefore doesn't require a standalone selenium server running per instance.

# Usage
Start a hub, any Selenium Hub anywhere:
```
$ docker run -d -P --name selenium-hub selenium/hub
```

Start as many PhantomJS nodes as you like, using different external ports.
```
$ docker run -d -e HUB=http://myhub.local:4444 -e PORT=5555 -e REMOTEHOST=http://mydesktop.local:5555 -p 5555:5555 madhavajay/selenium-node-phantomjs
```

# Environment Variables
- HUB = Host and Port of the Selenium Grid Hub
- PORT = Internal Port for PhantomJS Ghostdriver to bind to
- REMOTEHOST = The return Host and Port for Selenium Grid Hub to connect back to your docker container. Make this your machines external IP / HOSTNAME and PORT.
- IP = The docker container interface to bind to, which is not exposed as an environment variable but you could easily tweak the docker container to allow it.

To obtain the local IP for binding inside the docker container it simply runs:
```
--ip=`ip -4 addr show eth0| grep -Po 'inet \K[\d.]+'`
```

With this configuration you can run as many PhantomJS Containers on as many different machines as you like and point them to the same Hub. The Hub will be able to connect back because each container will bind to the IP and Port internally inside the Docker container, Docker will expose that port on your host with -p 5555:5555 so you can choose which ever ports you like and one for each container.
# Docker Hub
[madhavajay/selenium-node-phantomjs](https://hub.docker.com/r/madhavajay/selenium-node-phantomjs/)  
🌟 are welcome

# Credits
This uses PhantomJS Custom Edition build which has a fixed Ghostdriver:
https://github.com/mrorgues/PhantomJSCustomEdition

Then it loads the remotehost branch of my fork of @jesg's Ghost driver with an extra tweak allowing --remoteHost as a param on the CLI:
https://github.com/madhavajay/ghostdriver/blob/remotehost

Thanks to @wernight for a nice working reference Dockerfile for PhantomJS:
https://github.com/wernight/docker-phantomjs

Author: Madhava Jay  
Twitter: [@madhavajay](https://twitter.com/madhavajay)
