within Buildings.Templates.Plants.Controls.HeatRecoveryChillers;
block ModeControl
  "Mode control and setpoint selection"
  parameter Real COPHea_nominal(
    final min=1.1,
    final unit="1")
    "Heating COP at design heating conditions"
    annotation (Dialog(group="Information provided by designer"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SetMod
    "Enable mode setting"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QChiWatReq_flow(
    final unit="W")
    "CHW load"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaWatReq_flow(
    final unit="W")
    "HW load"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Active CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Active HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo
    "Mode command: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter QEvaHea_flow(
    final k=1 - 1 / COPHea_nominal)
    "Compute evaporator heat flow rate in heating mode"
    annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Less les
    "True (cooling) if CHW load lower than evaporator heat flow rate in heating mode"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch selTSupSet
    "Select supply temperature setpoint"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch setMod
    "Set mode if mode setting enabled, otherwise reuse previous mode"
    annotation (Placement(transformation(extent={{-10,50},{10,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preMod
    "Previous mode setting"
    annotation (Placement(transformation(extent={{60,50},{40,70}})));
equation
  connect(QHeaWatReq_flow, QEvaHea_flow.u)
    annotation (Line(points={{-120,-20},{-90,-20}},color={0,0,127}));
  connect(QChiWatReq_flow, les.u1)
    annotation (Line(points={{-120,0},{-52,0}},color={0,0,127}));
  connect(QEvaHea_flow.y, les.u2)
    annotation (Line(points={{-66,-20},{-60,-20},{-60,-8},{-52,-8}},color={0,0,127}));
  connect(TChiWatSupSet, selTSupSet.u1)
    annotation (Line(points={{-120,-60},{20,-60},{20,-52},{48,-52}},color={0,0,127}));
  connect(THeaWatSupSet, selTSupSet.u3)
    annotation (Line(points={{-120,-80},{40,-80},{40,-68},{48,-68}},color={0,0,127}));
  connect(selTSupSet.y, TSupSet)
    annotation (Line(points={{72,-60},{120,-60}},color={0,0,127}));
  connect(u1SetMod, setMod.u2)
    annotation (Line(points={{-120,40},{-12,40}},color={255,0,255}));
  connect(setMod.y, y1Coo)
    annotation (Line(points={{12,40},{40,40},{40,0},{120,0}},color={255,0,255}));
  connect(les.y, setMod.u1)
    annotation (Line(points={{-28,0},{-20,0},{-20,32},{-12,32}},color={255,0,255}));
  connect(y1Coo, preMod.u)
    annotation (Line(points={{120,0},{80,0},{80,60},{62,60}},color={255,0,255}));
  connect(preMod.y, setMod.u3)
    annotation (Line(points={{38,60},{-20,60},{-20,48},{-12,48}},color={255,0,255}));
  connect(y1Coo, selTSupSet.u2)
    annotation (Line(points={{120,0},{40,0},{40,-60},{48,-60}},color={255,0,255}));
  annotation (
    defaultComponentName="setMod",
    Documentation(
      info="<html>
<h4>Mode control</h4>
<p>
If the following equation is true prior to enabling the HRC, set the 
control mode to heating. Otherwise, set the control mode to cooling.
</p>
<p>
<code>QChiWatReq_flow > QHeaWat_flow * (1 - 1 / COPHea_nominal)</code>
</p>
<p>
Write mode via the chiller’s BACnet interface prior to sending the chiller 
an enable command.
</p>
<h4>Setpoint</h4>
<p>
When the control mode is cooling, the active setpoint shall be 
the CHW supply temperature setpoint.
When the control mode is heating, the active setpoint shall be 
the HW supply temperature setpoint.
</p>
<h4>Details</h4>
<p>
The condition \"prior to enabling the HRC\" is evaluated in the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable\">
Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end ModeControl;
