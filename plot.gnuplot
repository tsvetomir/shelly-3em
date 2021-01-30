set xdata time
set timefmt '%Y-%m-%dT%H:%M:%S'
set format x '%d.%m.%Y'
set xrange ['2021-01-23':'2021-01-30']
set yrange [0:10000]
set y2range [150:250]
set y2tics auto
set grid

set terminal png size 1720,880 enhanced font 'Segoe UI,10'
set output 'plot.png'

#set terminal svg enhanced font 'Segoe UI,10'
#set output 'plot.svg'

#set terminal qt size 1024,768 enhanced font 'Segoe UI,10' persist

set datafile separator ','
file = './data/data.2.csv'

set multiplot
set size 1, 0.33

set origin 0.0,0.66
set title 'L1'
plot file using 1:2 title 'Power (W)' with lines, \
     file using 1:3 title 'Voltage' with lines axis x1y2, \

set origin 0.0,0.33
set title 'L2'
plot file using 1:4 title 'Power (W)' with lines, \
     file using 1:5 title 'Voltage' with lines axis x1y2, \

set origin 0.0,0.0
set title 'L3'
plot file using 1:6 title 'Power (W)' with lines, \
     file using 1:7 title 'Voltage' with lines axis x1y2, \

