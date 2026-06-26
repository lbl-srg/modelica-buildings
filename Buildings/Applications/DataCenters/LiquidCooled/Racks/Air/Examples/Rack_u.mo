within Buildings.Applications.DataCenters.LiquidCooled.Racks.Air.Examples;
model Rack_u "Example model for air cooled rack"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air
    "Air medium";
  parameter Modelica.Units.SI.HeatFlowRate P_nominal=10000
    "Design heat flow rate at u=1, also called Thermal Design Power (TDP)";

  parameter Modelica.Units.SI.TemperatureDifference dT_nominal = 10
    "Design temperature difference of coolant fluid";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=P_nominal/
      dT_nominal/cp_default "Nominal mass flow rate at TDP";

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uti(
    amplitude=0.4,
    width=2/5,
    period=60,
    shift=0.2,
    offset=0.6)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Applications.DataCenters.LiquidCooled.Racks.Air.Rack_u rac(
    redeclare package Medium = Medium,
    P_nominal=P_nominal,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air-cooled rack"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,-40})));
  Fluid.Sensors.TemperatureTwoPort senTOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(state=state_default)
    "Heat capacity, to compute additional dry mass";
  Fluid.Sensors.TemperatureTwoPort senTIn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Inlet temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
protected
  parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
equation

  connect(uti.y, rac.u) annotation (Line(points={{-58,50},{-10,50},{-10,6},{-1,6}},
        color={0,0,127}));
  connect(rac.port_b, senTOut.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(senTOut.port_b,sou. ports[1])
    annotation (Line(points={{60,0},{74,0},{74,-30},{9,-30}},
                                             color={0,127,255}));
  connect(rac.port_a, senTIn.port_b)
    annotation (Line(points={{0,0},{-20,0}}, color={0,127,255}));
  connect(senTIn.port_a, sou.ports[2]) annotation (Line(points={{-40,0},{-62,0},
          {-62,-30},{11,-30}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=540,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/LiquidCooled/Racks/Air/Examples/Rack_u.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of an air-cooled rack different GPU utilization.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Rack_u;
