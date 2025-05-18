// (C) Wolfgang Huber 2010-2011

// Script parameters - these are set up by R in the function 'writeReport' when copying the 
//   template for this script from arrayQualityMetrics/inst/scripts into the report.

var highlightInitial = [ false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false ];
var arrayMetadata    = [ [ "1", "94189", "94189", "57", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "2", "DU18-02S0011619", "DU18-02S0011619", "60", "Male", "White", "COVID-19", "early", "No", "1" ], [ "3", "DU18-02S0011623", "DU18-02S0011623", "33", "Male", "White", "COVID-19", "early", "No", "2" ], [ "4", "DU18-02S0011627", "DU18-02S0011627", "28", "Male", "White", "COVID-19", "early", "No", "1" ], [ "5", "DU18-02S0011628", "DU18-02S0011628", "27", "Female", "White", "COVID-19", "early", "No", "1" ], [ "6", "DU18-02S0011629", "DU18-02S0011629", "31", "Female", "White", "COVID-19", "early", "No", "1" ], [ "7", "DU18-02S0011630", "DU18-02S0011630", "30", "Male", "White", "COVID-19", "early", "No", "1" ], [ "8", "DU18-02S0011632", "DU18-02S0011632", "32", "Male", "White", "COVID-19", "middle", "No", "1" ], [ "9", "DU18-02S0011677", "DU18-02S0011677", "30", "Female", "Asian", "COVID-19", "middle", "No", "1" ], [ "10", "DU18-02S0011678", "DU18-02S0011678", "28", "Female", "White", "COVID-19", "middle", "No", "1" ], [ "11", "DU18-02S0011679", "DU18-02S0011679", "32", "Female", "Black/African American", "COVID-19", "middle", "No", "1" ], [ "12", "DU18-02S0011680", "DU18-02S0011680", "31", "Female", "White", "COVID-19", "middle", "No", "1" ], [ "13", "DU18-02S0011634", "DU18-02S0011634", "28", "Female", "White", "COVID-19", "middle", "No", "2" ], [ "14", "DU18-02S0011635", "DU18-02S0011635", "29", "Female", "White", "COVID-19", "middle", "No", "1" ], [ "15", "DU18-02S0011636", "DU18-02S0011636", "28", "Male", "White", "COVID-19", "middle", "No", "2" ], [ "16", "DU18-02S0011637", "DU18-02S0011637", "26", "Female", "Asian", "COVID-19", "middle", "No", "2" ], [ "17", "DU18-02S0011638", "DU18-02S0011638", "50", "Male", "White", "COVID-19", "middle", "No", "1" ], [ "18", "DU18-02S0011639", "DU18-02S0011639", "33", "Male", "White", "COVID-19", "middle", "No", "2" ], [ "19", "DU18-02S0011640", "DU18-02S0011640", "29", "Male", "Asian", "COVID-19", "middle", "No", "2" ], [ "20", "DU18-02S0011641", "DU18-02S0011641", "29", "Female", "White", "COVID-19", "early", "No", "1" ], [ "21", "DU18-02S0011642", "DU18-02S0011642", "29", "Male", "White", "COVID-19", "middle", "No", "1" ], [ "22", "DU18-02S0011643", "DU18-02S0011643", "46", "Male", "White", "COVID-19", "middle", "No", "1" ], [ "23", "DU18-02S0011644", "DU18-02S0011644", "56", "Female", "Asian", "COVID-19", "middle", "No", "1" ], [ "24", "DU18-02S0011645", "DU18-02S0011645", "54", "Female", "White", "COVID-19", "late", "No", "1" ], [ "25", "DU18-02S0011646", "DU18-02S0011646", "51", "Male", "White", "COVID-19", "middle", "No", "1" ], [ "26", "DU18-02S0011647", "DU18-02S0011647", "50", "Female", "White", "COVID-19", "middle", "No", "1" ], [ "27", "DU18-02S0011661", "DU18-02S0011661", "20", "Male", "White", "COVID-19", "early", "No", "1" ], [ "28", "DU18-02S0011648", "DU18-02S0011648", "61", "Male", "Native Hawaiian/Pacific Islander", "COVID-19", "middle", "No", "1" ], [ "29", "DU18-02S0011649", "DU18-02S0011649", "63", "Female", "White", "COVID-19", "middle", "No", "2" ], [ "30", "DU18-02S0011650", "DU18-02S0011650", "52", "Female", "White", "COVID-19", "late", "No", "2" ], [ "31", "DU18-02S0011651", "DU18-02S0011651", "59", "Male", "Black/African American", "COVID-19", "middle", "Yes", "1" ], [ "32", "DU18-02S0011652", "DU18-02S0011652", "60", "Male", "Black/African American", "COVID-19", "middle", "Yes", "2" ], [ "33", "DU18-02S0011653", "DU18-02S0011653", "29", "Male", "Asian", "COVID-19", "late", "No", "1" ], [ "34", "DU18-02S0011667", "DU18-02S0011667", "62", "Female", "White", "COVID-19", "late", "No", "1" ], [ "35", "DU18-02S0011618", "DU18-02S0011618", "71", "Male", "Unknown/Not reported", "COVID-19", "early", "No", "1" ], [ "36", "DU18-02S0011664", "DU18-02S0011664", "43", "Female", "White", "COVID-19", "late", "No", "2" ], [ "37", "DU18-02S0011613", "DU18-02S0011613", "35", "Female", "Asian", "COVID-19", "early", "No", "1" ], [ "38", "DU18-02S0011668", "DU18-02S0011668", "31", "Female", "Black/African American", "COVID-19", "middle", "Yes", "1" ], [ "39", "DU18-02S0011670", "DU18-02S0011670", "67", "Male", "Black/African American", "COVID-19", "middle", "Yes", "1" ], [ "40", "DU18-02S0011612", "DU18-02S0011612", "64", "Male", "White", "COVID-19", "middle", "Yes", "1" ], [ "41", "DU18-02S0011676", "DU18-02S0011676", "70", "Male", "Black/African American", "COVID-19", "early", "Yes", "1" ], [ "42", "97389", "97389", "69", "Male", "Unknown/Not reported", "Bacterial", "NA", "NA", "1" ], [ "43", "94478", "94478", "68", "Female", "Black/African American", "Bacterial", "NA", "NA", "2" ], [ "44", "95967", "95967", "38", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "45", "95968", "95968", "76", "Male", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "46", "95969", "95969", "55", "Male", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "47", "97394", "97394", "87", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "48", "97395", "97395", "84", "Male", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "49", "95970", "95970", "79", "Male", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "50", "95971", "95971", "33", "Female", "Black/African American", "Bacterial", "NA", "NA", "2" ], [ "51", "DU09-03S19475", "DU09-03S19475", "39", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "52", "95981", "95981", "53", "Male", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "53", "95982", "95982", "35", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "54", "97406", "97406", "85", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "55", "95986", "95986", "74", "Female", "White", "Bacterial", "NA", "NA", "1" ], [ "56", "95996", "95996", "60", "Female", "White", "Bacterial", "NA", "NA", "1" ], [ "57", "95997", "95997", "52", "Female", "Black/African American", "Bacterial", "NA", "NA", "1" ], [ "58", "DU18-02S0011654", "DU18-02S0011654", "33", "Male", "White", "COVID-19", "early", "Yes", "1" ], [ "59", "DU18-02S0011631", "DU18-02S0011631", "88", "Female", "Black/African American", "COVID-19", "middle", "Yes", "2" ], [ "60", "DU18-02S0011633", "DU18-02S0011633", "69", "Female", "Black/African American", "COVID-19", "early", "Yes", "2" ], [ "61", "DU09-02S0000101", "DU09-02S0000101", "19", "Female", "Asian", "healthy", "NA", "NA", "1" ], [ "62", "DU09-02S0000103", "DU09-02S0000103", "18", "Male", "White", "healthy", "NA", "NA", "1" ], [ "63", "DU09-02S0000113", "DU09-02S0000113", "19", "Male", "White", "healthy", "NA", "NA", "1" ], [ "64", "DU09-02S0000114", "DU09-02S0000114", "18", "Female", "White", "healthy", "NA", "NA", "1" ], [ "65", "DU09-02S0000158", "DU09-02S0000158", "20", "Male", "Asian", "healthy", "NA", "NA", "1" ], [ "66", "DU09-02S0000115", "DU09-02S0000115", "18", "Female", "White", "healthy", "NA", "NA", "1" ], [ "67", "DU09-02S0000120", "DU09-02S0000120", "18", "Male", "Other/More than one race", "healthy", "NA", "NA", "1" ], [ "68", "DU09-02S0000157", "DU09-02S0000157", "19", "Male", "Asian", "healthy", "NA", "NA", "1" ], [ "69", "DU09-02S0000111", "DU09-02S0000111", "18", "Male", "White", "healthy", "NA", "NA", "1" ], [ "70", "DU09-02S0000154", "DU09-02S0000154", "18", "Female", "Asian", "healthy", "NA", "NA", "1" ], [ "71", "DU09-02S0000150", "DU09-02S0000150", "18", "Female", "White", "healthy", "NA", "NA", "1" ], [ "72", "DU09-02S0000155", "DU09-02S0000155", "19", "Male", "White", "healthy", "NA", "NA", "1" ], [ "73", "DU09-02S0000149", "DU09-02S0000149", "18", "Female", "Asian", "healthy", "NA", "NA", "1" ], [ "74", "DU09-02S0000156", "DU09-02S0000156", "18", "Female", "White", "healthy", "NA", "NA", "2" ], [ "75", "DU09-02S0000153", "DU09-02S0000153", "18", "Male", "White", "healthy", "NA", "NA", "1" ] ];
var svgObjectNames   = [ "pca", "dens" ];

var cssText = ["stroke-width:1; stroke-opacity:0.4",
               "stroke-width:3; stroke-opacity:1" ];

// Global variables - these are set up below by 'reportinit'
var tables;             // array of all the associated ('tooltips') tables on the page
var checkboxes;         // the checkboxes
var ssrules;


function reportinit() 
{
 
    var a, i, status;

    /*--------find checkboxes and set them to start values------*/
    checkboxes = document.getElementsByName("ReportObjectCheckBoxes");
    if(checkboxes.length != highlightInitial.length)
	throw new Error("checkboxes.length=" + checkboxes.length + "  !=  "
                        + " highlightInitial.length="+ highlightInitial.length);
    
    /*--------find associated tables and cache their locations------*/
    tables = new Array(svgObjectNames.length);
    for(i=0; i<tables.length; i++) 
    {
        tables[i] = safeGetElementById("Tab:"+svgObjectNames[i]);
    }

    /*------- style sheet rules ---------*/
    var ss = document.styleSheets[0];
    ssrules = ss.cssRules ? ss.cssRules : ss.rules; 

    /*------- checkboxes[a] is (expected to be) of class HTMLInputElement ---*/
    for(a=0; a<checkboxes.length; a++)
    {
	checkboxes[a].checked = highlightInitial[a];
        status = checkboxes[a].checked; 
        setReportObj(a+1, status, false);
    }

}


function safeGetElementById(id)
{
    res = document.getElementById(id);
    if(res == null)
        throw new Error("Id '"+ id + "' not found.");
    return(res)
}

/*------------------------------------------------------------
   Highlighting of Report Objects 
 ---------------------------------------------------------------*/
function setReportObj(reportObjId, status, doTable)
{
    var i, j, plotObjIds, selector;

    if(doTable) {
	for(i=0; i<svgObjectNames.length; i++) {
	    showTipTable(i, reportObjId);
	} 
    }

    /* This works in Chrome 10, ssrules will be null; we use getElementsByClassName and loop over them */
    if(ssrules == null) {
	elements = document.getElementsByClassName("aqm" + reportObjId); 
	for(i=0; i<elements.length; i++) {
	    elements[i].style.cssText = cssText[0+status];
	}
    } else {
    /* This works in Firefox 4 */
    for(i=0; i<ssrules.length; i++) {
        if (ssrules[i].selectorText == (".aqm" + reportObjId)) {
		ssrules[i].style.cssText = cssText[0+status];
		break;
	    }
	}
    }

}

/*------------------------------------------------------------
   Display of the Metadata Table
  ------------------------------------------------------------*/
function showTipTable(tableIndex, reportObjId)
{
    var rows = tables[tableIndex].rows;
    var a = reportObjId - 1;

    if(rows.length != arrayMetadata[a].length)
	throw new Error("rows.length=" + rows.length+"  !=  arrayMetadata[array].length=" + arrayMetadata[a].length);

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = arrayMetadata[a][i];
}

function hideTipTable(tableIndex)
{
    var rows = tables[tableIndex].rows;

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = "";
}


/*------------------------------------------------------------
  From module 'name' (e.g. 'density'), find numeric index in the 
  'svgObjectNames' array.
  ------------------------------------------------------------*/
function getIndexFromName(name) 
{
    var i;
    for(i=0; i<svgObjectNames.length; i++)
        if(svgObjectNames[i] == name)
	    return i;

    throw new Error("Did not find '" + name + "'.");
}


/*------------------------------------------------------------
  SVG plot object callbacks
  ------------------------------------------------------------*/
function plotObjRespond(what, reportObjId, name)
{

    var a, i, status;

    switch(what) {
    case "show":
	i = getIndexFromName(name);
	showTipTable(i, reportObjId);
	break;
    case "hide":
	i = getIndexFromName(name);
	hideTipTable(i);
	break;
    case "click":
        a = reportObjId - 1;
	status = !checkboxes[a].checked;
	checkboxes[a].checked = status;
	setReportObj(reportObjId, status, true);
	break;
    default:
	throw new Error("Invalid 'what': "+what)
    }
}

/*------------------------------------------------------------
  checkboxes 'onchange' event
------------------------------------------------------------*/
function checkboxEvent(reportObjId)
{
    var a = reportObjId - 1;
    var status = checkboxes[a].checked;
    setReportObj(reportObjId, status, true);
}


/*------------------------------------------------------------
  toggle visibility
------------------------------------------------------------*/
function toggle(id){
  var head = safeGetElementById(id + "-h");
  var body = safeGetElementById(id + "-b");
  var hdtxt = head.innerHTML;
  var dsp;
  switch(body.style.display){
    case 'none':
      dsp = 'block';
      hdtxt = '-' + hdtxt.substr(1);
      break;
    case 'block':
      dsp = 'none';
      hdtxt = '+' + hdtxt.substr(1);
      break;
  }  
  body.style.display = dsp;
  head.innerHTML = hdtxt;
}
