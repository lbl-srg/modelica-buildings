within Buildings.DHC.Plants.Steam.Examples;
model SingleBoiler "Example model to demonstrate the single-boiler steam plant
  in a single closed loop"
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam (
    p_default=300000,
    T_default=273.15+200,
    h_default=2700000)
    "Steam medium";
  package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity (
      p_default=101325,
      T_default=273.15+100)
    "Water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat=300000
    "Saturation pressure";
  parameter Modelica.Units.SI.Temperature TSat=
     MediumSte.saturationTemperature(pSat)
     "Saturation temperature";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate of plant";
  parameter Modelica.Units.SI.PressureDifference dpPip=6000
    "Pressure drop in the condensate return pipe";
  // pumps
  parameter Buildings.Fluid.Movers.Data.Generic perPumFW(
    pressure(
      V_flow=(m_flow_nominal/1000)*{0.4,0.6,0.8,1.0},
      dp=(pSat-101325)*{1.34,1.27,1.17,1.0}))
    "Performance data for feedwater pump";
    parameter Buildings.Fluid.Movers.Data.Generic perPumCNR(
   pressure(
     V_flow=(m_flow_nominal/1000)*{0,1,2},
     dp=dpPip*{2,1,0}))
    "Performance data for condensate return pumps";

  Buildings.DHC.Plants.Steam.SingleBoiler pla(
    redeclare final package Medium = MediumWat,
    redeclare final package MediumHea_b = MediumSte,
    allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal,
    final pSteSet=pSat,
    final per=perPumFW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Plant"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.DHC.Loads.Steam.BaseClasses.ControlVolumeCondensation vol(
    redeclare final package MediumSte = MediumSte,
    redeclare final package MediumWat = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=pSat,
    final m_flow_nominal=m_flow_nominal,
    V=1)
    "Volume"
    annotation (Placement(transformation(extent={{20,40},{40,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumWat,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal = dpPip)
    "Resistance in district network"
    annotation (Placement(transformation(extent={{0,-60},{-20,-40}})));
  Buildings.DHC.Loads.Steam.BaseClasses.SteamTrap steTra(
    redeclare final package Medium = MediumWat,
    final m_flow_nominal=m_flow_nominal)
    "Steam trap"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Sources.Sine inp(
    amplitude=-0.5,
    f=1/86400,
    phase=3.1415926535898,
    offset=0.5)
    "Input signal"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = MediumWat)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Buildings.Controls.Continuous.LimPID conPumCNR(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=15)
    "Controller"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.Gain m_flow(final k=m_flow_nominal)
    "Gain to calculate m_flow"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCNR(
    redeclare final package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=101325,
    final per=perPumCNR,
    y_start=1)
    "Condensate return pump"
    annotation (Placement(transformation(extent={{40,-60},{20,-40}})));
equation
  connect(res.port_b, pla.port_aSerHea) annotation (Line(points={{-20,-50},{-30,
          -50},{-30,30},{-20,30}},
                              color={0,127,255}));
  connect(vol.port_b, steTra.port_a)
    annotation (Line(points={{40,30},{60,30}}, color={0,127,255}));
  connect(pla.port_bSerHea, vol.port_a)
    annotation (Line(points={{0,30},{20,30}},  color={0,127,255}));
  connect(steTra.port_b, senMasFlo.port_a) annotation (Line(points={{80,30},{90,
          30},{90,-50},{80,-50}}, color={0,127,255}));
  connect(senMasFlo.port_b, pumCNR.port_a)
    annotation (Line(points={{60,-50},{40,-50}},color={0,127,255}));
  connect(pumCNR.port_b, res.port_a)
    annotation (Line(points={{20,-50},{0,-50}},    color={0,127,255}));
  connect(senMasFlo.m_flow, conPumCNR.u_m)
    annotation (Line(points={{70,-39},{70,-30},{10,-30},{10,-22}},
                                                 color={0,0,127}));
  connect(conPumCNR.y, pumCNR.y)
    annotation (Line(points={{21,-10},{30,-10},{30,-38}},   color={0,0,127}));
  connect(m_flow.y, conPumCNR.u_s)
    annotation (Line(points={{-39,-10},{-2,-10}},color={0,0,127}));
  connect(inp.y, m_flow.u)
    annotation (Line(points={{-69,-10},{-62,-10}},
                                                 color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Tolerance=1e-6),
      __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Steam/Examples/SingleBoiler.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>This model validates the steam plant implemented in
<a href=\"modelica://Buildings.DHC.Plants.Steam.SingleBoiler\">
Buildings.DHC.Plants.Steam.SingleBoiler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleBoiler;
