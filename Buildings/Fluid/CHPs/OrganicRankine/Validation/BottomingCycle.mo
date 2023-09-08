within Buildings.Fluid.CHPs.OrganicRankine.Validation;
model BottomingCycle "Example bottoming ORC model"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.R123 pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Air "Medium in the condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 0.4
    "Medium flow rate in the evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 1
    "Medium flow rate in the condenser";

  Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle ORC(
    redeclare final package Medium1 = MediumEva,
    redeclare final package Medium2 = MediumCon,
    final m1_flow_nominal=mEva_flow_nominal,
    final m2_flow_nominal=mCon_flow_nominal,
    pro=pro,
    TEva(displayUnit="degC") = 357.95,
    TCon(displayUnit="degC") = 298.15,
    etaExp=0.7,
    UA=100)     "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Modelica.Blocks.Sources.Cosine TSou(
    amplitude=5,
    f=0.01,
    offset=ORC.TEva,
    y(unit="K",
      displayUnit="degC")) "Medium source temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    redeclare final package Medium = MediumEva,
    m_flow=mEva_flow_nominal,
    use_T_in=true,
    nPorts=1) "Source on the evaporator side"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(
    redeclare final package Medium = MediumCon, nPorts=1)
          "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    redeclare final package Medium = MediumCon,
    m_flow=mCon_flow_nominal,
    T=288.15,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(
    redeclare final package Medium = MediumEva, nPorts=1)
              "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
equation
  connect(TSou.y, souEva.T_in) annotation (Line(points={{-59,30},{-50,30},{-50,34},
          {-42,34}}, color={0,0,127}));
  connect(souEva.ports[1], ORC.port_a1) annotation (Line(points={{-20,30},{-10,30},
          {-10,-4},{0,-4}}, color={0,127,255}));
  connect(ORC.port_b1, sinEva.ports[1]) annotation (Line(points={{20,-4},{30,-4},
          {30,30},{40,30}}, color={0,127,255}));
  connect(ORC.port_b2, sinCon.ports[1]) annotation (Line(points={{0,-16},{-10,-16},
          {-10,-50},{-20,-50}}, color={0,127,255}));
  connect(souCon.ports[1], ORC.port_a2) annotation (Line(points={{40,-50},{30,-50},
          {30,-16},{20,-16}}, color={0,127,255}));
annotation(experiment(StopTime=100, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/Validation/BottomingCycle.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the use of
<a href=\"modelica://Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle\">
Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle</a>.
When the upstream fluid temperature drops below the evaporation temperature
of the working fluid, the evaporator model blocks the reverse heat flow.
</html>",revisions="<html>
<ul>
<li>
September 8, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle;
