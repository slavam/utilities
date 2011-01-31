// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function updateTotalCost(value, price) {
  var element = $("#@human.code_erc");
  value = parseInt(value);
  isNaN(value) ? element.html("") : element.html("$" + value*price);
}

function update_sum8(tarif){
  var val1 = $("val1_8");
  var val2 = $("val2_8");
  var val3 = $("val3_8");
  var sum = $("sum_8");
  if (isNaN(val1) || isNaN(val2) || isNaN(val3)) {
  	sum.value = 0
  }
  else {
  	sum.value = parseFloat((val1.value + val2.value + val3.value) * tarif)
  }
}
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