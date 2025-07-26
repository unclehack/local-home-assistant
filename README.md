# local-home-assistant

## What is this?

local-home-assistant enables the users to include the icons Home Assistant loads from brands.home-assistant.io into the Home Assistant core Docker container images.

This avoids tracking and third-party dependencies for Home Assistant. The resulting Docker images doesn't rely on brands.home-assistant.io anymore. This provides better privacy and reliability.

## Current functionality

This is a new project. It'll require some additional improvements. The current feature set includes:
- identical icons are soft-linked to make the built image smaller
- the png images are quantized and shrunk to make the built image smaller
- compressed and uncompressed js files which contain the brands.home-assistant.io URL are updated to replace the URL with a reference to the Home Assistant static assets folder from the frontend
- js, js.gz and js.br files which don't contain references to brands.home-assistant.io URL aren't touched
- modified js.gz and js.br files are compressed again after modification
- .py files which contain references to brands.home-assistant.io are also updated
- the hass_frontend, insteon_frontend, knx_frontend and lcn_frontend are currently updated to replace references to brands.home-assistant.io in them

## Questions

Q: Is this a Home Assistant fork?
A: This isn't meant to be a fork. Ideally, this will be resolved in the upstream Home Assistant code to not require a fork or even these custom Home Assistant images.

## How to use?

1. Clone this repository
2. build the brands image which includes the icons
```
docker build --target brands-build -t brands-build-ha-with-brands .
```   
4. build the final Home Assistant Docker container image
```
docker build -t ha-no-brands:stable --force-rm .
```

The resulting ha-no-brands:stable image will be the image to use in your Docker compose or other tooling you use to run your containers.

Updating the brands image and the Home Assistant image would require these two additional steps before the steps above:
```
docker rmi brands-build
docker pull ghcr.io/home-assistant/home-assistant:stable
```

## Support

Don't reach out to the Home Assistant developers for support with issues encountered with Home Assistant Docker images modified with these tools.

Any issue you encounter has to be reproduced with the official image without changes before reporting issues. File an issue on this repository if you encounter the issue only with the modified images.

These tools are provided as they are. You're responsible for debugging and reporting issues if you want them investigated.

## License

This code is licensed under the GPL v3 and under future versions of the GPL license.
