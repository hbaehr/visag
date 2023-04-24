subroutine planet_gas_accretion
!
! Subroutine adds gas accretion to each planet
!

use planetdata
use gravdata
use unitdata
!use 

implicit none

integer :: iplanet,i
!real :: hp, aspectratio,mdiscmig
real :: planet_bondi_rad
real :: runaway_mass, thermal_mass, atmos_core_ratio
real :: mdot

!hp = cs(iplanetrad(iplanet))/omegaK(iplanetrad(iplanet))
!aspectratio = hp/ap(iplanet)


!do iplanet=1,nplanet
!      print*, 'Planet ', iplanet, 'currently located at cell ', iplanetrad(iplanet)
!      print*, 'Radius: ', rz(iplanetrad(iplanet))/AU
!      print*, 'Mass: ' , mp(iplanet)/mjup
!enddo

!
! calculate the mdot_gas for each planet
!

do iplanet=1,nplanet

   !
   ! calculate mass threshold for gas accretion Piso & Youdin 2014,2015
   !
   runaway_mass = 18.8*1/(sqrt(sqrt(ap(iplanet)*ap(iplanet)*ap(iplanet)))) * 318./mjup! 2.4 (r/50au)**(-.75)
   thermal_mass = cs(iplanetrad(iplanet))*cs(iplanetrad(iplanet))*cs(iplanetrad(iplanet)) / (G*omegaK(iplanetrad(iplanet)))
   atmos_core_ratio = mp_gas(iplanet)/mp_solid(iplanet)
   
   if (mp(iplanet) < runaway_mass .and. atmos_core_ratio < 1.) then
      mdotp_gas(iplanet) = 0.0
   elseif (mp(iplanet) > runaway_mass .and. atmos_core_ratio < 1.) then
      mdot = 0.000175*(1./(0.2*0.2))*(kappa(iplanetrad(iplanet)))**(-1)*(mp_solid(iplanet)*&
           318./mjup)**(11/3)*(mp_gas(iplanet)*318./mjup)**(-1)*(cs(iplanetrad(iplanet))*&
           cs(iplanetrad(iplanet))*mu(iplanetrad(iplanet))*m_H/(gamma(iplanetrad(iplanet))*k_B*81))**(-0.5)
      mdotp_gas(iplanet) = mdot*(mjup/318.)/(3E7*1000000) ! converting to cgs units from MEarth/Myr
      !mdotp_gas(iplanet) = 0.0
   elseif (atmos_core_ratio > 1.) then
      !mdotp_gas(iplanet) = 0.14*omegaK(iplanetrad(iplanet))*sigma(iplanetrad(iplanet))*h**2
      planet_bondi_rad = G * mp(iplanet) / (cs(iplanetrad(iplanet))*cs(iplanetrad(iplanet)))
      mdotp_gas(iplanet) = sigma(iplanetrad(iplanet)) / (cs(iplanetrad(iplanet))/omegaK(iplanetrad(iplanet))) *&
           pi * omegaK(iplanetrad(iplanet)) * (planet_bondi_rad*planet_bondi_rad*planet_bondi_rad)
   endif
enddo

!
! Add mdot to each planet
!

do iplanet=1,nplanet
           
   ! Add the mass to each planet but only up to 6 M_jup (or gap openine limit)
   if(mp(iplanet)/mjup < 6.0) then
      mp_gas(iplanet) = mp_gas(iplanet) + mdotp_gas(iplanet)*dt
   else
      mp_gas(iplanet) = mp_gas(iplanet)
   endif

   mp(iplanet) = mp_solid(iplanet) + mp_gas(iplanet)
  
enddo

end subroutine planet_gas_accretion
