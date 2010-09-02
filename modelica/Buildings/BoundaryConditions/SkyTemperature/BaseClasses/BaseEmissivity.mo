within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block BaseEmissivity "Base Emissivity"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput TDew(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Dew point temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput basEmi
    "Emissivity of the sky without correction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TdegC
    "Temperature in degree Celsius";

equation
  TdegC = TDew + Modelica.Constants.T_zero;
  basEmi = 0.711 + (0.0056 + 0.000073*TdegC)*TdegC;
  annotation (
    defaultComponentName="basEmi",
    Documentation(info="<HTML>
<p>
This component computes the base emissivity of the sky without corrections.
</p>
<h4>References</h4>
M. Martin and P. Berdahl (1984).
<i>Characteristics of Infrared Sky Radiation in the United States</i>,
Solar Energy, 33: 321-336.
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-48,38},{20,-26}},
          lineColor={0,0,255},
          textString="E"),
        Text(
          extent={{6,2},{46,-20}},
          lineColor={0,0,255},
          textString="base")}));
end BaseEmissivity;
