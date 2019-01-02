module.exports = {
  pluginOptions: {
    electronBuilder: {
      builderOptions: {
        // options placed here will be merged with default configuration and passed to electron-builder
        linux: {
          executableName: 'loginized',
          icon: './src/assets/logo_ld_4_256.png',
          target: [
            {
              target: "deb",
              arch: [
                "x64"
              ]
            },
            {
              target: "rpm",
              arch: [
                "x64"
              ]
            },
            {
              target: "pacman",
              arch: [
                "x64"
              ]
            },
            {
              target: "zip",
              arch: [
                "x64"
              ]
            },
            {
              target: "AppImage",
              arch: [
                "x64"
              ]
            },
            {
              target: "snap",
              arch: [
                "x64"
              ]
            }
          ]
        }
      }
    }
  }
}
