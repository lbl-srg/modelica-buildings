within Buildings.Utilities.Psychrometrics;
model HumidityRatioPressure
  "Relation between humidity ratio and water vapor pressure"
  extends Buildings.BaseClasses.BaseIcon;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
<p>
Model to compute the relation between humidity ratio and water vapor partial pressure
of moist air.</p>
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,134},{60,10}},
          lineColor={0,0,0},
          textString="p_w"),
        Text(
          extent={{-22,-16},{26,-84}},
          lineColor={0,0,0},
          textString="X"),
        Line(points={{-4,26},{-4,-16}}, color={0,0,0}),
        Polygon(
          points={{-4,-16},{0,0},{-8,0},{-4,-16}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,30},{0,12},{-8,12},{-4,30}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
  parameter Modelica.SIunits.Pressure pAtm = 101325 "Fixed value of pressure" 
          annotation (Evaluate = true,
                Dialog(enable = (cardinality(p)==0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal p(
                                           final quantity="Pressure",
                                           final unit="Pa",
                                           min = 0) "Pressure" 
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}, rotation=
           0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal XWat(
                                                    nominal=0.01)
    "Species concentration at dry bulb temperature" 
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}},
          rotation=0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal p_w(
                                           final quantity="Pressure",
                                           final unit="Pa",
                                           displayUnit="Pa",
                                           min = 0) "Water vapor pressure" 
    annotation (Placement(transformation(extent={{-100,60},{-80,80}}, rotation=
            0)));

  annotation (Diagram, Icon);
  Modelica.SIunits.MassFraction X_dryAir(min=0, max=1, nominal=0.01, start=0.001)
    "Water mass fraction per mass of dry air";
equation
  if cardinality(p)==0 then
    p = pAtm;
  end if;
  X_dryAir * (1-XWat) = XWat;
 ( p - p_w)   * X_dryAir = 0.62198 * p_w;
end HumidityRatioPressure;
