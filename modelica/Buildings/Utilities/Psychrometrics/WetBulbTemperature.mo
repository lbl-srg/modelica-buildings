within Buildings.Utilities.Psychrometrics;
model WetBulbTemperature "Model to compute the wet bulb temperature"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = 
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model" 
                                                            annotation (
      choicesAllMatching = true);
annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
          graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-20,-88},{20,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,50},{12,-58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,50},{-12,90},{-10,96},{-6,98},{0,100},{6,98},{10,96},{12,
              90},{12,50},{-12,50}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,50},{-12,-54}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,50},{12,-54}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-10},{-12,-10}}, color={0,0,0}),
        Line(points={{-40,30},{-12,30}}, color={0,0,0}),
        Line(points={{-40,70},{-12,70}}, color={0,0,0}),
        Text(
          extent={{120,-40},{0,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          textString="T")}),
    Documentation(info="<HTML>
<p>
Given a moist are medium model, this component computes the states 
of the medium at its wet bulb temperature.
</p><p>
For a use of this model, see for example
<a href=\"Modelica://Buildings.Fluid.Sensors.WetBulbTemperature\">Buildings.Fluid.Sensors.WetBulbTemperature</a>
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
May 19, 2008 by Michael Wetter:<br>
Added relative humidity as a port.
</li>
<li>
May 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  Medium.BaseProperties dryBul "Medium state at dry bulb temperature";
  Medium.BaseProperties wetBul(Xi(nominal=0.01*ones(Medium.nXi)))
    "Medium state at wet bulb temperature";
  ObsoleteModelica3.Blocks.Interfaces.RealSignal TDryBul(
                                           start=303,
                                           final quantity="ThermodynamicTemperature",
                                           final unit="K",
                                           min = 0) "Dry bulb temperature" 
    annotation (Placement(transformation(extent={{-100,70},{-80,90}}, rotation=
            0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal p(
                                           final quantity="Pressure",
                                           final unit="Pa",
                                           min = 0) "Pressure" 
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}, rotation=
           0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal TWetBul(
                                           start=293,
                                           final quantity="ThermodynamicTemperature",
                                           final unit="K",
                                           min = 0) "Wet bulb temperature" 
    annotation (Placement(transformation(extent={{80,-10},{100,10}}, rotation=0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal Xi[
                                          Medium.nXi]
    "Species concentration at dry bulb temperature" 
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}},
          rotation=0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal phi
    "Relative humidity (at dry-bulb state) in [0, 1]" 
    annotation (Placement(transformation(extent={{80,60},{100,80}}, rotation=0)));
protected
  parameter Integer iWat(min=1, fixed=false)
    "Index for water vapor concentration";
initial algorithm
  iWat :=1;
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.extraPropertiesNames[i], "Water")) then
      iWat := i;
    end if;
  end for;
equation
  dryBul.p = p;
  dryBul.T = TDryBul;
  dryBul.Xi = Xi;
  wetBul.phi = 1;
  wetBul.p = dryBul.p;
  wetBul.h = dryBul.h + (wetBul.X[iWat] - dryBul.X[iWat])
         * Medium.enthalpyOfLiquid(dryBul.T);
  TWetBul = wetBul.T;
  phi     = dryBul.phi;
end WetBulbTemperature;
