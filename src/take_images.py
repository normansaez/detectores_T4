#!/usr/bin/env python

'''
Take Images
'''

import time
from subprocess import Popen, PIPE
import math

def e_execute_cmd(cmd):
    '''
    Execute a command.
    The command is received by parameter as string.

    returns code status, std out, std err
    return int, str, str
    '''
    print cmd
    process = Popen(cmd , stdout=PIPE , stderr=PIPE , shell=True)
    sts = process.wait()
    out = process.stdout.read().strip()
    err = process.stderr.read().strip()
    return sts, out, err

def execute_cmd(cmd):
    '''
    '''
    print cmd
    return 1, "287.07", ""

def exposure(directory, name, n_step, temp, max_time, led_sts):
    '''
    '''
    cmd = "pan set image.dir %s" % directory
    execute_cmd(cmd)
    cmd = "led %s" % led_sts
    execute_cmd(cmd)
    time.sleep(2)
    for t in range(0, max_time+1,  n_step):
        cmd = "pan set image.number 1"
        execute_cmd(cmd)
        temp = int(math.floor(temp))
        tiempo = int(math.floor(t/1000.0)) #name in seconds
        cmd = "pan set image.basename %s_T_%s_E_%s" % (name, str(temp), str(tiempo))
        if led_sts == "off" and t == 0:
            cmd = "pan set image.basename %s_T_%s_E_%s" % ("bias", str(temp), str(tiempo))
        execute_cmd(cmd)
        cmd = "pan set exptime %d" % t
        execute_cmd(cmd)
        cmd = "pan expose"
        sts, out, err = execute_cmd(cmd)
        #print "%d" % sts
        print "%s" % out
        print "%s" % err



if __name__ == '__main__':
#    for temp in [282, 287]:
    dirs = ['/home/detector/alumnos/nsaez/imgA_fits/','/home/detector/alumnos/nsaez/imgB_fits/','/home/detector/alumnos/nsaez/imgC_fits/']
    for directory in dirs:
        for temp in range(278, 294):
            set_temp = temp
            cmd = "pan dhe tp set CCDSETP %d" % set_temp
            execute_cmd(cmd)
            t_init = time.time()
            count = 0
            attempts = 9
            while (count <=attempts):
                cmd = "pan dhe tp read CCDTEMP"
                sts, out, err = execute_cmd(cmd)
                get_temp = float(out)
                if set_temp == math.floor(get_temp):
                    t_reach = time.time()
                    print "set: %.3f   get: %.3f , %.3f" % (set_temp, get_temp, (t_reach - t_init))
                    name = "dark"
                    temp = get_temp
                    n_step = 60000
                    max_time = 300000
                    led_sts = "off"
                    exposure(directory, name, n_step, temp, max_time, led_sts)
                    name = "flat"
                    led_sts = "on"
                    exposure(directory, name, n_step, temp, max_time, led_sts)
                    count = attempts + 1
                else:
                    count += 1
                    print "Attempts %d, waiting 60 [s]" % count
    #                time.sleep(0.160)
                    if count == attempts + 1:
                        print "No more attempts to reach temperature %.3f" % set_temp 
    
#
# ___oOo___
