within Buildings.Templates.Components.CoolingTower;
model Merkel
  extends
    Buildings.Templates.Components.CoolingTower.Interfaces.PartialCoolingTower(
      final typ=Buildings.Templates.Components.Types.CoolingTower.Merkel);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));

  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow(
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small,
    each final ratWatAir_nominal=dat.ratWatAir_nominal,
    each final TAirInWB_nominal=dat.TAirInWB_nominal,
    each final TWatIn_nominal=dat.TWatIn_nominal,
    each final TWatOut_nominal=dat.TWatOut_nominal,
    each final PFan_nominal=dat.PFan_nominal,
    each final dp_nominal=dat.dp_nominal,
    each final show_T=show_T,
    each final m_flow_nominal=dat.m_flow_nominal,
    each final energyDynamics=energyDynamics) "Cooling tower"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, cooTow.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(cooTow.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.y, cooTow.y) annotation (Line(
      points={{0,100},{0,80},{-40,80},{-40,8},{-12,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{50,100},{50,80},{-40,80},{-40,4},{-12,4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Merkel;
