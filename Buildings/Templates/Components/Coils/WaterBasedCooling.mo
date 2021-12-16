within Buildings.Templates.Components.Coils;
model WaterBasedCooling "Chilled water coil"
  extends Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.WaterBasedCooling,
    final typHex=hex.typ,
    final typVal=val.typ,
    final have_sou=true,
    final have_weaBus=false,
    port_aSou(redeclare final package Medium = MediumCoo),
    port_bSou(redeclare final package Medium = MediumCoo),
    mAir_flow_nominal=dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Air mass flow rate.value"));

  outer replaceable package MediumCoo=Buildings.Media.Water
    "Source side medium";

  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(min=0)=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Liquid mass flow rate.value")
    "Liquid mass flow rate"
    annotation(Dialog(group = "Nominal condition"), Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpWat_nominal(
    displayUnit="Pa")=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Liquid pressure drop.value")
    "Liquid pressure drop"
    annotation(Dialog(group = "Nominal condition"), Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa",
    min=0)=if typVal==Buildings.Templates.Components.Types.Valve.None then 0 else
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Valve pressure drop.value")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition",
      enable=typVal<>Buildings.Templates.Components.Types.Valve.None));

  replaceable Buildings.Templates.Components.Valves.None val constrainedby
    Buildings.Templates.Components.Valves.Interfaces.PartialValve(redeclare
      final package Medium = MediumCoo,
      final m_flow_nominal=mWat_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=if typVal<>Buildings.Templates.Components.Types.Valve.None then
        dpWat_nominal else 0)
    "Valve"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,-60})));

  replaceable Buildings.Templates.Components.HeatExchangers.WetCoilCounterFlow
    hex constrainedby
    Buildings.Templates.Components.HeatExchangers.Interfaces.PartialCoilWater(
    redeclare final package Medium1 = MediumCoo,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=if typVal == Buildings.Templates.Components.Types.Valve.None then
      dpWat_nominal else 0,
    final dp2_nominal=dpAir_nominal)
    "Heat exchanger"
    annotation (choices(
      choice(redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.WetCoilCounterFlow hex
        "Discretized wet heat exchanger model"),
      choice(redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.WetCoilEffectivenessNTU
        hex "Effectiveness-NTU wet heat exchanger model")),
      Placement(transformation(extent={{10,4},{-10,-16}})));

  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare final package Medium = MediumCoo,
    final m_flow_nominal=mWat_flow_nominal*{1,-1,-1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=fill(0, 3))
    if typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    "Junction"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,-60})));
  Buildings.Templates.BaseClasses.PassThroughFluid pas(
    redeclare final package Medium=MediumCoo)
    if typVal<>Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    "Direct pass through"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-60})));
equation
  /* Control point connection - start */
  connect(bus, val.bus);
  /* Control point connection - end */
  connect(port_a,hex. port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));

  connect(hex.port_b2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(val.port_a, hex.port_b1) annotation (Line(points={{-40,-50},{-40,-12},
          {-10,-12}}, color={0,127,255}));
  connect(val.port_b, port_bSou)
    annotation (Line(points={{-40,-70},{-40,-100}}, color={0,127,255}));
  connect(val.portByp_a, jun.port_3)
    annotation (Line(points={{-30,-60},{30,-60}}, color={0,127,255}));
  connect(jun.port_2, hex.port_a1)
    annotation (Line(points={{40,-50},{40,-12},{10,-12}}, color={0,127,255}));
  connect(port_aSou, jun.port_1)
    annotation (Line(points={{40,-100},{40,-70}}, color={0,127,255}));
  connect(port_aSou, pas.port_a) annotation (Line(points={{40,-100},{40,-80},{60,
          -80},{60,-70}}, color={0,127,255}));
  connect(pas.port_b, hex.port_a1)
    annotation (Line(points={{60,-50},{60,-12},{10,-12}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<p>
Using modified getReal function with annotation(__Dymola_translate=true)
avoids warning for non literal nominal attributes.
Not supported by OCT though:
Compliance error at line 8, column 4,
  Constructors for external objects is not supported in functions

</p>
</html>"));
end WaterBasedCooling;
