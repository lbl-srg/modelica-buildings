within Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice;
model FloorOpenLoop
  "Open loop model of one floor"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Air
    "Medium for air";
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";
  final parameter Modelica.SIunits.MassFlowRate mOut_flow=2
    "Outside air infiltration for each room";
  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=idfName,
    weaName=weaName)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Name of the weather file";
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses.Floor flo(
    redeclare package Medium=Medium,
    use_windPressure=false,
    nor(
      T_start=275.15),
    wes(
      T_start=275.15),
    eas(
      T_start=275.15),
    sou(
      T_start=275.15),
    cor(
      T_start=275.15),
    att(
      T_start=275.15))
    "One floor of the office building"
    annotation (Placement(transformation(extent={{28,-8},{84,52}})));
  Fluid.Sources.MassFlowSource_WeatherData bou[4](
    redeclare each package Medium=Medium,
    each m_flow=mOut_flow,
    each nPorts=1)
    "Infiltration, used to avoid that the absolute humidity is continuously increasing"
    annotation (Placement(transformation(extent={{-28,-30},{-8,-10}})));
  Fluid.Sources.Outside out(
    redeclare package Medium=Medium,
    nPorts=1)
    "Outside condition"
    annotation (Placement(transformation(extent={{-30,-64},{-10,-44}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium=Medium,
    m_flow_nominal=mOut_flow,
    dp_nominal=10,
    linearized=true)
    annotation (Placement(transformation(extent={{20,-64},{0,-44}})));
  Fluid.FixedResistances.PressureDrop res1[4](
    redeclare each package Medium=Medium,
    each m_flow_nominal=mOut_flow,
    each dp_nominal=10,
    each linearized=true)
    "Small flow resistance for inlet"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
equation
  connect(weaBus,flo.weaBus)
    annotation (Line(points={{-40,50},{66,50},{66,22},{65,22}},color={255,204,51},thickness=0.5));
  connect(weaBus,out.weaBus)
    annotation (Line(points={{-40,50},{-40,-53.8},{-30,-53.8}},color={255,204,51},thickness=0.5));
  connect(bou[:].ports[1],res1[:].port_a)
    annotation (Line(points={{-8,-20},{0,-20}},color={0,127,255}));
  connect(res1[1].port_b,flo.portsWes[1])
    annotation (Line(points={{20,-20},{40,-20},{40,6.6}},color={0,127,255}));
  connect(res1[2].port_b,flo.portsNor[1])
    annotation (Line(points={{20,-20},{46,-20},{46,14.6},{52,14.6}},color={0,127,255}));
  connect(res1[3].port_b,flo.portsSou[1])
    annotation (Line(points={{20,-20},{52,-20},{52,-1.4}},color={0,127,255}));
  connect(res1[4].port_b,flo.portsEas[1])
    annotation (Line(points={{20,-20},{76.4,-20},{76.4,5.6}},color={0,127,255}));
  connect(weaBus,bou[1].weaBus)
    annotation (Line(points={{-40,50},{-40,-19.8},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[2].weaBus)
    annotation (Line(points={{-40,50},{-40,-20},{-28,-20},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[3].weaBus)
    annotation (Line(points={{-40,50},{-40,-19.8},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[4].weaBus)
    annotation (Line(points={{-40,50},{-40,-20},{-28,-20},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(building.weaBus,weaBus)
    annotation (Line(points={{-60,50},{-40,50}},color={255,204,51},thickness=0.5));
  connect(out.ports[1],res.port_b)
    annotation (Line(points={{-10,-54},{0,-54}},color={0,127,255}));
  connect(res.port_a,flo.portsCor[1])
    annotation (Line(points={{20,-54},{60,-54},{60,6.6},{52,6.6}},color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/VAVReheatRefBldgSmallOffice/FloorOpenLoop.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Test case of one floor of the small office DOE reference building.
</p>
</html>",
      revisions="<html>
<ul><li>
March 5, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FloorOpenLoop;
