within Buildings.Experimental.Templates.AHUs.Coils.Actuators;
model ThreeWayValve "Three-way valve"
  extends Interfaces.Actuator(
    final typ=Types.Actuator.ThreeWayValve);

  outer parameter Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased
    dat annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  replaceable Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Actuators.BaseClasses.PartialThreeWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=dat.mWat_flow_nominal,
      final dpValve_nominal=dat.datAct.dpValve_nominal,
      final dpFixed_nominal=dat.datAct.dpFixed_nominal)
    "Valve"
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,0})));
  Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=Medium,
    final m_flow_nominal=dat.mWat_flow_nominal * {1, -1, -1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=fill(0, 3))
    "Junction"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
equation
  connect(y, val.y)
    annotation (Line(points={{-120,0},{-80,0},{-80,20},{60,20},{60,2.22045e-15},
          {52,2.22045e-15}},                   color={0,0,127}));
  connect(port_aSup, jun.port_1)
    annotation (Line(points={{-40,-100},{-40,-10}}, color={0,127,255}));
  connect(jun.port_2, port_bSup)
    annotation (Line(points={{-40,10},{-40,100}}, color={0,127,255}));
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-30,0},{30,0}}, color={0,127,255}));
  connect(val.port_2, port_bRet) annotation (Line(points={{40,-10},{40,-100},{
          40,-100}}, color={0,127,255}));
  connect(val.port_1, port_aRet)
    annotation (Line(points={{40,10},{40,100},{40,100}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThreeWayValve;
