within Buildings.HeatTransfer.Windows.BaseClasses;
function convectionHorizontalCavity "Free convection in horizontal cavity"
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
  input Real sinTil "Sine of window tilt";
  input Real cosTil "Cosine of the window tilt";
  input Modelica.Units.SI.Area h(min=0) = 1.5 "Height of window";
  input Real deltaNu(min=0.01) = 0.1
    "Small value for Nusselt number, used for smoothing";
  input Real deltaRa(min=0.01) = 1E3
    "Small value for Rayleigh number, used for smoothing";
  output Real Nu(min=0) "Nusselt number";
  output Modelica.Units.SI.CoefficientOfHeatTransfer hCon(min=0)
    "Convective heat transfer coefficient";
  output Modelica.Units.SI.HeatFlux q_flow "Convective heat flux";
protected
  Real Nu_1(min=0) "Nusselt number";
  Real Nu_2(min=0) "Nusselt number";
  constant Real dx=0.1 "Half-width of interval used for smoothing";
algorithm
  if cosTil > 0 then
  Nu :=Buildings.Utilities.Math.Functions.spliceFunction(
    pos=
      Buildings.HeatTransfer.Windows.BaseClasses.nusseltHorizontalCavityReduced(
      gas=gas,
      Ra=Ra,
      T_m=T_m,
      dT=dT,
      h=h,
      sinTil=sinTil,
      deltaNu=deltaNu,
      deltaRa=deltaRa),
    neg=
      Buildings.HeatTransfer.Windows.BaseClasses.nusseltHorizontalCavityEnhanced(
      gas=gas,
      Ra=Ra,
      T_m=T_m,
      dT=dT,
      til=til,
      cosTil=abs(cosTil)),
    x=dT+dx,
    deltax=dx);
  else
    Nu :=Buildings.Utilities.Math.Functions.spliceFunction(
    pos=
      Buildings.HeatTransfer.Windows.BaseClasses.nusseltHorizontalCavityEnhanced(
      gas=gas,
      Ra=Ra,
      T_m=T_m,
      dT=dT,
      til=til,
      cosTil=abs(cosTil)),
    neg=
      Buildings.HeatTransfer.Windows.BaseClasses.nusseltHorizontalCavityReduced(
      gas=gas,
      Ra=Ra,
      T_m=T_m,
      dT=dT,
      h=h,
      sinTil=sinTil,
      deltaNu=deltaNu,
      deltaRa=deltaRa),
    x=dT-dx,
    deltax=dx);
  end if;
  hCon :=Nu*Buildings.HeatTransfer.Data.Gases.thermalConductivity(gas, T_m)/gas.x;
  q_flow :=hCon*dT;
    annotation (smoothOrder=1, Inline=true,
Documentation(info="<html>
<p>
Function for convective heat transfer in horizontal window cavity.
The computation is according to TARCOG 2006,
except that this implementation computes the convection coefficient
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
end convectionHorizontalCavity;
