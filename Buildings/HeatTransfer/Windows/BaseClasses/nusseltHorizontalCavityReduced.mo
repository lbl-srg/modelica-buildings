within Buildings.HeatTransfer.Windows.BaseClasses;
function nusseltHorizontalCavityReduced
  "Nusselt number for horizontal cavity, bottom surface colder than top surface"
  extends Modelica.Icons.Function;

  input Buildings.HeatTransfer.Data.Gases.Generic gas
    "Thermophysical properties of gas fill"
   annotation(choicesAllMatching=true);
  input Real Ra(min=0) "Rayleigh number";
  input Modelica.Units.SI.Temperature T_m
    "Temperature used for thermophysical properties";
  input Modelica.Units.SI.TemperatureDifference dT
    "Temperature difference used to compute q_flow = h*dT";
  input Modelica.Units.SI.Area h(min=0) = 1.5 "Height of window";
  input Real sinTil "Sine of window tilt";
  input Real deltaNu(min=0.01) = 0.1
    "Small value for Nusselt number, used for smoothing";
  input Real deltaRa(min=0.01) = 1E3
    "Small value for Rayleigh number, used for smoothing";
  output Real Nu(min=0) "Nusselt number";
protected
  Real NuVer(min=0) "Nusselt number for vertical window";
algorithm
  NuVer :=Buildings.HeatTransfer.Windows.BaseClasses.convectionVerticalCavity(
    gas=gas,
    Ra=Ra,
    T_m=T_m,
    dT=dT,
    h=h,
    deltaNu=deltaNu,
    deltaRa=deltaRa);
  Nu :=1 + (NuVer - 1)*sinTil;

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
end nusseltHorizontalCavityReduced;
