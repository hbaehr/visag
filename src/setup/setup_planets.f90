subroutine setup_planets
!
! Subroutine sets up planets to be added to disc
! Planet data read from separate input file
!
!

use gravdata
use planetdata
use unitdata

implicit none

integer :: iplanet

! Open planet file

open(10, file=planetfile,status='old')
! Read input data

read(10,*) nplanet

print*, 'There are ',nplanet, 'planets'
nactive = nplanet

allocate(mp(nplanet),ap(nplanet),alive(nplanet), iplanetrad(nplanet))
allocate(mp_gas(nplanet), mp_solid(nplanet))
allocate(lambdaI(nplanet,nmax), lambdaII(nplanet,nmax))
allocate(fII(nplanet))
allocate(adot(nplanet),tmig(nplanet),tmigI(nplanet))
allocate(torquei(nplanet,nmax), torque_term(nmax), total_planet_torque(nmax))
allocate(mdotp(nplanet))
allocate(mdotp_gas(nplanet), mdotp_solid(nplanet))


alive(:) = 1
mp(:) = 0.0
mp_gas(:) = 0.0
mp_solid(:) = 0.0
ap(:) = 0.0
iplanetrad(:) = 0

lambdaII(:,:) = 0.0
lambdaI(:,:) = 0.0
fII(:) = 0.0
adot(:) = 0.0
tmig(:) = 0.0
tmigI(:) = 0.0
torquei(:,:) = 0.0
total_planet_torque(:) = 0.0
mdotp(:) = 0.0
mdotp_gas(:) = 0.0
mdotp_solid(:) = 0.0

!do iplanet=1,nplanet
!   read(10,*) mp(iplanet), ap(iplanet)
!enddo

do iplanet=1,nplanet
   read(10,*) mp_solid(iplanet), mp_gas(iplanet), ap(iplanet)
   mp(iplanet) = mp_solid(iplanet) + mp_gas(iplanet)
enddo

! Convert to correct units
mp(:) = mp(:)*mjup

mp_solid(:) = mp_solid(:)*mjup
mp_gas(:) = mp_gas(:)*mjup
ap(:) = ap(:)*AU

call find_planets_in_disc

do iplanet=1,nplanet
      print*, 'Planet ', iplanet, 'initially located at cell ', iplanetrad(iplanet)
      print*, 'Radius: ', rz(iplanetrad(iplanet))/AU
      print*, 'Gas Mass: ' , mp_gas(iplanet)/mjup
      print*, 'Solid Mass: ' , mp_solid(iplanet)/mjup
enddo

end subroutine setup_planets
