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

!do iplanet=1,nplanet
!      print*, 'Planet ', iplanet, 'currently located at cell ', iplanetrad(iplanet)
!      print*, 'Radius: ', rz(iplanetrad(iplanet))/AU
!      print*, 'Mass: ' , mp(iplanet)/mjup
!enddo

!
! calculate the mdot_gas for each planet
!

do iplanet=1,nplanet
   if (mp(iplanet)/mjup < 0.03) then
      mdotp_gas(iplanet) = 0.000175*(1./(0.2*0.2))*(kappa_m(iplanetrad(iplanet)))**(-1)*(mp_solid(iplanet)*300./mjup)**(11/3)*(mp_gas(iplanet)*300./mjup)**(-1)*(cs_m(iplanetrad(iplanet))*cs_m(iplanetrad(iplanet))*mu(iplanetrad(iplanet))*m_H/(gamma(iplanetrad(iplanet))*k_B*81))**(-0.5)
   else
      mdotp_gas(iplanet) = 0.14*omegaK(iplanetrad(iplanet))*sigma(iplanetrad(iplanet))*h**2
   endif
enddo

!
! Add mdot to each planet
!

do iplanet=1,nplanet
           
   ! Add the mass to each planet but only up to 6 M_jup (or gap openine limit)
   if(mp(iplanet)/mjup > 6.0) then
      mp_gas(iplanet) = mp_gas(iplanet) + mdotp_gas(iplanet)*dt
   else
      mp_gas(iplanet) = mp_gas(iplanet)
   endif

   mp(iplanet) = mp_solid(iplanet) + mp_gas(iplanet)
  
enddo

end subroutine planet_gas_accretion
