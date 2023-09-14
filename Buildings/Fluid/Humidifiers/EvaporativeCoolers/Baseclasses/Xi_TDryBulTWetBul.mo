within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block Xi_TDryBulTWetBul
  "Compute the water vapor mass fraction"

  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model"
    annotation (choicesAllMatching = true);

  parameter Boolean approximateWetBulb=false
    "Set to true to approximate wet bulb temperature"
    annotation (Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput TDryBul(
    start=303,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput p(
    final quantity="Pressure",
    final unit="Pa",
    min = 0)
    "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealInput TWetBul(
    start=293,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0)
    "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealOutput Xi[Medium.nXi]
    "Water vapor mass fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  parameter Integer iWat = sum({(
  if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i], string2="Water", caseSensitive=false)
  then i else 0) for i in 1:Medium.nX})
    "Index of water in medium composition vector";

  constant Real uniCon1(final unit="1/rad") = 1
    "Constant to satisfy unit check";
  constant Real uniConK(final unit="K/rad") = 1
    "Constant to satisfy unit check";

  Modelica.Units.NonSI.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";

  Real rh_per(min=0)
    "Relative humidity in percentage";

  Modelica.Units.SI.MassFraction XiSat(start=0.01, nominal=0.01)
    "Water vapor mass fraction at saturation";

  Modelica.Units.SI.MassFraction XiSatRefIn
    "Water vapor mass fraction at saturation, referenced to inlet mass flow rate";

initial equation
  assert(iWat > 0, "Did not find medium species 'water' in the medium model. Change medium model.");

equation
  if approximateWetBulb then
    TDryBul_degC = TDryBul - 273.15;
    rh_per       = 100 * p/
         Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TDryBul)
         *Xi[iWat]/(Xi[iWat] +
         Buildings.Utilities.Psychrometrics.Constants.k_mair*(1-Xi[iWat]));
    TWetBul      = 273.15 + uniCon1 * TDryBul_degC
       * Modelica.Math.atan(0.151977 * sqrt(rh_per + 8.313659))
       + uniConK * ( Modelica.Math.atan(TDryBul_degC + rh_per)
         - Modelica.Math.atan(rh_per-1.676331)
         + 0.00391838 * rh_per^(1.5) * Modelica.Math.atan( 0.023101 * rh_per))
       - 4.686035;
    XiSat = 0;
    XiSatRefIn=0;
  else
    XiSatRefIn=(1-Xi[iWat])*XiSat/(1-XiSat);
    XiSat  = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TWetBul),
      p =    p,
      phi =  1);
    (TWetBul-Buildings.Utilities.Psychrometrics.Constants.T_ref) * (
              (1-Xi[iWat]) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
              XiSatRefIn * Buildings.Utilities.Psychrometrics.Constants.cpSte +
              (Xi[iWat]-XiSatRefIn) * Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    =
    (TDryBul-Buildings.Utilities.Psychrometrics.Constants.T_ref) * (
              (1-Xi[iWat]) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
              Xi[iWat] * Buildings.Utilities.Psychrometrics.Constants.cpSte)  +
    (Xi[iWat]-XiSatRefIn) * Buildings.Utilities.Psychrometrics.Constants.h_fg;
    TDryBul_degC = 0;
    rh_per       = 0;
  end if;
annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-100,102},{-70,58}},
          textColor={0,0,127},
          fontSize=8,
          textString="TDryBul"),
        Text(
          extent={{82,10},{96,-10}},
          textColor={0,0,127},
          fontSize=8,
          textString="Xi"),
        Text(
          extent={{-96,-72},{-78,-90}},
          textColor={0,0,127},
          fontSize=8,
          textString="p"),
        Text(
          extent={{-98,22},{-68,-22}},
          textColor={0,0,127},
          textString="TWetBul"),
        Line(points={{78,-74},{-48,-74}}),
        Text(
          extent={{76,-78},{86,-94}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{76,-46},{26,-4}},
          color={255,0,0},
          thickness=0.5),
        Line(points={{-48,-48},{-2,-30},{28,-4},{48,32},{52,72}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(points={{-48,84},{-48,-74}}),
        Text(
          extent={{-44,82},{-22,64}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Polygon(
          points={{86,-74},{76,-72},{76,-76},{86,-74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,88},{-46,74},{-50,74},{-48,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    defaultComponentName="wetBul",
    Documentation(info="<html>
<p>This block computes the water vapor mass fraction based on given dry bulb temperature, wet bulb temperature and atmospheric pressure. </p>
</html>", revisions="<html>
<ul>
<li>
Semptember 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Xi_TDryBulTWetBul;
