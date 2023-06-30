within Buildings.Fluid.CHPs.Rankine.Examples.BaseClasses;
partial model PartialORC "Partial example model of an organic Rankine cycle"

  parameter Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.R123 pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Air "Medium in the condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 0.4
    "Medium flow rate in the evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 1
    "Medium flow rate in the condenser";

  replaceable Buildings.Fluid.CHPs.Rankine.BaseClasses.PartialBottomingCycle ran(
    pro=pro,
    TEva(displayUnit="degC") = 357.95,
    TCon(displayUnit="degC") = 298.15,
    etaExp=0.7)
    "Bottoming Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    redeclare final package Medium = MediumEva,
    m_flow=mEva_flow_nominal,
    T=423.15,
    nPorts=1) "Source on the evaporator side"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(
    redeclare final package Medium = MediumCon,
    nPorts=1)
          "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.CHPs.Rankine.BaseClasses.HeaterCooler_Q con(
    redeclare final package Medium = MediumCon,
    final allowFlowReversal=false,
    final m_flow_nominal=mCon_flow_nominal,
    final from_dp=false,
    final dp_nominal=0,
    final T_start=sinCon.T,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Condenser"
    annotation (Placement(transformation(extent={{10,-60},{-10,-40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    redeclare final package Medium = MediumCon,
    m_flow=mCon_flow_nominal,
    T=288.15,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(
    redeclare final package Medium = MediumEva,
    nPorts=1) "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));

equation
  connect(con.port_a,souCon. ports[1])
    annotation (Line(points={{10,-50},{60,-50}}, color={0,127,255}));
  connect(con.port_b,sinCon. ports[1])
    annotation (Line(points={{-10,-50},{-60,-50}}, color={0,127,255}));
  connect(ran.QCon_flow,con. Q_flow) annotation (Line(points={{11,-10},{20,-10},
          {20,-44},{12,-44}},color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model demonstrates the use of models extended from
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.BaseClasses.PartialBottomingCycle\">
Buildings.Fluid.CHPs.Rankine.BaseClasses.PartialBottomingCycle</a>.
</html>",revisions="<html>
<ul>
<li>
June 30, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end PartialORC;
