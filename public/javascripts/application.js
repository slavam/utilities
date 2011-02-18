// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function updateTotalCost(value, price) {
  var element = $("#@human.code_erc");
  value = parseInt(value);
  isNaN(value) ? element.html("") : element.html("$" + value*price);
}

$(document).ready(function(){
function update_sum8(tarif){
	alert("HHHHHHHHHHHHH");
  var val1 = $("vol1");
  var val2 = $("vol2");
  var val3 = $("vol3");
  var sum = $("debt__sum_month");
  
  if (isNaN(val1) || isNaN(val2) || isNaN(val3)) {
  	sum.value = 0
  }
  else {
  	sum.value = parseFloat((val1.value + val2.value + val3.value) * tarif)
  }
};
});

function my_method_8() {
  var val = $("val1_8");
  var new_v = $("now1_8");
  var old_v = $("old1_8");
  new_v = parseFloat(new_v.value);
  old_v = parseFloat(old_v.value);
//  alert(c1_old);
  if (isNaN(new_v) || isNaN(old_v)) {
  	val.value = 0;
  }
  else {
  	if (new_v < old_v) {
  		val.value = 0;
  		alert('Новые показания должны быть больше предыдущих');
  	}
  	else {
  		val.value = new_v - old_v
  	}
  }
  
  val = $("val2_8");
  new_v = $("now2_8");
  old_v = $("old2_8");
  new_v = parseFloat(new_v.value);
  old_v = parseFloat(old_v.value);
  
  if (isNaN(new_v) || isNaN(old_v)) {
  	val.value = 0;
  }
  else {
  	if (new_v < old_v) {
  		val.value = 0;
  		alert('Новые показания должны быть больше предыдущих');
  	}
  	else {
  		val.value = new_v - old_v
  	}
  }
  val = $("val3_8");
  new_v = $("now3_8");
  old_v = $("old3_8");
  new_v = parseFloat(new_v.value);
  old_v = parseFloat(old_v.value);
  
  if (isNaN(new_v) || isNaN(old_v)) {
  	val.value = 0;
  }
  else {
  	if (new_v < old_v) {
  		val.value = 0;
  		alert('Новые показания должны быть больше предыдущих');
  	}
  	else {
  		val.value = new_v - old_v
  	}
  }
  
//   ? element.value("") : element.value = value-c1_old;
//  sum.value = parseFloat(val1.value*tarif);
//  tarif.value = parseFloat(val.value*tarif);
//  element.value=value-c1_old;
//  sum.value = (value-c1_old)*5;
//  isNaN(value) ? element.html("") : element.html("$"+value);
//alert('my_method called '+sum.value);
}
function my_method_20(c1_new, c1_old, tarif) {
  var val = $("val1_20");
  var sum = $("sum1_20");
  c1_new = parseFloat(c1_new);
  c1_old = parseFloat(c1_old);
  if (c1_new < c1_old) {
  	alert('Новые показания не должны быть меньше предыдущих');
  }
  if (isNaN(c1_new)|| isNaN(c1_old) ) {
    val.value = 0;
	}
  else 
    {val.value = c1_new - c1_old}
  sum.value = parseFloat(val.value*tarif);
}
function my_method_21(c1_new, c1_old, tarif) {

  var val = $("val1_21");
  var sum = $("sum1_21");
  c1_new = parseFloat(c1_new);
  c1_old = parseFloat(c1_old);
  if (c1_new < c1_old) {
  	alert('Новые показания не должны быть меньше предыдущих');
  }
  if (isNaN(c1_new)|| isNaN(c1_old) ) {
    val.value = 0;
	}
  else 
    {val.value = c1_new - c1_old}
  sum.value = parseFloat(val.value*tarif);
}


$(document).ready(function(){
$("input[type='text']").change(function(){
	
  var my_id = "";
  $(this).next().each(function(){my_id = this.value });
   
  var t = document.getElementById("t_"+my_id);
  var n1=$("#now1_"+my_id+" > #debt__end_count");
  var o1=$("#old1_"+my_id+" > #debt__month_count");
  var d1 = 0;
  var n2=$("#now2_"+my_id+" > #debt__end_count2");
  var o2=$("#old2_"+my_id+" > #debt__month_count2");
  var d2 = 0;
  var n3=$("#now3_"+my_id+" > #debt__end_count3");
  var o3=$("#old3_"+my_id+" > #debt__month_count3");
  var d3 = 0;

  if (isNaN(n1.val())|| isNaN(o1.val()) ) {
    d1.value = 0;  }
  else 
    {d1 = n1.val() - o1.val()}
  if (isNaN(n2.val())|| isNaN(o2.val()) ) {
    d2.value = 0;  }
  else 
    {d2 = n2.val() - o2.val()}
  if (isNaN(n3.val())|| isNaN(o3.val()) ) {
    d3.value = 0;  }
  else 
    {d3 = n3.val() - o3.val()}
  if (n1.val() < o1.val()) {
  	o1.val(n1.val());
	d1 = 0;
  	alert('Новые показания не должны быть меньше предыдущих');
  }
  $("#v1_"+my_id).text(d1);
  if (n2.val() < o2.val()) {
  	o2.val(n2.val());
	d2 = 0;
  	alert('Новые показания не должны быть меньше предыдущих');
  }
  $("#v2_"+my_id).text(d2);
  if (n3.val() < o3.val()) {
  	o3.val(n3.val());
	d3 = 0;
  	alert('Новые показания не должны быть меньше предыдущих');
  }
  $("#v3_"+my_id).text(d3);
  if ((this.id !== 'debt__sum_month') && (t.value > 0)) {
    $("#sum_"+my_id+" > #debt__sum_month").val((d1+d2+d3)*t.value);
  }
});
});

$(document).ready(function(){
$('.update_counters').bind('ajax:success', function() {
//$('.update_counters').html("<%= escape_javascript render(:partial => 'update_3counters', :object=>@debt) %>")
//    $(this).closest('tr').fadeOut();
});
});

$("#now1").change(function() {
  alert("HELLO WORLD!");
});
