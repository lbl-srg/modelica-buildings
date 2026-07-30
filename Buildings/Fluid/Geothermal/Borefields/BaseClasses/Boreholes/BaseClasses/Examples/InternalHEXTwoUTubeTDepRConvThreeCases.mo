within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model InternalHEXTwoUTubeTDepRConvThreeCases
  "Validation model for temperature-dependent convection resistance in two U-tube"
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

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_Rb=false,
        use_TDepRConv=false))
    "Borefield data for fixed-property water case"
    annotation (Placement(transformation(extent={{-117.0,120.0},{-97.0,140.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_Rb=false,
        use_TDepRConv=true,
        fluidPropertyEvaluation=
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water))
    "Borefield data for temperature-dependent water-correlation case"
    annotation (Placement(transformation(extent={{-87.0,120.0},{-67.0,140.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_Rb=false,
        use_TDepRConv=false,
        X_a=0.40))
    "Borefield data for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-57.0,120.0},{-37.0,140.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_Rb=false,
        use_TDepRConv=true,
        fluidPropertyEvaluation=
          Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater,
        X_a=0.40))
    "Borefield data for temperature-dependent glycol-correlation case"
    annotation (Placement(transformation(extent={{-27.0,120.0},{-7.0,140.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXTwoUTube
    intHexFixWat(
      redeclare package Medium = MediumWat,
      hSeg=hSeg,
      dp1_nominal=10,
      dp2_nominal=10,
      dp3_nominal=10,
      dp4_nominal=10,
      borFieDat=borFieDatFixWat,
      m1_flow_nominal=borFieDatFixWat.conDat.mBor_flow_nominal/2,
      m2_flow_nominal=borFieDatFixWat.conDat.mBor_flow_nominal/2,
      m3_flow_nominal=borFieDatFixWat.conDat.mBor_flow_nominal/2,
      m4_flow_nominal=borFieDatFixWat.conDat.mBor_flow_nominal/2,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Fixed-property water case"
    annotation (Placement(transformation(extent={{-10,58},{10,78}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXTwoUTube
    intHexWat(
      redeclare package Medium = MediumWat,
      hSeg=hSeg,
      dp1_nominal=10,
      dp2_nominal=10,
      dp3_nominal=10,
      dp4_nominal=10,
      borFieDat=borFieDatWat,
      m1_flow_nominal=borFieDatWat.conDat.mBor_flow_nominal/2,
      m2_flow_nominal=borFieDatWat.conDat.mBor_flow_nominal/2,
      m3_flow_nominal=borFieDatWat.conDat.mBor_flow_nominal/2,
      m4_flow_nominal=borFieDatWat.conDat.mBor_flow_nominal/2,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Water medium with local temperature-dependent water correlations"
    annotation (Placement(transformation(extent={{-10,18},{10,38}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXTwoUTube
    intHexFixGly(
      redeclare package Medium = MediumGly,
      hSeg=hSeg,
      dp1_nominal=10,
      dp2_nominal=10,
      dp3_nominal=10,
      dp4_nominal=10,
      borFieDat=borFieDatFixGly,
      m1_flow_nominal=borFieDatFixGly.conDat.mBor_flow_nominal/2,
      m2_flow_nominal=borFieDatFixGly.conDat.mBor_flow_nominal/2,
      m3_flow_nominal=borFieDatFixGly.conDat.mBor_flow_nominal/2,
      m4_flow_nominal=borFieDatFixGly.conDat.mBor_flow_nominal/2,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Fixed-property glycol case"
    annotation (Placement(transformation(extent={{-10,-22},{10,-2}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXTwoUTube
    intHexGly(
      redeclare package Medium = MediumGly,
      hSeg=hSeg,
      dp1_nominal=10,
      dp2_nominal=10,
      dp3_nominal=10,
      dp4_nominal=10,
      borFieDat=borFieDatGly,
      m1_flow_nominal=borFieDatGly.conDat.mBor_flow_nominal/2,
      m2_flow_nominal=borFieDatGly.conDat.mBor_flow_nominal/2,
      m3_flow_nominal=borFieDatGly.conDat.mBor_flow_nominal/2,
      m4_flow_nominal=borFieDatGly.conDat.mBor_flow_nominal/2,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TFlu_start=293.15,
      TGro_start=283.15)
    "Glycol medium with local temperature-dependent glycol correlations"
    annotation (Placement(transformation(extent={{-10,-62},{10,-42}})));

  Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(
    T=283.15)
    "Fixed grout/wall temperature"
    annotation (Placement(transformation(extent={{-134.0,-2.0},{-114.0,18.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixWatCold(
    redeclare package Medium = MediumWat,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatFixWat.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for fixed-property water pipes 1 and 3"
    annotation (Placement(transformation(extent={{-96,68},{-76,88}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixWatWarm(
    redeclare package Medium = MediumWat,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatFixWat.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for fixed-property water pipes 2 and 4"
    annotation (Placement(transformation(extent={{90.0,72.0},{70.0,92.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinFixWat(
    redeclare package Medium = MediumWat,
    nPorts=4)
    "Sink for fixed-property water case"
    annotation (Placement(transformation(extent={{120.0,92.0},{100.0,112.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souWatCold(
    redeclare package Medium = MediumWat,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatWat.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for water-correlation pipes 1 and 3"
    annotation (Placement(transformation(extent={{-96,28},{-76,48}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWatWarm(
    redeclare package Medium = MediumWat,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatWat.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for water-correlation pipes 2 and 4"
    annotation (Placement(transformation(extent={{88.0,12.0},{68.0,32.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    nPorts=4)
    "Sink for water-correlation case"
    annotation (Placement(transformation(extent={{120.0,44.0},{100.0,64.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGlyCold(
    redeclare package Medium = MediumGly,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatFixGly.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for fixed-property glycol pipes 1 and 3"
    annotation (Placement(transformation(extent={{-96,-12},{-76,8}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGlyWarm(
    redeclare package Medium = MediumGly,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatFixGly.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for fixed-property glycol pipes 2 and 4"
    annotation (Placement(transformation(extent={{88.0,-30.0},{68.0,-10.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinFixGly(
    redeclare package Medium = MediumGly,
    nPorts=4)
    "Sink for fixed-property glycol case"
    annotation (Placement(transformation(extent={{120.0,0.0},{100.0,20.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.MassFlowSource_T souGlyCold(
    redeclare package Medium = MediumGly,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatGly.conDat.mBor_flow_nominal,
    T=TCold)
    "Cold source for glycol-correlation pipes 1 and 3"
    annotation (Placement(transformation(extent={{-96,-52},{-76,-32}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGlyWarm(
    redeclare package Medium = MediumGly,
    nPorts=2,
    use_T_in=false,
    m_flow=borFieDatGly.conDat.mBor_flow_nominal,
    T=TWarm)
    "Warm source for glycol-correlation pipes 2 and 4"
    annotation (Placement(transformation(extent={{88.0,-76.0},{68.0,-56.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Sources.Boundary_pT sinGly(
    redeclare package Medium = MediumGly,
    nPorts=4)
    "Sink for glycol-correlation case"
    annotation (Placement(transformation(extent={{120.0,-46.0},{100.0,-26.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Units.SI.ThermalResistance R1FixWat = intHexFixWat.RVol1.y
    "Pipe 1 convection resistance, fixed-property water";
  Modelica.Units.SI.ThermalResistance R2FixWat = intHexFixWat.RVol2.y
    "Pipe 2 convection resistance, fixed-property water";
  Modelica.Units.SI.ThermalResistance R3FixWat = intHexFixWat.RVol3.y
    "Pipe 3 convection resistance, fixed-property water";
  Modelica.Units.SI.ThermalResistance R4FixWat = intHexFixWat.RVol4.y
    "Pipe 4 convection resistance, fixed-property water";

  Modelica.Units.SI.ThermalResistance R1Wat = intHexWat.RVol1.y
    "Pipe 1 convection resistance, water correlation";
  Modelica.Units.SI.ThermalResistance R2Wat = intHexWat.RVol2.y
    "Pipe 2 convection resistance, water correlation";
  Modelica.Units.SI.ThermalResistance R3Wat = intHexWat.RVol3.y
    "Pipe 3 convection resistance, water correlation";
  Modelica.Units.SI.ThermalResistance R4Wat = intHexWat.RVol4.y
    "Pipe 4 convection resistance, water correlation";

  Modelica.Units.SI.ThermalResistance R1FixGly = intHexFixGly.RVol1.y
    "Pipe 1 convection resistance, fixed-property glycol";
  Modelica.Units.SI.ThermalResistance R2FixGly = intHexFixGly.RVol2.y
    "Pipe 2 convection resistance, fixed-property glycol";
  Modelica.Units.SI.ThermalResistance R3FixGly = intHexFixGly.RVol3.y
    "Pipe 3 convection resistance, fixed-property glycol";
  Modelica.Units.SI.ThermalResistance R4FixGly = intHexFixGly.RVol4.y
    "Pipe 4 convection resistance, fixed-property glycol";

  Modelica.Units.SI.ThermalResistance R1Gly = intHexGly.RVol1.y
    "Pipe 1 convection resistance, glycol correlation";
  Modelica.Units.SI.ThermalResistance R2Gly = intHexGly.RVol2.y
    "Pipe 2 convection resistance, glycol correlation";
  Modelica.Units.SI.ThermalResistance R3Gly = intHexGly.RVol3.y
    "Pipe 3 convection resistance, glycol correlation";
  Modelica.Units.SI.ThermalResistance R4Gly = intHexGly.RVol4.y
    "Pipe 4 convection resistance, glycol correlation";

  Real dR1Wat(unit="K/W") = R1Wat - R1FixWat
    "Difference between water-correlation and fixed-property water case for pipe 1";
  Real dR2Wat(unit="K/W") = R2Wat - R2FixWat
    "Difference between water-correlation and fixed-property water case for pipe 2";
  Real dR3Wat(unit="K/W") = R3Wat - R3FixWat
    "Difference between water-correlation and fixed-property water case for pipe 3";
  Real dR4Wat(unit="K/W") = R4Wat - R4FixWat
    "Difference between water-correlation and fixed-property water case for pipe 4";

  Real dR1Gly(unit="K/W") = R1Gly - R1FixGly
    "Difference between glycol-correlation and fixed-property glycol case for pipe 1";
  Real dR2Gly(unit="K/W") = R2Gly - R2FixGly
    "Difference between glycol-correlation and fixed-property glycol case for pipe 2";
  Real dR3Gly(unit="K/W") = R3Gly - R3FixGly
    "Difference between glycol-correlation and fixed-property glycol case for pipe 3";
  Real dR4Gly(unit="K/W") = R4Gly - R4FixGly
    "Difference between glycol-correlation and fixed-property glycol case for pipe 4";

equation
  connect(fixedTemperature.port, intHexFixWat.port_wall)
    annotation (Line(points={{-114,8},{0,8},{0,78}}, color={191,0,0}));
  connect(fixedTemperature.port, intHexWat.port_wall)
    annotation (Line(points={{-114,8},{0,8},{0,38}}, color={191,0,0}));
  connect(fixedTemperature.port, intHexFixGly.port_wall)
    annotation (Line(points={{-114,8},{0,8},{0,-2}}, color={191,0,0}));
  connect(fixedTemperature.port, intHexGly.port_wall)
    annotation (Line(points={{-114,8},{0,8},{0,-42}}, color={191,0,0}));

  connect(souFixWatCold.ports[1], intHexFixWat.port_a1)
    annotation (Line(points={{-76,80},{-10,80},{-10,76}}, color={0,127,255}));
  connect(souFixWatCold.ports[2], intHexFixWat.port_a3)
    annotation (Line(points={{-76,76},{-20,76},{-20,64},{-10,64}}, color={0,127,255}));
  connect(souFixWatWarm.ports[1], intHexFixWat.port_a2)
    annotation (Line(points={{70,82},{10,82},{10,72}}, color={0,127,255}));
  connect(souFixWatWarm.ports[2], intHexFixWat.port_a4)
    annotation (Line(points={{70,82},{20,82},{20,58},{10,58}}, color={0,127,255}));
  connect(intHexFixWat.port_b1, sinFixWat.ports[1])
    annotation (Line(points={{10,76},{40,76},{40,102},{100,102}}, color={0,127,255}));
  connect(intHexFixWat.port_b2, sinFixWat.ports[2])
    annotation (Line(points={{-10,72},{-14,72},{-14,102},{100,102}}, color={0,127,255}));
  connect(intHexFixWat.port_b3, sinFixWat.ports[3])
    annotation (Line(points={{10,64},{40,64},{40,102},{100,102}}, color={0,127,255}));
  connect(intHexFixWat.port_b4, sinFixWat.ports[4])
    annotation (Line(points={{-10,58},{-40,58},{-40,102},{100,102}}, color={0,127,255}));

  connect(souWatCold.ports[1], intHexWat.port_a1)
    annotation (Line(points={{-76,40},{-10,40},{-10,36}}, color={0,127,255}));
  connect(souWatCold.ports[2], intHexWat.port_a3)
    annotation (Line(points={{-76,36},{-20,36},{-20,24},{-10,24}}, color={0,127,255}));
  connect(souWatWarm.ports[1], intHexWat.port_a2)
    annotation (Line(points={{68,22},{68,18},{18,18},{18,32},{10,32}}, color={0,127,255}));
  connect(souWatWarm.ports[2], intHexWat.port_a4)
    annotation (Line(points={{68,22},{68,18},{10,18}}, color={0,127,255}));
  connect(intHexWat.port_b1, sinWat.ports[1])
    annotation (Line(points={{10,36},{100,36},{100,54}}, color={0,127,255}));
  connect(intHexWat.port_b2, sinWat.ports[2])
    annotation (Line(points={{-10,32},{-30,32},{-30,54},{100,54}}, color={0,127,255}));
  connect(intHexWat.port_b3, sinWat.ports[3])
    annotation (Line(points={{10,24},{40,24},{40,54},{100,54}}, color={0,127,255}));
  connect(intHexWat.port_b4, sinWat.ports[4])
    annotation (Line(points={{-10,18},{-40,18},{-40,54},{100,54}}, color={0,127,255}));

  connect(souFixGlyCold.ports[1], intHexFixGly.port_a1)
    annotation (Line(points={{-76,0},{-10,0},{-10,-4}}, color={0,127,255}));
  connect(souFixGlyCold.ports[2], intHexFixGly.port_a3)
    annotation (Line(points={{-76,-4},{-20,-4},{-20,-16},{-10,-16}}, color={0,127,255}));
  connect(souFixGlyWarm.ports[1], intHexFixGly.port_a2)
    annotation (Line(points={{68,-20},{16,-20},{16,-8},{10,-8}}, color={0,127,255}));
  connect(souFixGlyWarm.ports[2], intHexFixGly.port_a4)
    annotation (Line(points={{68,-20},{10,-20},{10,-22}}, color={0,127,255}));
  connect(intHexFixGly.port_b1, sinFixGly.ports[1])
    annotation (Line(points={{10,-4},{100,-4},{100,10}}, color={0,127,255}));
  connect(intHexFixGly.port_b2, sinFixGly.ports[2])
    annotation (Line(points={{-10,-8},{-30,-8},{-30,10},{100,10}}, color={0,127,255}));
  connect(intHexFixGly.port_b3, sinFixGly.ports[3])
    annotation (Line(points={{10,-16},{40,-16},{40,10},{100,10}}, color={0,127,255}));
  connect(intHexFixGly.port_b4, sinFixGly.ports[4])
    annotation (Line(points={{-10,-22},{-40,-22},{-40,10},{100,10}}, color={0,127,255}));

  connect(souGlyCold.ports[1], intHexGly.port_a1)
    annotation (Line(points={{-76,-40},{-10,-40},{-10,-44}}, color={0,127,255}));
  connect(souGlyCold.ports[2], intHexGly.port_a3)
    annotation (Line(points={{-76,-44},{-20,-44},{-20,-56},{-10,-56}}, color={0,127,255}));
  connect(souGlyWarm.ports[1], intHexGly.port_a2)
    annotation (Line(points={{68,-66},{16,-66},{16,-48},{10,-48}}, color={0,127,255}));
  connect(souGlyWarm.ports[2], intHexGly.port_a4)
    annotation (Line(points={{68,-66},{10,-66},{10,-62}}, color={0,127,255}));
  connect(intHexGly.port_b1, sinGly.ports[1])
    annotation (Line(points={{10,-44},{10,-36},{100,-36}}, color={0,127,255}));
  connect(intHexGly.port_b2, sinGly.ports[2])
    annotation (Line(points={{-10,-48},{-30,-48},{-30,-30},{100,-30},{100,-36}}, color={0,127,255}));
  connect(intHexGly.port_b3, sinGly.ports[3])
    annotation (Line(points={{10,-56},{40,-56},{40,-36},{100,-36}}, color={0,127,255}));
  connect(intHexGly.port_b4, sinGly.ports[4])
    annotation (Line(points={{-10,-62},{-38,-62},{-38,-30},{100,-30},{100,-36}}, color={0,127,255}));

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/InternalHEXTwoUTubeTDepRConvThreeCases.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-130,-90},{130,120}})),
    Documentation(info="<html>
<p>
This validation model compares fixed and temperature-dependent pipe convection
resistances in a double U-tube internal heat exchanger.
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
resistances.
</li>
<li>
Fixed-property propylene-glycol/water.
</li>
<li>
Propylene-glycol/water using local temperature-dependent glycol correlations
for the convection resistances.
</li>
</ul>
<p>
The double U-tube configuration is parallel. Pipes 1 and 3 receive the cold
inlet temperature, while pipes 2 and 4 receive the warm inlet temperature.
The model verifies that the active fluid-property evaluation is propagated to
all four convection resistances.
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

end InternalHEXTwoUTubeTDepRConvThreeCases;
