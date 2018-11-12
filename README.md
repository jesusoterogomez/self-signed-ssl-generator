# Self Signed Certificate Generator

```
For development use only
```

Utility to Generate Self Signed Certificates which can be accepted by Chrome 68+ (@see https://stackoverflow.com/a/42917227/781779)

### Requirements
- Linux / MacOS
- OpenSSL

### Usage

- Update server.conf with your desired values
- Run the utility
```sh
$ ./create.sh
```

- Get CA Key / Certificates from `./ssl` directory
