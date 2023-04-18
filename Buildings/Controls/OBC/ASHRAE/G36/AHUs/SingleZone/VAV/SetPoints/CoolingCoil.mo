within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block CoolingCoil "Controller for cooling coil valve"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Cooling coil loop signal"));
  parameter Real kCooCoi(final unit="1/K")=0.1
    "Gain for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal"));
  parameter Real TiCooCoi(final unit="s")=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCooCoi(final unit="s")=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (Dialog(group="Cooling coil loop signal",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan proven on"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi
    "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conCoi(
    final controllerType=controllerTypeCooCoi,
    final k=kCooCoi,
    final Ti=TiCooCoi,
    final Td=TdCooCoi,
    final reverseActing=false)
    "Cooling coil control signal"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Logical block to check if zone is in cooling state"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling)
    "Cooling state value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch "Switch to assign cooling coil control signal"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0) "Cooling off mode"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Conditions for cooling state"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(const.y, switch.u3) annotation (Line(points={{42,-40},{60,-40},{60,-8},
          {70,-8}}, color={0,0,127}));
  connect(conCoi.trigger, u1SupFan)
    annotation (Line(points={{-6,68},{-6,-80},{-120,-80}}, color={255,0,255}));
  connect(conCoi.u_s, TSupCooSet)
    annotation (Line(points={{-12,80},{-120,80}}, color={0,0,127}));
  connect(conCoi.u_m, TAirSup)
    annotation (Line(points={{0,68},{0,40},{-120,40}}, color={0,0,127}));
  connect(switch.y, yCooCoi)
    annotation (Line(points={{94,0},{120,0}}, color={0,0,127}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{-18,0},{-2,0}}, color={255,0,255}));
  connect(and2.u2, u1SupFan) annotation (Line(points={{-2,-8},{-6,-8},{-6,-80},
          {-120,-80}}, color={255,0,255}));
  connect(and2.y, switch.u2) annotation (Line(points={{22,0},{70,0}}, color={255,0,255}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-58,0},{-42,0}},     color={255,127,0}));
  connect(uZonSta, intEqu.u2) annotation (Line(points={{-120,-20},{-50,-20},{
          -50,-8},{-42,-8}},   color={255,127,0}));
  connect(conCoi.y, switch.u1)
    annotation (Line(points={{12,80},{60,80},{60,8},{70,8}}, color={0,0,127}));
annotation (defaultComponentName="cooCoi",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
        Diagram(coordinateSystem(
          preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block outputs the cooling coil control signal if the fan is on and the zone is
in cooling status (see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates</a>).
Otherwise, the control signal for the coil is set to <code>0</code>.
The implementation is according to the Section 5.18.5.3 of ASHRAE Guideline 36, May 2020.
</p>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation based on G36 official version.
</li>
</ul>
</html>"));
end CoolingCoil;
