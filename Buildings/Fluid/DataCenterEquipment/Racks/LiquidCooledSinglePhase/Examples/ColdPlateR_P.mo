within Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Examples;
model ColdPlateR_P "Example model for cold plate"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=0.25)
    "Propylene glycol";
  parameter Modelica.Units.SI.HeatFlowRate P_nominal=2*66000
    "Design heat flow rate at u=1, also called Thermal Design Power (TDP)";

  parameter Modelica.Units.SI.TemperatureDifference dT_nominal = 7
    "Design temperature difference of coolant fluid";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=P_nominal/
      dT_nominal/cp_default "Nominal mass flow rate at TDP";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(state=state_default)
    "Heat capacity, to compute additional dry mass";
  parameter Data.OCP_1kW_OAM_PG25 dat(PIT_nominal=P_nominal,
      m_flow_nominal=m_flow_nominal) "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uti(
    amplitude=0.4,
    width=2/5,
    period=5,
    shift=0.2,
    offset=0.62)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp m_flow(
    height=-m_flow_nominal/2,
    duration=5,
    offset=m_flow_nominal,
    startTime=30)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.ColdPlateR_P rac(
    redeclare package Medium = Medium,
    dat=dat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Rack with cold plate heat exchangers"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  Fluid.Sensors.TemperatureTwoPort senTOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Modelica.Blocks.Math.Gain PIT(
    k(final unit="W",
      min=0) = dat.PIT_nominal,
    u(final unit="1"),
    y(final unit="W"))
    "Power consumption by the IT equipment"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
protected
  parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
equation
  connect(sou.ports[1],rac. port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));

  connect(m_flow.y, sou.m_flow_in) annotation (Line(points={{-58,8},{-42,8}},
                            color={0,0,127}));
  connect(rac.port_b, senTOut.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(senTOut.port_b, bou.ports[1])
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(uti.y, PIT.u)
    annotation (Line(points={{-58,50},{-42,50}}, color={0,0,127}));
  connect(PIT.y, rac.P) annotation (Line(points={{-19,50},{-10,50},{-10,6},{-1,6}},
        color={0,0,127}));
  annotation (
    experiment(
      StopTime=60,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/LiquidCooledSinglePhase/Examples/ColdPlateR_P.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a cold plate with different GPU utilization.
</p>
<p>
The GPU utilization is modeled as a pulse that is parameterized based on the data of Patel et al. (2024),
Figure 6(b) which is for the Llama2-50B LLM, neglecting the very high frequency and approximating
the change in utilization with a periodic pulse input.
The cold plate has a constant flow rate at the start of the simulation, and then ramps down to
half the design flow rate to show the change in case temperature.
</p>
<h4>References</h4>
<p>Pratyush Patel, Esha Choukse, Chaojie Zhang, Íñigo Goiri, Brijesh Warrier, Nithish Mahalingam, and Ricardo Bianchini.<br/>
Characterizing Power Management Opportunities for LLMs in the Cloud.<br/>
In Proceedings of the 29th ACM International Conference on
Architectural Support for Programming Languages and Operating Systems, Volume 3 (ASPLOS '24).<br/>
Association for Computing Machinery, New York, NY, USA, 207–222. 2024.<br/>
<a href=\"https://doi.org/10.1145/3620666.3651329\">doi:10.1145/3620666.3651329</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ColdPlateR_P;
