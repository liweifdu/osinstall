#!/usr/bin/python3
#-------------------------------------------------------------------
  #
  #  Filename      : extractData.py
  #  Author        : 
  #  Created       : 2019-??-??
  #  Description   : a script to extract psnr, bit rate info
  #
#-------------------------------------------------------------------

import re
import os

directory = "./recode"
os.chdir(directory)
cwd = os.getcwd()  

with open("result_temp_p.csv","w") as file_object:
    file_object.write("cyc_min , cyc_max , cyc_avg , Sequence\n")

file_list = ["BasketballPass"  ,
             "BQSquare"        ,
             "BlowingBubbles"  ,
             "RaceHorses"      ,
             "BasketballDrill" ,
             "BQMall"          ,
             "PartyScene"      ,
             "RaceHorsesC"     ,
             "FourPeople"      ,
             "Johnny"          ,
             "KristenAndSara"  ,
             "Kimono"          ,
             "ParkScene"       ,
             "Cactus"          ,
             "BasketballDrive" ,
             "BQTerrace"       ,
             "Traffic"         ,
             "PeopleOnStreet"
            ]
qp_list = [22,27,32,37]

for file_name in file_list:
    for qp in qp_list:
        file = str(file_name) + "_" + str(qp) + ".log"
        if os.path.exists(file):
            total = 0
            count = 0
            cyc_max = 0
            cyc_min = 4000
            cyc_avg = 0
            with open(file) as file_object:
                lines = file_object.readlines()
            for line in lines:
                element  = line.split(" ")
                if int(element[2]) % 2 != 0: 
                    total  += float(element[5])
                    count  += 1
                    if float(element[5]) > cyc_max:
                        cyc_max = float(element[5])
                    if float(element[5]) < cyc_min and float(element[5]) != float(111):
                        cyc_min = float(element[5])
            with open("result_temp_p.csv","a") as file_object:
                if count != 0:
                    file_object.write(str(cyc_min) +",")
                    file_object.write(str(cyc_max) +",")
                    file_object.write(str(total / count)+",")
                    file_object.write(str(file_name) + "_" + str(qp) + "\n")
