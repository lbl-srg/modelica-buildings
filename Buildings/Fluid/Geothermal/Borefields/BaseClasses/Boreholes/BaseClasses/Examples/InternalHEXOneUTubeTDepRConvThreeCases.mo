within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model InternalHEXOneUTubeTDepRConvThreeCases
  "Validation model for temperature-dependent convection resistance in one U-tube"
  extends Modelica.Icons.Example;

  package MediumWat = Buildings.Media.Water
    "Constant-property water transport medium";

  package MediumGly =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=0.40)
    "Constant-property propylene glycol/water transport medium";

  parameter Integer nSeg(min=1) = 10
    "Number of borehole segments";

  parameter Modelica.Units.SI.Length hSeg=borFieDatFixWat.conDat.hBor/nSeg
    "Length of the internal heat exchanger";

  parameter Modelica.Units.SI.Temperature TCold=278.15
    "Cold inlet temperature";

  parameter Modelica.Units.SI.Temperature TWarm=318.15
    "Warm inlet temperature";
  
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 10000/nSeg
  "Nominal pressure drop per borehole segment";

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=false))
    "Borefield data for fixed-property water case"
    annotation (Placement(transformation(extent={{-115.0,102.0},{-95.0,122.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=true,
        fluidPropertyEvaluation=
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water))
    "Borefield data for temperature-dependent water-correlation case"
    annotation (Placement(transformation(extent={{-85.0,102.0},{-65.0,122.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=false,
        X_a=0.40))
    "Borefield data for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-55.0,102.0},{-35.0,122.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_Rb=false,
        use_TDepRConv=true,
        fluidPropertyEvaluation=
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater,
        X_a=0.40))
    "Borefield data for temperature-dependent glycol-correlation case"
    annotation (Placement(transformation(extent={{-25.0,102.0},{-5.0,122.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
    intHexFixWat(
      redeclare package Medium = MediumWat,
      hSeg=hSeg,
      dp1_nominal=dp_nominal,
      dp2_nominal=dp_nominal,
      borFieDat=borFieDatFixWat,
      m1_flow_nominal=borFieDatFixWat.conDat.mBor_flow_nominal,
      m2_flow_nominal=borFieDatFixWat.conDat.mBor_flow_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Fixed-property water case"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
    intHexWat(
      redeclare package Medium = MediumWat,
      hSeg=hSeg,
      dp1_nominal=dp_nominal,
      dp2_nominal=dp_nominal,
      borFieDat=borFieDatWat,
      m1_flow_nominal=borFieDatWat.conDat.mBor_flow_nominal,
      m2_flow_nominal=borFieDatWat.conDat.mBor_flow_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Water medium with local temperature-dependent water correlations"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
    intHexFixGly(
      redeclare package Medium = MediumGly,
      hSeg=hSeg,
      dp1_nominal=dp_nominal,
      dp2_nominal=dp_nominal,
      borFieDat=borFieDatFixGly,
      m1_flow_nominal=borFieDatFixGly.conDat.mBor_flow_nominal,
      m2_flow_nominal=borFieDatFixGly.conDat.mBor_flow_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Fixed-property glycol case"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
    intHexGly(
      redeclare package Medium = MediumGly,
      hSeg=hSeg,
      dp1_nominal=dp_nominal,
      dp2_nominal=dp_nominal,
      borFieDat=borFieDatGly,
      m1_flow_nominal=borFieDatGly.conDat.mBor_flow_nominal,
      m2_flow_nominal=borFieDatGly.conDat.mBor_flow_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Glycol medium with local temperature-dependent glycol correlations"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Buildings.HeatTransfer.Sources.FixedTemperature TGro(
    T=283.15)
    "Fixed grout/wall temperature"
    annotation (Placement(transformation(extent={{-128.0,-8.0},{-108.0,12.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixWat1(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatFixWat.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for fixed-property water pipe 1"
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixWat2(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatFixWat.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for fixed-property water pipe 2"
    annotation (Placement(transformation(extent={{90.0,62.0},{70.0,82.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinFixWat(
    redeclare package Medium = MediumWat,
    nPorts=2)
    "Sink for fixed-property water case"
    annotation (Placement(transformation(extent={{90.0,90.0},{70.0,110.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat1(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatWat.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for water-correlation pipe 1"
    annotation (Placement(transformation(extent={{-90,22},{-70,42}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat2(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatWat.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for water-correlation pipe 2"
    annotation (Placement(transformation(extent={{90.0,4.0},{70.0,24.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    nPorts=2)
    "Sink for water-correlation case"
    annotation (Placement(transformation(extent={{90.0,36.0},{70.0,56.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGly1(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatFixGly.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for fixed-property glycol pipe 1"
    annotation (Placement(transformation(extent={{-90,-18},{-70,2}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGly2(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatFixGly.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for fixed-property glycol pipe 2"
    annotation (Placement(transformation(extent={{90.0,-46.0},{70.0,-26.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinFixGly(
    redeclare package Medium = MediumGly,
    nPorts=2)
    "Sink for fixed-property glycol case"
    annotation (Placement(transformation(extent={{90.0,-22.0},{70.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souGly1(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatGly.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for glycol-correlation pipe 1"
    annotation (Placement(transformation(extent={{-90,-58},{-70,-38}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGly2(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDatGly.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for glycol-correlation pipe 2"
    annotation (Placement(transformation(extent={{90.0,-114.0},{70.0,-94.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinGly(
    redeclare package Medium = MediumGly,
    nPorts=2)
    "Sink for glycol-correlation case"
    annotation (Placement(transformation(extent={{90.0,-84.0},{70.0,-64.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Units.SI.ThermalResistance R1FixWat = intHexFixWat.RVol1.y
    "Pipe 1 convection resistance, fixed-property water";
  Modelica.Units.SI.ThermalResistance R2FixWat = intHexFixWat.RVol2.y
    "Pipe 2 convection resistance, fixed-property water";

  Modelica.Units.SI.ThermalResistance R1Wat = intHexWat.RVol1.y
    "Pipe 1 convection resistance, water correlation";
  Modelica.Units.SI.ThermalResistance R2Wat = intHexWat.RVol2.y
    "Pipe 2 convection resistance, water correlation";

  Modelica.Units.SI.ThermalResistance R1FixGly = intHexFixGly.RVol1.y
    "Pipe 1 convection resistance, fixed-property glycol";
  Modelica.Units.SI.ThermalResistance R2FixGly = intHexFixGly.RVol2.y
    "Pipe 2 convection resistance, fixed-property glycol";

  Modelica.Units.SI.ThermalResistance R1Gly = intHexGly.RVol1.y
    "Pipe 1 convection resistance, glycol correlation";
  Modelica.Units.SI.ThermalResistance R2Gly = intHexGly.RVol2.y
    "Pipe 2 convection resistance, glycol correlation";

  Real dR1Wat(unit="K/W") = R1Wat - R1FixWat
    "Difference between water-correlation and fixed-property water case for pipe 1";
  Real dR2Wat(unit="K/W") = R2Wat - R2FixWat
    "Difference between water-correlation and fixed-property water case for pipe 2";

  Real dR1Gly(unit="K/W") = R1Gly - R1FixGly
    "Difference between glycol-correlation and fixed-property glycol case for pipe 1";
  Real dR2Gly(unit="K/W") = R2Gly - R2FixGly
    "Difference between glycol-correlation and fixed-property glycol case for pipe 2";

equation

  connect(souFixWat1.ports[1], intHexFixWat.port_a1)
    annotation (Line(points={{-70,72},{-10,72},{-10,66}}, color={0,127,255}));
  connect(souFixWat2.ports[1], intHexFixWat.port_a2)
    annotation (Line(points={{70,72},{70,60},{10,60},{10,54}}, color={0,127,255}));
  connect(intHexFixWat.port_b1, sinFixWat.ports[1])
    annotation (Line(points={{10,66},{10,88},{70,88},{70,100}}, color={0,127,255}));
  connect(intHexFixWat.port_b2, sinFixWat.ports[2])
    annotation (Line(points={{-10,54},{-40,54},{-40,88},{70,88},{70,100}}, color={0,127,255}));

  connect(souWat1.ports[1], intHexWat.port_a1)
    annotation (Line(points={{-70,32},{-10,32},{-10,26}}, color={0,127,255}));
  connect(souWat2.ports[1], intHexWat.port_a2)
    annotation (Line(points={{70,14},{10,14}}, color={0,127,255}));
  connect(intHexWat.port_b1, sinWat.ports[1])
    annotation (Line(points={{10,26},{70,26},{70,46}}, color={0,127,255}));
  connect(intHexWat.port_b2, sinWat.ports[2])
    annotation (Line(points={{-10,14},{-40,14},{-40,46},{70,46}}, color={0,127,255}));

  connect(souFixGly1.ports[1], intHexFixGly.port_a1)
    annotation (Line(points={{-70,-8},{-10,-8},{-10,-14}}, color={0,127,255}));
  connect(souFixGly2.ports[1], intHexFixGly.port_a2)
    annotation (Line(points={{70,-36},{10,-36},{10,-26}}, color={0,127,255}));
  connect(intHexFixGly.port_b1, sinFixGly.ports[1])
    annotation (Line(points={{10,-14},{70,-14},{70,-12}}, color={0,127,255}));
  connect(intHexFixGly.port_b2, sinFixGly.ports[2])
    annotation (Line(points={{-10,-26},{-40,-26},{-40,8},{70,8},{70,-12}}, color={0,127,255}));

  connect(souGly1.ports[1], intHexGly.port_a1)
    annotation (Line(points={{-70,-48},{-10,-48},{-10,-54}}, color={0,127,255}));
  connect(souGly2.ports[1], intHexGly.port_a2)
    annotation (Line(points={{70,-104},{10,-104},{10,-66}}, color={0,127,255}));
  connect(intHexGly.port_b1, sinGly.ports[1])
    annotation (Line(points={{10,-54},{30,-54},{30,-74},{70,-74}}, color={0,127,255}));
  connect(intHexGly.port_b2, sinGly.ports[2])
    annotation (Line(points={{-10,-66},{-40,-66},{-40,-44},{70,-44},{70,-74}}, color={0,127,255}));
    connect(TGro.port,intHexFixWat.port_wall) annotation(Line(points = {{-108,2},{0,2},{0,70}},color = {191,0,0}));
    connect(TGro.port,intHexWat.port_wall) annotation(Line(points = {{-108,2},{0,2},{0,30}},color = {191,0,0}));
    connect(TGro.port,intHexFixGly.port_wall) annotation(Line(points = {{-108,2},{0,2},{0,-10}},color = {191,0,0}));
    connect(TGro.port,intHexGly.port_wall) annotation(Line(points = {{-108,2},{0,2},{0,-50}},color = {191,0,0}));

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/InternalHEXOneUTubeTDepRConvThreeCases.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}})),
    Documentation(info="<html>
<p>
This validation model compares fixed and temperature-dependent pipe convection
resistances in a single U-tube internal heat exchanger.
</p>
<p>
Four cases are simulated side by side:
</p>
<ul>
<li>
Fixed-property water.
</li>
<li>
Water using local temperature-dependent water correlations for the convection
resistance.
</li>
<li>
Fixed-property propylene-glycol/water.
</li>
<li>
Propylene-glycol/water using local temperature-dependent glycol correlations
for the convection resistance.
</li>
</ul>
<p>
Pipe 1 is exposed to a cold inlet temperature and pipe 2 is exposed to a warm
inlet temperature. The model verifies that the temperature-dependent property
evaluation changes the active fluid properties and therefore the convection
resistance supplied to the convective resistors.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
</ul>
</html>"));

end InternalHEXOneUTubeTDepRConvThreeCases;
