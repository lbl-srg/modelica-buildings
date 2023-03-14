within Buildings.Templates.Components.Interfaces;
model BoilerHotWater "Hot water boiler"
  extends Buildings.Templates.Components.Interfaces.PartialBoilerHotWater;

  replaceable Buildings.Fluid.Boilers.BaseClasses.PartialBoiler boi(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_small=m_flow_small)
    "Boiler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Controls.OBC.CDL.Continuous.PIDWithReset ctl(
    Ti=60,
    final yMax=1,
    final yMin=0,
    final reverseActing=true)
    "HW supply temperature controller"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
equation
  connect(port_a, boi.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(boi.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(boi.T, ctl.u_m) annotation (Line(points={{11,8},{20,8},{20,20},{-40,
          20},{-40,28}}, color={0,0,127}));
  connect(ctl.y, boi.y) annotation (Line(points={{-28,40},{-20,40},{-20,8},{-12,
          8}}, color={0,0,127}));
  connect(bus.THeaWatSupSet, ctl.u_s) annotation (Line(
      points={{0,100},{0,60},{-60,60},{-60,40},{-52,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y1, ctl.trigger) annotation (Line(
      points={{0,100},{0,60},{-60,60},{-60,20},{-46,20},{-46,28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  defaultComponentName="boi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BoilerHotWater;
