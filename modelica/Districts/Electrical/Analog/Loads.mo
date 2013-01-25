within Districts.Electrical.Analog;
package Loads "Library with models for electrical loads"
  extends Modelica.Icons.VariantsPackage;
  model VariableResistor "Model of a variable resistive load"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;

    Modelica.Blocks.Interfaces.RealInput P(unit="W", min=0)
      "Dissipated electrical power"
      annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,106}),
          iconTransformation(extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,110})));

  protected
    Modelica.SIunits.Conductance G(start=1) "Conductance";

  equation
    P = v*i;
    i = v*G;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                           graphics={Rectangle(extent={{-100,100},{100,-100}},
              lineColor={255,255,255}),
          Text(
            extent={{34,144},{124,102}},
            lineColor={0,0,255},
            textString="%name"),
          Text(
            extent={{-32,68},{-12,96}},
            lineColor={0,0,255},
            textString="P"),
      Line(points={{0,90},{0,30}}, color={0,0,127},
            pattern=LinePattern.Dash),
      Rectangle(
        extent={{-70,30},{70,-30}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(points={{-90,0},{-70,0}}, color={0,0,255}),
      Line(points={{70,0},{90,0}}, color={0,0,255})}),
            Documentation(info="<html>
<p>
Model of a resistive load that takes as an input the dissipated power.
</p>
<p>
The model computes the power as
<i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage and <i>i</i> is the current.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 8, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics));
  end VariableResistor;
end Loads;
