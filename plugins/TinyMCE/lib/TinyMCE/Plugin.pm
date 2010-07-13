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

    # If 'Use TinyMCE' is enabled for this blog, enable it on entry creation page
    unless ( !defined $use_tinymce || $use_tinymce == " " ) {
        my $tmpl_file = $plugin->path.'/tmpl/cms/include/archetype_editor.tmpl';
#        $app->config( 'AltTemplatePath', $tmpl_file );
        $param->{rich_editor} = '1';
        
        my $basename_field = $tmpl->getElementById('basename');
        my $innerHTML = "<mt:include name=\"$tmpl_file\">";
        my $editor_elem = $tmpl->createElement('setvarblock',{ name => 'rich_editor_tmpl' });
        $editor_elem->innerHTML($innerHTML);
        $tmpl->insertBefore($editor_elem, $basename_field);

        MT->log({
            message => "$param->{rich_editor}, $tmpl_file",
            class => 'blog',
            level => MT::Log::DEBUG(), 
        });
    }
}

1;
