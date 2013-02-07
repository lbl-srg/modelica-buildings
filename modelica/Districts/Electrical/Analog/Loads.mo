within Districts.Electrical.Analog;
package Loads "Library with models for electrical loads"
  extends Modelica.Icons.VariantsPackage;
model Conductor "Model of a constant conductive load"
    extends Modelica.Electrical.Analog.Interfaces.OnePort;
 parameter Modelica.SIunits.Power P_nominal(min=0)
      "Nominal power (P_nominal >= 0)";
  protected
    Modelica.SIunits.Conductance G(start=1) "Conductance";
equation
  P_nominal = v*i;
  i = G*v;
  annotation (
    Documentation(info="<html>
<p>
Model of a constant conductive load.
</p>
<p>
The model computes the power as
<i>P_nominal = v &nbsp; i</i>,
where <i>v</i> is the voltage and <i>i</i> is the current.
</p>
</html>", revisions="<html>
<ul>
<li>
February 1, 2013, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Rectangle(
            extent={{-70,30},{70,-30}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}}, color={0,0,255}),
          Line(
            visible=useHeatPort,
            points={{0,-100},{0,-30}},
            color={127,0,0},
            smooth=Smooth.None,
            pattern=LinePattern.Dot),
          Text(
            extent={{-152,87},{148,47}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-144,-38},{142,-70}},
            lineColor={0,0,0},
            textString="G=%G")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Line(points={{-96,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{96,0}}, color={0,0,255}),
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255})}));
end Conductor;

  model VariableConductor "Model of a variable conductive load"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;

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
            Line(points={{-10,0},{10,0}},  color={0,0,0},
            origin={80,0},
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
</html>",   revisions="<html>
<ul>
<li>
January 8, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end VariableConductor;
end Loads;
