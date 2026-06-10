within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SetpointResolution "Setpoint resolution"

  parameter Real resInt
    "Setpoint resolution interval";
  parameter Real refSet
    "Reference setpoint for resolution calculation; set to 293.15 for temperature setpoints and zero for other setpoints";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSet "Setpoint input"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySet
    "Setpoint output that follows the resolution interval"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.AddParameter subRefSet(p=-refSet)
    "Subtract the reference setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Divide the difference from the reference setpoint by the resolution interval to get the number of resolution intervals"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Round rouNumResInt(n=0)
    "Round the number of resolution intervals to an integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Multiple the integer number of resolution intervals by the resolution interval"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addRefSet(p=refSet)
    "Add the reference setpoint"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conResInt(k=resInt)
    "Constant for the setpoint resolution interval"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
equation
  connect(subRefSet.y, div.u1)
    annotation (Line(points={{-78,0},{-60,0},{-60,6},{-42,6}}, color={0,0,127}));
  connect(div.y, rouNumResInt.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(rouNumResInt.y, mul.u1)
    annotation (Line(points={{22,0},{30,0},{30,6},{38,6}}, color={0,0,127}));
  connect(addRefSet.y, ySet)
    annotation (Line(points={{102,0},{140,0}}, color={0,0,127}));
  connect(conResInt.y, div.u2)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,-6},{-42,-6}},
    color={0,0,127}));
  connect(conResInt.y, mul.u2)
    annotation (Line(points={{-78,-70},{30,-70},{30,-6},{38,-6}}, color={0,0,127}));
  connect(uSet, subRefSet.u)
    annotation (Line(points={{-140,0},{-102,0}}, color={0,0,127}));
  connect(mul.y, addRefSet.u)
    annotation (Line(points={{62,0},{78,0}}, color={0,0,127}));
  annotation (defaultComponentName="setRes",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
June 10, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This sequence enforces the value of a setpoint to fall onto discrete resolution
intervals.
</p>
<p>
For any setpoint input <code>uSet</code>, the setpoint output <code>ySet</code> is
the closest value to <code>uSet</code> that is equal to
<code>refSet + n * resInt</code>, where <code>refSet</code> is the reference
setpoint, <code>resInt</code> is the resolution interval, and <code>n</code> is an
integer. 
</p>
<p>
The reference setpoint is set to <i>293.15 K</i> for temperature setpoints and zero
for other setpoints.
</p>
</html>"));
end SetpointResolution;
