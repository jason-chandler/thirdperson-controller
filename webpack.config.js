const webpack = require('webpack');
const path = require('path');
const fs = require('fs');

module.exports = {
  mode: 'none',
  entry: './.valtan-cache/thirdperson-controller.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  resolve: {
    modules: [
      'node_modules',
      fs.readFileSync('.valtan-path', 'utf-8')
    ]
  },
  plugins: [
        new webpack.DefinePlugin({
            'process.env.NODE_ENV': JSON.stringify('development')
        })
    ],
  devtool: 'inline-source-map',
  module: {
    rules: [
      {
        test: /\.js$/,
        use: ["source-map-loader"],
        enforce: "pre"
      }
    ]
  }
};
