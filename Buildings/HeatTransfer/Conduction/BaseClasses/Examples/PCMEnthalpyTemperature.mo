within Buildings.HeatTransfer.Conduction.BaseClasses.Examples;
model PCMEnthalpyTemperature
  "Approximation of Enthalpy-Temperature curve with Hermite cubic spline"
  extends Modelica.Icons.Example;
  //Phase-change properties - problem dependent;
  parameter Modelica.SIunits.Temperature TSol=273.15+30.9 "Solidus temperature";
  parameter Modelica.SIunits.Temperature TLiq=273.15+40.0 "Liquidus temperature";
  parameter Modelica.SIunits.SpecificInternalEnergy LHea=1000000 "Latent heat";
  parameter Modelica.SIunits.SpecificHeatCapacity c=920 "Specific heat capacity";
  //Temperature values;
  parameter Modelica.SIunits.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSup](each fixed=false)
    "Support points";
  parameter Modelica.SIunits.Temperature Td[Buildings.HeatTransfer.Conduction.nSup](each fixed=false)
    "Support points";
public
  parameter Real scale=0.999
    "Scale used to position the points 1,3,4 and 6 while T2=TSol and T5=TLiq";
  parameter Real dT_du[Buildings.HeatTransfer.Conduction.nSup](fixed=false, unit="kg.K2/J")
    "Derivatives at the support points - NonMonotone, default in Modelica PCM";
  parameter Real[Buildings.HeatTransfer.Conduction.nSup] dT_duMonotone(fixed=false, unit="kg.K2/J")
    "Derivatives at the support points - Monotone";
  Modelica.SIunits.SpecificInternalEnergy u "Simulated value of specific internal energy";
  Modelica.SIunits.Temperature T
    "Temperature calculated for given u value without monotone interpolation of derivatives";
  Modelica.SIunits.Temperature TMonotone
    "Temperature calculated for given u value with monotone interpolation of derivatives";
  Real errMonotone
    "Relative temperature error between calculated value with monotone interpolation and exact temperature";
  Real errNonMonotone
    "Relative temperature error between calculated value with non-monotone interpolation and exact temperature";
  Integer i "Integer to select data interval";
protected
  constant Real conFac(unit="1/s") = 1 "Conversion factor to satisfy unit check";  
initial algorithm
  // Calculates derivatives at support points (non-monotone)
  (ud, Td, dT_du) :=
    Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u(
    TSol=TSol,
    TLiq=TLiq,
    LHea=LHea,
    c=c,
    ensureMonotonicity=false);
  // Calculates derivatives at support points (monotone);
 (ud, Td, dT_duMonotone) :=
    Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u(
    TSol=TSol,
    TLiq=TLiq,
    LHea=LHea,
    c=c,
    ensureMonotonicity=true);

equation
  // Simulation of u value in the relevant range
  u =  time*(c*(TSol+TLiq)+LHea)*conFac;

algorithm
  // i is a counter that is used to pick the derivative of d or dMonotonic
  // that correspond to the interval that contains u
  i := 1;
  for j in 1:size(ud, 1) - 1 loop
    if u > ud[j] then
      i := j;
    end if;
  end for;
  // Calculate T based on non-monotone interpolation
  T := Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u(
       ud=ud,
       Td=Td,
       dT_du=dT_du,
       u=u);
  // Calculate T based on monotone interpolation
  TMonotone := Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u(
       ud=ud,
       Td=Td,
       dT_du=dT_duMonotone,
       u=u);
  //Relative errors of obtained temperatures by using monotone and non-monotone
  //interpolation against exact values of tempratures taken from the u-T curve;
  if time>=1.e-05 then
    if u <= c*TSol then
      errNonMonotone := (T-(u/c))/(u/c);
      errMonotone := (TMonotone-(u/c))/(T/c);
    elseif u >= c*TLiq+LHea then
      errNonMonotone := (T-((u-LHea)/c))/((u-LHea)/c);
      errMonotone := (TMonotone-((u-LHea)/c))/((u-LHea)/c);
    else
      errNonMonotone := (T-((u+LHea*TSol/(TLiq-TSol))/(c+LHea/(TLiq-TSol))))/
        ((u+LHea*TSol/(TLiq-TSol))/(c+LHea/(TLiq-TSol)));
      errMonotone := (TMonotone-((u+LHea*TSol/(TLiq-TSol))/(c+LHea/(TLiq-TSol))))/
        ((u+LHea*TSol/(TLiq-TSol))/(c+LHea/(TLiq-TSol)));
    end if;
  else
    errMonotone := 0;
    errNonMonotone := 0;
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Conduction/BaseClasses/Examples/PCMEnthalpyTemperature.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p> fixme: review documentation.

This example demonstrates the implementation of the specific internal 
energy-temperature (u-T) relationship for phase-change problems. Hermite 
cubic spline interpolation and linear extrapolation is used to approximate 
the u-T dependency. By default settings in Building library, a linear 
u-T relationship in all three chracteristic regions is assumed (solid, mushy and liquid).
The example uses the der_temperature_u and temeprature_u functions designed
for phase change problems in which the first function is used for calculation 
of derivatives at prescribed points and the second function returns the temeprature 
for given specific internal energy values. Default settings for phase-change problems
in Buildings library is applicable for
cases in which phase-change occurs in finite temperature interval between TSol and 
TLiq with linear u-T relationship. In case of isothermal phase-change materials again
TLiq hase to be larger than Tsol but this 
temperature difference can be set on arbitrary small value (1.E-02 or even smaller).  
</p>
<p>
The example demonstrates also the use of Hermite cubic spline interpolation with 
two different settings: One produces a monotone cubic hermite, whereas the other 
does not enforce monotonicity. The latter one is used as default in
Modelica phase-change model, since it produces better approximation in the mushy
region, especially for materials in which phase-change trasformation occurs in wide
temperature interval (see the figure below). Curves errNonMonotone and 
errMonotone represent the relative error between approximated and exact temperatures 
obtained for different enthalpy values (right hand side figure).
This example can be used to fit the u-T curve for non-linear u-T 
relationship (some real phase-change materials) before it is implemented in 
function der_temperature_u.   
</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Conduction/BaseClasses/Examples/PCMEnthalpyTemperature.png\"/>
</p>
</html>"));
end PCMEnthalpyTemperature;
