within Buildings.Fluid.HeatExchangers.BaseClasses;
function cpSat "Fictious heat capacity along saturation line"

  annotation (preferedView="info",
              smoothOrder=1,
Documentation(info="<html>
This function computes the specific heat capacity along the saturation line.
For a given temperature <code>T1</code> it computes its saturation enthalpy <code>h1</code>.
Next, for a given species concentration <code>X2</code>, it computes the
saturation temperature <code>T2</code> and the enthalpy <code>h2(T2, X2)</code>.
It then computes the specific heat capacity as<pre>
        h2 - h1
  cp = --------
        T2 - T1
</pre>
<p>
The pressure is an optional input, which is by default the atmospheric pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 18, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
 input Modelica.SIunits.Temperature T1 "Temperature medium 1";
 input Modelica.SIunits.MassFraction XW2 "Water mass fraction of medium 2";
 input Modelica.SIunits.Pressure p=101325 "Total pressure";
 output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
protected
 constant Real epsilon = 10e-10 "Small number to avoid division by zero";
 Modelica.SIunits.Pressure pW2(nominal=100) "Water vapor pressure";
 Modelica.SIunits.Temperature Tdp2 "Dew point temperature of XW2";
 Modelica.SIunits.SpecificEnthalpy hdp2 "Specific enthalpy of XW2 at dew point";
 Modelica.SIunits.Temperature TSat1 "Saturation temperature of medium 1";
 Modelica.SIunits.MassFraction XSat1
    "Species concentration at saturation and T1";
 Modelica.SIunits.SpecificEnthalpy hSat1
    "Specific enthalpy at saturation and T1";
 Modelica.SIunits.TemperatureDifference dT "Temperature difference";
algorithm
  pW2   :=Buildings.Utilities.Psychrometrics.Functions.pW_X(X_w=XW2, p=p);
  Tdp2  :=Buildings.Utilities.Psychrometrics.Functions.Tdp_pW(p_w=pW2);
  hdp2  :=Modelica.Media.Air.MoistAir.h_pTX(
    p=p,
    T=Tdp2,
    X={XW2, 1 - XW2});
  dT  :=T1 - Tdp2;
  if (abs(dT) < epsilon) then
    if dT>0 then
        TSat1:=Tdp2 + epsilon;
    else
        TSat1:=Tdp2 - epsilon;
    end if;
  else
        TSat1:=T1;
  end if;
  XSat1 :=Modelica.Media.Air.MoistAir.Xsaturation(Modelica.Media.Air.MoistAir.setState_pTX(
    p=p,
    T=TSat1,
    X={0, 1}));
  hSat1 :=Modelica.Media.Air.MoistAir.h_pTX(
    p=p,
    T=TSat1,
    X={XSat1, 1 - XSat1});
  cp :=(hSat1 - hdp2)/(TSat1 - Tdp2);
end cpSat;
