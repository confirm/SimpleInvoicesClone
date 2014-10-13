# SimpleInvoicesClone

## About

The problem w/ a "large" SimpleInvoices installation is, that there are way too many products. Sometimes you just want to create a new invoice, based on the last invoice for the same customer. 

We're using SimpleInvoices internally, to create monthly invoices for our customers. The items will differ from customer to customer, but they'll always be the same for each customer. So I started to look for a simple way to duplicate the customer's last invoice. This is the solution I came up with. 

It is a patch and an AJAX backend for SimpleInvoices, to clone the last invoice of a customer on creation of a new invoice.

When you create a new invoice, you just click on the "New Invoice" button as usual. Then you select your customer in the existing dropdown, and click on the new "clone last invoice" button (http://cloud.confirm.ch/XMCG). The last invoice will be looked up via AJAX, and your form will automatically be updated w/ all the data of the last invoice. The following things will be updated:

- custom fields
- invoice items (amount, product, tax, description, etc.)
- month / year in description will be increased (June 2014 -> July 2014 / December 2014 -> January 2015)

Yeah I know, it's anything else than perfectly scripted, but hey it works :)

## Install

Copy the following file to the `root directory` of your SimpleInvoices instance:

- `ajax.php` (PHP AJAX backend to fetch last invoice)

Patch the following files:

- `include/jquery/jquery.conf.js.tpl` (JavaScript function to clone last invoice)
- `templates/default/invoices/itemised.tpl` (Button to clone last invoice)

## Language

The month/year replacement thingy is hard coded in the `jquery.conf.js.tpl` Patch and it's written in german (e.g. Januar, Februar, ... Dezember). You might want to update it to english months (e.g. January, February, ... December).
