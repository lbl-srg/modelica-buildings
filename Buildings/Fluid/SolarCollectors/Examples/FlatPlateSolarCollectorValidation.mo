within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateSolarCollectorValidation
  "Test model for FlatPlateSolarCollector"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";
  Real Q_Use = -boundary.m_flow_in * 4190*(boundary.T_in-TOut.T)/3.6
    "Useful heat gain";
  Real SumHeaGai "Sum of the heat gain in all of the segments";
  Buildings.Fluid.SolarCollectors.Examples.BaseClasses.FlatPlateValidation
                                                    solCol(
    redeclare package Medium = Medium,
    Cp=4189,
    shaCoe=0,
    azi=0,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.TRNSYSValidation(),
    nSeg=3,
    I_nominal=800,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    lat=0.6457718232379,
    til=0.78539816339745,
    TEnv_nominal=283.15,
    TIn_nominal=293.15)
    "Flat plate solar collector model, has been modified for validation purposes"
             annotation (Placement(transformation(extent={{14,-20},{34,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data file reader"
    annotation (Placement(transformation(extent={{-38,20},{-18,40}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
                                     annotation (Placement(transformation(extent={{100,-20},{80,0}},
          rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{80,80},{100,100}},
                                                 rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{38,-20},{58,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true) "Inlet for water flow, at a prescribed flow rate"
    annotation (Placement(transformation(extent={{-12,-20},{8,0}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                       combiTable1Ds(
    tableOnFile=true,
    tableName="TRNSYS",
    columns=2:5,
    fileName=
        "Fluid/SolarCollector/Examples/ValidationData/TRNSYSAnnualData.txt")
    "Data reader with inlet conditions from TRNSYS"
    annotation (Placement(transformation(extent={{-82,-20},{-62,0}})));

  Modelica.Blocks.Math.Add add "Converts TRNSYS data from C to K"
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Modelica.Blocks.Sources.Constant const(k=273.15)
    "Used to convert TRNSYS data from C to K"
    annotation (Placement(transformation(extent={{-100,-56},{-80,-36}})));

equation
    SumHeaGai = sum(solCol.solHeaGai.QSol_flow[1:3]);

  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{34,-10},{38,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-18,30},{26.6,30},{26.6,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boundary.ports[1], solCol.port_a) annotation (Line(
      points={{8,-10},{14,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, add.u2) annotation (Line(
      points={{-79,-46},{-50,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, boundary.T_in) annotation (Line(
      points={{-27,-40},{-24,-40},{-24,-6},{-14,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTable1Ds.y[1], add.u1) annotation (Line(
      points={{-61,-10},{-54,-10},{-54,-34},{-50,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTable1Ds.y[4], boundary.m_flow_in) annotation (Line(
      points={{-61,-10},{-44,-10},{-44,-2},{-12,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.port_b, sou.ports[1]) annotation (Line(
      points={{58,-10},{80,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model was used to validate the <a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> Buildings.Fluid.SolarCollectors.FlatPlate</a> solar collector model against TRNSYS data.
Data files are used to ensure that the FlatPlate solar collector model saw the same inlet and weather conditions as the TRNSYS simulation. A special version of the
<a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> Buildings.Fluid.SolarCollectors.FlatPlate</a> solar collector model was made to accommodate the data files. It 
can be accessed in the BaseClasses folder.
</p>
</html>",revisions="<html>
<ul>
<li>
Mar 27, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/FlatPlateSolarCollectorValidation.mos"
        "Simulate and Plot"),
    Icon(graphics));
end FlatPlateSolarCollectorValidation;
