within Buildings.ChillerWSE;
model HeatExchanger_T
  "Heat exchanger with outlet temperature control on medium 2 side"
  extends Buildings.ChillerWSE.BaseClasses.PartialHeatExchanger_T;
  extends Buildings.ChillerWSE.BaseClasses.PartialControllerInterface(
    final reverseAction=true);

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
    final y_start=y_startController,
    final reverseAction=reverseAction,
    final reset=reset,
    final y_reset=y_reset)
    "Controller for temperature at port_b2"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.RealExpression T_port_b2(y=T_outflow)
    "Temperature at port_b2"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

protected
  Medium2.Temperature T_outflow "Temperature of outflowing fluid at port_b on medium 2 side";

equation
  T_outflow=Medium2.temperature(state=Medium2.setState_phX(
      p=port_b2.p, h=actualStream(port_b2.h_outflow), X=actualStream(port_b2.Xi_outflow)));

  connect(T_port_b2.y, con.u_m)
    annotation (Line(points={{-79,0},{-70,0},{-70,28}},  color={0,0,127}));
  connect(TSet, con.u_s)
    annotation (Line(points={{-120,40},{-120,40},{-82,40}}, color={0,0,127}));
  connect(con.y, bypVal.y)
    annotation (Line(points={{-59,40},{-50,40},{-50,-8}}, color={0,0,127}));
  connect(y_reset_in, con.y_reset_in) annotation (Line(points={{-90,-100},{-90,
          -100},{-90,-68},{-78,-68},{-78,20},{-88,20},{-88,32},{-82,32}},
                                    color={0,0,127}));
  connect(trigger, con.trigger) annotation (Line(points={{-60,-100},{-60,-100},{
          -60,-40},{-78,-40},{-78,28}},color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}})),                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    __Dymola_Commands,
    Documentation(info="<html>
<p>This module simulates a heat exchanger with a three-way valve used to modulate water flow rate.The three-way valve has the same differential pressure as the heat exchanger.</p>
</html>", revisions="<html>
<ul>
<li>
September 08, 2016, by Yangyang Fu:<br>
Delete parameter: nominal flowrate of temperaure sensors. 
</li>
</ul>
<ul>
<li>
July 30, 2016, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end HeatExchanger_T;
