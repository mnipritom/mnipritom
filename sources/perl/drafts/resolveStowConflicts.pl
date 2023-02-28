use v5.34;
use strict;
use warnings;

use Env;

use feature("say");

use Cwd(qw(abs_path));
use File::Basename(qw(dirname));

my %rules = (
  "xorg" => "$HOME"
)
