package MT::Plugin::TinyMCE;
use strict;
use MT;
use MT::Plugin;
use MT::Tag;

our $VERSION = '1.1.2';

use base qw( MT::Plugin );

@MT::Plugin::TinyMCE::ISA = qw(MT::Plugin);

my $plugin = new MT::Plugin::TinyMCE({
    name => 'TinyMCE',
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    author_name => 'Alfasado, Inc.',
    author_link => 'http://alfasado.net/',
    version     => $VERSION,
# Custom toolbar setup for ChicagoNow
    settings => new MT::PluginSettings ([
        ['editor_style_css', { Default => '<$mt:var name="static_uri"$>plugins/tinymce/css/editor_style.css' }],
        ['theme_advanced_buttons1', { Default => 'bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,formatselect,fontsizeselect' }],
        ['theme_advanced_buttons2', { Default => 'cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo' }],
        ['theme_advanced_buttons3', { Default => 'link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,|,forecolor,backcolor,|,charmap,emotions,iespell,media,advhr' }],
        ['theme_advanced_buttons4', { Default => 'tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,print,|,ltr,rtl,|,fullscreen' }],
#        ['theme_advanced_buttons5', { Default => 'insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak,|,mt-image,mt-file' }],
    ]),
#    settings => new MT::PluginSettings ([
#        ['editor_style_css', { Default => '<$mt:var name="static_uri"$>plugins/tinymce/css/editor_style.css' }],
#        ['theme_advanced_buttons1', { Default => 'bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect' }],
#        ['theme_advanced_buttons2', { Default => 'newdocument,|,cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo' }],
#        ['theme_advanced_buttons3', { Default => 'link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor,|,charmap,emotions,iespell,media,advhr' }],
#        ['theme_advanced_buttons4', { Default => 'tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,print,|,ltr,rtl,|,fullscreen' }],
#        ['theme_advanced_buttons5', { Default => 'insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak,|,mt-image,mt-file' }],
#    ]),
    system_config_template => 'tinymce.tmpl',
    l10n_class => 'TinyMCE::L10N',
});

MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_param.edit_entry'
                => \&_set_editor_prefs,
        },
   });
}

sub _set_editor_prefs {
    my ( $cb, $app, $param ) = @_;
    my $tmpl_dir = File::Spec->catdir( $plugin->path, 'tmpl' );
    $app->config( 'AltTemplatePath', $tmpl_dir );
    my $static_path = $app->static_path;
    my $editor_style_css = $plugin->get_config_value('editor_style_css');
    $editor_style_css =~ s/<\${0,1}mt:var\sname="static_uri"\${0,1}>/$static_path/;
# Custom settings for ChicagoNow
    $param->{'editor_style_css'} = $editor_style_css;
    $param->{'theme_advanced_buttons1'} = $plugin->get_config_value('theme_advanced_buttons1');
    $param->{'theme_advanced_buttons2'} = $plugin->get_config_value('theme_advanced_buttons2');
    $param->{'theme_advanced_buttons3'} = $plugin->get_config_value('theme_advanced_buttons3');
    $param->{'theme_advanced_buttons4'} = $plugin->get_config_value('theme_advanced_buttons4');
#    $param->{'theme_advanced_buttons5'} = $plugin->get_config_value('theme_advanced_buttons5');
#    $param->{'editor_style_css'} = $editor_style_css;
#    $param->{'theme_advanced_buttons1'} = $plugin->get_config_value('theme_advanced_buttons1');
#    $param->{'theme_advanced_buttons2'} = $plugin->get_config_value('theme_advanced_buttons2');
#    $param->{'theme_advanced_buttons3'} = $plugin->get_config_value('theme_advanced_buttons3');
#    $param->{'theme_advanced_buttons4'} = $plugin->get_config_value('theme_advanced_buttons4');
#    $param->{'theme_advanced_buttons5'} = $plugin->get_config_value('theme_advanced_buttons5');
    $param->{'lang'} = $app->blog->language;
}

1;