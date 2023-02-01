use feature "say";
use Cwd qw( abs_path );
use File::Basename qw( dirname );

say dirname(abs_path($0));
