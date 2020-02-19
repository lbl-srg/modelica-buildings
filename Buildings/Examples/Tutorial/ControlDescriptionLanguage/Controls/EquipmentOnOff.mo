within Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls;
block EquipmentOnOff "Control for equipment on/off control"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoi(
    final unit="K",
    displayUnit="degC")
    "Boiler temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput onSys
    "System on status"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput onPum
    "Pump on status"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput onBoi
    "Boiler on status"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "And operator to switch boiler on based on temperature and system on command"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of output signal, because boiler should be off if temperature exceed uHigh"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTBoi(uHigh=273.15 + 90,
      uLow=273.15 + 70)
    "Hysteresis for on/off of boiler"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation

  connect(TBoi, hysTBoi.u)
    annotation (Line(points={{-120,60},{-62,60}}, color={0,0,127}));
  connect(hysTBoi.y, not1.u)
    annotation (Line(points={{-38,60},{-22,60}}, color={255,0,255}));
  connect(onSys, onPum)
    annotation (Line(points={{-120,-60},{120,-60}}, color={255,0,255}));
  connect(and1.u1, not1.y) annotation (Line(points={{18,0},{10,0},{10,60},{2,60}},
        color={255,0,255}));
  connect(and1.u2, onSys) annotation (Line(points={{18,-8},{10,-8},{10,-60},{
          -120,-60}}, color={255,0,255}));
  connect(and1.y, onBoi) annotation (Line(points={{42,0},{60,0},{60,60},{120,60}},
        color={255,0,255}));
  annotation (
  defaultComponentName="conEquSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,82},{-42,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TOut"),
        Text(
          extent={{40,24},{88,-16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onSys"),
        Text(
          extent={{-92,-40},{-44,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TRet"),
        Text(
          lineColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Open loop controller that outputs a constant control signal for the system status.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquipmentOnOff;
