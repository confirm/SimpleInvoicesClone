--- /backups/rsnapshot/monthly.3/local/var/apache2/vhosts/invoices.confirm.ch/htdocs/templates/default/invoices/itemised.tpl	2010-06-05 03:14:48.000000000 +0200
+++ templates/default/invoices/itemised.tpl	2014-10-13 09:59:29.000000000 +0200
@@ -232,10 +232,25 @@
 							/>
 							{$LANG.add_new_row}
 						</a>
 				
 					</td>
+                    <!--
+                    \brief   Button to clone last invoice item.
+                    \author  confirm IT solutions, dbarton
+                    -->
+                    <td>
+						<a
+							class="clone-last-invoice"
+						>
+							<img
+								src="./images/common/download.png"
+								alt=""
+							/>
+							Clone last invoice
+						</a>
+                    </td>
 					<td>
 					<a href='#' class="show-note" onclick="javascript: $('.note').show();$('.show-note').hide();">
 						<img src="./images/common/page_white_add.png" title="{$LANG.show_details}" alt="" />{$LANG.show_details}</a>
 					<a href='#' class="note" onclick="javascript: $('.note').hide();$('.show-note').show();">
 						<img src="./images/common/page_white_delete.png" title="{$LANG.hide_details}" alt="" />{$LANG.hide_details}</a>
