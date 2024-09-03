within Buildings.HeatTransfer.Windows.BaseClasses;
function convectionVerticalCavity "Free convection in vertical cavity"
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
algorithm

  Nu_1 :=Buildings.Utilities.Math.Functions.spliceFunction(
    pos=0.0673838*Ra^(1/3),
    neg=Buildings.Utilities.Math.Functions.spliceFunction(
      pos=0.028154*Ra^(0.4134),
      neg=1 + 1.7596678E-10*Ra^(2.2984755),
      x=Ra - 1E4,
      deltax=deltaRa),
    x=Ra - 5E4,
    deltax=deltaRa);
  /*
  if ( Ra <= 1E4) then
    Nu_1 = 1 + 1.7596678E-10*Ra^(2.2984755);
  elseif ( Ra <= 5E4) then
    Nu_1 = 0.028154*Ra^(0.4134);
  else
    Nu_1 = 0.0673838*Ra^(1/3);
  end if;
  */
  Nu_2 :=0.242*(Ra/(h/gas.x))^(0.272);
  Nu :=Buildings.Utilities.Math.Functions.smoothMax(
    x1=Nu_1,
    x2=Nu_2,
    deltaX=deltaNu);
  hCon :=Nu*Buildings.HeatTransfer.Data.Gases.thermalConductivity(gas=gas, T=T_m)/gas.x;
  q_flow :=hCon*dT;
    annotation (smoothOrder=1, Inline=true,
Documentation(info="<html>
<p>
Function for convective heat transfer in vertical window cavity.
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
end convectionVerticalCavity;
