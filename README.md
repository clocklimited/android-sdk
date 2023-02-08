# android-sdk

This is a docker image which contains the Android SDK, OpenJDK 8, and Gradle 4.5.1.

You can alter the versions of build tools like so:

```
~/android-sdk-linux/tools/bin/sdkmanager "platform-tools" "platforms;android-28" "build-tools;30.0.3"
```

## Setting up the repo for DockerHub

1. Create the GitHub repo (obviously)
2. Login to DockerHub using `clockreleasebot`
3. Click `Create Repository`, or click [here](https://hub.docker.com/repository/create?namespace=clocklimited)
 - Make sure you set the repo description to be a link to the GitHub repo
4. Make sure `clocklimited` is selected, do not publish to `clockreleasebot/`
5. In the GitHub repo, go to [Settings -> Secrets -> Actions](https://github.com/clocklimited/android-sdk/settings/secrets/actions)
6. Add the repository-level secret `DOCKERHUB_USERNAME` with content `clockreleasebot`
7. Add the repository-level secret `DOCKERHUB_TOKEN` with the content obtained from creating a new token at [DockerHub](https://hub.docker.com/settings/security?generateToken=true)
 - Your token description should use the repo name, and have `Read & Write` permissions
8. Once setup, you can trigger a build and confirm everything is working as expected

## License

MIT

## Author

Clock Limited <https://www.clock.co.uk>
