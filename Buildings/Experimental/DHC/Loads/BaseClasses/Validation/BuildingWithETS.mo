within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model BuildingWithETS
  "Model that validates the PartialBuildingWithPartialETS class"
  extends Modelica.Icons.Example;
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  package MediumW=Buildings.Media.Water
    "Water";
  package MediumS=Modelica.Media.Water.IdealSteam
    "Steam";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  BaseClasses.BuildingWithETS buiHeaGen1(
    redeclare final package Medium1=MediumS,
    redeclare final package Medium1b=MediumW,
    redeclare final package Medium2=MediumW,
    ets(
      final typ=TypDisSys.HeatingGeneration1,
      final m_flow_nominal=m_flow_nominal))
    "Building and ETS component - Heating only (steam)"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Fluid.Sources.MassFlowSource_T souDisSup(
    redeclare final package Medium=MediumS,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  Fluid.Sources.Boundary_pT sinDisRet(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare final package Medium1=MediumS,
    redeclare final package Medium2=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-200,196},{-180,216}})));
  BaseClasses.BuildingWithETS buiComGen1(
    redeclare final package Medium1=MediumS,
    redeclare final package Medium1b=MediumW,
    redeclare final package Medium1ChiWat=MediumW,
    redeclare final package Medium2=MediumW,
    ets(
      final typ=TypDisSys.CombinedGeneration1,
      final m_flow_nominal=m_flow_nominal))
    "Building and ETS component - Combined heating (steam) and cooling"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));
  Fluid.Sources.MassFlowSource_T souDisSup1(
    redeclare final package Medium=MediumS,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Fluid.Sources.Boundary_pT sinDisRet1(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo1(
    redeclare final package Medium1=MediumS,
    redeclare final package Medium2=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-40,196},{-20,216}})));
  Fluid.Sources.MassFlowSource_T souDisSup2(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Fluid.Sources.Boundary_pT sinDisRet2(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo2(
    redeclare final package Medium1=MediumW,
    redeclare final package Medium2=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{0,156},{20,176}})));
  Fluid.Sources.MassFlowSource_T souDisSup3(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));
  Fluid.Sources.Boundary_pT sinDisRet3(
    redeclare final package Medium=MediumW,
    nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo3(
    redeclare final package Medium1=MediumW,
    redeclare final package Medium2=MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-200,76},{-180,96}})));
  BaseClasses.BuildingWithETS buiCoo(
    redeclare final package Medium1=MediumW,
    redeclare final package Medium2=MediumW,
    ets(
      final typ=TypDisSys.Cooling,
      final m_flow_nominal=m_flow_nominal))
    "Building and ETS component - Cooling only"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
equation
  connect(souDisSup.ports[1],senDifEntFlo.port_a1)
    annotation (Line(points={{-220,220},{-212,220},{-212,212},{-200,212}},color={0,127,255}));
  connect(senDifEntFlo.port_b1,buiHeaGen1.port_a1)
    annotation (Line(points={{-180,212},{-170,212},{-170,220},{-160,220}},color={0,127,255}));
  connect(buiHeaGen1.port_b1,senDifEntFlo.port_a2)
    annotation (Line(points={{-140,220},{-120,220},{-120,200},{-180,200}},color={0,127,255}));
  connect(senDifEntFlo.port_b2,sinDisRet.ports[1])
    annotation (Line(points={{-200,200},{-212,200},{-212,180},{-220,180}},color={0,127,255}));
  connect(souDisSup1.ports[1],senDifEntFlo1.port_a1)
    annotation (Line(points={{-60,220},{-52,220},{-52,212},{-40,212}},color={0,127,255}));
  connect(senDifEntFlo1.port_b1,buiComGen1.port_a1)
    annotation (Line(points={{-20,212},{-10,212},{-10,220},{0,220}},color={0,127,255}));
  connect(buiComGen1.port_b1,senDifEntFlo1.port_a2)
    annotation (Line(points={{20,220},{60,220},{60,200},{-20,200}},color={0,127,255}));
  connect(senDifEntFlo1.port_b2,sinDisRet1.ports[1])
    annotation (Line(points={{-40,200},{-52,200},{-52,180},{-60,180}},color={0,127,255}));
  connect(souDisSup2.ports[1],senDifEntFlo2.port_a1)
    annotation (Line(points={{-20,180},{-10,180},{-10,172},{0,172}},color={0,127,255}));
  connect(senDifEntFlo2.port_b2,sinDisRet2.ports[1])
    annotation (Line(points={{0,160},{-10,160},{-10,140},{-20,140}},color={0,127,255}));
  connect(senDifEntFlo2.port_a2,buiComGen1.port_b1ChiWat)
    annotation (Line(points={{20,160},{40,160},{40,216},{20,216}},color={0,127,255}));
  connect(senDifEntFlo2.port_b1,buiComGen1.port_a1ChiWat)
    annotation (Line(points={{20,172},{32,172},{32,206},{-4,206},{-4,216},{0,216}},color={0,127,255}));
  connect(souDisSup3.ports[1],senDifEntFlo3.port_a1)
    annotation (Line(points={{-220,100},{-210,100},{-210,92},{-200,92}},color={0,127,255}));
  connect(sinDisRet3.ports[1],senDifEntFlo3.port_b2)
    annotation (Line(points={{-220,60},{-210,60},{-210,80},{-200,80}},color={0,127,255}));
  connect(senDifEntFlo3.port_a2,buiCoo.port_b1ChiWat)
    annotation (Line(points={{-180,80},{-120,80},{-120,96},{-140,96}},color={0,127,255}));
  connect(senDifEntFlo3.port_b1,buiCoo.port_a1ChiWat)
    annotation (Line(points={{-180,92},{-170,92},{-170,96},{-160,96}},color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-260},{260,260}})));
end BuildingWithETS;
