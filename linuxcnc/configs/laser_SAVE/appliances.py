#!/usr/bin/env python

import hal_glib                           
import glib
import hal                                
import time
import re, os, time
import ConfigParser
from gladevcp.persistence import IniFile  

class LaserClass:
    def __init__(self,halcomp,builder,useropts):
        self.builder = builder
        self.halcomp = halcomp

        # cool system that stores in .var file
        self.defaults = { IniFile.vars : {"laser_power_val"   : 1}}
        self.ini_filename = __name__ + ".var"
        self.ini = IniFile(self.ini_filename,self.defaults,self.builder)
        self.ini.restore_state(self)

        self.laser_power_min =  1.0
        self.laser_power_max =  100.0
        self.laser_power_incr = 1.0
        self.spin_oneshot_time = 1.0

        self.lbl_program_name = self.builder.get_object("lbl_program_name")

        self.laser_on_cont =      hal_glib.GPin(halcomp.newpin("laser_on_cont", hal.HAL_BIT, hal.HAL_OUT))
        self.laser_pulse =        hal_glib.GPin(halcomp.newpin("laser_on_pulse", hal.HAL_BIT, hal.HAL_OUT))
        self.laser_pulse_width =  hal_glib.GPin(halcomp.newpin("laser_pulse_width", hal.HAL_FLOAT, hal.HAL_OUT))
        # ext_power_in is how an M100 program will change the value of the laser power
        self.laser_power_in    =  hal_glib.GPin(halcomp.newpin("power_in", hal.HAL_FLOAT, hal.HAL_IN))

        self.box = self.builder.get_object("hbox1") # arbitrary object to test for ending
        self.box.connect("destroy", self._on_destroy)

        self.btn_chiller_pressed = self.builder.get_object("btn_chiller")
        self.btn_chiller_pressed.connect("pressed", self.on_btn_chiller_pressed)

        self.btn_squealer_pressed = self.builder.get_object("squeal_button")
        self.btn_squealer_pressed.connect("pressed", self.on_btn_squealer_pressed)

        self.mbtn_laser_pressed = self.builder.get_object("mbtn-laser_start")
        self.mbtn_laser_pressed.connect("pressed", self.on_mbtn_laser_pressed)

        self.mbtn_laser_released = self.builder.get_object("mbtn-laser_start")
        self.mbtn_laser_released.connect("released", self.on_mbtn_laser_released)

        self.adj_spin_oneshot = self.builder.get_object("spin_adjust")
        self.adj_spin_oneshot.connect("value_changed", self.on_adj_spin_oneshot_value_changed)
        self.adj_spin_oneshot.set_value(self.laser_power_incr)

        self.adj_laser_power = self.builder.get_object("slide_adjust")
        self.adj_laser_power.connect("value_changed", self.on_adj_laser_power_value_changed)
        self.adj_laser_power.upper = self.laser_power_max
        self.adj_laser_power.lower = self.laser_power_min
        self.adj_laser_power.set_value(self.laser_power_val)

        if os.getenv('INI_FILE_NAME'):
            ini_file = os.getenv('INI_FILE_NAME')
        else:
            self.lbl_program_name.set_label("INI_FILE_NAME not set?")

        if os.path.isfile(ini_file):
            config = ConfigParser.ConfigParser()
            config.read(ini_file)

            if config.has_option('DISPLAY','PROGRAM_PREFIX') and config.has_option('DISPLAY','PROGRAM_DEFAULT'):
                prefix = config.get('DISPLAY','PROGRAM_PREFIX')
                prog = config.get('DISPLAY','PROGRAM_DEFAULT')
                self.target_path = os.path.join(prefix, prog)
            else:
                self.lbl_program_name.set_label("ncfile not found")

        glib.timeout_add_seconds(1, self.on_timer_tick)

    def human_readable_file_date(self, f):
        seconds = int(float(time.time()) - float(os.path.getmtime(f)))
        value = ''
        if seconds < 10:
            value = 'NEW'
        elif seconds < 60:
            value = '%d sec' % seconds
        elif seconds < (60 * 2):
            value = '%d min' % (seconds / 60)
        elif seconds < (2 * 60 * 60):
            value = '%d mins' % (seconds / 60)
        elif seconds > (60 * 60 * 60):
            value = '%dh' % (seconds / (60 * 60 * 60))
        else:
            value = 'age?'
        return (value)

    # chows the thing.ngc file and finds the numth occurance of 
    #  of a comment in the form "^(text)"
    def extract_headline(self, file_name, num):
        f = open(file_name, "r")
        tag = self.human_readable_file_date(file_name)
        count = 0
        for line in f.read().splitlines():
            if re.match("^\(.*", line):
                if count == (num - 1):
                    line = re.sub('[\(\))]', '', line)
                    return('%s (%s)' % (line, tag))
                count += 1

    def on_btn_squealer_pressed(self, pin, data = None):
        print "poked squealer button"

    def on_timer_tick(self,userdata=None):
        # the interface shows the power OR
        # the user can set power_in using M100 P40 (where 40 is power setting) 
        # update the display in either case
        if self.halcomp["power_in"] != self.laser_power_val:
            self.laser_power_val = int(self.halcomp["power_in"])
            self.adj_laser_power.set_value(self.laser_power_val)

        # for milli seconds
        self.halcomp["laser_pulse_width"] = self.halcomp["spin_oneshot_time-s"] / float(1000)
        # for seconds
        # self.halcomp["laser_pulse_width"] = self.halcomp["spin_oneshot_time-s"]  / float(1)

        if os.path.isfile(self.target_path):
            r = self.extract_headline(self.target_path, 1)
            if r:
                self.lbl_program_name.set_label(r)
        return True # True restarts the timer

    def on_adj_laser_power_value_changed(self, pin, data = None):
        # user has hit the slide bar so grab the value
        self.halcomp["power_in"] = pin.get_value()

    def _on_destroy(self, obj, data = None):
        self.ini.save_state(self)

    def on_btn_chiller_pressed(self, pin, data = None):
        # print self.halcomp["chiller.is-on"]
        pass

    def on_mbtn_laser_pressed(self, pin, data = None):
        if self.halcomp["chkbtn_oneshot"]:
            self.halcomp["laser_on_cont"]  = 0
            self.halcomp["laser_on_pulse"] = 1
        else:
            self.halcomp["laser_on_cont"]  = 1
            self.halcomp["laser_on_pulse"] = 0

    def on_mbtn_laser_released(self, pin, data = None):
        self.halcomp["laser_on_cont"]  = 0
        self.halcomp["laser_on_pulse"] = 0

    def on_adj_spin_oneshot_value_changed(self, pin, data = None):
        self.spin_oneshot_time = pin.get_value()

    def on_unix_signal(self,signum,stack_frame):
        print "on_unix_signal(): signal %d received, saving state" % (signum)
        self.ini.save_state(self)

def get_handlers(halcomp,builder,useropts):
    return[LaserClass(halcomp,builder,useropts)]
