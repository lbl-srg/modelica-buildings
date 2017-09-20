within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block ChillerSwitch "Control unit for enabling/disabling chiller"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput chiCHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Chiller chilled water supply temperature (water entering chiller)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "Control signal for chiller. 1: Enable, 0: Disable" annotation (Placement(
        transformation(extent={{100,-22},{144,22}}), iconTransformation(extent=
            {{100,-16},{120,4}})));
  Modelica.Blocks.Interfaces.RealInput TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Set temperature of chiller" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-120,-60},{-100,-40}})));
  parameter Modelica.SIunits.Temperature deaBan
    "Dead band of temperature to prevent chiller short cycling";
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0, uHigh=deaBan)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Add add(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(hysteresis.y, y) annotation (Line(
      points={{41,6.10623e-16},{52.5,6.10623e-16},{52.5,1.11022e-16},{122,
          1.11022e-16}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(chiCHWST, add.u1) annotation (Line(
      points={{-120,60},{-80,60},{-80,6},{-42,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, add.u2) annotation (Line(
      points={{-120,-60},{-80,-60},{-80,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, hysteresis.u) annotation (Line(
      points={{-19,6.10623e-16},{-1.5,6.10623e-16},{-1.5,6.66134e-16},{18,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
    defaultComponentName="chiSwi",
    Documentation(info="<html>
The controls for enabling/disabling chiller are as follows:
<ul>
<li>
The chiller is enabled when
<p align=\"left\" style=\"font-style:italic;\">
  T<sub>Chi_CHWST</sub> &gt; T<sub>ChiSet</sub> + T<sub>DeaBan</sub> </p>
  </li>
<li>
The chiller is disabled when
<p align=\"left\" style=\"font-style:italic;\">
  T<sub>Chi_CHWST</sub> &le; T<sub>ChiSet</sub></p>
</li>
</ul>
where <i>T<sub>Chi_CHWST</sub></i> is chiller chilled water supply temperature, <i>T<sub>ChiSet</sub></i> is set temperature for chilled water leaving chiller, and <i>T<sub>DeaBan</sub></i> is dead band to prevent short cycling.
</html>", revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Add comments, change variable names, and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul></html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-78,94},{-86,72},{-70,72},{-78,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,72},{-78,-25}}, color={192,192,192}),
        Polygon(
          points={{94,-25},{72,-17},{72,-33},{94,-25}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-77,-25},{86,-25}}, color={192,192,192}),
        Line(points={{-77,-25},{43,-25}}, color={0,0,0}),
        Line(points={{-13,-17},{3,-25},{-13,-32}}, color={0,0,0}),
        Line(points={{43,55},{43,-25}}, color={0,0,0}),
        Line(points={{35,7},{43,26},{52,7}}, color={0,0,0}),
        Line(points={{-47,55},{83,55}}, color={0,0,0}),
        Line(points={{-2,63},{-17,55},{-2,47}}, color={0,0,0}),
        Line(points={{-57,33},{-47,15},{-37,33}}, color={0,0,0}),
        Line(points={{-47,55},{-47,-25}}, color={0,0,0}),
        Text(
          extent={{-90,-45},{-7,-88}},
          lineColor={192,192,192},
          textString="%uLow"),
        Text(
          extent={{4,-45},{93,-88}},
          lineColor={192,192,192},
          textString="%uHigh"),
        Rectangle(extent={{-89,-45},{-6,-88}}, lineColor={192,192,192}),
        Line(points={{-47,-25},{-47,-45}}, color={192,192,192}),
        Rectangle(extent={{4,-45},{93,-88}}, lineColor={192,192,192}),
        Line(points={{43,-25},{43,-45}}, color={192,192,192})}));
end ChillerSwitch;
