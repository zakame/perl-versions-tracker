### perl-versions-tracker - simple API for finding Perl releases

This is a small PH Independence Day hack to provide a small API for finding
Perl releases via [MetaCPAN's FastAPI][fastapi].

[fastapi]: https://github.com/metacpan/metacpan-api/blob/master/docs/API-docs.md

The intent is to do a proof-of-concept for an API that can be included in
MetaCPAN's [GET convenience URLs][metacpan-urls] so Perl distribution
developers at the downstream (such as [docker-perl][docker-perl] or
[NixOS][nixos]) can consume this API to automate maintenance of their
packages.

[metacpan-urls]: https://github.com/metacpan/metacpan-api/blob/master/docs/API-docs.md#get-convenience-urls
[docker-perl]: https://github.com/Perl/docker-perl
[nixos]: https://nixos.org
