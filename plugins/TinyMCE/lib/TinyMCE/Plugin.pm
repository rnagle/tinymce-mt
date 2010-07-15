package TinyMCE::Plugin;

use strict;
use MT::App;
use MT::Template;

sub plugin {
    return MT->component('TinyMCE');
}

sub set_editor_prefs {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $blog = MT->instance->blog;
    my $plugin = plugin();
    my $scope  = "blog:" . $blog->id;
    my $use_tinymce = $plugin->get_config_value('use_tinymce',$scope);
    
    unless ( !defined $use_tinymce || $use_tinymce == " " ) {
    # If 'Use TinyMCE' is enabled for this blog, override the default text edtior template file location
        my $tmpl_file = $plugin->path.'/tmpl';
        $app->config( 'AltTemplatePath', $tmpl_file );
    } else {
    # Otherwise, make sure the default template path is set -- this should help avoid problems when using FastCGI
        my $tmpl_file = $app->path.'tmpl';
        $app->config('AltTemplatePath', $tmpl_file);
    }
}

1;
