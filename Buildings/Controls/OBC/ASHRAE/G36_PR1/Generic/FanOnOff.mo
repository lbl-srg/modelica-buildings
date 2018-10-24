within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic;
block FanOnOff "Determine the supply fan status"
  CDL.Integers.Sources.Constant conInt(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Interfaces.IntegerInput uOpeMod
   "System operation mode"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.BooleanOutput ySupFan "Supply fan on status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Logical.Not switch "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-59,0},{-50,0},{-50,-8},{-22,-8}},
      color={255,127,0}));
  connect(uOpeMod,intEqu. u1)
    annotation (Line(points={{-120,0},{-90,0},{-90,20},{-40,20},{-40,0},{-22,0}},
                  color={255,127,0}));
  connect(intEqu.y, switch.u)
    annotation (Line(points={{1,0},{38,0}}, color={255,0,255}));
  connect(switch.y, ySupFan)
    annotation (Line(points={{61,0},{110,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),             Diagram(coordinateSystem(
          preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Block that computes the fan status signal based on AHU operating mode.  Fan
operates in all modes except unoccupied mode.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end FanOnOff;
