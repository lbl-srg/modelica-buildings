within Buildings.Examples.Tutorial.CDL.Controls;
block EquipmentOnOff "Controller for equipment on/off control"
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
  Buildings.Controls.OBC.CDL.Logical.And and1
    "And operator to switch boiler on based on temperature and system on command"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of output signal, because boiler should be off if temperature exceed uHigh"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
  uHigh=273.15 + 90,
  uLow=273.15  + 70) "Hysteresis for on/off of boiler"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation

  connect(TBoi, hys.u)
    annotation (Line(points={{-120,60},{-62,60}}, color={0,0,127}));
  connect(hys.y, not1.u)
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
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TBoi"),
        Text(
          extent={{38,-38},{86,-78}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onPum"),
        Text(
          extent={{-92,-40},{-44,-80}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onSys"),
        Text(
          textColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name"),
        Text(
          extent={{44,82},{92,42}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="onBoi")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Controller that takes as an input the boiler water temperature <code>TBoi</code>
and the system on command <code>onSys</code>, and outputs
the on command for the pumps <code>onPum</code> and the boiler <code>onBoi</code>.
</p>
<p>
The pump on command is the same as the system on command.
The boiler is switched on if the boiler temperature <code>TBoi</code> falls below
<i>70</i>&deg;C and if <code>onSys=true</code>, and it switches off
if either <code>TBoi</code> exceeds <i>90</i>&deg;C or if <code>onSys=false</code>.
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
