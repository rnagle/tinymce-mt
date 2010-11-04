package TinyMCE::Plugin;

use strict;
use MT::App;
use MT::Template;
use Switch;

sub plugin {
    return MT->component('TinyMCE');
}

sub set_editor_prefs {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $blog = MT->instance->blog;
    my $plugin = plugin();
    my $scope  = "blog:" . $blog->id;
    
    # TODO: It would be nice to enhance this portion of the plugin
    # to allow multiple rich text editor options.
    my $use_tinymce = ( !defined($plugin->get_config_value('tinymce_on',$scope)) ? 'off' : 'on' );
    
   switch ($use_tinymce) {
       case 'on' { 
           my $tmpl_file = $plugin->path.'/tmpl';
           $app->config( 'AltTemplatePath', $tmpl_file );
           } else {
           my $tmpl_file = $app->path.'tmpl';
           $app->config('AltTemplatePath', $tmpl_file);
       }
    }
}

sub apply {
    my $app     = shift;
    my ($param) = @_;

    $app->validate_magic or return;

    my $q       = $app->{query};
    my $blog    = MT->model('blog')->load( $q->param('blog_id') );
    my $pval     = $q->param('pref_value');

    my $plugin = plugin();
    my $scope  = "blog:" . $blog->id;
    $plugin->set_config_value('tinymce_on',$pval,$scope);

    return $app->redirect(
    $app->uri(
        'mode' => 'manage_editor',
        'args' => {
        'prefs_applied' => 1,
        'blog_id'       => $app->param('blog_id'),
        'return_args'   => $app->return_args,
        'magic_token'   => $app->param('magic_token')
        }
    )
    );
}

sub manage_editor {
    my $app     = shift;
    my ($param) = @_;
    my $q       = $app->{query};
    my $blog    = MT->model('blog')->load( $q->param('blog_id') );

    $param ||= {};

    my $prefs = MT->registry('rte_prefs');
    
    my $plugin = plugin();
    my $scope  = "blog:" . $blog->id;
    my $use_tinymce = $plugin->get_config_value('tinymce_on',$scope);
    
    my @data;
    # NOTE: The following is probably not necessary with only one 
    # RTE option, but means we can potentially extend this plugin 
    # to work with other editors in the future.
    foreach my $pval (keys %$prefs) {
        my $pref = $prefs->{$pval};
        push @data, {
            id => $pval,
            name => &{ $pref->{'label'} },
            description => $pref->{'description'},
            order => $pref->{'order'} || 10,
            value => $use_tinymce
            };
    }
    @data = sort { $a->{order} <=> $b->{order} } @data;
    $param->{prefs} = \@data;
    $param->{blog_id} = $app->param('blog_id');
    $param->{return_args} = $app->return_args;
    $param->{magic_token} = $app->param('magic_token');
    $param->{prefs_applied} = $app->param('prefs_applied') ? 1 : 0;

    return $app->load_tmpl( 'manage_editor.tmpl', $param );
}

1;
