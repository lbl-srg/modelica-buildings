within Buildings.HeatTransfer.Windows.BaseClasses;
function nusseltHorizontalCavityEnhanced
  "Nusselt number for horizontal cavity, bottom surface warmer than top surface"
  extends Modelica.Icons.Function;

  input Buildings.HeatTransfer.Data.Gases.Generic gas
    "Thermophysical properties of gas fill"
   annotation(choicesAllMatching=true);
  input Real Ra(min=0) "Rayleigh number";
  input Modelica.Units.SI.Temperature T_m
    "Temperature used for thermophysical properties";
  input Modelica.Units.SI.TemperatureDifference dT
    "Temperature difference used to compute q_flow = h*dT";
  input Modelica.Units.SI.Angle til "Window tilt";
  input Real cosTil(min=0) "Cosine of the window tilt";
  output Real Nu(min=0) "Nusselt number";
protected
  Real k1 "Auxiliary variable";
  Real k2 "Auxiliary variable";
  Real k11 "Auxiliary variable";
  Real k22 "Auxiliary variable";
algorithm
  // Windows inclined from 0 to 60 deg (eqn. 3.1-42 to 3.1-43)
  k1 :=1 - 1708/Ra/cosTil;
  k2 :=(Ra*cosTil/5830)^(1/3) - 1;
  k11 :=(k1 + Buildings.Utilities.Math.Functions.smoothMax(
    x1=k1,
    x2=-k1,
    deltaX=1E-1))/2;
  k22 :=(k2 + Buildings.Utilities.Math.Functions.smoothMax(
    x1=k2,
    x2=-k2,
    deltaX=1E-1))/2;
  Nu :=1 + 1.44*k11*(1 - 1708*abs(Modelica.Math.sin(1.8*til*180/Modelica.Constants.pi))
    ^(1.6)/Ra/cosTil) + k22;
    annotation (smoothOrder=1, Inline=true,
Documentation(info="<html>
<p>
Function for Nusselt number in horizontal window cavity.
The computation is according to TARCOG 2006,
except that this implementation computes the Nusselt number
as a function that is differentiable in the temperatures.
</p>
<h4>References</h4>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
December 9, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end nusseltHorizontalCavityEnhanced;
