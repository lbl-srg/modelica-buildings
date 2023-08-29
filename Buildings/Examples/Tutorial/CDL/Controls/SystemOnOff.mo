within Buildings.Examples.Tutorial.CDL.Controls;
block SystemOnOff "Controller for system on/off"
  parameter Real TRooSet(
    final unit="K",
    displayUnit="degC") = 293.65
    "Room air temperature set point";
  parameter Real dTRoo(
    min=0.5,
    final unit="K") = 1
    "Room air temperature dead band";
  parameter Real TOutLow(
    final unit="K",
    displayUnit="degC") = 289.15
    "Outdoor temperature below which system is allowed to switch on";


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
  Buildings.Controls.OBC.CDL.Logical.OnOffController onTOut(bandwidth=1)
    "On/off control based on outside air temperature"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetOut(k=TOutLow + 0.5)
    "Set point for outdoor air temperature plus half the dead band"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.OnOffController onTRoo(bandwidth=1)
    "On/off control based on room air temperature"
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRoo(k=TRooSet)
                 "Set point for room air temperature plus half the dead band"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "And operator to switch boiler on based on temperature and system on command"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(onTOut.u, TOut)
    annotation (Line(points={{-42,60},{-120,60}}, color={0,0,127}));
  connect(TSetOut.y, onTOut.reference) annotation (Line(points={{-58,80},{-50,
          80},{-50,72},{-42,72}}, color={0,0,127}));
  connect(onTRoo.u, TRoo)
    annotation (Line(points={{-42,-60},{-120,-60}}, color={0,0,127}));
  connect(TSetRoo.y, onTRoo.reference) annotation (Line(points={{-58,-30},{-50,-30},
          {-50,-48},{-42,-48}}, color={0,0,127}));
  connect(and1.u2, onTRoo.y) annotation (Line(points={{58,-8},{-10,-8},{-10,-54},
          {-18,-54}}, color={255,0,255}));
  connect(and1.y, onSys)
    annotation (Line(points={{82,0},{120,0}}, color={255,0,255}));
  connect(onTOut.y, and1.u1) annotation (Line(points={{-18,66},{-10,66},{-10,0},
          {58,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="conSysSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
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
Controller that takes as an input the outside air temperature <code>TOut</code> and
the room air temperature <code>TRoo</code>,
and outputs the system on command <code>onSys</code>.
</p>
<p>
The system on command is <code>true</code> if both conditions are satisfied:
The outside air temperature is below a limit of <code>TOutLow</code>(<i>=16</i>&deg;C, adjustable)
and the room air temperature is below <code>TRooSet-dTRoo/2</code>,
where <code>TRooSet</code> is the room air temperature setpoint (<i>=20.5</i>&deg;C, adjustable)
and <code>dTRoo</code> is the deadband (<i>=1</i> Kelvin, adjustable).
Otherwise, the system on command is <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemOnOff;
