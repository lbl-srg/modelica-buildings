within Buildings.Templates.Components.CoolingTower;
model Merkel
  extends
    Buildings.Templates.Components.CoolingTower.Interfaces.PartialCoolingTower(
      final typ=Buildings.Templates.Components.Types.CoolingTower.Merkel);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));

  parameter Real ratWatAir_nominal(final min=0, final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal=
    dat.getReal(varName=id + ".CoolingTower.TAirInWB_nominal.value")
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatIn_nominal=
    dat.getReal(varName=id + ".CoolingTower.TCW_nominal.value")
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(
    displayUnit="K", final min=0)=
    dat.getReal(varName=id + ".CoolingTower.dT_nominal.value")
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  final parameter Modelica.Units.SI.Temperature TWatOut_nominal(displayUnit="degC")=
    TWatIn_nominal - dT_nominal
    "Nominal water outlet temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Power PFan_nominal=
    dat.getReal(varName=id + ".CoolingTower.PFan_nominal.value")
    "Fan power"
    annotation (Dialog(group="Fan"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    dat.getReal(varName=id + ".CoolingTower.dp_nominal.value")
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.TemperatureDifference dTApp_nominal(
    displayUnit="K", final min=0)=
    TWatOut_nominal - TAirInWB_nominal
    "Nominal approach temperature"
    annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow(
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small,
    each final ratWatAir_nominal=ratWatAir_nominal,
    each final TAirInWB_nominal=TAirInWB_nominal,
    each final TWatIn_nominal=TWatIn_nominal,
    each final TWatOut_nominal=TWatOut_nominal,
    each final PFan_nominal=PFan_nominal,
    each final dp_nominal=dp_nominal,
    redeclare each final package Medium = Medium,
    each final show_T=show_T,
    each final m_flow_nominal=m_flow_nominal,
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
