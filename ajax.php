<?php

/*
 * \file    ajax.php
 *
 * \brief   AJAX backend.
 *
 * Currently it's only used by the "clone invoice" feature in the "new invoice"
 * view.
 *
 * \author  confirm IT solutions, dbarton
 *
 * \license GNU Lesser General Public License, version 3.0 (LGPL-3.0)
 */

// @confirm AJAX script to clone last invoice.

/*
 * Initialize.
 */

    define("BROWSE","browse");

    require_once("./include/init_pre.php");

    $module = isset($_GET['module']) ? filenameEscape($_GET['module']) : null;
    $view   = isset($_GET['view'])  ? filenameEscape($_GET['view'])    : null;
    $action = isset($_GET['case'])  ? filenameEscape($_GET['case'])    : null;

    require_once("./include/init.php");

    foreach($config->extension as $extension)
    {
        /*
        * If extension is enabled then continue and include the requested file for that extension if it exists
        */
        if($extension->enabled == "1")
        {
            //echo "Enabled:".$value['name']."<br><br>";
            if(file_exists("./extensions/$extension->name/include/init.php"))
            {
                require_once("./extensions/$extension->name/include/init.php");
            }
        }
    }

    $success = TRUE;
    $message = 'AJAX request initialized';
    $data    = array();

try
{

    /*
     * Sanity check for arguments.
     */

    if(!array_key_exists('customer_id', $_REQUEST))
        throw new Exception('Missing parameter customer_id.');

    $customer_id = $_REQUEST['customer_id'];

    if(array_key_exists('except_invoice_id', $_REQUEST))
        $except_invoice_id = $_REQUEST['except_invoice_id'];
    else
        $except_invoice_id = 0;

    /*
     * Query database to get customer's last invoice items.
     */

    $message   = 'query database for invoice data...';

    $statement = dbQuery('
        SELECT custom_field1, custom_field2, custom_field3, custom_field4
        FROM si_invoices
        WHERE customer_id = :customer_id AND id <> :id
        ORDER BY id DESC
        LIMIT 1',
        ':customer_id', $customer_id,
        ':id', $except_invoice_id
    );

    $message = 'fetching invoice data...';

    if(!($data = $statement->fetch(PDO::FETCH_ASSOC)))
        throw new Exception('Sorry there are no invoices for this customer');

    /*
     * Query database to get customer's last invoice items.
     */

    $message   = 'query database for invoice items...';

    $statement = dbQuery('
        SELECT items.*, tax.tax_id
        FROM si_invoice_items items
        LEFT JOIN si_invoice_item_tax tax
            ON items.id = tax.invoice_item_id
        WHERE items.invoice_id = (
            SELECT inv.id
            FROM si_invoices inv
            WHERE inv.customer_id = :customer_id AND inv.id <> :id
            ORDER BY inv.id DESC
            LIMIT 1)
        ',
        ':customer_id', $customer_id,
        ':id', $except_invoice_id
    );

    $message = 'fetching invoice items...';
    $data['items'] = $statement->fetchAll(PDO::FETCH_ASSOC);

    $message = 'query database successful';
}

catch(Exception $e)
{
    $success = FALSE;
    $message = $e->getMessage();
}

echo json_encode(array(
    'success' => $success,
    'message' => $message,
    'data'    => $data
));
?>