subroutine planet_accretion
!
! Subroutine uses the pebble accretion rate to add mass
! to each planet
!

use planetdata
use gravdata
use unitdata
!use 

implicit none

integer :: iplanet,i
logical :: polydisperse = .false.
!real :: poly_factor                                                                                                                                        

!do iplanet=1,nplanet
!      print*, 'Planet ', iplanet, 'currently located at cell ', iplanetrad(iplanet)
!      print*, 'Radius: ', rz(iplanetrad(iplanet))/AU
!      print*, 'Mass: ' , mp(iplanet)/mjup
!enddo

!
! calculate the mdot for each planet
!

!
! calculate the polydisperse factor in the Bondi or Hill regime
!
!poly_factor =

! use monodisperse or polydisperse pebble accretion (Lyra et al. 2023)
do iplanet=1,nplanet
   if (polydisperse .eqv. .true.) then ! Not yet implemented
      mdotp(iplanet) = 0.0
   else
      !mdotp(iplanet) = 0.0
      mdotp(iplanet) = 2*(pebble_size*pebble_size*100)**(1./real (3))*ap(iplanet)*ap(iplanet)*(mp(iplanet)/ &
        (3*mstar))**(2./real (3))*(omegaK(iplanetrad(iplanet)))*sigma(iplanetrad(iplanet))*metallicity*pebble_fraction
   endif
enddo


!
! Add mdot to each planet
!

do iplanet=1,nplanet  
           
   ! Add the mass to each planet but only up to 20 M_Earth (or pebble isolation mass)
   if(mp(iplanet)/mjup < 0.0666) then
      mp(iplanet) = mp(iplanet) + mdotp(iplanet)*dt
   else
      mp(iplanet) = mp(iplanet)
   endif
  
enddo

end subroutine planet_accretion
