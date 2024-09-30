within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model PumpedCondenser "Pumped heat pump water heater model"
  extends Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses.PartialHeater(
    redeclare parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.PumpedCondenser
      datHPWH,
    redeclare Buildings.Fluid.Storage.StratifiedEnhancedInternalHex tan(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare package MediumHex = MediumTan,
      hHex_a=datHPWH.datTanWat.hSegTop,
      hHex_b=datHPWH.datTanWat.hSegBot,
      Q_flow_nominal=Q_flow_nominal,
      TTan_nominal=293.15,
      THex_nominal=323.15,
      mHex_flow_nominal=mHex_flow_nominal,
      dpHex_nominal=0,
      energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial));

  parameter Modelica.Units.SI.PressureDifference dpCon_nominal
    "Pressure difference over condenser at nominal flow rate"
    annotation(Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Heat transfer at nominal conditions"
    annotation(Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal
    "Nominal mass flow rate through the heat exchanger"
    annotation(Dialog(group="Nominal conditions"));

  Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed sinSpeDXCoo(
    datCoi=datHPWH.datCoi,
    redeclare package MediumEva = MediumAir,
    redeclare package MediumCon = MediumTan,
    dpEva_nominal=dpAir_nominal,
    dpCon_nominal=dpCon_nominal,
    final computeReevaporation=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single-speed air-to-water heating coil"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(redeclare package Medium =
    MediumTan,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=datHPWH.datPum,
    m_flow_nominal=mHex_flow_nominal,
    dp_nominal=100000)
    "Hot water circulation pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=270,
      origin={-70,10})));

  Modelica.Blocks.Math.Add3 add
    "Addition of power"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));

  Modelica.Blocks.Math.Gain gai_mHex_flow(
    final k=mHex_flow_nominal)
    "Nominal mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,30})));

  Buildings.Fluid.Storage.ExpansionVessel exp1(
    redeclare package Medium = MediumTan)
    "Thermal expansion vessel for normalizing pressure in hot water loop"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-90,40})));


equation
  connect(on,sinSpeDXCoo. on)
    annotation (Line(points={{-120,80},{-88,80},{-88,94},{-31,94},{-31,68}},
                                                                  color={255,0,255}));

  connect(add.y, P)
    annotation (Line(points={{91,20},{110,20}},   color={0,0,127}));

  connect(fan.P, add.u1)
    annotation (Line(points={{51,69},{60,69},{60,28},{68,28}},   color={0,0,127}));

  connect(add.u2,sinSpeDXCoo. P)
    annotation (Line(points={{68,20},{50,20},{50,28},{-4,28},{-4,69},{-9,69}},
                                                               color={0,0,127}));

  connect(add.u3, pum.P)
    annotation (Line(points={{68,12},{60,12},{60,-2},{-48,-2},{-48,-1},{-61,-1}},
                                                                      color={0,0,127}));

  connect(yMov.y, gai_mHex_flow.u)
    annotation (Line(points={{-59,80},{-40,80},{-40,42}},            color={0,0,127}));

  connect(gai_mHex_flow.y, pum.m_flow_in)
    annotation (Line(points={{-40,19},{-40,10},{-58,10}},                    color={0,0,127}));

  connect(exp1.port_a, pum.port_a)
    annotation (Line(points={{-90,30},{-90,24},{-70,24},{-70,20}},
                                                            color={0,127,255}));
  connect(sinSpeDXCoo.port_b, fan.port_a)
    annotation (Line(points={{-10,60},{30,60}}, color={0,127,255}));

  connect(port_a1, sinSpeDXCoo.port_a)
    annotation (Line(points={{-100,60},{-30,60}}, color={0,127,255}));

  connect(pum.port_a, sinSpeDXCoo.portCon_b)
    annotation (Line(points={{-70,20},{-70,46},{-26,46},{-26,50}},            color={0,127,255}));

  connect(sinSpeDXCoo.portCon_a, tan.portHex_b)
    annotation (Line(points={{-14,50},{-14,-38},{30,-38}},                 color={0,127,255}));

  connect(pum.port_b, tan.portHex_a)
    annotation (Line(points={{-70,-3.55271e-15},{-70,-33.8},{30,-33.8}},
                                                                      color={0,127,255}));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This is a model of a heat pump water heater with pumped condenser for thermal
    energy storage based on the EnergyPlus model <code>WaterHeater:HeatPump:PumpedCondenser</code>.
    </p>
    <p>
    The system model consists of the following components:
    <ul>
    <li>
    A stratified water tank of class
    <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
    Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a>
    </li>
    <li>
    A single speed air-to-water heating coil of class
    <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed\">
    Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed</a>
    </li>
    <li>
    An evaporator coil fan of class
    <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
    Buildings.Fluid.Movers.FlowControlled_m_flow</a>
    </li>
    <li> A circulation pump of class
    <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
    Buildings.Fluid.Movers.FlowControlled_m_flow</a>
    </li>
    </ul>
    </p>
    <p>
    Please note that this model takes into account the detailed heat exchange of
    the circulation pump, which is not included in EnergyPlus. The heat exchanger
    component is absent from the EnergyPlus model. Similar to the wrapped configuration,
    the performance curve of the EIR as a function of fluid temperatures needs to
    be provided for this class while the EnergyPlus model requires the COP curve
    as a function of fluid temperatures.</p>
</html>", revisions="<html>
    <ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));
end PumpedCondenser;
