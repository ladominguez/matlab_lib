   High Resolution Santa Monica Survey
   Component of the LARSE II Experiment
The programs in this directory read the disk with the Santa Monica Vibroseis
data.  Note there are 336 receivers starting at number 110 and ending at number 445
There are 166 shots =336*166 =55776 traces
Receiver 110 was located near Santa Monica Pier
Receiver 445 north in the Santa Monica Mountains 270-300 traverse Riviera Country Club.

mysegyread.m reads and plots the record sections.
myreadhdr.m  reads UTM locations and plots stations and shot point.
   
   
   
   
P.I.'s: Paul Davis and Shirley Baher, UCLA
Date: June 19 -25, 2000
Publications:  U.S.G.S Open File Report 02-237
Location: Northern edge of the Los Angeles Basin
         into the foothill and the Santa Monica Mtns.
         From : Lat 34.01221  Lon -118.4960
          To  : Lat 34.07152  Lon -118.5112
Purpose:  To determine the shallow (1-2 km) structure
         causing the strong motion amplification
         observed in the Northrige Earthquake (1994) and
         its aftershocks.
Contractor and Equipment:
         SubSurface Exploration Co. (SECO)
         Sign-bit recording system
         Single   40,000 lb Vibrator
Survey Parameters
         Fixed (approximate) N-S line with 345 receivers
            with a nominial spacing of 30 meters.  The total
            length of the line is 10 km.
         Source shot through the line at approximately every
            2 receiver points starting at the first receiver,
            with a total of 166 shots.
         Data are in UTM coordinates.  Recorded at 2 mil.
         Effective Vibrator Sweep Range: 8 - 58 Hz
         Number of sweeps/ source point. 8 sweeps/ source point
                                        12 second sweep length
Data Format
         Data were originally recorded in GSC propertiary format.
         Converted to ISIS format.
         Converted from Isis to SEGY format.
         SEGY variables used:
                 trseql:  trace counter
                 sp    :  flag number of shot point
                 trid  :  receiver flah number
                 sx,sy,szsurf: source location (m)
                 gx,gy,gz: receiver loaction (m)
                 nt, dt, offset.
