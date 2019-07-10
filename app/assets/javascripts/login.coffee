# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(window).load ->
  console.log("window load complete")
  web3 = new Web3(Web3.givenProvider || 'ws://localhost:8546', null, {});
  console.log(web3)
