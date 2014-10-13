--- /backups/rsnapshot/monthly.3/local/var/apache2/vhosts/invoices.confirm.ch/htdocs/include/jquery/jquery.conf.js.tpl	2010-06-08 08:59:34.000000000 +0200
+++ include/jquery/jquery.conf.js.tpl	2014-10-13 09:56:32.000000000 +0200
@@ -246,9 +246,107 @@
       	var $row_number = $(this).attr("rel");
 		siLog('debug',"{/literal}$config->export->spreadsheet{literal}");
 		export_invoice($row_number, '{/literal}{$config->export->spreadsheet}{literal}','{/literal}{$config->export->wordprocessor}{literal}');
      });
 
+	/*
+	 * \brief  	Listener for "clone invoice" button.
+	 *
+	 * \author  confirm IT solutions, dbarton
+	 */
+
+	$('.clone-last-invoice').click(function()
+	{
+		var customer_id	= $('[name=customer_id]').val();
+
+		$.getJSON('ajax.php', { customer_id: customer_id }, function(response)
+		{
+			// Replace custom fields.
+			for(i=1; i<=4; i++)
+			{
+				var value = response.data['custom_field' + i];
+				var field = $('input[name=customField' + i + ']');
+				field.val(value);
+			}
+
+			// Get items from JSON response.
+			var items   	= response.data.items;
+			var item_count	= items.length
+
+			// Get row count.
+			var lastRow = $('#itemtable tbody.line_item:last')
+			var row_id  = $("input[@id^='quantity']",lastRow).attr("id");
+			row_count   = parseInt(row_id.slice(8)) + 1;
+
+			// Add new rows.
+			if(row_count <= item_count)
+				for(i=row_count; i<item_count; i++)
+					add_line_item();
+
+			// Set required rows and delete unnecessary rows.
+			for(i=0; i<row_count; i++)
+			{
+				if(i<item_count)
+				{
+					// Get description.
+					var description = items[i].description;
+
+                    // Replace month and new lines in description.
+					jQuery.each([
+                        ['Januar',      'Feburar'],
+						['Februar', 	'März'],
+						['M(ä|ae)rz',   'April'],
+                        ['April',       'Mai'],
+                        ['Mai',         'Juni'],
+                        ['Juni',        'Juli'],
+                        ['Juli',        'August'],
+                        ['August',      'September'],
+                        ['September',   'Oktober'],
+                        ['Oktober',     'November'],
+                        ['November',    'Dezember'],
+                        ['Dezember',    'Januar'],
+                        [' *<br /> *',    '\n']
+					], function(index, element)
+					{
+						var search  = new RegExp(element[0], 'g');
+						var replace = element[1];
+
+                        if(description.match(search))
+                        {
+    						description = description.replace(search, replace);
+                            return false;
+                        }
+					});
+
+                    // Increase year if Januar is matched.
+                    if(description.match('Januar'))
+                    {
+                        var match = description.match(/20[0-9]{2}/);
+                        if(match)
+                        {
+                            var year     = parseInt(match[0]);
+                            var new_year = year + 1;
+                            description = description.replace(year, new_year);
+                        }
+                    }
+
+					$('#quantity' + i).val(parseFloat(items[i].quantity));
+					$('#products' + i).val(items[i].product_id);
+					$('#tax_id\\[' + i + '\\]\\[0\\]').val(items[i].tax_id);
+					$('#unit_price' + i).val(parseFloat(items[i].unit_price));
+					$('#description' + i).val($.trim(description)).css({ color: '#333' });
+				}
+				else
+				{
+					if(i > 0)
+						delete_line_item(i);
+				}
+			}
+
+			// Show details.
+			$('.note').show();$('.show-note').hide();
+		});
+	});
 });
 
 </script>
 {/literal}
