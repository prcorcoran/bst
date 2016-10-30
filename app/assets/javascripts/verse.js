
//Set both the Find and Search group boxes to the same height
originalHeight = 0;
function setHeight() { 
  //alert(originalHeight);
  var height = document.getElementById('headerDiv').offsetHeight;
  //Save the original height
  if (originalHeight == 0) {
    originalHeight = height;
  }
  
  var hFind = document.getElementById('findFormDiv').offsetHeight;
  var hAdvancedSearch = document.getElementById('advancedSearchFormDiv').offsetHeight;  
  var hSearch = document.getElementById('searchFormDiv').offsetHeight;  
  //alert("header=" + height + '-' + "hFind=" + hFind+ " - " + "hSearch=" + hSearch+ " - " + "hAdvancedSearch=" + hAdvancedSearch);
  var a = document.getElementById('findFieldset');
  var margins;
  // Mozilla: getComputedStyle
   if (window.getComputedStyle) {
     var paddingTop = document.defaultView.getComputedStyle(document.getElementById('findFieldset'),'').getPropertyValue('padding-top');
     var paddingBottom = document.defaultView.getComputedStyle(document.getElementById('findFieldset'),'').getPropertyValue('padding-bottom');
     var borderBottomWidth = document.defaultView.getComputedStyle(document.getElementById('findFieldset'),'').getPropertyValue('border-bottom-width');
     var borderTopWidth = document.defaultView.getComputedStyle(document.getElementById('findFieldset'),'').getPropertyValue('border-top-width');
     var margins = 0;
     margins += Math.round(parseFloat(paddingTop));
     margins += Math.round(parseFloat(paddingBottom));
     margins += Math.round(parseFloat(borderBottomWidth));
     margins += Math.round(parseFloat(borderTopWidth)); 
     margins += 0;
   // IE: currentStyle
   } else if (a.currentStyle) {
    //document.recalc(true);
   	var elm = document.getElementById('headerDiv');
    elm.style.height = 'auto';
    var height = elm.offsetHeight; 
    margins = 0;
    margins += Math.round(parseFloat(eval('a.currentStyle.paddingBottom')));
    margins += Math.round(parseFloat(eval('a.currentStyle.paddingTop')));
    margins += Math.round(parseFloat(eval('a.currentStyle.borderBottomWidth')));
    margins += Math.round(parseFloat(eval('a.currentStyle.borderTopWidth')));    
    margins -= 2;    
   } 
   
  if (hSearch == 0) {
    searchHeight = hAdvancedSearch;
  } else {
    searchHeight = hSearch;  
  }

  //Don't allow the Find div to be set below the original height
  if (searchHeight > originalHeight) {
  //alert(searchHeight +'>'+ originalHeight);
    document.getElementById("findFieldset").style.height = searchHeight - margins + 'px';  
  } else {
      if (document.getElementById('advancedSearchFormDiv').className == "invisible") {
        document.getElementById('searchFieldset').style.height = hFind - margins + 'px';
      } else {
      //alert (document.getElementById('advancedSearchFieldset').offsetHeight );
        document.getElementById('advancedSearchFieldset').style.height = hFind - margins + 'px';    
      }
  }

//document.getElementById("findFieldset").style.height = height - margins + 'px';  
//  if (document.getElementById('advancedSearchFormDiv').className == "invisible") {
//    document.getElementById('searchFieldset').style.height = height - margins + 'px';
//  } else {
  //alert (document.getElementById('advancedSearchFieldset').offsetHeight );
//    document.getElementById('advancedSearchFieldset').style.height = height - margins + 'px';    
//  }

}

function hideShowSearchResults() {
  //new Ajax.Request('/verse/clearSearchResults', {asynchronous:true, evalScripts:true});
  //location.href="/verse/clearSearchResults";
  if (document.getElementById("searchResultsTable") == null) {
    document.getElementById("clearSearchResults").className="invisible";
    document.getElementById("hideShowSearchResults").className="invisible";
    document.getElementById("searchResultsMessage").className="invisible";    
    return;
  }
  var elTextNode = document.getElementById("hideShowSearchResults").firstChild;
  if (elTextNode.nodeValue == 'Hide Results') {
    elTextNode.nodeValue = 'Show Results'
    document.getElementById("searchResultsTable").className="invisible";
  } else {
    elTextNode.nodeValue = 'Hide Results'  
    document.getElementById("searchResultsTable").className="none";    
  }
  return false;
}

//The strongs number cell was clicked in the main table. Here we want to set the selected strongs number into the Search form for the user.
function editCell (cell) {
  if (document.getElementById("advancedSearchFormDiv").className != "invisible") {
    //searchWords = document.getElementsByName("strong_number_id")
    for (i=1; i < 30; i++) {
      if (document.getElementById("searchWord" + i) != null && document.getElementById("searchWord" + i).value == "") {
          setGrammarOptions (cell, i);
          break;
      }
    }
  } else {
     document.getElementById("searchWord").value += cell.firstChild.innerHTML + " ";
  }
 }
 //Set the grammar Search form options based on the clicked cell in the main table.
 function setGrammarOptions (cell, position) {
     document.getElementById("searchWord" + position).value += cell.firstChild.innerHTML;
    next = cell.nextSibling;
    next = next.nextSibling;
    options = document.getElementById("tenseGender" + position).options;
    for (var i = 0; i < options.length; i++) {
      if (options[i].text == next.innerHTML) {document.getElementById("tenseGender" + position).selectedIndex = options[i].value};    
    }
    next = next.nextSibling;
    options = document.getElementById("voiceCase" + position).options;
    for (var i = 0; i < options.length; i++) {
      if (options[i].text == next.innerHTML) {document.getElementById("voiceCase" + position).selectedIndex = options[i].value};    
    }
    next = next.nextSibling;
    options = document.getElementById("mode" + position).options;
    for (var i = 0; i < options.length; i++) {
      if (options[i].text == next.innerHTML) {document.getElementById("mode" + position).selectedIndex = options[i].value};    
    }
    next = next.nextSibling;
    options = document.getElementById("numberPerson" + position).options;
    for (var i = 0; i < options.length; i++) {
      if (options[i].text == next.innerHTML) {document.getElementById("numberPerson" + position).selectedIndex = options[i].value};    
    }
    next = next.nextSibling;
    options = document.getElementById("participleCase" + position).options;
    for (var i = 0; i < options.length; i++) {
      if (options[i].text == next.innerHTML) {document.getElementById("participleCase" + position).selectedIndex = options[i].value};    
    }
 }
function printCSSRules() {
//This was taken from the Gecko DOM Reference but doesn't work
  ss = document.styleSheets;
  for(i=0; i<ss.length; i++)
  {
    for(j=0; j<ss[0].cssRules.length; j++)
    {
      dump( ss[i].cssRules[j].style.selectorText + "\n" );
    //  document.write(ss[i].cssRules[j].style.selectorText + "\n"); 
    }
  }
  
}
function init(){
  //Encode the screen resolution and browser type in the className of the body for CSS
  var browser = "mozilla";
  if(CustomPicker.is_ie) {browser = "ie"}
  if(CustomPicker.is_ie5) {browser = "ie5"}
  if(CustomPicker.is_opera) {browser = "opera"}
  if(CustomPicker.is_khtml) {browser = "is_khtml"}    
  var htmlClass = document.getElementsByTagName("html")[0].className += browser;
  var screenRes;
  if ((screen.width > 800) && (screen.height > 600)) {
    screenRes = ' hiScreenRes'
  } else {
    screenRes = ' loScreenRes'  
  }
  var htmlClass = document.body.className += screenRes;  
  
  //Init for main application view only.
  if (document.getElementById("userVerse")) {
    setFocus();
    //Instantiate the verse custom picker and register event handling
    var picker = new CustomPicker(1);
    var row = document.getElementById("booksTable").firstChild.firstChild;
      while (row) {
        var cell = row.firstChild;
        while (cell) {
          cell.customPicker = picker;
          cell.appType = "book";
          CustomPicker._add_evs(cell);
          cell = cell.nextSibling;
        }
      row = row.nextSibling;
    }
    //Set the height of both find and Serach group boxes to the same height.
    setHeight();
  }
  //var sizeBorder = new SizeBorder(document.getElementById("sizeBorder"),document.getElementById("headerDiv"));
  //document.getElementById("headerDiv").style.marginBottom = "-50px";
  //sizeBorder.registerEvents();
};

// decipher key press codes
function showDown(evt) {
    evt = (evt) ? evt : ((event) ? event : null);
    if (evt) {
        var text = "";
        //alert(evt.keyCode)
        var K = evt.keyCode;
        var shiftKey = evt.shiftKey? true : false;
        var ctrlKey = evt.ctrlKey? true : false;
        var altKey = evt.altKey? true : false;
        switch (K) {
        case 33: // KEY PageUp
            $("#prevChapterCell").click();
            break;
        case 34: // KEY PageDown
            $("#nextChapterCell").click();
            break;
        case 35: // KEY End        
            $("#nextBookCell").click();
            break;
        case 36: // KEY Home   
            $("#prevBookCell").click();
            break;
        case 38: // KEY Up arrow
            $("#prevVerseCell").click();
            break;
        case 40: // KEY Down arrow        
            $("#nextVerseCell").click();
            break;
        //case 123: //KEY F12
        //    if (shiftKey) {
        //       printCSSRules();
        //    }
        //    return false;
        case 115: // KEY F4        
            if (shiftKey) {
              var request = new Ajax.Request('/verse/key_F4_pressed/prev', {asynchronous:true, evalScripts:true});
              //document.location.href='/verse/keyF4Pressed/prev'
              //request.transport.abort();
              if (document.all && window.event && !event.preventDefault) {
                event.cancelBubble = true;
                event.returnValue = false;
                event.keyCode = 0;
              }
              return false;
            } else {
              hideShowSearchResults ();
             //new Ajax.Request('/verse/keyF4Pressed/next', {asynchronous:true, evalScripts:true});
             // request.transport.abort();
              if (document.all && window.event && !event.preventDefault) {
                event.cancelBubble = true;
                event.returnValue = false;
                event.keyCode = 0;
              }
              return false;
            }
            break;
        case 116: // KEY F5        
            if (shiftKey) {
              new Ajax.Request('/verse/key_F5_pressed/prev', {asynchronous:true, evalScripts:true});
              if (document.all && window.event && !event.preventDefault) {
                event.cancelBubble = true;
                event.returnValue = false;
                event.keyCode = 0;
              }
              return false;
            } else {
              new Ajax.Request('/verse/key_F5_pressed/next', {asynchronous:true, evalScripts:true});
              if (document.all && window.event && !event.preventDefault) {
                event.cancelBubble = true;
                event.returnValue = false;
                event.keyCode = 0;
              }
              return false;
            }
            break;
         default: return true;
      }
      return false;
    }
    return false;
};

  var formInUse = false;
  function setFocus()  {
    if(!formInUse) {
      document.getElementById("userVerse").focus();
    }
  };

