within Buildings.DHC.Loads.Steam.BaseClasses.Examples;
model ControlVolumeCondensation
  "Example model for heat transfer with the condensation control volume"
  extends Modelica.Icons.Example;

package MediumSte = Buildings.Media.Steam (
  T_default=273.15+180,
  p_default=1e6)
    "Steam medium - Medium model for port_a (inlet)";
package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_b (outlet)";

  Buildings.DHC.Loads.Steam.BaseClasses.ControlVolumeCondensation volDyn(
    V=1,
    redeclare package MediumWat = MediumWat,
    redeclare package MediumSte = MediumSte,
    m_flow_nominal=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true) "Dynamic volume"
    annotation (Placement(transformation(extent={{20,0},{40,-20}})));
  Buildings.DHC.Loads.Steam.BaseClasses.ControlVolumeCondensation volSte(
    V=1,
    redeclare package MediumWat = MediumWat,
    redeclare package MediumSte = MediumSte,
    m_flow_nominal=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=true) "Steady volume"
    annotation (Placement(transformation(extent={{20,-40},{40,-60}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    T=453.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    T=453.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = MediumWat,
    p=volDyn.p_start,
    T=293.15,
    nPorts=2) "Boundary condition"
    annotation (Placement(transformation(extent={{80,-22},{60,-2}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    offset=2,
    height=-1) "Ramp signal"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant const(k=-10000) "Heat loss"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(sou.ports[1], volDyn.port_a)
    annotation (Line(points={{2,-10},{20,-10}}, color={0,127,255}));
  connect(volDyn.port_b, bou.ports[1])
    annotation (Line(points={{40,-10},{60,-10}}, color={0,127,255}));
  connect(preHeaFlo.port,heaFlo. port_a) annotation (Line(
      points={{-40,50},{-20,50}},
      color={191,0,0}));
  connect(preHeaFlo.Q_flow,const. y) annotation (Line(
      points={{-60,50},{-69,50}},
      color={0,0,127}));
  connect(heaFlo.port_b, volDyn.heatPort)
    annotation (Line(points={{0,50},{30,50},{30,0}}, color={191,0,0}));
  connect(sou1.ports[1], volSte.port_a)
    annotation (Line(points={{0,-50},{20,-50}}, color={0,127,255}));
  connect(ramp.y, sou.m_flow_in) annotation (Line(points={{-69,-10},{-40,-10},{-40,-2},{-18,-2}},
                             color={0,0,127}));
  connect(ramp.y, sou1.m_flow_in) annotation (Line(points={{-69,-10},{-40,-10},
          {-40,-42},{-20,-42}}, color={0,0,127}));
  connect(volSte.port_b, bou.ports[2]) annotation (Line(points={{40,-50},{50,
          -50},{50,-14},{60,-14}}, color={0,127,255}));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the control volume with condensation.
The dynamic volume includes heat conduction to the ambient while the
steady volume heat balance is only dependent on the mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
February 26, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1E-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/Steam/BaseClasses/Examples/ControlVolumeCondensation.mos"
        "Simulate and plot"));
end ControlVolumeCondensation;
