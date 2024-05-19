within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
model CoolingCoil "Controller for cooling coil valve"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Cooling coil loop signal"));
  parameter Real kCooCoi=0.1
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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCoo(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi "Cooling coil control signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset cooCoiPI(
    final reverseActing=false,
    final controllerType=controllerTypeCooCoi,
    final k=kCooCoi,
    final Ti=TiCooCoi,
    final Td=TdCooCoi) "Cooling coil control signal"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Logical block to check if zone is in cooling state"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling)
    "Cooling state value"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch switch "Switch to assign cooling coil control signal"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(k=0) "Cooling off mode"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Conditions for cooling state"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

equation
  connect(const.y, switch.u3) annotation (Line(points={{62,-20},{66,-20},{66,-8},
          {70,-8}}, color={0,0,127}));
  connect(cooCoiPI.trigger, uSupFan) annotation (Line(points={{-6,68},{-6,-80},{
          -120,-80}},                      color={255,0,255}));
  connect(cooCoiPI.u_s, TSupCoo) annotation (Line(points={{-12,80},{-120,80}},
                      color={0,0,127}));
  connect(cooCoiPI.u_m, TSup)
    annotation (Line(points={{0,68},{0,40},{-120,40}},    color={0,0,127}));
  connect(switch.y, yCooCoi)
    annotation (Line(points={{94,0},{110,0}}, color={0,0,127}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{-18,-20},{-2,-20}},
                    color={255,0,255}));
  connect(and2.u2, uSupFan) annotation (Line(points={{-2,-28},{-6,-28},{-6,-80},
          {-120,-80}}, color={255,0,255}));
  connect(and2.y, switch.u2) annotation (Line(points={{22,-20},{30,-20},{30,0},
          {70,0}},color={255,0,255}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={255,127,0}));
  connect(uZonSta, intEqu.u2) annotation (Line(points={{-120,-40},{-50,-40},{
          -50,-28},{-42,-28}}, color={255,127,0}));
  connect(cooCoiPI.y, switch.u1)
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
This block outputs the cooling coil control signal if the fan is on and the zone status
is <code>uZonSta = Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling</code>.
Otherwise, the control signal for the coil is set to <code>0</code>.
</p>
</html>",revisions="<html>
<ul>
<li>
May 1, 2021, by Michael Wetter:<br/>
Changed model to have the PI controller public rather than protected.
PI controllers should be public, allowing their variables to be inspected.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2477\">#2477</a>.
</li>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Moved interfaces instances to be right after parameter section.
</li>
<li>
August 1, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoil;
