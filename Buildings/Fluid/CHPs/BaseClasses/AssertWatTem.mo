within Buildings.Fluid.CHPs.BaseClasses;
model AssertWatTem
  "Assert if water temperature is outside boundaries"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Modelica.Blocks.Interfaces.RealInput TWat(unit="K")
    "Water outlet temperature" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Water temperature is higher than the maximum!")
    "Assert function for checking water temperature"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

protected
  Modelica.Blocks.Logical.LessEqualThreshold
                                        lessEqualThreshold(
                                                      threshold=per.TWatMax)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  connect(lessEqualThreshold.u, TWat)
    annotation (Line(points={{-12,0},{-120,0}}, color={0,0,127}));
  connect(lessEqualThreshold.y, assMes.u)
    annotation (Line(points={{11,0},{78,0}}, color={255,0,255}));
  annotation (
    defaultComponentName="assWatTem",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{0,72},{-72,-56},{72,-56},{0,72}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-6,-32},{4,-42}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
The model sends a warning message if the water temperature is higher than the maximum defined by the manufacturer.  
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertWatTem;
