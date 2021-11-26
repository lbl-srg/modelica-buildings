within Buildings.Templates.Components.Coils;
model WaterBasedCooling "Water-based"
  extends Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.WaterBased,
    final typHex=hex.typ,
    final typAct=act.typ,
    final have_sou=true,
    final have_weaBus=false,
    port_aSou(redeclare final package Medium = MediumCoo),
    port_bSou(redeclare final package Medium = MediumCoo));

  outer replaceable package MediumCoo=Buildings.Media.Water
    "Source side medium";

  inner parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Liquid mass flow rate.value")
    "Liquid mass flow rate"
    annotation(Dialog(group = "Nominal condition"), Evaluate=true);

  inner parameter Modelica.SIunits.PressureDifference dpWat_nominal(
    displayUnit="Pa")=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Liquid pressure drop.value")
    "Liquid pressure drop"
    annotation(Dialog(group = "Nominal condition"), Evaluate=true);

  replaceable Buildings.Templates.Components.Valves.None act constrainedby
    Buildings.Templates.Components.Valves.Interfaces.PartialValve(redeclare
      final package Medium = MediumCoo) "Actuator" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-10,-70},{10,-50}})));

  replaceable Buildings.Templates.Components.HeatExchangers.WetCoilCounterFlow
    hex constrainedby .Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerWater(
    redeclare final package Medium1 = MediumCoo,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=if typAct == Types.Actuator.None then dpWat_nominal else 0,
    final dp2_nominal=dpAir_nominal)
    "Heat exchanger"
    annotation (choices(
        choice(redeclare
          Buildings.Templates.Components.Coils.HeatExchangers.WetCoilCounterFlow hex
          "Discretized wet heat exchanger model"), choice(redeclare
          Buildings.Templates.Components.Coils.HeatExchangers.WetCoilEffectivenessNTU
          hex "Effectiveness-NTU wet heat exchanger model")), Placement(
        transformation(extent={{10,4},{-10,-16}})));

equation
  /* Hardware point connection - start */
  connect(bus.y, act.y);
  /* Hardware point connection - end */
  connect(port_aSou, act.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
          {-4,-80},{-4,-70}}, color={0,127,255}));
  connect(act.port_bRet, port_bSou) annotation (Line(points={{4,-70},{4,-80},{40,
          -80},{40,-100}}, color={0,127,255}));
  connect(act.port_bSup,hex. port_a1) annotation (Line(points={{-4,-50},{-4,-22},
          {20,-22},{20,-12},{10,-12}}, color={0,127,255}));
  connect(hex.port_b1, act.port_aRet) annotation (Line(points={{-10,-12},{-20,-12},
          {-20,-24},{4,-24},{4,-50}}, color={0,127,255}));
  connect(port_a,hex. port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));

  connect(hex.port_b2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (
    Icon(
      graphics={
      Bitmap(
        extent={{-53,-100},{53,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/WaterBasedCooling.svg"),
      Bitmap(
        extent={{-200,-260},{40,-100}},
        visible=typAct==Buildings.Templates.Components.Types.Actuator.ThreeWayValve,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/ThreeWayValve.svg"),
      Bitmap(
        extent={{-200,-260},{40,-100}},
        visible=typAct==Buildings.Templates.Components.Types.Actuator.TwoWayValve,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoWayValve.svg")},
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
