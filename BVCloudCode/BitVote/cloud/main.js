// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

var Buffer = Parse.Object.extend("Buffer");


function broadcastTransaction (signedTransactionBuffer, done) {
  console.log('Signed Transaction in Hex: ' + signedTransactionBuffer);
  console.log('Signed Transaction in Hex: ' + hexify(signedTransactionBuffer));
  Parse.Cloud.httpRequest({
              method: 'POST',
              url: 'https://api.coinprism.com/v1/sendrawtransaction',
              headers: {
                'Content-Type': 'application/json;charset=utf-8'
              },
              body: hexify(signedTransactionBuffer),
              success: function(httpResponse) {
                console.log(httpResponse.text);
                done(httpResponse);
              },
              error: function(httpResponse) {
                var message = 'Signing request failed with response code ' + httpResponse.status + '  \n' + httpResponse.text;
                console.error('Error while attempting to broadcast transaction: ' + message);

              }
            });
}

function signTransaction (unsignedTransaction, done) {

    console.log('Unsigned trasaction: ' +unsignedTransaction.text);
    var buffer = new Buffer(unsignedTransaction.text);
    console.log('Buffer ' + buffer);
    var transactionHex = buffer.toString('hex');
    console.log('Unsigned trasaction in hex: ' + transactionHex);


  Parse.Cloud.httpRequest({
              method: 'POST',
              url: 'https://api.coinprism.com/v1/signtransaction',
              headers: {
                'Content-Type': 'application/json;charset=utf-8'
              },
              body: {
                          transaction: transactionHex,
                          keys: ["4b78746d47516662594157347151364b663743574c614745625935383373466d55337256435435686d6e7a4232794d6a4c4d4776"]
                        },
              success: function(httpResponse) {
                console.log(httpResponse.text);
                broadcastTransaction(signedTransaction['text'], function (signedHttpResponse) {
                    status.success('Output Hash ' + httpResponse.text);
                    done(httpResponse);
                });
              },
              error: function(httpResponse) {
                var message = 'Broadcasting request failed with response code ' + httpResponse.status + '  \n' + httpResponse.text;
                console.error(message);

              }
            });
}


Parse.Cloud.job("StartElection", function(request, status) {
    var Voter = Parse.Object.extend("User");
    var queryVoters = new Parse.Query(Voter);
    queryVoters.each(function (voter)
        {
          var voterAddress = voter.get('assetAddress');

          Parse.Cloud.httpRequest({
              method: 'POST',
              url: 'https://api.coinprism.com/v1/sendasset?format=json',
              headers: {
                'Content-Type': 'application/json;charset=utf-8'
              },
              body: {
                          fees: 1000,
                          from: "akUUGLmKpMWfc3udbJoUrbNX4TbpsLruEcn",
                          to:
                          [
                              {
                                  address: voterAddress,
                                  amount: "1",
                                  asset_id: "AemejeTG4LwuaCDu4HgYPp3zGBbkMjrvPA"
                              }
                          ]
                      },
              success: function(httpResponse) {
                console.log(httpResponse.text);

                signTransaction(httpResponse, function (signedHttpResponse) {
                    status.success('Signed Transaction ' + httpResponse.text);
                });



              },
              error: function(httpResponse) {
                var message = 'Request failed with response code ' + httpResponse.status + '  \n' + httpResponse.text;
                console.error(message);
                status.error(message);

              }
            });
    });
});



