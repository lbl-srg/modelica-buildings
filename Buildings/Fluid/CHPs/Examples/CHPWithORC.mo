within Buildings.Fluid.CHPs.Examples;
model CHPWithORC "A CHP system with an ORC as its bottoming cycle"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.4
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort ORC(
    final pro=pro,
    final m_flow_nominal=m_flow_nominal,
    TEva(displayUnit="K") = 320,
    TCon(displayUnit="K") = 300,
    etaExp=0.85,
    redeclare final package Medium = Medium,
    UA=1800,
    eva(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState))
    "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.CHPs.ThermalElectricalFollowing CHP(
    redeclare package Medium = Medium,
    redeclare Data.ValidationData3 per,
    final m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    switchThermalElectricalFollowing=false,
    TEngIni=273.15 + 69.55,
    waitTime=0) "CHP unit"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=true, table={172800})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sources.MassFlowSource_T cooWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Cooling water source"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.UnitConversions.From_degC           TWatIn
    "Convert cooling water inlet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.CombiTimeTable valDat(
    tableOnFile=true,
    tableName="tab1",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(unit={"W","kg/s","degC","degC","W","W","W","W","W","degC","degC","degC"}),
    offset={0,0,0,0,0,0,0,0,0,0,0,0},
    columns={2,3,4,5,6,7,8,9,10,11,12,13},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/CHPs/Validation/MicroCogeneration.mos"))
    "Validation data from EnergyPlus simulation"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa"),
    nPorts=1) "Cooling water sink"
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  parameter Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.Pentane pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  connect(avaSig.y, CHP.avaSig) annotation (Line(points={{-19,50},{-10,50},{-10,
          19},{-2,19}}, color={255,0,255}));
  connect(cooWat.ports[1], CHP.port_a)
    annotation (Line(points={{-20,10},{0,10}}, color={0,127,255}));
  connect(valDat.y[3], TWatIn.u) annotation (Line(points={{-59,50},{-50,50},{-50,
          30},{-92,30},{-92,10},{-82,10}}, color={0,0,127}));
  connect(TWatIn.y, cooWat.T_in) annotation (Line(points={{-58,10},{-50,10},{-50,
          14},{-42,14}}, color={0,0,127}));
  connect(valDat.y[2], cooWat.m_flow_in) annotation (Line(points={{-59,50},{-50,
          50},{-50,18},{-42,18}}, color={0,0,127}));
  connect(valDat.y[1], CHP.PEleDem) annotation (Line(points={{-59,50},{-50,50},{
          -50,30},{-14,30},{-14,13},{-2,13}}, color={0,0,127}));
  connect(CHP.port_b, ORC.port_a)
    annotation (Line(points={{20,10},{40,10}}, color={0,127,255}));
  connect(ORC.port_b, sin.ports[1])
    annotation (Line(points={{60,10},{80,10}}, color={0,127,255}));
    annotation(experiment(StopTime=10000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Examples/CHPWithORC.mos"
        "Simulate and plot"));
end CHPWithORC;
