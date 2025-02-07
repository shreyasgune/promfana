# Sample Web Api backend for the Game Web App
This is a sample Web Api backend for the Game Web App. It is written in C# using the .NET Core framework.

## Local Dev

- Make sure you have .Net SDK and CLI installed.
```
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --version latest
## Make sure to have the path sorted out
```

- Instantiate the project
```
dotnet new webapi -n GameBackend
```

- Create a container and run it locally
> I'm choosing to use podman instead of docker because 
    - out of box, it provides better security features
    - allows me to run as non-root user, making it better for security best practices
    - offers better integration with kubernetes
    - lighter than docker (which is nice because I'm running this on a SteamDeck)
    - adheres to OCI standards

### Build
```
podman build -t game-backend .

```

### Run
```
podman run -p 8080:8080 game-backend
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://[::]:8080
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /app
```

### Tag and Push
```
podman tag game-backend shreyasgune/dotnet-web-api:0.1

podman push shreyasgune/dotnet-web-api:0.1 
Getting image source signatures
Copying blob 84c9c5ff8f7f done  
Copying blob cab7a4d937d9 done  
Copying blob dbeea92a9458 done  
Copying blob 54538f06ae8f done  
Copying blob e6e3e0e27a6c done  
Copying blob 7914c8f600f5 done  
Copying blob cc2fa59615b4 done  
Copying config 0466182711 done  
Writing manifest to image destination
Storing signatures

```

### Testing
```
curl -X POST "http://localhost:8080/players" -H "Content-Type: application/json" -d '{"id":1, "name":"Alice", "score":0}'

curl -X POST "http://localhost:8080/players" -H "Content-Type: application/json" -d '{"id":17, "name":"Shreyas", "score":666}'

curl -X GET "http://localhost:8080/players"
[{"id":1,"name":"Alice","score":0},{"id":17,"name":"Shreyas","score":666}]

curl -X GET "http://localhost:8080/players/17"
{"id":17,"name":"Shreyas","score":666}%

```

### Security Scanning
- Set up snyk if you don't have it yet.
```
Create an account at https://snyk.io/
npm install -g snyk
snyk auth
```
- CodeTest
```
snyk test

Testing /home/sgune/devs/promfana/monitoring-stack/game-web-api-dotnet/GameBackend...

Organization:      shreyasgune
Package manager:   nuget
Target file:       obj/project.assets.json
Project name:      GameBackend
Open source:       no
Project path:      /home/sgune/devs/promfana/monitoring-stack/game-web-api-dotnet/GameBackend
Licenses:          enabled

✔ Tested 7 dependencies for known issues, no vulnerable paths found.
```

- Container test
```
snyk container test shreyasgune/dotnet-web-api:0.1 --file=Dockerfile

```

<details>

```
Testing shreyasgune/dotnet-web-api:0.1...

✗ Low severity vulnerability found in util-linux/libblkid1
  Description: Information Exposure
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-UTILLINUX-2401083
  Introduced through: util-linux/libblkid1@2.38.1-5+deb12u3, e2fsprogs@1.47.0-2, util-linux/libmount1@2.38.1-5+deb12u3, util-linux@2.38.1-5+deb12u3, util-linux/mount@2.38.1-5+deb12u3, util-linux/libuuid1@2.38.1-5+deb12u3, util-linux/libsmartcols1@2.38.1-5+deb12u3, util-linux/util-linux-extra@2.38.1-5+deb12u3, util-linux/bsdutils@1:2.38.1-5+deb12u3
  From: util-linux/libblkid1@2.38.1-5+deb12u3
  From: e2fsprogs@1.47.0-2 > util-linux/libblkid1@2.38.1-5+deb12u3
  From: util-linux/libmount1@2.38.1-5+deb12u3 > util-linux/libblkid1@2.38.1-5+deb12u3
  and 17 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in tar
  Description: CVE-2005-2541
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-TAR-1560620
  Introduced through: tar@1.34+dfsg-1.2+deb12u1, dash@0.5.12-2
  From: tar@1.34+dfsg-1.2+deb12u1
  From: dash@0.5.12-2 > dpkg@1.21.22 > tar@1.34+dfsg-1.2+deb12u1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Link Following
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SYSTEMD-1560739
  Introduced through: systemd/libsystemd0@252.33-1~deb12u1, apt@2.6.1, util-linux@2.38.1-5+deb12u3, util-linux/bsdutils@1:2.38.1-5+deb12u3, systemd/libudev1@252.33-1~deb12u1
  From: systemd/libsystemd0@252.33-1~deb12u1
  From: apt@2.6.1 > systemd/libsystemd0@252.33-1~deb12u1
  From: util-linux@2.38.1-5+deb12u3 > systemd/libsystemd0@252.33-1~deb12u1
  and 5 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Validation of Integrity Check Value
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SYSTEMD-5733385
  Introduced through: systemd/libsystemd0@252.33-1~deb12u1, apt@2.6.1, util-linux@2.38.1-5+deb12u3, util-linux/bsdutils@1:2.38.1-5+deb12u3, systemd/libudev1@252.33-1~deb12u1
  From: systemd/libsystemd0@252.33-1~deb12u1
  From: apt@2.6.1 > systemd/libsystemd0@252.33-1~deb12u1
  From: util-linux@2.38.1-5+deb12u3 > systemd/libsystemd0@252.33-1~deb12u1
  and 5 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Validation of Integrity Check Value
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SYSTEMD-5733390
  Introduced through: systemd/libsystemd0@252.33-1~deb12u1, apt@2.6.1, util-linux@2.38.1-5+deb12u3, util-linux/bsdutils@1:2.38.1-5+deb12u3, systemd/libudev1@252.33-1~deb12u1
  From: systemd/libsystemd0@252.33-1~deb12u1
  From: apt@2.6.1 > systemd/libsystemd0@252.33-1~deb12u1
  From: util-linux@2.38.1-5+deb12u3 > systemd/libsystemd0@252.33-1~deb12u1
  and 5 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Validation of Integrity Check Value
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SYSTEMD-5733398
  Introduced through: systemd/libsystemd0@252.33-1~deb12u1, apt@2.6.1, util-linux@2.38.1-5+deb12u3, util-linux/bsdutils@1:2.38.1-5+deb12u3, systemd/libudev1@252.33-1~deb12u1
  From: systemd/libsystemd0@252.33-1~deb12u1
  From: apt@2.6.1 > systemd/libsystemd0@252.33-1~deb12u1
  From: util-linux@2.38.1-5+deb12u3 > systemd/libsystemd0@252.33-1~deb12u1
  and 5 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in shadow/passwd
  Description: Access Restriction Bypass
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SHADOW-1559391
  Introduced through: shadow/passwd@1:4.13+dfsg1-1+b1, adduser@3.134, shadow/login@1:4.13+dfsg1-1+b1
  From: shadow/passwd@1:4.13+dfsg1-1+b1
  From: adduser@3.134 > shadow/passwd@1:4.13+dfsg1-1+b1
  From: shadow/login@1:4.13+dfsg1-1+b1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in shadow/passwd
  Description: Arbitrary Code Injection
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SHADOW-5423923
  Introduced through: shadow/passwd@1:4.13+dfsg1-1+b1, adduser@3.134, shadow/login@1:4.13+dfsg1-1+b1
  From: shadow/passwd@1:4.13+dfsg1-1+b1
  From: adduser@3.134 > shadow/passwd@1:4.13+dfsg1-1+b1
  From: shadow/login@1:4.13+dfsg1-1+b1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in shadow/passwd
  Description: Improper Authentication
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SHADOW-5879156
  Introduced through: shadow/passwd@1:4.13+dfsg1-1+b1, adduser@3.134, shadow/login@1:4.13+dfsg1-1+b1
  From: shadow/passwd@1:4.13+dfsg1-1+b1
  From: adduser@3.134 > shadow/passwd@1:4.13+dfsg1-1+b1
  From: shadow/login@1:4.13+dfsg1-1+b1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in shadow/passwd
  Description: CVE-2024-56433
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-SHADOW-8551160
  Introduced through: shadow/passwd@1:4.13+dfsg1-1+b1, adduser@3.134, shadow/login@1:4.13+dfsg1-1+b1
  From: shadow/passwd@1:4.13+dfsg1-1+b1
  From: adduser@3.134 > shadow/passwd@1:4.13+dfsg1-1+b1
  From: shadow/login@1:4.13+dfsg1-1+b1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in perl/perl-base
  Description: Link Following
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-PERL-1556505
  Introduced through: perl/perl-base@5.36.0-7+deb12u1
  From: perl/perl-base@5.36.0-7+deb12u1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in perl/perl-base
  Description: Improper Certificate Validation
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-PERL-5489184
  Introduced through: perl/perl-base@5.36.0-7+deb12u1
  From: perl/perl-base@5.36.0-7+deb12u1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in perl/perl-base
  Description: Improper Certificate Validation
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-PERL-5489190
  Introduced through: perl/perl-base@5.36.0-7+deb12u1
  From: perl/perl-base@5.36.0-7+deb12u1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in pam/libpam0g
  Description: CVE-2024-22365
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-PAM-6178914
  Introduced through: pam/libpam0g@1.5.2-6+deb12u1, shadow/login@1:4.13+dfsg1-1+b1, util-linux@2.38.1-5+deb12u3, adduser@3.134, pam/libpam-modules-bin@1.5.2-6+deb12u1, pam/libpam-modules@1.5.2-6+deb12u1, pam/libpam-runtime@1.5.2-6+deb12u1
  From: pam/libpam0g@1.5.2-6+deb12u1
  From: shadow/login@1:4.13+dfsg1-1+b1 > pam/libpam0g@1.5.2-6+deb12u1
  From: util-linux@2.38.1-5+deb12u3 > pam/libpam0g@1.5.2-6+deb12u1
  and 11 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in pam/libpam0g
  Description: Insecure Storage of Sensitive Information
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-PAM-8303301
  Introduced through: pam/libpam0g@1.5.2-6+deb12u1, shadow/login@1:4.13+dfsg1-1+b1, util-linux@2.38.1-5+deb12u3, adduser@3.134, pam/libpam-modules-bin@1.5.2-6+deb12u1, pam/libpam-modules@1.5.2-6+deb12u1, pam/libpam-runtime@1.5.2-6+deb12u1
  From: pam/libpam0g@1.5.2-6+deb12u1
  From: shadow/login@1:4.13+dfsg1-1+b1 > pam/libpam0g@1.5.2-6+deb12u1
  From: util-linux@2.38.1-5+deb12u3 > pam/libpam0g@1.5.2-6+deb12u1
  and 11 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in openssl/libssl3
  Description: CVE-2024-13176
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-OPENSSL-8648323
  Introduced through: openssl/libssl3@3.0.15-1~deb12u1, ca-certificates@20230311
  From: openssl/libssl3@3.0.15-1~deb12u1
  From: ca-certificates@20230311 > openssl@3.0.15-1~deb12u1 > openssl/libssl3@3.0.15-1~deb12u1
  From: ca-certificates@20230311 > openssl@3.0.15-1~deb12u1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in ncurses/libtinfo6
  Description: CVE-2023-50495
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-NCURSES-6123823
  Introduced through: ncurses/libtinfo6@6.4-4, bash/bash@5.2.15-2+b7, ncurses/ncurses-bin@6.4-4, util-linux@2.38.1-5+deb12u3, ncurses/ncurses-base@6.4-4
  From: ncurses/libtinfo6@6.4-4
  From: bash/bash@5.2.15-2+b7 > ncurses/libtinfo6@6.4-4
  From: ncurses/ncurses-bin@6.4-4 > ncurses/libtinfo6@6.4-4
  and 3 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in libgcrypt20
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-LIBGCRYPT20-1550206
  Introduced through: libgcrypt20@1.10.1-3, apt@2.6.1
  From: libgcrypt20@1.10.1-3
  From: apt@2.6.1 > apt/libapt-pkg6.0@2.6.1 > libgcrypt20@1.10.1-3
  From: apt@2.6.1 > gnupg2/gpgv@2.2.40-1.1 > libgcrypt20@1.10.1-3
  and 1 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in libgcrypt20
  Description: Information Exposure
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-LIBGCRYPT20-6405981
  Introduced through: libgcrypt20@1.10.1-3, apt@2.6.1
  From: libgcrypt20@1.10.1-3
  From: apt@2.6.1 > apt/libapt-pkg6.0@2.6.1 > libgcrypt20@1.10.1-3
  From: apt@2.6.1 > gnupg2/gpgv@2.2.40-1.1 > libgcrypt20@1.10.1-3
  and 1 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in gnutls28/libgnutls30
  Description: Improper Input Validation
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GNUTLS28-1547121
  Introduced through: gnutls28/libgnutls30@3.7.9-2+deb12u3, apt@2.6.1
  From: gnutls28/libgnutls30@3.7.9-2+deb12u3
  From: apt@2.6.1 > gnutls28/libgnutls30@3.7.9-2+deb12u3
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in gnupg2/gpgv
  Description: Out-of-bounds Write
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GNUPG2-3330747
  Introduced through: gnupg2/gpgv@2.2.40-1.1, apt@2.6.1
  From: gnupg2/gpgv@2.2.40-1.1
  From: apt@2.6.1 > gnupg2/gpgv@2.2.40-1.1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Information Exposure
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1546991
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Uncontrolled Recursion
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1547039
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Uncontrolled Recursion
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1547069
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Use of Insufficiently Random Values
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1547135
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Out-of-Bounds
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1547196
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Resource Management Errors
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1547293
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: CVE-2019-1010023
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-1547373
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: CVE-2025-0395
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GLIBC-8658672
  Introduced through: glibc/libc-bin@2.36-9+deb12u9, glibc/libc6@2.36-9+deb12u9
  From: glibc/libc-bin@2.36-9+deb12u9
  From: glibc/libc6@2.36-9+deb12u9
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in gcc-12/libstdc++6
  Description: Uncontrolled Recursion
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GCC12-2606941
  Introduced through: gcc-12/libstdc++6@12.2.0-14, apt@2.6.1, icu/libicu72@72.1-3, gcc-12/gcc-12-base@12.2.0-14, gcc-12/libgcc-s1@12.2.0-14
  From: gcc-12/libstdc++6@12.2.0-14
  From: apt@2.6.1 > gcc-12/libstdc++6@12.2.0-14
  From: icu/libicu72@72.1-3 > gcc-12/libstdc++6@12.2.0-14
  and 3 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in gcc-12/libstdc++6
  Description: CVE-2023-4039
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-GCC12-5901316
  Introduced through: gcc-12/libstdc++6@12.2.0-14, apt@2.6.1, icu/libicu72@72.1-3, gcc-12/gcc-12-base@12.2.0-14, gcc-12/libgcc-s1@12.2.0-14
  From: gcc-12/libstdc++6@12.2.0-14
  From: apt@2.6.1 > gcc-12/libstdc++6@12.2.0-14
  From: icu/libicu72@72.1-3 > gcc-12/libstdc++6@12.2.0-14
  and 3 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in coreutils
  Description: Improper Input Validation
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-COREUTILS-1543939
  Introduced through: coreutils@9.1-1
  From: coreutils@9.1-1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in coreutils
  Description: Race Condition
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-COREUTILS-1543947
  Introduced through: coreutils@9.1-1
  From: coreutils@9.1-1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Low severity vulnerability found in apt/libapt-pkg6.0
  Description: Improper Verification of Cryptographic Signature
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-APT-1541449
  Introduced through: apt/libapt-pkg6.0@2.6.1, apt@2.6.1
  From: apt/libapt-pkg6.0@2.6.1
  From: apt@2.6.1 > apt/libapt-pkg6.0@2.6.1
  From: apt@2.6.1
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)

✗ Critical severity vulnerability found in zlib/zlib1g
  Description: Integer Overflow or Wraparound
  Info: https://security.snyk.io/vuln/SNYK-DEBIAN12-ZLIB-6008963
  Introduced through: zlib/zlib1g@1:1.2.13.dfsg-1, util-linux@2.38.1-5+deb12u3, apt@2.6.1, dash@0.5.12-2
  From: zlib/zlib1g@1:1.2.13.dfsg-1
  From: util-linux@2.38.1-5+deb12u3 > zlib/zlib1g@1:1.2.13.dfsg-1
  From: apt@2.6.1 > apt/libapt-pkg6.0@2.6.1 > zlib/zlib1g@1:1.2.13.dfsg-1
  and 2 more...
  Image layer: Introduced by your base image (mcr.microsoft.com/dotnet/aspnet:8.0)



Organization:      shreyasgune
Package manager:   deb
Target file:       Dockerfile
Project name:      docker-image|shreyasgune/dotnet-web-api
Docker image:      shreyasgune/dotnet-web-api:0.1
Platform:          linux/amd64
Base image:        mcr.microsoft.com/dotnet/aspnet:8.0
Licenses:          enabled

Tested 92 dependencies for known issues, found 35 issues.

Currently, we only offer base image recommendations for Official Docker images

Pro tip: use `--exclude-base-image-vulns` to exclude from display Docker base image vulnerabilities.

Snyk found some vulnerabilities in your image applications (Snyk searches for these vulnerabilities by default). See https://snyk.co/app-vulns for more information.

To remove these messages in the future, please run `snyk config set disableSuggestions=true`

Learn more: https://docs.snyk.io/products/snyk-container/getting-around-the-snyk-container-ui/base-image-detection
```
</details>