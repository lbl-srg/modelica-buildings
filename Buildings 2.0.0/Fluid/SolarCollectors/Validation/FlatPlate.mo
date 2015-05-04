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
    lat=0.6457718232379,
    til=0.78539816339745)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data file reader"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true)
    "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-12,-20},{8,0}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    tableName="TRNSYS",
    columns=2:5,
    fileName=ModelicaServices.ExternalReferences.loadResource(
       "modelica://Buildings/Fluid/SolarCollectors/Examples/ValidationData/TRNSYSAnnualData.txt"))
    "Data reader with inlet conditions from TRNSYS"
    annotation (Placement(transformation(extent={{-88,-20},{-68,0}})));

  Modelica.Blocks.Math.Add add
    "Converts TRNSYS data from degree Celsius to Kelving"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Modelica.Blocks.Sources.Constant const(k=273.15)
    "Used to convert TRNSYS data from degree Celsius to Kelving"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

equation
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-20,30},{20,30},{20,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou.ports[1], solCol.port_a)      annotation (Line(
      points={{8,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, add.u2) annotation (Line(
      points={{-69,-50},{-60,-50},{-60,-36},{-52,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, bou.T_in)      annotation (Line(
      points={{-29,-30},{-24,-30},{-24,-6},{-14,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], add.u1)        annotation (Line(
      points={{-67,-10},{-60,-10},{-60,-24},{-52,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[4], bou.m_flow_in)             annotation (Line(
      points={{-67,-10},{-44,-10},{-44,-2},{-12,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], solCol.port_b) annotation (Line(
      points={{60,-10},{40,-10}},
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
    </html>",
revisions="<html>
<ul>
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
        "Simulate and Plot"),
    experiment(StopTime=86400.0));
end FlatPlate;
