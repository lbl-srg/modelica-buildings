within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups;
block ZoneGroupSystem
  "Compute the AHU operating mode from the group operating mode"

  parameter Integer nGro
    "Total number of groups";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod[nGro]
    "Groups operation mode"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nGro]
    "Convert integer to real"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(nin=nGro)
    "Find the highest priotity operating mode"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ahuMod
    "Air handling operating mode"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAhuOpeMod
    "Operation mode for AHU operation"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

equation
  connect(intToRea.y, mulMin.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={0,0,127}));
  connect(mulMin.y, ahuMod.u)
    annotation (Line(points={{2,0},{38,0}}, color={0,0,127}));
  connect(ahuMod.y, yAhuOpeMod)
    annotation (Line(points={{62,0},{82,0},{82,0},{120,0}}, color={255,127,0}));
  connect(uOpeMod, intToRea.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={255,127,0}));

annotation (defaultComponentName="ahuMod",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
This sequence specifies the operation mode of a AHU system, which may serve
multiple zone group. It is implemented according
to Section 5.15.1 of ASHRAE Guideline G36, May 2020.
</p>
<p>
When zone group served by an air-handling system are in different modes, the following
hierarchy applies (highest one sets AHU mode):
</p>
<ol>
<li>
Occupied mode
</li>
<li>
Cooldown mode
</li>
<li>
Setup mode
</li>
<li>
Warm-up mode
</li>
<li>
Setback mode
</li>
<li>
Freeze protection setback mode
</li>
<li>
Unoccupied mode
</li>
</ol>
<p>
See the operation mode enumeration in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes\">
Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes</a> for the detailed
description.
</p>
</html>", revisions="<html>
<ul>
<li>
August 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneGroupSystem;
