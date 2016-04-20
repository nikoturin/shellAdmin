#!/bin/bash
###################################################
#Name Process: ctc_DOM.h
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 10/02/2015
#Objective: Check Rejected Status
#this process check every 30 minutes per hours.
#Msg: If you have a better idea let us know please
###################################################

function dom_sendEmail()
{
	local strRDOM="$1";
        local toCSV="$2";

msg="<html>
    	<head>
           <body>
    		<table cellspacing=0 align=center border=0 width='100%'>
		   <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
                           <tr style='position:relative; top:expression(offsetParent.scrollTop);'>
                                <td style='width:1%;FONT-WEIGHT: bolder;font-size: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #FFFFFF;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #DF0101;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>Statistics on credit card payments () in the last 30 minutes shows an unusual number of payments with the Rejected Error</TD>                          
			  </tr>
                   </table>
                   <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
        	      <tr style='position:relative; top:expression(offsetParent.scrollTop);'>
                        <td style='width:1%;FONT-WEIGHT: bolder;font-size: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #FFFFFF;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #DF0101;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>ACCERTIFY REJECTED STATUS</TD>
	             </tr>
	    	  </table>
                 <div style='position:absolute; height:70%; width:100%;'>
                   <table class='header3'  cellspacing=0 align=center border=0 width='100%'>
                        <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
                         <tr style='height:1%'>
                           <tr>
                               <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #ececec;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>TRANSACTION STATUS</TD>
                               <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #ececec;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>TRANSACTION PERCENTAGE(%)</TD>
                               <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #ececec;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>TRANSACTION COUNT</TD>
                           </tr>"
		for str in $(echo "$strRDOM" | tr "|" "\n")
		do
		    msg=${msg}"<tr>";
	 	    rej_statusCode=$(echo "$str" | awk '{print $1}' FS='-')       
                    rej_percent=$(echo "$str" | awk '{print $2}' FS='-')
                    rej_total=$(echo "$str" | awk '{print $3}' FS='-'|awk '{print $1}' FS=':')

		    msg=${msg}"<TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #FFFFFF;TEXT-ALIGN: left;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=left>$rej_statusCode</TD>
		    	       <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #FFFFFF;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>$rej_percent</TD>
 <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #FFFFFF;TEXT-ALIGN: ce
nter;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>$rej_total</TD>"
        	  
		  msg=${msg}"</tr>"
		done

	   msg=${msg}"</tr>
    		      </table>
    		   <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
    	             <tr style='height:1%'>
    		     </tr>
    		   </table>
    		 </table>
    	     </div>
    	  </body>
    	</head>
     </html>"

     #echo "$msg" > outputHTML.html
     (
echo "From: "
echo "To: "
echo "Subject: Rejected"
echo "MIME-Version: 1.0"
echo 'Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"'
echo "Content-Disposition: inline"
echo ""
echo "--GvXjxJ+pjyke8COw"
echo "Content-Type: text/html"
echo "Content-Disposition: inline"
echo "$msg"
echo ""
echo "--GvXjxJ+pjyke8COw"
echo "Content-Type: text/plain;"
echo "Content-Disposition: attachment; filename=list_rejected.csv"
echo ""
echo "$toCSV") | /usr/sbin/sendmail -t
}
