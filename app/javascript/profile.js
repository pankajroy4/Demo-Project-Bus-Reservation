$(document).ready(function () {
    alert("Hello")
    $(".datepicker").datepicker({ 
          autoclose: true, 
          todayHighlight: true
    }).datepicker('update', new Date());
  });
  
  