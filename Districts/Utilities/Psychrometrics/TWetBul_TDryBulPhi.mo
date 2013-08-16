within Districts.Utilities.Psychrometrics;
block TWetBul_TDryBulPhi
  "Model to compute the wet bulb temperature based on relative humidity"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
                                                            annotation (
      choicesAllMatching = true);

  parameter Boolean approximateWetBulb=false
    "Set to true to approximate wet bulb temperature" annotation (Evaluate=true);
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    start=303,
    final quantity="Temperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}},rotation=
            0)));

  Modelica.Blocks.Interfaces.RealInput phi(min=0, max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},
          rotation=0)));

  Modelica.Blocks.Interfaces.RealInput p(  final quantity="Pressure",
                                           final unit="Pa",
                                           min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}},
                                                                       rotation=
           0)));

  Modelica.Blocks.Interfaces.RealOutput TWetBul(
    start=293,
    final quantity="Temperature",
    final unit="K",
    min=0) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));

protected
  constant Modelica.Media.IdealGases.Common.DataRecord dryair = Modelica.Media.IdealGases.Common.SingleGasesData.Air;
  constant Modelica.Media.IdealGases.Common.DataRecord steam = Modelica.Media.IdealGases.Common.SingleGasesData.H2O;
  constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";
  Real rh_per(min=0) "Relative humidity in percentage";
  Modelica.SIunits.MassFraction XiDryBul
    "Water vapor mass fraction at dry bulb state";
  Modelica.SIunits.MassFraction XiSat "Water vapor mass fraction at saturation";
  constant Modelica.SIunits.SpecificHeatCapacity cpAir=
     Buildings.Media.PerfectGases.Common.SingleGasData.Air.cp
    "Specific heat capacity of air";
  constant Modelica.SIunits.SpecificHeatCapacity cpSte=
     Buildings.Media.PerfectGases.Common.SingleGasData.H2O.cp
    "Specific heat capacity of water vapor";
  constant Modelica.SIunits.SpecificEnthalpy h_fg = 2501014.5
    "Specific heat capacity of water vapor";
equation
  if approximateWetBulb then
    TDryBul_degC = TDryBul - 273.15;
    rh_per       = 100*phi;
    TWetBul      = 273.15 + TDryBul_degC
       * Modelica.Math.atan(0.151977 * sqrt(rh_per + 8.313659))
       + Modelica.Math.atan(TDryBul_degC + rh_per)
       - Modelica.Math.atan(rh_per-1.676331)
       + 0.00391838 * rh_per^(1.5) * Modelica.Math.atan( 0.023101 * rh_per)  - 4.686035;
    XiSat    = 0;
    XiDryBul = 0;
  else
    XiSat   = Districts.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=   Medium.saturationPressureLiquid(Tsat=TWetBul),
      p=     p,
      phi=   1);
    XiDryBul =Districts.Utilities.Psychrometrics.Functions.X_pSatpphi(
      p=p,
      pSat=Medium.saturationPressureLiquid(Tsat=TDryBul),
      phi=phi);
    TWetBul = (TDryBul * ((1-XiDryBul) * cpAir + XiDryBul * cpSte) + (XiDryBul-XiSat) * h_fg)/
            ( (1-XiSat)*cpAir + XiSat * cpSte);
    TDryBul_degC = 0;
    rh_per       = 0;
  end if;

annotation (
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
          graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-22,-94},{18,-56}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,44},{10,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,44},{-14,84},{-12,90},{-8,92},{-2,94},{4,92},{8,90},{10,
              84},{10,44},{-14,44}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,44},{-14,-60}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,44},{10,-60}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-42,-16},{-14,-16}}, color={0,0,0}),
        Line(points={{-42,24},{-14,24}}, color={0,0,0}),
        Line(points={{-42,64},{-14,64}}, color={0,0,0}),
        Text(
          extent={{-92,100},{-62,56}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Text(
          extent={{-86,14},{-54,-14}},
          lineColor={0,0,127},
          textString="phi"),
        Text(
          extent={{-90,-72},{-72,-90}},
          lineColor={0,0,127},
          textString="p"),
        Text(
          extent={{62,22},{92,-22}},
          lineColor={0,0,127},
          textString="TWetBul")}),
    defaultComponentName="wetBul",
    Documentation(info="<html>
<p>
This block computes the the wet bulb temperature for a given dry bulb temperature, relative air humidity
and atmospheric pressure.
</p>
<p>
If the constant <code>approximateWetBulb</code> is <code>true</code>,
then the block uses the approximation of Stull (2011) to compute
the wet bulb temperature without requiring a nonlinear equation.
Otherwise, the model will introduce one nonlinear equation.
</p>
<p>
The approximation by Stull is valid for a relative humidity of <i>5%</i> to <i>99%</i>,
a temperature range from <i>-20&circ;C</i> to <i>50&circ;C</i> 
and standard sea level pressure. 
For this range of data, the approximation error is <i>-1</i> Kelvin to <i>+0.65</i> Kelvin,
with a mean error of less than <i>0.3</i> Kelvin.
</p>
<p>
For a model that takes the mass fraction instead of the relative humidity as an input, see
<a href=\"modelica://Districts.Utilities.Psychrometrics.TWetBul_TDryBulXi\">
Districts.Utilities.Psychrometrics.TWetBul_TDryBulXi</a>.
</p>
<h4>References</h4>
<p>
Stull, Roland.
<i><a href=\"http://dx.doi.org/10.1175/JAMC-D-11-0143.1\">
Wet-Bulb Temperature from Relative Humidity and Air Temperature
Roland Stull.</a></i>
Journal of Applied Meteorology and Climatology.
Volume 50, Issue 11, pp. 2267-2269. November 2011 
DOI: 10.1175/JAMC-D-11-0143.1
</p>
</html>
",
revisions="<html>
<ul>
<li>
October 1, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TWetBul_TDryBulPhi;
