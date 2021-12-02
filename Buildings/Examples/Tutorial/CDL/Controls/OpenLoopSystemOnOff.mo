within Buildings.Examples.Tutorial.CDL.Controls;
block OpenLoopSystemOnOff
  "Open loop controller for system on/off"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC")
    "Room air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput onSys
    "System on command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    "Constant control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(con.y, onSys)
    annotation (Line(points={{12,0},{120,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="conSysSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,82},{-42,42}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TOut"),
        Text(
          extent={{40,24},{88,-16}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onSys"),
        Text(
          extent={{-92,-40},{-44,-80}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TRoo"),
        Text(
          textColor={0,0,255},
          extent={{-152,104},{148,144}},
          textString="%name")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Open loop controller that outputs a constant control signal for the system on command.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenLoopSystemOnOff;
