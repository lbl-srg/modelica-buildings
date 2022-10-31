within Buildings.Controls.OBC.Shade;
block Shade_H
  "Shade controller with solar irradiation as input"
  parameter Real HHigh(
    final quantity="Irradiance",
    final unit="W/m2")
    "if y=0 and H>=HHigh, switch to y=1";
  parameter Real HLow(
    final quantity="Irradiance",
    final unit="W/m2")
    "if y=1 and H<=HLow, switch to y=0";
  CDL.Interfaces.RealInput H(
    final unit="W/m2")
    "Measured irradiation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealOutput y(
    final min=0,
    final max=1,
    unit="1")
    "Control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  CDL.Continuous.Hysteresis hys(
    final uLow=HLow,
    final uHigh=HHigh)
    "Hysteresis block"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  CDL.Conversions.BooleanToReal booToRea
    "Boolean to real converter"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(H,hys.u)
    annotation (Line(points={{-120,0},{-42,0}},color={0,0,127}));
  connect(hys.y,booToRea.u)
    annotation (Line(points={{-18,0},{18,0}},color={255,0,255}));
  connect(booToRea.y,y)
    annotation (Line(points={{42,0},{120,0}},color={0,0,127}));
  annotation (
    defaultComponentName="shaH",
    Icon(
      coordinateSystem(
        extent={{-100,-80},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-164,144},{164,106}},
          textColor={0,0,127},
          textString="%name"),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-29}},
          color={192,192,192}),
        Polygon(
          points={{92,-29},{70,-21},{70,-37},{92,-29}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-79,-29},{84,-29}},
          color={192,192,192}),
        Line(
          points={{-79,-29},{41,-29}}),
        Line(
          points={{-15,-21},{1,-29},{-15,-36}}),
        Line(
          points={{41,51},{41,-29}}),
        Line(
          points={{33,3},{41,22},{50,3}}),
        Line(
          points={{-49,51},{81,51}}),
        Line(
          points={{-4,59},{-19,51},{-4,43}}),
        Line(
          points={{-59,29},{-49,11},{-39,29}}),
        Line(
          points={{-49,51},{-49,-29}}),
        Text(
          extent={{-92,-49},{-9,-92}},
          textColor={192,192,192},
          textString="%HLow"),
        Text(
          extent={{2,-49},{91,-92}},
          textColor={192,192,192},
          textString="%HHigh"),
        Rectangle(
          extent={{-91,-49},{-8,-92}},
          lineColor={192,192,192}),
        Line(
          points={{-49,-29},{-49,-49}},
          color={192,192,192}),
        Rectangle(
          extent={{2,-49},{91,-92}},
          lineColor={192,192,192}),
        Line(
          points={{41,-29},{41,-49}},
          color={192,192,192})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.05)),
    Documentation(
      info="<html>
<p>
Block that outputs a shade control signal <i>y &isin; {0, 1}</i> as follows:
</p>
<ul>
<li> When <code>y=0</code> and the input <code>H</code> becomes
     greater than the parameter <code>HHigh</code>, the output
     switches to <code>y=1</code>.
</li>
<li> When <code>y=1</code> and the input <code>H</code> becomes
     less than the parameter <code>HLow</code>, the output
     switches to <code>y=0</code>.
</li>
</ul>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/Shade/Shade_H.png\"
   alt=\"Shade control chart\" />
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 8, 2018, by Michael Wetter:<br/>
Reimplemented model to make it analogous to the hysteresis block.
</li>
<li>
June 01, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shade_H;
