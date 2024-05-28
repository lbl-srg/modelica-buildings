within Buildings.Fluid.SolarCollectors.Validation;
model FlatPlate "Validation model for FlatPlate"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the system";
  Buildings.Fluid.SolarCollectors.ASHRAE93
   solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    azi=0,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_TRNSYSValidation(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=1,
    nSeg=30,
    til=0.78539816339745)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      computeWetBulbTemperature=false)
    "Weather data file reader"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true)
    "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Add add
    "Converts TRNSYS data from degree Celsius to Kelving"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    tableName="TRNSYS",
    columns=2:5,
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://Buildings/Fluid/SolarCollectors/Examples/ValidationData/TRNSYSAnnualData.txt"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Data reader with inlet conditions from TRNSYS"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Modelica.Blocks.Sources.Constant const(k=273.15)
    "Used to convert TRNSYS data from degree Celsius to Kelving"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));

equation
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-20,70},{20,70},{20,8},{30,8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou.ports[1], solCol.port_a)      annotation (Line(
      points={{10,0},{30,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, add.u2) annotation (Line(
      points={{-69,-30},{-60,-30},{-60,4},{-52,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, bou.T_in)      annotation (Line(
      points={{-29,10},{-24,10},{-24,4},{-12,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], add.u1)        annotation (Line(
      points={{-69,30},{-60,30},{-60,16},{-52,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[4], bou.m_flow_in)             annotation (Line(
      points={{-69,30},{-20,30},{-20,8},{-12,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], solCol.port_b) annotation (Line(
      points={{70,0},{50,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This model was used to validate the
<a href=\"modelica://Buildings.Fluid.SolarCollectors.ASHRAE93\">
Buildings.Fluid.SolarCollectors.ASHRAE93</a> solar collector model
against TRNSYS data. Data files are used to ensure that the
<a href=\"modelica://Buildings.Fluid.SolarCollectors.ASHRAE93\">
Buildings.Fluid.SolarCollectors.ASHRAE93</a> solar collector model and
the TRNSYS model use the same inlet and weather conditions. The
solar collector model must reference the
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_TRNSYSValidation\">
Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_TRNSYSValidation</a>
data record when comparing model results to the stored TRNSYS results.
</p>
<p>
The solar collector temperature of the Modelica model has a spike
in the morning. At this time, there is solar irradiation on the collector
but no mass flow rate, which leads to an increase in temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter assignment for <code>lat</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Replaced <code>ModelicaServices.ExternalReferences.loadResource</code> with
<code>Modelica.Utilities.Files.loadResource</code>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 27, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Validation/FlatPlate.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=86400));
end FlatPlate;
