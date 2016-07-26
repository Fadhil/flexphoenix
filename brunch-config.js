exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {

      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      joinTo: {
       "js/app.js": /^(web\/static\/js)|(node_modules\/phoenix\/priv)|(node_modules\/phoenix_html\/priv)/,
       "js/vendor.js": /^(web\/static\/vendor\/js)|(bower_components)/
      },
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      order: {
        before: [
          "bower_components/jquery/dist/jquery.min.js",
          "bower_components/bootstrap/dist/js/bootstrap.min.js"
        ]
      }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /^(web\/static\/css)/,
        "css/vendor.css": /^(web\/static\/vendor\/css)|(bower_components)/
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static",
      "bower_components/bootstrap/dist/css"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/^(web\/static\/vendor)|(bower_components)/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html"]
  }
};
