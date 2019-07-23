$(()=>{
  if(typeof web3 !== 'undefined') {
    web3.eth.getAccounts((error, accounts)=>{
      if(error){
        console.log("getAccountsでエラー発生");
        return;
      }

      var wallet_address = accounts[0];
      if(typeof wallet_address !== 'undefined') {
          $("#top-title").html("きたぜ、ぬるりと・・・");
          $('.user-profile').css("display", "block");
          $("#button-metamask-login").css("display", "none");
      } else {
        $('#button-metamask-login').delay(900).css('display', 'inline-block');
      }
    });
  } else {
    alert("metamaskインストールして！");
  }
});

$(window).load(()=>{
  $('#loader-bg').delay(900).fadeOut(800);
});
