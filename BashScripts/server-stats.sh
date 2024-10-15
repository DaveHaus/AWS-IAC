#!/bin/bash


#Total CPU usage 
cpu=vmstat 1 2 | tail -1 | awk '{print 100 - $15"% CPU used"}'

#Total memory usage (Free vs Used including percentage)
mem_used=vmstat 1 2 | tail -1 | awk '{print $3" Mem used"}'
mem_free=vmstat 1 2 | tail -1 | awk '{print $4" Mem free"}' 

#Total disk usage (Free vs Used including percentage)
disk_free=df -h --total | tail -1 | awk '{print $4}'
disk_used=df -h --total | tail -1 | awk '{print $3}'

#Top 5 processes by CPU usage
ps aux 

#Top 5 processes by memory usage
ps aux