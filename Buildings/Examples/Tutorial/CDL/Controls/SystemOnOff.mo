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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetOut(k=TOutLow + 0.5)
    "Set point for outdoor air temperature plus half the dead band"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetRoo(k=TRooSet)
    "Set point for room air temperature plus half the dead band"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "And operator to switch boiler on based on temperature and system on command"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub "Inputs different"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis onTOut(
    final uLow=-0.5,
    final uHigh=0.5) "On/off control based on outside air temperature"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Inputs different"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis onTRoo(
    final uLow=-0.5,
    final uHigh=0.5) "On/off control based on room air temperature"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
equation
  connect(and1.y, onSys)
    annotation (Line(points={{82,0},{120,0}}, color={255,0,255}));
  connect(TSetOut.y, sub.u1) annotation (Line(points={{-58,80},{-50,80},{-50,66},
          {-42,66}}, color={0,0,127}));
  connect(TOut, sub.u2) annotation (Line(points={{-120,60},{-60,60},{-60,54},{-42,
          54}}, color={0,0,127}));
  connect(sub.y, onTOut.u)
    annotation (Line(points={{-18,60},{-2,60}}, color={0,0,127}));
  connect(onTOut.y, and1.u1) annotation (Line(points={{22,60},{40,60},{40,0},{58,
          0}}, color={255,0,255}));
  connect(TSetRoo.y, sub1.u1) annotation (Line(points={{-58,-30},{-50,-30},{-50,
          -54},{-42,-54}}, color={0,0,127}));
  connect(TRoo, sub1.u2) annotation (Line(points={{-120,-60},{-60,-60},{-60,-66},
          {-42,-66}}, color={0,0,127}));
  connect(sub1.y, onTRoo.u)
    annotation (Line(points={{-18,-60},{-2,-60}}, color={0,0,127}));
  connect(onTRoo.y, and1.u2) annotation (Line(points={{22,-60},{40,-60},{40,-8},
          {58,-8}}, color={255,0,255}));
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
December 11, 2023, by Jianjun Hu:<br/>
Reimplemented on-off control to avoid using the obsolete <code>OnOffController</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">#3595</a>.
</li>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SystemOnOff;
