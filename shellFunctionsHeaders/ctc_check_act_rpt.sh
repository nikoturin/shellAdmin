#!/bin/bash
###################################################
#Name Process: ctc_check_act_rpt.sh
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 28/10/2013
#Objective: Check network
#this process check every 30 minutes per hours.
#Msg: If you have a better idea let us know please
###################################################

source ~/app/db_mon_rec.h


act_date=$(date +%Y/%m/%d/%H);
let flag_email=0;
let count_fail=0;

qry_act="SELECT a.error_code,a.act_transaction_status, count(*)
                FROM TABLE(MULTISET(
                                select b.pnr_book_numb, p.payment_no
                                from book b inner join payments p on b.book_no=p.book_no
                                where p.updt_date_time  >= '$act_date/00/00' )) AS vtab(pnr_book_numb, payment_no)
                inner join accertify_transaction a ON a.locator=vtab.pnr_book_numb and a.payment_no=vtab.payment_no
                group by 1,2;"

msg="<html>
    	<head>
           <body>
    		<table cellspacing=0 align=center border=0 width='100%'>
		   <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
                           <tr style='position:relative; top:expression(offsetParent.scrollTop);'>
                                <td style='width:1%;FONT-WEIGHT: bolder;font-size: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #FFFFFF;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #DF0101;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>La estad&iacute;stica de pagos con tarjeta de cr&eacute;dito() en los &uacute;ltimos 30 minutos muestra un n&uacute;mero inusual de pagos con el error ConnectionFailed</TD>                          
			  </tr>
                   </table>
                   <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
        	      <tr style='position:relative; top:expression(offsetParent.scrollTop);'>
                        <td style='width:1%;FONT-WEIGHT: bolder;font-size: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #FFFFFF;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #DF0101;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>ACCERTIFY NETWORK STATUS</TD>
	             </tr>
	    	  </table>
               <!--div style='border:1px inset; position:absolute; height:70%; width:100%;'-->
                 <div style='position:absolute; height:70%; width:100%;'>
                   <table class='header3'  cellspacing=0 align=center border=0 width='100%'>
                        <table class=N2 cellspacing=0 align=center border=0 style='width:100%;height:1px;'>
                         <tr style='height:1%'>
                           <tr>
                               <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #ececec;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>ERROR CODE</TD>
                               <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #ececec;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>TRANSACTION STATUS</TD>
                               <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #ececec;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>TRANSACTION COUNT</TD>
                           </tr>"
		for str in $(echo $qry_act | sqlcmd -d $)
		do
		    msg=${msg}"<tr>";
	 	    error_code=$(echo $str | cut -d"|" -f1);        
		    act_transaction=$(echo $str | cut -d"|" -f2);        
		    count=$(echo $str | cut -d"|" -f3);

		    msg=${msg}"<TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #FFFFFF;TEXT-ALIGN: left;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=left>$error_code</TD>
		    	       <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #FFFFFF;TEXT-ALIGN: center;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>$act_transaction</TD>
 <TD style='width:1%;FONT-WEIGHT: bold;FONT-SIZE: 10px;HEIGHT: 21px;VERTICAL-ALIGN: middle;COLOR: #666666;FONT-FAMILY: Verdana;BACKGROUND-COLOR: #FFFFFF;TEXT-ALIGN: ce
nter;BORDER-STYLE: solid solid solid solid;BORDER-WIDTH: 1px 1px 1px 1px;BORDER-COLOR: #D0D0D0 #D0D0D0 #D0D0D0 #D0D0D0;' ALIGN=CENTER>$count</TD>"


		    if [[ $act_transaction = "ConnectionFailed" && $count -gt 0 ]]
	          	then

			     let flag_email++;
			     let count_fail=$count;
        	    fi
        	  
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

     if [[ $flag_email -eq 1 && $count_fail -ge 10 ]]
	then

		(echo "From: "; echo "To: "; echo "Bcc: "; echo "Subject:ConnectionFailed"; echo "Content-Type: text/html"; echo "MIME-Version: 1.0"; echo ""; echo "$msg"; ) | /usr/sbin/sendmail -t

		add_rec_accertify $count_fail

     elif [[ $flag_email -eq 1 && $count_fail -lt 10 ]]
	then
		(echo "From: "; echo "To: "; echo "Bcc: "; echo "Subject:ConnectionFailed"; echo "Content-Type: text/html"; echo "MIME-Version: 1.0"; echo ""; echo "$msg"; ) | /usr/sbin/sendmail -t

		add_rec_accertify $count_fail
     fi
