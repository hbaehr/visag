  SUBROUTINE midplane_properties_grav(tauplus)
! Routine calculates state properties of the self-gravitating disc (layer)
! tauplus is passed in case there is extra optical depth above the layer

  use gravdata
  use unitdata

    implicit none
    
    real,dimension(nmax) :: tauplus
    real(kind=8) :: twoDint,fine,oldtry
    real(kind=8) :: rho, Teff,Qfactor
    integer :: i

    coolfunc(:) = 0.0

!$OMP PARALLEL &
  !$OMP shared(isr,ier,cs,sigma,kappa,mu,gamma,omegaK)&
  !$OMP shared(Tc,tau,nu_tc,tcool,T_source,alpha_g)&
  !$OMP shared(tauplus) &
  !$OMP private(H,rho,coolfunc,Teff,twoDint,i)
  !$OMP DO SCHEDULE(runtime)
  do i = isr, ier

     omegaK(i) = Sqrt(G*mstar/rz(i)**3.0d0)

     IF(Tc(i) < T_source(i)) Tc(i) = T_source(i)
     cs(i) = gamma(i)*k_B*Tc(i)/(mu(i)*m_H)

     cs(i) = sqrt(cs(i))
     H(i) = cs(i)/omegaK(i)

     IF(H(i)>1.0e-30) THEN
        rho = 0.5d0*sigma(i)/H(i)
     ELSE
        rho = 0.0
     ENDIF


     !	Interpolate over rho,T to get cs,kappa, mu, gamma

     IF(rho>=1.0e-25) THEN

        call eos_T(rho,cs(i),Tc(i),kappa(i),mu(i),gamma(i),cp(i))
        
        ! Calculate Q
        Q(i) = cs(i)*omegaK(i)/(pi*G*sigma(i))

        ! Now calculate cooling time
        tau(i) = kappa(i)*sigma(i) + tauplus(i)

        ! Cooling function for disc
        coolfunc(i) = 16.0d0/3.0d0*stefan*(Tc(i)**4.0d0-T_source(i)**4.0d0)
        coolfunc(i) = coolfunc(i)*tau(i)/(1.0d0+tau(i)**2.0d0)

        Teff = Tc(i)**4.0d0*tau(i)/(1.0d0+tau(i)**2.0d0)
        Teff = Teff**0.25d0

        twoDint = cs(i)**2.0*sigma(i)/gamma(i)/(gamma(i)-1.0d0)

        If (coolfunc(i).ne.0.0d0) Then
           tcool(i) = twoDint/coolfunc(i)
        Else
           tcool(i) = 1.0d35
        EndIf

     ELSE
        Tc(i) = 0.0
        cs(i) = 0.0
        kappa(i) = 0.0
        mu(i) = 0.0
        gamma(i) = 0.0
        tcool(i) = 1.0d35
        coolfunc(i) = 0.0
     ENDIF

if(gamma(i)>1.000001) then
   alpha_g(i) =  9.0d0/4.0d0*gamma(i)*(gamma(i)-1.0)*tcool(i)*omegaK(i)
   alpha_g(i) =  1.0d0/alpha_g(i)

else if (alpha_g(i) .lt. 1.0d-12.or.gamma(i)<1.00001) THEN
   alpha_g(i) = 1.0d-12

endif

! Modify alpha so that only effective in self-gravitating regions

Qfactor = exp(-Q(i)/Qcrit)
if(Qfactor>1.0) Qfactor = 1.0

alpha_g(i) = alpha_g(i)*Qfactor

nu_tc(i) = alpha_g(i)*cs(i)*cs(i)/omegaK(i)

  enddo
  !$OMP END DO
  !$OMP END PARALLEL

return

END SUBROUTINE midplane_properties_grav
