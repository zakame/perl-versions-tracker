  #!/usr/bin/env perl
use Mojolicious::Lite -signatures;

helper release_search => sub ($c, $maturity, $size = 3, $rc = undef) {
  +[
    map { $_->{fields} } $c->ua->post('https://fastapi.metacpan.org/v1/release/_search',
    json => {
      $maturity eq 'released' ? () : (query => {
        regexp => {
          name => {
            value => $rc ? '.+-RC.+' : '@&~(.+-RC.+)'
          }
        }
      }),
      size => $size,
      fields => [qw(name author checksum_sha256 download_url)],
      filter => {
        and => [
          {term => {'distribution.lowercase' => 'perl'}},
          {term => {maturity => $maturity}},
        ]
      },
      sort => [{date => {order => 'desc'}}]    
    })->result->json->{hits}{hits}->@*
  ];
};

get '/' => sub ($c) {
  $c->redirect_to('/v1/stable');
};

under '/v1';

get '/stable' => sub ($c) {
  $c->render(json => $c->release_search('released'));
};

get '/devel' => sub ($c) {
  $c->render(json => $c->release_search('developer', 1));
};

get '/testing' => sub ($c) {
  $c->render(json => $c->release_search('developer', 1, 'rc'));
};

app->start;
