within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsTDepRConvGlycolSeason
  "Seasonal glycol validation for temperature-dependent convection resistance"
  extends Modelica.Icons.Example;

  package MediumGlyAvg =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=0.40)
    "Propylene glycol/water medium with properties fixed at average temperature";

  package MediumGlyCold =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=278.15,
      X_a=0.40)
    "Propylene glycol/water medium with properties fixed at cold conservative temperature";

  parameter Modelica.Units.SI.Time year=31536000
    "One year";

  parameter Modelica.Units.SI.Time tLoaAgg=3600
    "Time resolution of load aggregation";

  parameter Modelica.Units.SI.Temperature TGro=283.15
    "Undisturbed ground temperature";

  parameter Modelica.Units.SI.Temperature TIn_mean=293.15
    "Mean seasonal inlet temperature";

  parameter Modelica.Units.SI.TemperatureDifference TIn_amp=15
    "Seasonal inlet temperature amplitude";

  parameter Modelica.Units.SI.MassFlowRate mBor_flow_nominal_gly=0.20
    "Nominal mass flow rate per borehole for glycol cases";

  Modelica.Blocks.Sources.Sine TInSea(
    amplitude=TIn_amp,
    f=1/year,
    phase=-Modelica.Constants.pi/2,
    offset=TIn_mean)
    "Seasonal inlet temperature, starting at the cold extreme"
    annotation (Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}},rotation = -180.0,origin = {-56.0,98.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixAvg(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for glycol case with fixed properties at average temperature"
    annotation (Placement(transformation(extent={{-26.0,90.0},{-6.0,110.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatFixCold(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for glycol case with fixed properties at cold temperature"
    annotation (Placement(transformation(extent={{4.0,90.0},{24.0,110.0}},rotation = 0.0,origin = {0.0,0.0})));

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDatTDep(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        mBor_flow_nominal=mBor_flow_nominal_gly))
    "Borefield data for glycol case with temperature-dependent convection resistance"
    annotation (Placement(transformation(extent={{34.0,90.0},{54.0,110.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieFixAvg(
    redeclare package Medium = MediumGlyAvg,
    borFieDat=borFieDatFixAvg,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_DarcyPressureDrop=false,
    use_TDepPressureDrop=false,
    use_TDepRConv=false)
    "Glycol borefield with fixed properties evaluated at average temperature"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieFixCold(
    redeclare package Medium = MediumGlyCold,
    borFieDat=borFieDatFixCold,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_DarcyPressureDrop=false,
    use_TDepPressureDrop=false,
    use_TDepRConv=false)
    "Glycol borefield with fixed properties evaluated at cold temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieTDep(
    redeclare package Medium = MediumGlyAvg,
    borFieDat=borFieDatTDep,
    tLoaAgg=tLoaAgg,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    allowFlowReversal=false,
    use_DarcyPressureDrop=false,
    use_TDepPressureDrop=false,
    use_TDepRConv=true)
    "Glycol borefield with temperature-dependent pipe convection resistance"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixAvg(
    redeclare package Medium = MediumGlyAvg,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatFixAvg.conDat.mBorFie_flow_nominal)
    "Seasonal inlet source for average fixed-property case"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInFixAvg(
    redeclare package Medium = MediumGlyAvg,
    m_flow_nominal=borFieDatFixAvg.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for average fixed-property case"
    annotation (Placement(transformation(extent={{-38,50},{-18,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutFixAvg(
    redeclare package Medium = MediumGlyAvg,
    m_flow_nominal=borFieDatFixAvg.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for average fixed-property case"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixAvg(
    redeclare package Medium = MediumGlyAvg,
    nPorts=1)
    "Outlet sink for average fixed-property case"
    annotation (Placement(transformation(extent={{70,50},{50,70}})));

  Buildings.Fluid.Sources.MassFlowSource_T souFixCold(
    redeclare package Medium = MediumGlyCold,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatFixCold.conDat.mBorFie_flow_nominal)
    "Seasonal inlet source for cold fixed-property case"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInFixCold(
    redeclare package Medium = MediumGlyCold,
    m_flow_nominal=borFieDatFixCold.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for cold fixed-property case"
    annotation (Placement(transformation(extent={{-38,10},{-18,30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutFixCold(
    redeclare package Medium = MediumGlyCold,
    m_flow_nominal=borFieDatFixCold.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for cold fixed-property case"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Fluid.Sources.Boundary_pT sinFixCold(
    redeclare package Medium = MediumGlyCold,
    nPorts=1)
    "Outlet sink for cold fixed-property case"
    annotation (Placement(transformation(extent={{70,10},{50,30}})));

  Buildings.Fluid.Sources.MassFlowSource_T souTDep(
    redeclare package Medium = MediumGlyAvg,
    nPorts=1,
    use_T_in=true,
    m_flow=borFieDatTDep.conDat.mBorFie_flow_nominal)
    "Seasonal inlet source for temperature-dependent case"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TInTDep(
    redeclare package Medium = MediumGlyAvg,
    m_flow_nominal=borFieDatTDep.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature sensor for temperature-dependent case"
    annotation (Placement(transformation(extent={{-38,-30},{-18,-10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TOutTDep(
    redeclare package Medium = MediumGlyAvg,
    m_flow_nominal=borFieDatTDep.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature sensor for temperature-dependent case"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Fluid.Sources.Boundary_pT sinTDep(
    redeclare package Medium = MediumGlyAvg,
    nPorts=1)
    "Outlet sink for temperature-dependent case"
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));

  Modelica.Units.SI.Temperature TIn = TInSea.y
    "Seasonal inlet temperature signal";

  Modelica.Units.SI.TemperatureDifference dTOutTDepAvg =
    TOutTDep.T - TOutFixAvg.T
    "Outlet temperature difference between T-dependent and average fixed-property case";

  Modelica.Units.SI.TemperatureDifference dTOutTDepCold =
    TOutTDep.T - TOutFixCold.T
    "Outlet temperature difference between T-dependent and cold fixed-property case";

  Modelica.Units.SI.TemperatureDifference dTOutColdAvg =
    TOutFixCold.T - TOutFixAvg.T
    "Outlet temperature difference between cold and average fixed-property cases";

  Modelica.Units.SI.TemperatureDifference dTAppFixAvg =
    TOutFixAvg.T - TInFixAvg.T
    "Outlet-inlet temperature change for average fixed-property case";

  Modelica.Units.SI.TemperatureDifference dTAppFixCold =
    TOutFixCold.T - TInFixCold.T
    "Outlet-inlet temperature change for cold fixed-property case";

  Modelica.Units.SI.TemperatureDifference dTAppTDep =
    TOutTDep.T - TInTDep.T
    "Outlet-inlet temperature change for temperature-dependent case";

equation
  connect(TInSea.y, souFixAvg.T_in)
    annotation (Line(points={{-67,98},{-78,98},{-78,64},{-72,64}}, color={0,0,127}));
  connect(TInSea.y, souFixCold.T_in)
    annotation (Line(points={{-67,98},{-78,98},{-78,24},{-72,24}}, color={0,0,127}));
  connect(TInSea.y, souTDep.T_in)
    annotation (Line(points={{-67,98},{-78,98},{-78,-16},{-72,-16}}, color={0,0,127}));

  connect(souFixAvg.ports[1], TInFixAvg.port_a)
    annotation (Line(points={{-50,60},{-38,60}}, color={0,127,255}));
  connect(TInFixAvg.port_b, borFieFixAvg.port_a)
    annotation (Line(points={{-18,60},{-10,60}}, color={0,127,255}));
  connect(borFieFixAvg.port_b, TOutFixAvg.port_a)
    annotation (Line(points={{10,60},{20,60}}, color={0,127,255}));
  connect(TOutFixAvg.port_b, sinFixAvg.ports[1])
    annotation (Line(points={{40,60},{50,60}}, color={0,127,255}));

  connect(souFixCold.ports[1], TInFixCold.port_a)
    annotation (Line(points={{-50,20},{-38,20}}, color={0,127,255}));
  connect(TInFixCold.port_b, borFieFixCold.port_a)
    annotation (Line(points={{-18,20},{-10,20}}, color={0,127,255}));
  connect(borFieFixCold.port_b, TOutFixCold.port_a)
    annotation (Line(points={{10,20},{20,20}}, color={0,127,255}));
  connect(TOutFixCold.port_b, sinFixCold.ports[1])
    annotation (Line(points={{40,20},{50,20}}, color={0,127,255}));

  connect(souTDep.ports[1], TInTDep.port_a)
    annotation (Line(points={{-50,-20},{-38,-20}}, color={0,127,255}));
  connect(TInTDep.port_b, borFieTDep.port_a)
    annotation (Line(points={{-18,-20},{-10,-20}}, color={0,127,255}));
  connect(borFieTDep.port_b, TOutTDep.port_a)
    annotation (Line(points={{10,-20},{20,-20}}, color={0,127,255}));
  connect(TOutTDep.port_b, sinTDep.ports[1])
    annotation (Line(points={{40,-20},{50,-20}}, color={0,127,255}));

  annotation (
    experiment(StopTime=31536000, Tolerance=1e-6),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/BorefieldsTDepRConvGlycolSeason.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-80},{100,120}})),
    Documentation(info="<html>
<p>
This validation model compares seasonal operation of a single-U-tube borefield
with propylene-glycol/water as heat-transfer fluid.
</p>
<p>
Three cases are simulated side by side:
</p>
<ul>
<li>
Fixed-property propylene-glycol/water evaluated at an average temperature of
293.15 K.
</li>
<li>
Fixed-property propylene-glycol/water evaluated at a cold conservative
temperature of 278.15 K.
</li>
<li>
Temperature-dependent convection resistance using the current fluid temperature
and propylene-glycol/water property correlations.
</li>
</ul>
<p>
The seasonal inlet temperature is sinusoidal with mean 293.15 K and amplitude
15 K, starting at the cold extreme. This allows checking whether fixed average
properties are representative and whether fixed cold properties are overly
conservative during warm operation.
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

end BorefieldsTDepRConvGlycolSeason;
