within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model HeatExchanger "Heat exchanger"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialHeatExchanger(
    final activate_ThrWayVal=use_controller);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialControllerInterface;


  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC") if use_controller
    "Temperature setpoint for port_b2"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.Continuous.LimPID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_start=yCon_start,
    final reverseAction=reverseAction,
    final reset=reset,
    final y_reset=y_reset) if use_controller
    "Controller for temperature at port_b2"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.RealExpression T_b2(y=T_outflow) if use_controller
    "Temperature at port_b2"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
protected
  Medium2.Temperature T_outflow "Temperature of outflowing fluid at port_b on medium 2 side";

equation
  T_outflow=Medium2.temperature(state=Medium2.setState_phX(
      p=port_b2.p, h=actualStream(port_b2.h_outflow), X=actualStream(port_b2.Xi_outflow)));

  if use_controller then
    connect(T_b2.y, con.u_m)
      annotation (Line(points={{-59,70},{-44,70},{-44,20},
            {-70,20},{-70,28}}, color={0,0,127}));
    connect(TSet, con.u_s)
      annotation (Line(points={{-120,40},{-120,40},{-82,40}}, color={0,0,127}));
    connect(con.y, thrWayVal.y)
      annotation (Line(points={{-59,40},{-50,40},{-50,-18}}, color={0,0,127}));
  end if;
  connect(y_reset_in, con.y_reset_in)
    annotation (Line(points={{-90,-100},{-90,
          -100},{-90,-68},{-78,-68},{-78,20},{-88,20},{-88,32},{-82,32}},
          color={0,0,127}));
  connect(trigger, con.trigger)
    annotation (Line(points={{-60,-100},{-60,-100},{
          -60,-40},{-78,-40},{-78,28}},color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}})),                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    __Dymola_Commands,
    Documentation(info="<html>
<p>
This module impliments a heat exchanger model with a built-in PID controller to
control the outlet temperature at <code>port_b2</code> if set parameter
<code>use_controller=true </code>. Otherwise, if set <code>use_controller=false</code>,
the PID controller and the three-way valve are removed and the outlet temperature at <code>port_b2</code> will
not be controlled.
</p>
<p>
Note that if the three-way valve is activated, it'll have the same differential pressure as the heat exchanger.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatExchanger;
