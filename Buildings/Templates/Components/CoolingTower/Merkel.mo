within Buildings.Templates.Components.CoolingTower;
model Merkel "Cooling tower model using Merkel method"
  extends
    Buildings.Templates.Components.CoolingTower.Interfaces.PartialCoolingTower(
      final typ=Buildings.Templates.Components.Types.CoolingTower.Merkel);

  //TODO : Add a basin with a bypass and a heater

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
  Controls.OBC.CDL.Continuous.Multiply sigCon "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,30})));
  Controls.OBC.CDL.Conversions.BooleanToReal sigSta "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,60})));
  Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(each t=1E-2, each h=
        0.5E-2) "Evaluate fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,30})));
equation
  connect(port_a, cooTow.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(cooTow.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{50,100},{50,-20},{-20,-20},{-20,4},{-12,4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(sigCon.u2, sigSta.y)
    annotation (Line(points={{-16,42},{-30,42},{-30,48}}, color={0,0,127}));
  connect(bus.y1, sigSta.u) annotation (Line(
      points={{0,100},{0,80},{-30,80},{-30,72}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus.y, sigCon.u1) annotation (Line(
      points={{0,100},{0,60},{-4,60},{-4,42}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigCon.y, cooTow.y) annotation (Line(points={{-10,18},{-20,18},{-20,8},
          {-12,8}}, color={0,0,127}));
  connect(cooTow.PFan, evaSta.u)
    annotation (Line(points={{11,8},{30,8},{30,18}}, color={0,0,127}));
  connect(evaSta.y, bus.y1_actual) annotation (Line(points={{30,42},{30,80},{0,
          80},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Merkel;
