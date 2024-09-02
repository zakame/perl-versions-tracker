use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->dirname->sibling('app'));

plan skip_all => 'MetaCPAN API is down'
  unless $t->ua->get('https://fastapi.metacpan.org/v1/release/_search')->res->is_success;

is ref $t->app->release_search('released'), 'ARRAY', 'found Perl release data';

$t->get_ok('/')->status_is(302)->header_is(location => '/v1/stable');

$t->get_ok('/bad')->status_is(404)->content_like(qr#Not Found#);

$t->get_ok('/v1/stable')->status_is(200)->content_type_like(qr#application/json#)                            #
  ->json_has('/0/name')->json_has('/0/author')->json_has('/0/checksum_sha256')->json_has('/0/download_url')  # latest
  ->json_has('/1/name')->json_has('/1/author')->json_has('/1/checksum_sha256')->json_has('/1/download_url')  # oldstable
  ->json_has('/2/name')->json_has('/2/author')->json_has('/2/checksum_sha256')->json_has('/2/download_url');

$t->get_ok('/v1/devel')->status_is(200)->content_type_like(qr#application/json#)                             #
  ->json_has('/0/name')->json_has('/0/author')->json_has('/0/checksum_sha256')->json_has('/0/download_url');

$t->get_ok('/v1/testing')->status_is(200)->content_type_like(qr#application/json#)                           #
  ->json_has('/0/name')->json_has('/0/author')->json_has('/0/checksum_sha256')->json_has('/0/download_url');

done_testing();
