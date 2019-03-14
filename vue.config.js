module.exports = {
  pluginOptions: {
    electronBuilder: {
      builderOptions: {
        // options placed here will be merged with default configuration and passed to electron-builder
        directories: {
          buildResources: 'build_electron',
        },
        extraFiles: [
          "loginized-cli*",
          "utils.sh",
          "completion/*"
        ],
        productName: 'Loginized',
        linux: {
          category: 'GTK;GNOME;Utility;',
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
            // {
            //   target: "snap",
            //   arch: [
            //     "x64"
            //   ]
            // }
          ]
        }
      }
    }
  }
}
