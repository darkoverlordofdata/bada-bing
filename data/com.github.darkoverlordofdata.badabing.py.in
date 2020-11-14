#
# python /usr/local/share/bin/com.github.darkoverlordofdata.badabing.py
# nohup python /usr/local/share/bin/com.github.darkoverlordofdata.badabing.py &

import gi
import os
import signal
import time

gi.require_version('Gtk', '3.0')
gi.require_version('AppIndicator3', '0.1')
gi.require_version('Notify', '0.7')

from gi.repository import Gtk as gtk
from gi.repository import AppIndicator3 as appindicator
from gi.repository import Notify as notify

APPINDICATOR_ID = "@package@"

class Indicator():
    def __init__(self):
        self.indicator = appindicator.Indicator.new(APPINDICATOR_ID, "@prefix@/icons/@package@.svg", appindicator.IndicatorCategory.SYSTEM_SERVICES)
        self.indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
        self.indicator.set_menu(self.build_menu())
        notify.init(APPINDICATOR_ID)

    def build_menu(self):
        menu = gtk.Menu()

        item_about = gtk.MenuItem('About')
        item_about.connect('activate', self.about_badabing)

        item_preferences = gtk.MenuItem('Preferences')
        item_preferences.connect('activate', self.preferences_badabing)

        item_gallery = gtk.MenuItem('Gallery')
        item_gallery.connect('activate', self.gallery_badabing)

        item_download = gtk.MenuItem('Download')
        item_download.connect('activate', self.download_badabing)

        item_quit = gtk.MenuItem('Quit')
        item_quit.connect('activate', self.quit)

        menu.append(item_gallery)
        menu.append(item_preferences)
        menu.append(item_download)
        menu.append(item_about)
        menu.append(item_quit)
        menu.show_all()
        return menu

    def about_badabing(self, source):
        # a  Gtk.AboutDialog
        aboutdialog = gtk.AboutDialog()

        # authors = ["bruce davidson <darkoverlordofdata@gmail.com>"]
        aboutdialog.set_comments("Hey Linux, I got yer wallpaper here.")
        aboutdialog.set_program_name("Bada Bing")
        aboutdialog.set_version("0.0.4")
        aboutdialog.set_copyright("Copyright darkoverlordofdata 2019")
        aboutdialog.set_authors(["bruce davidson <darkoverlordofdata@gmail.com>"])
        aboutdialog.set_logo_icon_name("@package@")
        aboutdialog.set_website("https://github.com/darkoverlordofdata/badabing")
        aboutdialog.set_website_label("website")
        aboutdialog.set_title("About BadaBing")
        aboutdialog.show()


    def gallery_badabing(self, source):
        os.system("@package@ --gallery")

    def download_badabing(self, source):
        os.system("@package@ --download")

    def preferences_badabing(self, source):
        os.system("@package@ --preferences")

    def quit(self, source):
        gtk.main_quit()


Indicator()
signal.signal(signal.SIGINT, signal.SIG_DFL)
gtk.main()
