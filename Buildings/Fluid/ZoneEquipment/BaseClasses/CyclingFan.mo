within Buildings.Fluid.ZoneEquipment.BaseClasses;
model CyclingFan
  "Controller for unit heater system with variable heating rate and fixed speed fan"

  parameter Real minFanSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) = 0.4
    "Minimum allowed fan speed"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum duration for which fan is enabled"
    annotation(Dialog(group="System parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "Availability signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput fanOpeMod
    "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput heaCooOpe
    "Heating/cooling operation is enabled"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,0},{140,40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And andAva
    "Enable the fan only when availability signal is true"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And andFanPro
    "Pass true if fan is enabled but not yet proven on"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Logical.Not notProOn
    "Pass true if fan is not proven on"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinFanSpe(
    final k=minFanSpe)
    "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanSpe
    "Boolean to Real conversion for fan speed in heating or cooling mode"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOpe
    "Enable fan when operating mode signal is true or when heating load is present"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFanEnaHol(
    final trueHoldDuration=tFanEna,
    final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation

  connect(orHeaCooOpe.y, booToReaFanSpe.u) annotation (Line(points={{-18,0},{18,
          0}},                        color={255,0,255}));
  connect(orHeaCooOpe.y, truFanEnaHol.u)
    annotation (Line(points={{-18,0},{10,0},{10,-40},{18,-40}},
                                                 color={255,0,255}));
  connect(timFan.passed,orHeaCooOpe. u1) annotation (Line(points={{-68,2},{-60,2},
          {-60,0},{-42,0}},   color={255,0,255}));
  connect(fanOpeMod, orHeaCooOpe.u2) annotation (Line(points={{-120,-80},{-50,-80},
          {-50,-8},{-42,-8}}, color={255,0,255}));
  connect(uAva, andAva.u2) annotation (Line(points={{-120,-40},{0,-40},{0,-60},{
          50,-60},{50,-48},{58,-48}},          color={255,0,255}));
  connect(truFanEnaHol.y, andAva.u1) annotation (Line(points={{42,-40},{58,-40}},
                               color={255,0,255}));
  connect(andAva.y, yFan)
    annotation (Line(points={{82,-40},{120,-40}},  color={255,0,255}));
  connect(conMinFanSpe.y, swi.u1) annotation (Line(points={{42,80},{50,80},{50,48},
          {58,48}},  color={0,0,127}));
  connect(booToReaFanSpe.y, swi.u3) annotation (Line(points={{42,0},{50,0},{50,32},
          {58,32}},          color={0,0,127}));
  connect(andFanPro.y, swi.u2)
    annotation (Line(points={{42,40},{58,40}},   color={255,0,255}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{82,40},{120,40}},    color={0,0,127}));
  connect(uFan, notProOn.u) annotation (Line(points={{-120,70},{-92,70}},
                     color={255,0,255}));
  connect(heaCooOpe, timFan.u)
    annotation (Line(points={{-120,10},{-92,10}},    color={255,0,255}));
  connect(notProOn.y, andFanPro.u1) annotation (Line(points={{-68,70},{-10,70},{
          -10,40},{18,40}},  color={255,0,255}));
  connect(andAva.y, andFanPro.u2) annotation (Line(points={{82,-40},{90,-40},{90,
          -72},{-10,-72},{-10,32},{18,32}},    color={255,0,255}));
  annotation (defaultComponentName="conFanCyc",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,180}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
      <p>
      This is a control module for the cycling fan designed as an 
      analogue to the control logic in EnergyPlus. The components are operated 
      as follows:
      <ul>
      <li>
      The fan is enabled (<code>yFan=true</code>) when the cooling/heating mode signal
      <code>fanOpeMod</code> is held <code>true</code> for a minimum time duration
      <code>tFanEnaDel</code>.
      </li>
      <li>
      Once enabled, the fan is held enabled for minimum time duration <code>tFanEna</code>.
      </li>
      <li>
      The fan is run at minimum speed <code>minFanSpe</code> until it is proven 
      on (<code>uFan=true</code>). The fan speed <code>yFanSpe</code> is then set
      to 100%.
      </li>
      </ul>
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      April 10, 2023 by Karthik Devaprasad and Xing Lu:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end CyclingFan;
