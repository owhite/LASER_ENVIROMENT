#!/usr/bin/env python

import hal_glib                           
import hal                                
import os
from gladevcp.persistence import IniFile  

class PWMClass:

    def __init__(self,halcomp,builder,useropts):
        self.builder = builder
        self.halcomp = halcomp
        self.defaults = { IniFile.vars : {"laser_milliseconds"   : 166}}

        self.ini_filename = __name__ + ".var"
        self.ini = IniFile(self.ini_filename,self.defaults,self.builder)
        self.ini.restore_state(self)

        self.laser_hertz_value = hal_glib.GPin(halcomp.newpin("laser_hertz_value", hal.HAL_U32, hal.HAL_OUT))

        self.lbl_duration_value = self.builder.get_object("lbl_duration_value")

        # sets what got loaded in from the ini_file
        self.calc_and_set_milliseconds(self.laser_milliseconds)

        # self.btn1 = self.builder.get_object("period_50")
        # self.btn1.connect("pressed", self.on_btn_pressed, 50)

        self.btn1 = self.builder.get_object("period_50")
        self.btn1.connect("pressed", self.on_btn_pressed, 50)

        self.btn1 = self.builder.get_object("period_100")
        self.btn1.connect("pressed", self.on_btn_pressed, 100)

        self.btn1 = self.builder.get_object("period_200")
        self.btn1.connect("pressed", self.on_btn_pressed, 200)

        self.btn1 = self.builder.get_object("period_500")
        self.btn1.connect("pressed", self.on_btn_pressed, 500)

        self.btn1 = self.builder.get_object("period_700")
        self.btn1.connect("pressed", self.on_btn_pressed, 700)

        self.btn1 = self.builder.get_object("period_900")
        self.btn1.connect("pressed", self.on_btn_pressed, 900)

        self.box = self.builder.get_object("tbl_marius") # arbitrary object to test for ending
        self.box.connect("destroy", self._on_destroy)

    def calc_and_set_milliseconds(self, value):
        self.laser_milliseconds = value
        if (self.laser_milliseconds < 20):
            self.laser_milliseconds = 20
        if (self.laser_milliseconds > 990):
            self.laser_milliseconds = 990
        self.halcomp["laser_hertz_value"]  = (1000000 / self.laser_milliseconds)

        self.lbl_duration_value.set_label("%d" % self.laser_milliseconds)
        os.system("halcmd setp hm2_5i20.0.pwmgen.pwm_frequency %d" % self.halcomp["laser_hertz_value"])

    def on_btn_pressed(self, pin, value):
        self.calc_and_set_milliseconds(value)

    def on_unix_signal(self,signum,stack_frame):
        print "on_unix_signal(): signal %d received, saving state" % (signum)
        self.ini.save_state(self)

    def _on_destroy(self, obj, data = None):
        self.ini.save_state(self)

def get_handlers(halcomp,builder,useropts):
    return(PWMClass(halcomp,builder,useropts))
