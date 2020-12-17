# project name and programming language
project('com.github.darkoverlordofdata.badabing', ['vala', 'c'], version: '0.0.5')


# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Add vapi files
add_project_arguments(
  [
    '--vapidir',
    join_paths(meson.current_source_dir(), 'vapi')
  ],
  language: 'vala'
)

# Set configuration data
conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('PREFIX', get_option('prefix'))
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('PACKAGE', meson.project_name())
conf.set_quoted('LOCALE_DIR', join_paths(get_option('prefix'), get_option('localedir')))
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('PKG_DATADIR', join_paths(get_option('prefix'), get_option('datadir'), meson.project_name()))

configure_file(
  output: 'config.h',
  configuration: conf
)

subdir('data')
subdir('po')

# Create a new executable
executable(
    meson.project_name(),
    'src/BadaBing.vala',
    'src/WallpaperApplication.vala',
    'src/MainWindow.vala',
    'src/Data/ImageTag.vala',
    'src/Widgets/About.vala',
    'src/Views/WelcomeView.vala',
    'src/Views/GalleryView.vala',
    'src/Views/PreferencesView.vala',
    'src/Views/PreferencesView/PreferencesAppearance.vala',
    'src/Views/PreferencesView/PreferencesGeneral.vala',
    'src/Preferences/IPreference.vala',
    'src/Preferences/AutoStart.vala',
    'src/Preferences/TrayIcon.vala',
    'src/Preferences/CronJob.vala',
    'src/Preferences/LockScreen.vala',

    import('gnome').compile_resources(
        'as-resources', join_paths('data', meson.project_name() + '.gresource.xml'),
        source_dir: 'data',
        c_name: 'as'
    ),
    c_args: [
      '-include', 'config.h',
      '-w', 
      '-DGETTEXT_PACKAGE="' + meson.project_name() + '"'
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi'
    ],
    dependencies: [
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('glib-2.0'),
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('json-glib-1.0'),
        dependency('appindicator3-0.1'),
        dependency('libsoup-2.4'),
        dependency('libnotify'),
        dependency('libxml-2.0'),
        meson.get_compiler('c').find_library('m', required: false)        
    ],
    # link_args: ['-lm'],
    install: true
)

# Add post install scripts
meson.add_install_script('meson/post_install.py')
# if build_machine.system() == 'freebsd'
#   meson.add_install_script('meson/freebsd_schema.py')
#   meson.add_install_script('meson/enable_catlock.sh')
# endif
# meson.add_install_script('meson/crontab_install.sh')
