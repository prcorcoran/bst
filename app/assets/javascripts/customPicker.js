// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  try {
  //Add a click event to all anchor tags
  // create a element so that HTMLAnchorElement is accessible
  document.createElement('a');
  HTMLElement.prototype.click = function () {
    if (typeof this.onclick == 'function') {
      if (this.onclick({type: 'click'}) && this.href) 
        window.open(this.href, this.target ? this.target : '_self');
    }
    else if (this.href)
      window.open(this.href, this.target ? this.target : '_self');
  };
}
catch (e) {
  //ie is throwing this: alert('click method for HTMLAnchorElement couldn\'t be added')
};


   function CheckNumericKeyInfo($char, $mozChar) {
   alert("got here");
   var char = false;
  if($mozChar != null) {        // Look for a Mozilla-compatible browser
    charx = $mozChar;
    alert( "mozchar = " + charx);
  } else {
    charx = $char;
    alert( "char = " + charx);
  }
  
  if ("x" == "x") { //if (charx == 33 || charx == 34 || charx = 38 || charx == 40) {
    
    $RetVal = true;
  }
   return $RetVal; 
}; 
  _dom = 0;
function notSupported(){ alert('your browser is not supported.'); };
function fromKeyCode(k){ return ''; };

//****************************************************************
//** Begin CustomPicker
//****************************************************************
CustomPicker = function (levels) {
  this.levels = levels;
  this.activeBook = null;
  this.activeChapter = null;
  this.activeVerse = null;
};
/// "static", needed for event handlers.
CustomPicker._C = null;

/// detect a special case of "web browser"
CustomPicker.is_ie = ( /msie/i.test(navigator.userAgent) && !/opera/i.test(navigator.userAgent) );

CustomPicker.is_ie5 = ( CustomPicker.is_ie && /msie 5\.0/i.test(navigator.userAgent) );

/// detect Opera browser
CustomPicker.is_opera = /opera/i.test(navigator.userAgent);

/// detect KHTML-based browsers
CustomPicker.is_khtml = /Konqueror|Safari|KHTML/i.test(navigator.userAgent);

CustomPicker.removeEvent = function(el, evname, func) {
	if (el.detachEvent) { // IE
		el.detachEvent("on" + evname, func);
	} else if (el.removeEventListener) { // Gecko / W3C
		el.removeEventListener(evname, func, true);
	} else {
		el["on" + evname] = null;
	}
};

CustomPicker.createElement = function(type, parent) {
	var el = null;
	if (document.createElementNS) {
		el = document.createElementNS("http://www.w3.org/1999/xhtml", type);
	} else {
		el = document.createElement(type);
	}
	if (typeof parent != "undefined") {
		parent.appendChild(el);
	}
	return el;
};
CustomPicker._add_evs = function(el) {
	with (CustomPicker) {
		addEvent(el, "mouseover", CustomPicker.pickerMouseOver);
		addEvent(el, "mousedown", CustomPicker.pickerMouseDown);
		addEvent(el, "mouseout", CustomPicker.pickerMouseOut);
	}
};
CustomPicker.addEvent = function(el, evname, func) {
	if (el.attachEvent) { // IE
		el.attachEvent("on" + evname, func);
	} else if (el.addEventListener) { // Gecko / W3C
		el.addEventListener(evname, func, true);
	} else {
		el["on" + evname] = func;
	}
};
CustomPicker.stopEvent = function(ev) {
	ev || (ev = window.event);
	if (CustomPicker.is_ie) {
		ev.cancelBubble = true;
		ev.returnValue = false;
	} else {
		ev.preventDefault();
		ev.stopPropagation();
	}
	return false;
};
CustomPicker.addClass = function(el, className) {
 	CustomPicker.removeClass(el, className);
	el.className += " " + className;
 };
CustomPicker.isRelated = function (el, evt) {
	var related = evt.relatedTarget;
	if (!related) {
		var type = evt.type;
		if (type == "mouseover") {
			related = evt.fromElement;
		} else if (type == "mouseout") {
			related = evt.toElement;
		}
	}
	while (related) {
		if (related == el) {
			return true;
		}
		related = related.parentNode;
	}
	return false;
};

CustomPicker.removeClass = function(el, className) {
	if (!(el && el.className)) {
		return;
	}
	var cls = el.className.split(" ");
	var ar = new Array();
	for (var i = cls.length; i > 0;) {
		if (cls[--i] != className) {
			ar[ar.length] = cls[i];
		}
	}
	el.className = ar.join(" ");
};
CustomPicker.removeElement = function(el, parent) {
	if (el) {
  //console.trace();
  //console.log("parent=" + parent + " id=" + parent.id + " parentparent=" + parent.parentNode + " el=" + el);
		parent.removeChild(el);
  }
};

CustomPicker.leftTrim = function(sString) {
  while (sString.substring(0,1) == ' ')
  {
  sString = sString.substring(1, sString.length);
  }
  return sString;
};

CustomPicker.rightTrim = function(sString) {
//console.log("substring=" + (sString.substring(sString.length-1, sString.length) == " ") + "<");
  return sString.replace(/^\W+/,'').replace(/\W+$/,'');
  //while (sString.substring(sString.length-1, sString.length) == ' ')
  //{
  //sString = sString.substring(0,sString.length-1);
  //}
  //return sString;
};

CustomPicker.trimAll = function(sString) {
  while (sString.substring(0,1) == ' ')
  {
  sString = sString.substring(1, sString.length);
  }
  while (sString.substring(sString.length-1, sString.length) == ' ')
  {
  sString = sString.substring(0,sString.length-1);
  }
  return sString;
};


CustomPicker.pickerMouseOver = function(ev) {

	var el = CustomPicker.getElement(ev);
  //console.log("mouseOver=" + el.innerHTML);
	if (el.navtype != 300) {
		CustomPicker.addClass(el, "hilite");
    //el.customPicker.activeBook
	}
	return CustomPicker.stopEvent(ev);
};

CustomPicker.pickerMouseOut = function(ev) {

with (CustomPicker) {
		var el = getElement(ev);
    //console.log("mouseOut=" + el.innerHTML);
    if (el != el.customPicker.activeBook && el != el.customPicker.activeChapter)
      removeClass(el, "hilite");
		return stopEvent(ev);
	}
};

//*********************************************************
//BOOK MOUSE DOWN
//*********************************************************
CustomPicker.pickerMouseDown = function(ev) {
	var el = CustomPicker.getElement(ev);
	if (el.disabled) {
		return false;
	}
	var picker = el.customPicker;  
  //Remove the old Chapter table if present
  if ((document.getElementById("booksTable").chapterDivDiv) || ((picker.activeBook) && (picker.activeBook.textContent == el.textContent))) {
    CustomPicker.removeElement(document.getElementById("booksTable").chapterDivDiv,document.getElementById("chapterDiv"));
    CustomPicker.removeElement(document.getElementById("chapterDiv").verseDivDiv,document.getElementById("verseDiv"));
    document.getElementById("booksTable").chapterDivDiv = null;
    document.getElementById("chapterDiv").verseDivDiv = null;    
  }
 
  if ((picker.activeBook) && (picker.activeBook == el)) {
   // alert (picker.activeBook.textContent + "/" + el.textContent);
    picker.activeBook = null;
    document.getElementById("userVerse").value = "";
    return false;
  }
  CustomPicker.removeClass(el.customPicker.activeBook, "hilite"); 
	picker.activeBook = el;
  document.getElementById("userVerse").value = picker.activeBook.firstChild.nodeValue;
  CustomPicker.addClass(el, "hilite");

//******* NEW TABLE ******************
//parent = document.getElementsByTagName("body")[0];
<!--  var tr = CustomPicker.createElement("tr");-->

//Create a new table
	var table = CustomPicker.createElement("table");
  table.className = "customPicker";
  //console.log(this);
	table.cellSpacing = 2;
  //table.style.borderSpacing = "20px 2px"; //this works
	table.cellPadding = 0;
  //table.border = 1;
	table.customPicker = this;

//Create a new div
	var div = CustomPicker.createElement("div");
	this.element = div;
	div.className = "customPicker";
  div.style.position= "absolute";
  div.classname= "customPicker";
  div.style.display = "block";
  document.getElementById("booksTable").chapterDivDiv = div;
  
//Calculate top/left position for new div ********************************************
 	var y = CustomPicker.findPos(document.getElementById("booksDiv"))[1];
 	var x = CustomPicker.findPos(el)[0];
  var tmpMarginTop = 0;
  //In the end I didn't need any of this stuff but wanted to keep it around for reference
  //if(el.currentStyle) {
  //  tmpMarginTop = document.getElementById("booksDiv").currentStyle["marginTop"];
  //  var fz = parseInt(el.currentStyle["fontSize"].split('pt')[0]);
  //  tmpMarginTop = parseInt(1.3333*fz);
  //  alert("fz=" + fz);
  //} else {
  //  tmpMarginTop = document.defaultView.getComputedStyle(document.getElementById("booksDiv"), null).getPropertyValue("margin-top");
  //  tmpMarginTop = tmpMarginTop.split('px');
  //  tmpMarginTop = tmpMarginTop[0];
  //}
  div.style.left= x + 'px';
  var extra = parseInt(el.parentNode.parentNode.parentNode.cellSpacing)
  div.style.top= parseInt(y)  + parseInt(CustomPicker.getComputedHeight(document.getElementById("booksTable"))) + (CustomPicker.is_ie ? -1 : 1)  + 'px';

//Append the table to the div  
 	div.appendChild(table);

//Append the div to the ChapterDiv
  document.getElementById("chapterDiv").appendChild(div);

//Create the tbody
	var tbody = CustomPicker.createElement("tbody", table);

  this.tbody = tbody;
  //console.log(el.textContent);
	var nbrOfChapters = bookChapters[el.firstChild.nodeValue];
	row = CustomPicker.createElement("tr", tbody);
  //Create the cells  
  var i = 1;
	for (i = 1; i <= nbrOfChapters; i++) {
      if (i%10 == 1 && i != 1) {
    	row = CustomPicker.createElement("tr", tbody);
    }
		cell = CustomPicker.createElement("td", row);
    if (i < 10) {
      cell.innerHTML = i + "&nbsp;&nbsp";
    }
    else {
       cell.innerHTML = i + "&nbsp;";    
    }
		cell.customPicker = picker;
    cell.appType = "chapter";
    with (CustomPicker) {
      addEvent(cell, "mouseover", pickerMouseOver);
      addEvent(cell, "mousedown", chapterMouseDown);
      addEvent(cell, "mouseout", pickerMouseOut);
    }
	}

//***********************
  return CustomPicker.stopEvent(ev);
};

//VERSE MOUSE DOWN
CustomPicker.verseMouseDown = function(ev) {
	var el = CustomPicker.getElement(ev);
	if (el.disabled) {
		return false;
	}
  var coors = CustomPicker.findPos(el); 
  //console.log("verse coords=" + coors);
	var picker = el.customPicker;
	picker.activeVerse = el;
  
  var chapter = CustomPicker.rightTrim(el.firstChild.nodeValue);
  document.getElementById("userVerse").value = picker.activeBook.firstChild.nodeValue + " " + CustomPicker.rightTrim(picker.activeChapter.firstChild.nodeValue) + "." + el.firstChild.nodeValue;

  if (document.getElementById("booksTable").chapterDivDiv) {
    CustomPicker.removeElement(document.getElementById("booksTable").chapterDivDiv,document.getElementById("chapterDiv"));
    CustomPicker.removeElement(document.getElementById("chapterDiv").verseDivDiv,document.getElementById("verseDiv"));
    document.getElementById("booksTable").chapterDivDiv = null;
    document.getElementById("chapterDiv").verseDivDiv = null;    
  }
  $("#bstForm").submit();
};

//CHAPTER MOUSE DOWN
CustomPicker.chapterMouseDown = function(ev) {
	var el = CustomPicker.getElement(ev);
	if (el.disabled) {
		return false;
	}
  
  CustomPicker.removeClass(el.customPicker.activeChapter, "hilite");
  
  var picker = el.customPicker;
	picker.activeChapter = el;
  CustomPicker.addClass(el, "hilite");


//Remove the old Chapter table if present
  if (document.getElementById("chapterDiv").verseDivDiv) {
    CustomPicker.removeElement(document.getElementById("chapterDiv").verseDivDiv,document.getElementById("verseDiv"));
  }

//Create a new table
	var table = CustomPicker.createElement("table");
  table.className = "customPicker";
 	table.cellSpacing = 2;
  //console.log(this);
	table.cellPadding = 0;
  //table.border = 1;
	table.customPicker = this;

//Create a new div
	var div = CustomPicker.createElement("div");
	this.element = div;
	div.className = "customPicker";
  div.style.position= "absolute";
  div.classname= "customPicker";
  div.style.display = "block";
  document.getElementById("chapterDiv").verseDivDiv = div;
  
//Calculate top/left position for new div
 	var y = CustomPicker.findPos(el.parentNode.parentNode.parentNode)[1];
 	var x = CustomPicker.findPos(el)[0];
  div.style.left= x + 'px';
  div.style.top= parseInt(y) + parseInt(CustomPicker.getComputedHeight(el.parentNode.parentNode.parentNode)) + (CustomPicker.is_ie ? -1 : 1)  + 'px';
 
//Append the table to the div  
 	div.appendChild(table);

//Append the div to the ChapterDiv
  document.getElementById("verseDiv").appendChild(div);

//Create the tbody
	var tbody = CustomPicker.createElement("tbody", table);
	this.tbody = tbody;
  
  var chapter = CustomPicker.rightTrim(el.firstChild.nodeValue);
  document.getElementById("userVerse").value = picker.activeBook.firstChild.nodeValue + " " + CustomPicker.rightTrim(picker.activeChapter.firstChild.nodeValue);
	var nbrOfVerses = chapterVerses[picker.activeBook.firstChild.nodeValue + chapter];
 
  row = CustomPicker.createElement("tr", tbody);
  
//Create the cells  
	for (i = 1; i <= nbrOfVerses; i++) {
    if (i%10 == 1 && i != 1) {
    	row = CustomPicker.createElement("tr", tbody);
    }
		cell = CustomPicker.createElement("td", row);
    if (i < 10) {
      //cell.innerHTML = "&nbsp;&nbsp;" + i;
       cell.innerHTML = i + "&nbsp;&nbsp";
    }
    else {
       cell.innerHTML = i + "&nbsp;";    
    }
		cell.customPicker = picker;
    cell.appType = "verse";
    with (CustomPicker) {
      addEvent(cell, "mouseover", pickerMouseOver);
      addEvent(cell, "mousedown", verseMouseDown);
      addEvent(cell, "mouseout", pickerMouseOut);
    }
    

	}

  return CustomPicker.stopEvent(ev);
};

CustomPicker.findPos = function(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		curleft = obj.offsetLeft
		curtop = obj.offsetTop
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
	}
	return [curleft,curtop];
};
CustomPicker.getComputedHeight = function(theElt) {
        if(CustomPicker.is_ie){
                tmphght = theElt.offsetHeight;
        }
        else{
                docObj = theElt;
                var tmphght1 = document.defaultView.getComputedStyle(docObj, '').getPropertyValue("height");
                tmphght = tmphght1.split('px');
                tmphght = tmphght[0];
        }
        //alert(tmphght);
        return tmphght;

};

CustomPicker.getElement = function(ev) {
	var f = CustomPicker.is_ie ? window.event.srcElement : ev.currentTarget;
	while (f.nodeType != 1 || /^div$/i.test(f.tagName))
		f = f.parentNode;
	return f;
};
//****************************************************************
//** End CustomPicker
//****************************************************************
