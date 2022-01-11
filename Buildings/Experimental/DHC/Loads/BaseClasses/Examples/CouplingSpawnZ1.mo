within Buildings.Experimental.DHC.Loads.BaseClasses.Examples;
model CouplingSpawnZ1
  "Example illustrating the coupling of a building model to heating water and chilled water loops"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingSpawnZ1 bui(
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    "Building"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHeaWat(
    use_m_flow_in=true,
    redeclare final package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-30,0})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(
    y=bui.terUni.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression mHeaWat_flow(
    y=bui.disFloHea.mReqTot_flow)
    "Heating water flow rate"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T supChiWat(
    use_m_flow_in=true,
    redeclare final package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Chilled water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-30,-80})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(
    y=bui.terUni.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Sources.RealExpression mChiWat_flow(
    y=bui.disFloCoo.mReqTot_flow)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium=Medium1,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,0})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium=Medium1,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,-80})));
equation
  connect(THeaWatSup.y,supHeaWat.T_in)
    annotation (Line(points={{-59,0},{-50,0},{-50,4},{-42,4}},color={0,0,127}));
  connect(mHeaWat_flow.y,supHeaWat.m_flow_in)
    annotation (Line(points={{-59,20},{-50,20},{-50,8},{-42,8}},color={0,0,127}));
  connect(TChiWatSup.y,supChiWat.T_in)
    annotation (Line(points={{-59,-80},{-50,-80},{-50,-76},{-42,-76}},color={0,0,127}));
  connect(mChiWat_flow.y,supChiWat.m_flow_in)
    annotation (Line(points={{-59,-60},{-50,-60},{-50,-72},{-42,-72}},color={0,0,127}));
  connect(supHeaWat.ports[1],bui.ports_aHeaWat[1])
    annotation (Line(points={{-20,0},{20,0},{20,-32},{40,-32}},color={0,127,255}));
  connect(supChiWat.ports[1],bui.ports_aChiWat[1])
    annotation (Line(points={{-20,-80},{20,-80},{20,-36},{40,-36}},color={0,127,255}));
  connect(bui.ports_bHeaWat[1],sinHeaWat.ports[1])
    annotation (Line(points={{60,-32},{80,-32},{80,0},{120,0}},color={0,127,255}));
  connect(bui.ports_bChiWat[1],sinChiWat.ports[1])
    annotation (Line(points={{60,-36},{80,-36},{80,-80},{120,-80}},color={0,127,255}));
  annotation (
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This example illustrates the use of
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding</a>,
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution</a>
in a configuration with
</p>
<ul>
<li>
a one-zone building model based on an EnergyPlus envelope model, and
</li>
<li>
no secondary pumps.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-140},{160,80}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Examples/CouplingSpawnZ1.mos" "Simulate and plot"));
end CouplingSpawnZ1;
