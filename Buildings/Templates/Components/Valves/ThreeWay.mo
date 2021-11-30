within Buildings.Templates.Components.Valves;
model ThreeWay "Three-way valve"
  extends Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.ThreeWay);

  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil valve.Pressure drop.value")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.PressureDifference dpFixed_nominal[2](
    each displayUnit="Pa",
    each min=0)={1, 1} * dpWat_nominal
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation(Dialog(group="Nominal condition"));

  replaceable Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=mWat_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=dpFixed_nominal)
    "Valve"
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,0})));
  Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mWat_flow_nominal * {1, -1, -1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=fill(0, 3))
    "Junction"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,0})));
equation
  connect(port_aSup, jun.port_1)
    annotation (Line(points={{40,-100},{40,-10}},   color={0,127,255}));
  connect(jun.port_2, port_bSup)
    annotation (Line(points={{40,10},{40,100}},   color={0,127,255}));
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{30,5.55112e-16},{-30,-1.77636e-15}},
                                              color={0,127,255}));
  connect(val.port_2, port_bRet) annotation (Line(points={{-40,-10},{-40,-100}},
                     color={0,127,255}));
  connect(val.port_1, port_aRet)
    annotation (Line(points={{-40,10},{-40,100}},        color={0,127,255}));

  connect(y, val.y)
    annotation (Line(points={{-120,0},{-52,2.10942e-15}}, color={0,0,127}));
end ThreeWay;
