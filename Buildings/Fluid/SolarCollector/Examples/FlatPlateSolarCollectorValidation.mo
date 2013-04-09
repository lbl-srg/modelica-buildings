within Buildings.Fluid.SolarCollector.Examples;
model FlatPlateSolarCollectorValidation
  "Test model for FlatPlateSolarCollector"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  Real Q_Use = -boundary.m_flow_in * 4190*(boundary.T_in-TOut.T)/3.6;
  Real SumHeaGai;
  Buildings.Fluid.SolarCollector.Examples.BaseClasses.FlatPlateValidation
                                                    solCol(
    redeclare package Medium = Medium,
    Cp=4189,
    shaCoe=0,
    azi=0,
    per=Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.TRNSYSValidation(),
    nSeg=3,
    I_nominal=800,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    lat=0.6457718232379,
    til=0.78539816339745,
    TEnv_nominal=283.15,
    TIn_nominal=293.15)
             annotation (Placement(transformation(extent={{32,-20},{52,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) annotation (Placement(transformation(extent={{100,-20},{80,0}},
          rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{56,-20},{76,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true)
    annotation (Placement(transformation(extent={{6,-20},{26,0}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                       combiTable1Ds(
    tableOnFile=true,
    tableName="TRNSYS",
    columns=2:5,
    fileName=
        "Fluid/SolarCollector/Examples/ValidationData/TRNSYSAnnualData.txt")
    annotation (Placement(transformation(extent={{-64,-20},{-44,0}})));

  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Modelica.Blocks.Sources.Constant const(k=273.15)
    annotation (Placement(transformation(extent={{-82,-56},{-62,-36}})));

equation
    SumHeaGai = sum(solCol.solHeaGai.QSol_flow[1:3]);

  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{52,-10},{56,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{76,-10},{80,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{4.44089e-16,30},{44.6,30},{44.6,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boundary.ports[1], solCol.port_a) annotation (Line(
      points={{26,-10},{32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, add.u2) annotation (Line(
      points={{-61,-46},{-32,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, boundary.T_in) annotation (Line(
      points={{-9,-40},{-6,-40},{-6,-6},{4,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTable1Ds.y[1], add.u1) annotation (Line(
      points={{-43,-10},{-36,-10},{-36,-34},{-32,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiTable1Ds.y[4], boundary.m_flow_in) annotation (Line(
      points={{-43,-10},{-26,-10},{-26,-2},{6,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model was used to validate the FlatPlate solar collector model against TRNSYS data. Data files are used to ensure that the FlatPlate solar collector model saw the same inlet
and weather conditions as the TRNSYS simulation. A special version of the FlatPlate solar collector model was made to accomodate the data files. It can be accessed in the BaseClasses
folder.
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
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/FlatPlateSolarCollector.mos"
        "Simulate and plot"),
    Icon(graphics));
end FlatPlateSolarCollectorValidation;
