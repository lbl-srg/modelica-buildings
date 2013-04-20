within Districts.Electrical.DC.Loads;
model VariableConductor "Model of a variable conductive load"
extends Districts.Electrical.DC.Interfaces.OnePort;

  Modelica.Blocks.Interfaces.RealInput P(unit="W") "Power input"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

protected
  Modelica.SIunits.Conductance G(start=1) "Conductance";

equation
  P = v*i;
  i = v*G;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-70,30},{70,-30}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={-3.55271e-15,2},
          rotation=180),
          Line(points={{-10,0},{10,0}},color={0,0,0},
          origin={-80,2},
          rotation=180),
        Text(
          extent={{-44,146},{46,104}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-120,98},{-100,126}},
          lineColor={0,0,255},
          textString="P")}),
          Documentation(info="<html>
<p>
Model of a variable conductive load that takes as an input the dissipated power.
</p>
<p>
The model computes the power as
<i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage and <i>i</i> is the current.
</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end VariableConductor;
