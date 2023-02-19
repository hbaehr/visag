module planetdata
! Contains all data relating to planets inside the disc

  real, parameter :: tdelay_planettorque = 1.0 ! Time delay for torques to activate in disc (years)

  ! Variables
  integer :: nplanet, nactive
  
  real(kind=8) :: rremove, p_create
  character(100) :: planetfile
  character(1) :: planetchoice, pebblechoice, gasaccretion

  ! Arrays
  integer, allocatable,dimension(:)  :: alive, iplanetrad
  real, allocatable, dimension(:)  :: mp,ap, total_planet_torque, torque_term
  real, allocatable, dimension(:) :: mp_gas, mp_solid
  real, allocatable, dimension(:) :: adot,tmig,tmigI, fII
  real, allocatable, dimension(:,:) :: lambdaI, lambdaII
  real, allocatable, dimension(:,:) :: torquei
  real, allocatable, dimension(:) :: mdotp, mdotp_gas, mdotp_solid
  real :: metallicity, pebble_fraction, pebble_size

end module planetdata
 
