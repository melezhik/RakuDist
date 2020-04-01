#!perl6

file 'capitals.csv', %(
  content => "Country,Capital\nJapan,Tokio\nRussia,Moscow\nUK,London"
);

bash "pt --csv capitals.csv";
