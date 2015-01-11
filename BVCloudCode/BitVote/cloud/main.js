var bitcoin = require('cloud/node_modules/bitcoinjs-lib/src/index.js');
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.job("TestBC", function(request, status) {
  key = bitcoin.ECKey.makeRandom();

  // Print your private key (in WIF format)
  console.log(key.toWIF());
  // => Kxr9tQED9H44gCmp6HAdmemAzU3n84H3dGkuWTKvE23JgHMW8gct

  // Print your public key (toString defaults to a Bitcoin address)
  console.log(key.pub.getAddress().toString());
  // => 14bZ7YWde4KdRb5YN7GYkToz3EHVCvRxkF
});
