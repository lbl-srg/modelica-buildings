within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsDarcyPressureDropVariableTemperature
  "Validation model for temperature-dependent Darcy-Weisbach pressure drop in borefields"
  extends Modelica.Icons.Example;

  package MediumWat = Buildings.Media.Water
    "Constant-property water transport medium";

  package MediumGly =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=0.40)
    "Constant-property propylene-glycol/water transport medium";

  parameter Modelica.Units.SI.Time tLoaAgg=300
    "Time resolution of load aggregation";

  parameter Modelica.Units.SI.Time period=12000
    "Period of inlet temperature variation";

  parameter Modelica.Units.SI.Temperature TGro=283.15
    "Ground temperature";

  parameter Modelica.Units.SI.Temperature TIn_mean=293.15
    "Mean inlet temperature";

  parameter Modelica.Units.SI.TemperatureDifference TIn_amp=20
    "Amplitude of inlet temperature variation";

  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal_wat=0.30
    "Nominal mass flow rate per borehole for water cases";

  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal_gly=0.20
    "Nominal mass flow rate per borehole for glycol cases";

  Modelica.Blocks.Sources.Sine TInSig(
    amplitude=TIn_amp,
    f=1/period,
    phase=-Modelica.Constants.pi/2,
    offset=TIn_mean)
    "Sinusoidal inlet temperature"
    annotation (Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}},rotation = -180.0,origin = {-66.0,92.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_wat))
    "Borefield data for fixed-property water Darcy pressure-drop case"
    annotation (Placement(transformation(extent={{-27.0,70.0},{-7.0,90.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatWat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_wat))
    "Borefield data for temperature-dependent water Darcy pressure-drop case"
    annotation (Placement(transformation(extent={{3.0,70.0},{23.0,90.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for fixed-property glycol Darcy pressure-drop case"
    annotation (Placement(transformation(extent={{33.0,70.0},{53.0,90.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatGly(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for temperature-dependent glycol Darcy pressure-drop case"
    annotation (Placement(transformation(extent={{63.0,70.0},{83.0,90.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieFixWat(
    redeclare package Medium = MediumWat,
    borFieDat=borFieDatFixWat,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_detailedPressureDrop=true,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    use_TDepRConv=false)
    "Fixed-property water borefield with Darcy pressure drop"
    annotation (Placement(transformation(extent={{-10,36},{10,56}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieWat(
    redeclare package Medium = MediumWat,
    borFieDat=borFieDatWat,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_detailedPressureDrop=true,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature,
    use_TDepRConv=false)
    "Water borefield with temperature-dependent Darcy pressure drop"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieFixGly(
    redeclare package Medium = MediumGly,
    borFieDat=borFieDatFixGly,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_DarcyPressureDrop=true,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    use_TDepRConv=false)
    "Fixed-property glycol borefield with Darcy pressure drop"
    annotation (Placement(transformation(extent={{-10,-36},{10,-16}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieGly(
    redeclare package Medium = MediumGly,
    borFieDat=borFieDatGly,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_detailedPressureDrop=true,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature,
    use_TDepRConv=false)
    "Glycol borefield with temperature-dependent Darcy pressure drop"
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));


  Buildings.Fluid.Sources.MassFlowSource_T souFixWat(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatFixWat.conDat.mBorFie_flow_nominal)
    "Source for fixed-property water case"
    annotation (Placement(transformation(extent={{-88,36},{-68,56}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInFixWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatFixWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for fixed-property water case"
    annotation (Placement(transformation(extent={{-56,36},{-36,56}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutFixWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatFixWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for fixed-property water case"
    annotation (Placement(transformation(extent={{36,36},{56,56}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Sink for fixed-property water case"
    annotation (Placement(transformation(extent={{88,36},{68,56}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatWat.conDat.mBorFie_flow_nominal)
    "Source for temperature-dependent water case"
    annotation (Placement(transformation(extent={{-88,0},{-68,20}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for temperature-dependent water case"
    annotation (Placement(transformation(extent={{-56,0},{-36,20}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=borFieDatWat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for temperature-dependent water case"
    annotation (Placement(transformation(extent={{36,0},{56,20}})));

  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWat,
    nPorts=1)
    "Sink for temperature-dependent water case"
    annotation (Placement(transformation(extent={{88,0},{68,20}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixGly(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatFixGly.conDat.mBorFie_flow_nominal)
    "Source for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-88,-36},{-68,-16}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInFixGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatFixGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for fixed-property glycol case"
    annotation (Placement(transformation(extent={{-56,-36},{-36,-16}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutFixGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatFixGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for fixed-property glycol case"
    annotation (Placement(transformation(extent={{36,-36},{56,-16}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixGly(
    redeclare package Medium = MediumGly,
    nPorts=1)
    "Sink for fixed-property glycol case"
    annotation (Placement(transformation(extent={{88,-36},{68,-16}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGly(
    redeclare package Medium = MediumGly,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatGly.conDat.mBorFie_flow_nominal)
    "Source for temperature-dependent glycol case"
    annotation (Placement(transformation(extent={{-88,-72},{-68,-52}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for temperature-dependent glycol case"
    annotation (Placement(transformation(extent={{-56,-72},{-36,-52}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutGly(
    redeclare package Medium = MediumGly,
    m_flow_nominal=borFieDatGly.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for temperature-dependent glycol case"
    annotation (Placement(transformation(extent={{36,-72},{56,-52}})));

  Buildings.Fluid.Sources.Boundary_pT sinGly(
    redeclare package Medium = MediumGly,
    nPorts=1)
    "Sink for temperature-dependent glycol case"
    annotation (Placement(transformation(extent={{88,-72},{68,-52}})));

  Modelica.Units.SI.Temperature TIn = TInSig.y
    "Inlet temperature signal";

  Modelica.Units.SI.PressureDifference dpFixWat = borFieFixWat.dp
    "Pressure drop of fixed-property water borefield";

  Modelica.Units.SI.PressureDifference dpWat = borFieWat.dp
    "Pressure drop of temperature-dependent water borefield";

  Modelica.Units.SI.PressureDifference dpFixGly = borFieFixGly.dp
    "Pressure drop of fixed-property glycol borefield";

  Modelica.Units.SI.PressureDifference dpGly = borFieGly.dp
    "Pressure drop of temperature-dependent glycol borefield";

  Modelica.Units.SI.PressureDifference dDpWat = dpWat - dpFixWat
    "Difference between temperature-dependent and fixed-property water pressure drop";

  Modelica.Units.SI.PressureDifference dDpGly = dpGly - dpFixGly
    "Difference between temperature-dependent and fixed-property glycol pressure drop";

  Modelica.Units.SI.TemperatureDifference dTOutWat =
    TOutWat.T - TOutFixWat.T
    "Outlet temperature difference between water pressure-drop cases";

  Modelica.Units.SI.TemperatureDifference dTOutGly =
    TOutGly.T - TOutFixGly.T
    "Outlet temperature difference between glycol pressure-drop cases";

equation
  connect(TInSig.y, souFixWat.T_in)
    annotation (Line(points={{-77,92},{-96,92},{-96,50},{-90,50}}, color={0,0,127}));
  connect(TInSig.y, souWat.T_in)
    annotation (Line(points={{-77,92},{-96,92},{-96,14},{-90,14}}, color={0,0,127}));
  connect(TInSig.y, souFixGly.T_in)
    annotation (Line(points={{-77,92},{-96,92},{-96,-22},{-90,-22}}, color={0,0,127}));
  connect(TInSig.y, souGly.T_in)
    annotation (Line(points={{-77,92},{-96,92},{-96,-58},{-90,-58}}, color={0,0,127}));

  connect(souFixWat.ports[1], TInFixWat.port_a)
    annotation (Line(points={{-68,46},{-56,46}}, color={0,127,255}));
  connect(TInFixWat.port_b, borFieFixWat.port_a)
    annotation (Line(points={{-36,46},{-10,46}}, color={0,127,255}));
  connect(borFieFixWat.port_b, TOutFixWat.port_a)
    annotation (Line(points={{10,46},{36,46}}, color={0,127,255}));
  connect(TOutFixWat.port_b, sinFixWat.ports[1])
    annotation (Line(points={{56,46},{68,46}}, color={0,127,255}));

  connect(souWat.ports[1], TInWat.port_a)
    annotation (Line(points={{-68,10},{-56,10}}, color={0,127,255}));
  connect(TInWat.port_b, borFieWat.port_a)
    annotation (Line(points={{-36,10},{-10,10}}, color={0,127,255}));
  connect(borFieWat.port_b, TOutWat.port_a)
    annotation (Line(points={{10,10},{36,10}}, color={0,127,255}));
  connect(TOutWat.port_b, sinWat.ports[1])
    annotation (Line(points={{56,10},{68,10}}, color={0,127,255}));

  connect(souFixGly.ports[1], TInFixGly.port_a)
    annotation (Line(points={{-68,-26},{-56,-26}}, color={0,127,255}));
  connect(TInFixGly.port_b, borFieFixGly.port_a)
    annotation (Line(points={{-36,-26},{-10,-26}}, color={0,127,255}));
  connect(borFieFixGly.port_b, TOutFixGly.port_a)
    annotation (Line(points={{10,-26},{36,-26}}, color={0,127,255}));
  connect(TOutFixGly.port_b, sinFixGly.ports[1])
    annotation (Line(points={{56,-26},{68,-26}}, color={0,127,255}));

  connect(souGly.ports[1], TInGly.port_a)
    annotation (Line(points={{-68,-62},{-56,-62}}, color={0,127,255}));
  connect(TInGly.port_b, borFieGly.port_a)
    annotation (Line(points={{-36,-62},{-10,-62}}, color={0,127,255}));
  connect(borFieGly.port_b, TOutGly.port_a)
    annotation (Line(points={{10,-62},{36,-62}}, color={0,127,255}));
  connect(TOutGly.port_b, sinGly.ports[1])
    annotation (Line(points={{56,-62},{68,-62}}, color={0,127,255}));

  annotation (
    experiment(StopTime=36000, Tolerance=1e-6),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/BorefieldsDarcyPressureDropVariableTemperature.mos"
      "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-90},{110,110}})),
    Documentation(info="<html>
<p>
This validation model extends the Darcy-Weisbach pressure-drop validation to
time-varying inlet temperature at constant mass flow rate.
</p>
<p>
Four single-U-tube borefields are simulated side by side:
</p>
<ul>
<li>
Fixed-property water with Darcy-Weisbach pressure drop.
</li>
<li>
Water with temperature-dependent density and viscosity for the Darcy-Weisbach
pressure drop.
</li>
<li>
Fixed-property propylene-glycol/water with Darcy-Weisbach pressure drop.
</li>
<li>
Propylene-glycol/water with temperature-dependent density and viscosity for the
Darcy-Weisbach pressure drop.
</li>
</ul>
<p>
The Darcy-Weisbach pressure-drop calculation is enabled by setting
<code>use_DarcyPressureDrop=true</code> on the borefield model instances.
Temperature-dependent pressure-drop properties are enabled with
<code>use_TDepPressureDrop=true</code>.
</p>
<p>
The fluid type and glycol mass fraction are derived from the redeclared
<code>Medium</code>. For glycol-water media, the glycol mass fraction
<code>X_a</code> is specified only in the medium redeclaration.
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
end BorefieldsDarcyPressureDropVariableTemperature;
