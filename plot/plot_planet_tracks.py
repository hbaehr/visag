# Written 28/3/18 by dh4gan
# Reads all planets files and computes semimajor axis evolution

import io_disc as io
import filefinder as ff
import matplotlib.pyplot as plt
from numpy import amax,amin

prefix = ff.get_file_prefix('*.log')

time, nplanet,active,ap, mp,tmig = io.obtain_planet_tracks(prefix)

# Semimajor axis
fig1 = plt.figure()
ax1 = fig1.add_subplot(111)

ax1.set_ylim(amin(ap[:,:])*0.9,amax(ap[:,:])*1.1)

for i in range(nplanet):
    ax1.plot(time,ap[i,:], label='Planet '+str(i+1), linewidth=2)

ax1.spines['top'].set_linewidth(2)
ax1.spines['bottom'].set_linewidth(2)
ax1.spines['left'].set_linewidth(2)
ax1.spines['right'].set_linewidth(2)
ax1.tick_params(axis='both', which='major', length=4, width=2)
ax1.tick_params(axis='both', which='minor', length=3, width=1.5)
    
ax1.set_ylabel('Semimajor axis (AU)',fontsize=22)
ax1.set_xlabel('Time (yr)',fontsize=22)
ax1.legend()



# Migration Timescale
fig2 = plt.figure()
ax2 = fig2.add_subplot(111)

ax2.set_ylim(amin(abs(tmig[:,:]))*0.9,amax(abs(tmig[:,:]))*1.1)
#ax2.set_yscale('log')

for i in range(nplanet):
    ax2.plot(time,abs(tmig[i,:]), label='Planet '+str(i+1), linewidth=2)

ax2.spines['top'].set_linewidth(2)
ax2.spines['bottom'].set_linewidth(2)
ax2.spines['left'].set_linewidth(2)
ax2.spines['right'].set_linewidth(2)
ax2.tick_params(axis='both', which='major', length=4, width=2)
ax2.tick_params(axis='both', which='minor', length=3, width=1.5)
    
ax2.set_ylabel('Migration Timescale (yr)',fontsize=22)
ax2.set_xlabel('Time (yr)',fontsize=22)
ax2.set_yscale('log')
ax2.legend()



# Planet mass
fig3 = plt.figure()
ax3 = fig3.add_subplot(111)

ax3.set_ylim(amin(abs(mp[:,:]))*0.9,amax(abs(mp[:,:]))*1.1)
ax3.set_yscale('log')

for i in range(nplanet):
    ax3.plot(time,abs(mp[i,:]), label='Planet '+str(i+1), linewidth=2)

ax3.spines['top'].set_linewidth(2)
ax3.spines['bottom'].set_linewidth(2)
ax3.spines['left'].set_linewidth(2)
ax3.spines['right'].set_linewidth(2)
ax3.tick_params(axis='both', which='major', length=4, width=2)
ax3.tick_params(axis='both', which='minor', length=3, width=1.5)
    
ax3.set_ylabel(r'Planet Mass ($M_{Jup}$)',fontsize=22)
ax3.set_xlabel('Time (yr)',fontsize=22)
ax3.set_yscale('log')
ax3.legend()



# Evolution tracks
fig4 = plt.figure()
ax4 = fig4.add_subplot(111)

ax4.set_ylim(amin(abs(mp[:,:]))*0.9,amax(abs(mp[:,:]))*1.1)
#ax4.set_xlim(amin(ap[:,:])*0.9,amax(ap[:,:])*1.1)
ax4.set_yscale('log')

for i in range(nplanet):
    ax4.plot(ap[i,:],abs(mp[i,:]), label='Planet '+str(i+1), linewidth=2)

ax4.spines['top'].set_linewidth(2)
ax4.spines['bottom'].set_linewidth(2)
ax4.spines['left'].set_linewidth(2)
ax4.spines['right'].set_linewidth(2)
ax4.tick_params(axis='both', which='major', length=4, width=2)
ax4.tick_params(axis='both', which='minor', length=3, width=1.5)

ax4.set_ylabel(r'Planet Mass ($M_{Jup}$)',fontsize=22)
ax4.set_xlabel('Radius (AU)',fontsize=22)
ax4.set_yscale('log')
ax4.legend()



plt.show()
