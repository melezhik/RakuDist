use DBIish;

sub MAIN ( $id )
{
    my $dbh = DBIish.connect("SQLite", database => "sparky/db.sqlite3"  );
    $dbh.do("UPDATE builds SET state = -1 WHERE id = $id");
}

