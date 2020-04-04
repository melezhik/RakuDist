#!perl6

task-run "tasks/pdf-doc";

bash "wget http://www.stillhq.com/pdfdb/000432/data.pdf";
bash "pdf-toc.raku data.pdf";
