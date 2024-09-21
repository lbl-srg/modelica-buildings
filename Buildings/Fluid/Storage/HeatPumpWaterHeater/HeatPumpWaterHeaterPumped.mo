within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterPumped "Pumped heat pump water heater model"
  extends
    Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses.PartialHeatPumpWaterHeater(
      redeclare Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.DXCoil datCoi,
      redeclare Buildings.Fluid.Storage.StratifiedEnhancedInternalHex tan(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare package MediumHex = MediumTan,
      hHex_a=datWT.hSegTop,
      hHex_b=datWT.hSegBot,
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

    replaceable parameter Buildings.Fluid.Movers.Data.Generic pumPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for pump"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-70,-76},{-50,-56}})),Dialog(group="Pump parameters"));

  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal
    "Nominal mass flow rate through the heat exchanger"
    annotation(Dialog(group="Nominal conditions"));

  Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed sinSpeDXCoo(datCoi=
    datCoi,
    redeclare package MediumEva = MediumAir,
    redeclare package MediumCon = MediumTan,
    dpEva_nominal=dpAir_nominal,
    dpCon_nominal=dpCon_nominal,
    final computeReevaporation=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(redeclare package Medium =
    MediumTan,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=pumPer,
    m_flow_nominal=mHex_flow_nominal,
    dp_nominal=100000)
    annotation (Placement(transformation(extent={{-46,-44},{-26,-24}})));

  Modelica.Blocks.Math.Add3 add "Addition of power"
    annotation (Placement(transformation(extent={{66,-50},{86,-30}})));

  Modelica.Blocks.Math.Gain gai_mHex_flow(k=mHex_flow_nominal)
    "Nominal mass flow rate"
    annotation (Placement(transformation(extent={{-34,10},{-26,18}})));

  ExpansionVessel exp1(redeclare package Medium = MediumTan, V_start=1)
    annotation (Placement(transformation(extent={{-70,-6},{-50,14}})));


equation
  connect(on,sinSpeDXCoo. on)
    annotation (Line(points={{-120,0},{-80,0},{-80,68},{-61,68}}, color={255,0,255}));

  connect(add.y, P)
    annotation (Line(points={{87,-40},{110,-40}}, color={0,0,127}));

  connect(fan.P, add.u1)
    annotation (Line(points={{45,69},{48,69},{48,-32},{64,-32}}, color={0,0,127}));

  connect(add.u2,sinSpeDXCoo. P)
    annotation (Line(points={{64,-40},{8,-40},{8,69},{-39,69}},color={0,0,127}));

  connect(add.u3, pum.P)
    annotation (Line(points={{64,-48},{-18,-48},{-18,-25},{-25,-25}}, color={0,0,127}));

  connect(yMov.y, gai_mHex_flow.u)
    annotation (Line(points={{-49,30},{-46,30},{-46,14},{-34.8,14}}, color={0,0,127}));

  connect(gai_mHex_flow.y, pum.m_flow_in)
    annotation (Line(points={{-25.6,14},{-20,14},{-20,0},{-36,0},{-36,-22}}, color={0,0,127}));

  connect(exp1.port_a, pum.port_a)
    annotation (Line(points={{-60,-6},{-60,-34},{-46,-34}}, color={0,127,255}));
  connect(sinSpeDXCoo.port_b, fan.port_a)
    annotation (Line(points={{-40,60},{24,60}}, color={0,127,255}));

  connect(port_a1, sinSpeDXCoo.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));

  connect(pum.port_a, sinSpeDXCoo.portCon_b)
    annotation (Line(points={{-46,-34},{-90,-34},{-90,46},{-56,46},{-56,50}}, color={0,127,255}));

  connect(sinSpeDXCoo.portCon_a, tan.portHex_b)
    annotation (Line(points={{-44,50},{-44,46},{18,46},{18,-34},{26,-34}}, color={0,127,255}));

  connect(pum.port_b, tan.portHex_a)
    annotation (Line(points={{-26,-34},{0,-34},{0,-29.8},{26,-29.8}}, color={0,127,255}));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This is a model of a heat pump water heater with pumped condenser for thermal energy storage based on the EnergyPlus model WaterHeater:HeatPump:PumpedCondenser. </p>
    <p>
    The system model is composed of the following component model: (1) A stratified water tank (2) A single speed air-to-water heating coil (3) A supply fan (4) A circulation pump. </p>
    <p>
    Please note that this model takes into account the detailed heat exchange of the circulation pump, which is not included in EnergyPlus. The heat exchanger component is absent from the EnergyPlus model. Similar to the wrapped configuration, the performance curve of the EIR for fluid temperatures needs to be given in this model while the EnergyPlus model requires the COP curve for fluid temperatures as the counterpart.</p>
</html>"));
end HeatPumpWaterHeaterPumped;
