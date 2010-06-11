package TinyMCE::Plugin;

use strict;

sub plugin {
    return MT->component('TinyMCE');
}

sub set_editor_prefs {
    my ( $cb, $app, $ctx, $args ) = @_;
    my $blog = MT->instance->blog;
    my $plugin = plugin();
    my $scope  = "blog:" . $blog->id;
    my $use_tinymce = $plugin->get_config_value('use_tinymce',$scope);

    # If Use TinyMCE is enabled for this blog, enable it on entry creation page    
    unless ( !defined $use_tinymce ) {
        MT->log({
            message => "Use TinyMCE?: " . $use_tinymce,
            class => 'blog',
            level => MT::Log::DEBUG(), 
            });
        my $tmpl_dir = $plugin->path . '/tmpl';
        $app->config( 'AltTemplatePath', $tmpl_dir );
    }
}

1;
