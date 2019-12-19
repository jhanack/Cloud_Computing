#!/usr/bin/env python3
# Before running this script, install required Pythons package manager:
#   sudo apt update && sudo apt install -y python-pip
# Then install required packages:
#   pip install numpy matplotlib

import matplotlib.pyplot as plt
import matplotlib.dates as md
import numpy as np
import datetime as dt

def make_image(metric, data_names, data):
    ax = plt.gca()
    ax.boxplot(data)
    
    image_name = 'plot-' + metric + '.png'
    print("Plotting " + image_name)
    ax.set_xticklabels(data_names)
    plt.ylabel(metric)
    plt.savefig(image_name, bbox_inches='tight')
    plt.clf()

def load(platform):
    return np.loadtxt('results-{}.csv'.format(platform), delimiter=',', unpack=True, skiprows=1)

print("Loading data")
data_native = load('native')
data_docker = load('docker')
data_kvm = load('kvm')
data_qemu = load('qemu')

data_names = ['native', 'docker', 'kvm', 'qemu']
def get_data(index):
    return [data_native[index],  data_docker[index], data_kvm[index], data_qemu[index]]

make_image('cpu', data_names, get_data(1))
make_image('mem', data_names, get_data(2))
make_image('diskRand', data_names, get_data(3))
make_image('diskSeq', data_names, get_data(4))
make_image('fork', data_names, get_data(5))
make_image('uplink', data_names, get_data(6))
