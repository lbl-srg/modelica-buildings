within Buildings.Experimental.OpenBuildingControl.CDL.Discrete;
block Sampler "Ideal sampler of a continuous signal"

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component";

  parameter Modelica.SIunits.Time startTime=0 "First sample time instant";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Continuous output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger = sample(startTime, samplePeriod);
  when sampleTrigger then
    firstTrigger = time <= startTime + samplePeriod/2;
  end when;

  // Declarations specific to this type of discrete block
  when {sampleTrigger, initial()} then
    y = u;
  end when;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={                     Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{25.0,-10.0},{45.0,10.0}}),
      Line(points={{-100.0,0.0},{-45.0,0.0}},
        color={0,0,127}),
      Line(points={{45.0,0.0},{100.0,0.0}},
        color={0,0,127}),
      Line(points={{-35.0,0.0},{30.0,35.0}},
        color={0,0,127}),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-45.0,-10.0},{-25.0,10.0}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-25,-10},{-45,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,-10},{25,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-45,0}}, color={0,0,255}),
        Line(points={{45,0},{100,0}}, color={0,0,255}),
        Line(points={{-35,0},{30,35}}, color={0,0,255})}),
    Documentation(info="<html>
<p>
Block that outputs the input signal, sampled at a sampling rate defined
via parameter <code>samplePeriod</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Sampler;
