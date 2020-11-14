#!/usr/local/bin/python3.7

# run this on bsd to create keys in dconf for NomadBSD

import os
from gi.repository  import Gio

schema_source = Gio.SettingsSchemaSource.new_from_directory(
	# get default schema
    os.path.expanduser("~/GitHub/badabing/data"),
    Gio.SettingsSchemaSource.get_default(),
    False,
)
schema = schema_source.lookup('com.github.darkoverlordofdata.badabing', False)
settings = Gio.Settings.new_full(schema, None, None)
settings.set_boolean('dark', False)
settings.set_boolean('indicator', False)
settings.set_boolean('minimized', False)
settings.set_boolean('start-on-boot', True)
settings.set_boolean('use-cron-job', True)
settings.set_boolean('create-lock-assets', True)
settings.set_int('maximum', 7)
settings.set_boolean('xml', False)
settings.set_string('locale', "US-en")
settings.set_string('resolution', "1900x1200")
settings.set_string('image-path',"~/Wallpapers/badabing.jpg")

