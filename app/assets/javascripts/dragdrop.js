$(document).ready(function() {
  jQuery.event.props.push('dataTransfer');
  var dropZone = $("#dropZone");
  var input = $("#thefile")
  dropZone.on("drop",drop);
  dropZone.on("dragover",over);
  dropZone.on("dragleave",leave);
  dropZone.on("click",performClick);
  input.on("change", selected);
  
  function performClick(ev){
    input.trigger("click");
  }
  function over(ev){
    dropZone.addClass('hover');
    return false;
  }
  function leave(ev){
    dropZone.removeClass('hover');
    return false;
  }
  function selected(){
    dropZone.addClass('drop');
    $("#header").html('');
    $("result").html(''); 
    
    var files = input[0].files;
    console.log(input);
    $.each(files,parse);
  }
  function drop(ev){
    ev.preventDefault();
    dropZone.removeClass('hover');
    dropZone.addClass('drop');
    $("#header").html('');
    $("result").html('');
    
    var files = ev.dataTransfer.files;
    $.each(files,parse);
  }
  function parse(index,file){
    console.log(file);
    if (!file.type.match("text.*")){
      $('#result').html("Only TEXT");
      dropZone.removeClass('drop');
      dropZone.addClass('error');
      return false;
    }
    var reader = new FileReader();
    reader.onload = loaded;
    reader.onerror = error;
    reader.onloadstart = start;
    reader.readAsText(file);
  }
  function loaded(ev){
    dropZone.removeClass('drop');
    console.log(ev);
    var result = ev.target.result;
    $("#result").html(result);
    var csv = $.csv.toArrays(result);
    console.log(csv);
    $("#headers").html(csv[0].join(' '));
  }
  function error(ev){
    alert("CAN'T READ");
  }
  function start(ev){
    $("#result").html("Loading");    
  }
});