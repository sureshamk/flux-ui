module.exports = {
  devServer: {
    proxy: {
      '^/api': {
        target: 'example.com'
      }
    }
  }
}