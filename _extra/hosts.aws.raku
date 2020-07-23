use JSON::Tiny;
use Data::Dump;

my $data = from-json("/home/melezhik/projects/terraform/examples/aws/terraform.tfstate".IO.slurp);
my $client-ip;
my $database-ip;

my @aws-instances = $data<resources><>.grep({ 
  .<type> eq "aws_instance" 
}).map({

  if .<instances>[0]<attributes><tags><Name> eq "client" {
    $client-ip = .<instances>[0]<attributes><public_ip>
  }
  if .<instances>[0]<attributes><tags><Name> eq "database" {
    $database-ip = .<instances>[0]<attributes><public_ip>
  }


  %( 
    host => .<instances>[0]<attributes><public_dns>,
    tags => "{.<instances>[0]<attributes><tags><Name>},name={.<instances>[0]<attributes><tags><Name>},aws,ip={.<instances>[0]<attributes><public_ip>}"
  )
});

for @aws-instances -> $i {
  $i<tags> ~= ",client_ip={$client-ip}";
  $i<tags> ~= ",database_ip={$database-ip}"
}

say Dump(@aws-instances);

@aws-instances;
