within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function multipoleFluidTemperature "Fluid temperatures from multipole solution"
  extends Modelica.Icons.Function;

  input Integer nPip "Number of pipes";
  input Integer J "Number of multipoles";
  input Modelica.Units.SI.Position xPip[nPip] "x-Coordinates of pipes";
  input Modelica.Units.SI.Position yPip[nPip] "y-Coordinates of pipes";
  input Real QPip_flow[nPip](each unit="W/m") "Heat flow in pipes";
  input Modelica.Units.SI.Temperature TBor "Average borehole wall temperature";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.Radius rPip[nPip] "Outter radius of pipes";
  input Modelica.Units.SI.ThermalConductivity kFil
    "Thermal conductivity of grouting material";
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of soil material";
  input Real RFluPip[nPip](each unit="(m.K)/W") "Fluid to pipe wall thermal resistances";
  input Real eps=1.0e-5 "Iteration relative accuracy";
  input Integer it_max=100 "Maximum number of iterations";

  output Modelica.Units.SI.Temperature TFlu[nPip] "Fluid temperature in pipes";

protected
  Real pikFil(unit="(m.K)/W")=1/(2*Modelica.Constants.pi*kFil) "Coefficient based on grout thermal conductivity";
  Real sigma=(kFil - kSoi)/(kFil + kSoi) "Thermal conductivity ratio";
  Real betaPip[nPip]=2*Modelica.Constants.pi*kFil*RFluPip "Dimensionless fluid to outter pipe wall thermal resistance";
  Complex zPip_i "Position of pipe i";
  Complex zPip_j "Position of pipe j";
  Complex P_nj "Multipole of order j for pipe n";
  Real PRea[nPip,J] "Matrix of real part of multipoles";
  Real PIma[nPip,J] "Matrix of imaginary part of multipole";
  Complex P_nj_new "New value of multipole of order j for pipe n";
  Real PRea_new[nPip,J] "New value of real part of multipoles";
  Real PIma_new[nPip,J] "New value of imaginary part of multipoles";
  Complex F_mk "Coefficient F of order k of pipe m";
  Real FRea[nPip,J] "Real part of matrix F_mk";
  Real FIma[nPip,J] "Imaginary part of matrix F_mk";
  Real R0[nPip,nPip](each unit="(m.K)/W") "Line source approximation of thermal resistances";
  Complex deltaTFlu "Fluid temperature difference with line source approximation";
  Real rbm "Intermediate coefficient";
  Modelica.Units.SI.Distance dz "Pipe to pipe distance";
  Real coeff[nPip,J] "Coefficient for multiplication with matrix F_mk";
  Real diff "Difference in subsequent multipole evaluations";
  Real diff_max "Maximum difference in subsequent multipole evaluations";
  Real diff_min "Minimum difference in subsequent multipole evaluations";
  Real diff0 "Difference in subsequent multipole evaluations";
  Integer it "Iteration counter";
  Real eps_max "Convergence variable";

algorithm
  // Thermal resistance matrix from 0th order multipole
  for i in 1:nPip loop
    zPip_i := Complex(xPip[i], yPip[i]);
    rbm :=rBor^2/(rBor^2 - Modelica.ComplexMath.abs(zPip_i)^2);
    R0[i, i] := pikFil*(log(rBor/rPip[i]) + betaPip[i] + sigma*log(rbm));
    for j in 1:nPip loop
      zPip_j := Complex(xPip[j], yPip[j]);
      if i <> j then
        dz :=Modelica.ComplexMath.abs(zPip_i - zPip_j);
        rbm :=rBor^2/Modelica.ComplexMath.abs(rBor^2 - zPip_j*
          Modelica.ComplexMath.conj(zPip_i));
        R0[i, j] := pikFil*(log(rBor/dz) + sigma*log(rbm));
      end if;
    end for;
  end for;

  // Initialize maximum error and iteration counter
  eps_max := 1.0e99;
  it := 0;
  // Multipoles
  if J > 0 then
    for m in 1:nPip loop
      for k in 1:J loop
        coeff[m, k] := -(1 - k*betaPip[m])/(1 + k*betaPip[m]);
        PRea[m, k] := 0;
        PIma[m, k] := 0;
      end for;
    end for;
    while eps_max > eps and it < it_max loop
      it := it + 1;
      (FRea, FIma) :=
        Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleFmk(
        nPip,
        J,
        QPip_flow,
        PRea,
        PIma,
        rBor,
        rPip,
        xPip,
        yPip,
        kFil,
        kSoi);
      for m in 1:nPip loop
        for k in 1:J loop
          F_mk := Complex(FRea[m, k], FIma[m, k]);
          P_nj_new := coeff[m, k]*Modelica.ComplexMath.conj(F_mk);
          PRea_new[m, k] := Modelica.ComplexMath.real(P_nj_new);
          PIma_new[m, k] := Modelica.ComplexMath.imag(P_nj_new);
        end for;
      end for;
      diff_max := 0;
      diff_min := 1e99;
      for m in 1:nPip loop
        for k in 1:J loop
          P_nj := Complex(PRea[m, k], PIma[m, k]);
          P_nj_new := Complex(PRea_new[m, k], PIma_new[m, k]);
          diff_max :=max(diff_max, Modelica.ComplexMath.abs(P_nj_new - P_nj));
          diff_min :=min(diff_min, Modelica.ComplexMath.abs(P_nj_new - P_nj));
        end for;
      end for;
      diff := diff_max - diff_min;
      if it == 1 then
        diff0 :=diff;
      end if;
      eps_max := diff/diff0;
      PRea := PRea_new;
      PIma := PIma_new;
    end while;
  end if;

  // Fluid Temperatures
  TFlu := TBor .+ R0*QPip_flow;
  if J > 0 then
    for m in 1:nPip loop
      zPip_i :=Complex(xPip[m], yPip[m]);
      deltaTFlu := Complex(0, 0);
      for n in 1:nPip loop
        zPip_j :=Complex(xPip[n], yPip[n]);
        for j in 1:J loop
          P_nj := Complex(PRea[n, j], PIma[n, j]);
          if n <> m then
            // Second term
            deltaTFlu := deltaTFlu + P_nj*(rPip[n]/(zPip_i - zPip_j))^j;
          end if;
          // Third term
          deltaTFlu := deltaTFlu + sigma*P_nj*(rPip[n]*
            Modelica.ComplexMath.conj(zPip_i)/(rBor^2 - zPip_j*
            Modelica.ComplexMath.conj(zPip_i)))^j;
        end for;
      end for;
      TFlu[m] := TFlu[m] + Modelica.ComplexMath.real(deltaTFlu);
    end for;
  end if;

  annotation (Documentation(info="<html>
<p> This model evaluates the fluid temperatures using the multipole method of Claesson and Hellstrom (2011).
</p>
<h4>References</h4>
<p>J. Claesson and G. Hellstrom. 
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger. 
</i>
HVAC&amp;R Research,
17(6): 895-911, 2011.</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end multipoleFluidTemperature;
