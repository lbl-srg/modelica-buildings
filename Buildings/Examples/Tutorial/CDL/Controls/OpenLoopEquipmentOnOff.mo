within Buildings.Examples.Tutorial.CDL.Controls;
block OpenLoopEquipmentOnOff
  "Open loop controller for equipment on/off control"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoi(
    final unit="K",
    displayUnit="degC")
    "Boiler temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput onSys
    "System on command"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput onPum
    "Pump on command"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput onBoi
    "Boiler on command"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    "Constant control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation

  connect(con.y, onBoi) annotation (Line(points={{12,0},{60,0},{60,60},{120,60}},
        color={255,0,255}));
  connect(con.y, onPum) annotation (Line(points={{12,0},{60,0},{60,-60},{120,
          -60}}, color={255,0,255}));
  annotation (
  defaultComponentName="conEquSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name"),
        Text(
          extent={{-94,-40},{-46,-80}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onSys"),
        Text(
          extent={{36,-38},{84,-78}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onPum"),
        Text(
          extent={{42,82},{90,42}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onBoi"),
        Text(
          extent={{-92,82},{-44,42}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TBoi")}),
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
end OpenLoopEquipmentOnOff;
