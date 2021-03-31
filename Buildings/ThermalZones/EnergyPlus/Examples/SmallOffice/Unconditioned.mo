within Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice;
model Unconditioned
  "Open loop model of one floor"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Air
    "Medium for air";
  parameter String weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";
  final parameter Modelica.SIunits.MassFlowRate mOut_flow[4]=0.3/3600*{flo.VRooSou,flo.VRooEas,flo.VRooNor,flo.VRooWes}*1.2
    "Outside air infiltration for each exterior room";
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=weaName,
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.BaseClasses.Floor flo(
    redeclare package Medium=Medium,
    nor(
      T_start=275.15),
    wes(
      T_start=275.15),
    eas(
      T_start=275.15),
    sou(
      T_start=275.15),
    cor(
      T_start=275.15))
    "One floor of the office building"
    annotation (Placement(transformation(extent={{32,-2},{86,28}})));
  // Above, the volume V is for Spawn obtained in the initial equation section.
  // Hence it is not known when the model is compiled. This leads to a
  // warning in Dymola and an error in Optimica (Modelon#2020031339000191)
  // if used in an expression for the nominal attribute of lea*(res(m_flow(nominal=....))).
  // Assigning the nominal attribute to a constant avoids this warning and error.
  Fluid.Sources.MassFlowSource_WeatherData bou[4](
    redeclare each package Medium=Medium,
    m_flow=mOut_flow,
    each nPorts=1)
    "Infiltration, used to avoid that the absolute humidity is continuously increasing"
    annotation (Placement(transformation(extent={{-28,-30},{-8,-10}})));
  Fluid.Sources.Outside out(
    redeclare package Medium=Medium,
    nPorts=1)
    "Outside condition"
    annotation (Placement(transformation(extent={{-28,-64},{-8,-44}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium=Medium,
    m_flow_nominal=sum(mOut_flow),
    dp_nominal=10,
    linearized=true)
    "Small flow resistance for inlet"
    annotation (Placement(transformation(extent={{6,-64},{26,-44}})));
  Fluid.FixedResistances.PressureDrop res1[4](
    redeclare each package Medium=Medium,
    each m_flow_nominal=sum(mOut_flow),
    each dp_nominal=10,
    each linearized=true)
    "Small flow resistance for inlet"
    annotation (Placement(transformation(extent={{4,-30},{24,-10}})));

equation
  connect(weaDat.weaBus,weaBus)
    annotation (Line(points={{-60,50},{-40,50}},color={255,204,51},thickness=0.5));
  connect(weaBus,flo.weaBus)
    annotation (Line(points={{-40,50},{66,50},{66,30.3077},{66.0435,30.3077}},color={255,204,51},thickness=0.5));
  connect(out.ports[1],res.port_a)
    annotation (Line(points={{-8,-54},{6,-54}},color={0,127,255}));
  connect(res.port_b,flo.portsCor[1])
    annotation (Line(points={{26,-54},{48,-54},{48,12},{51.7217,12},{51.7217,12.7692}},color={0,127,255}));
  connect(weaBus,out.weaBus)
    annotation (Line(points={{-40,50},{-40,-53.8},{-28,-53.8}},color={255,204,51},thickness=0.5));
  connect(bou[:].ports[1],res1[:].port_a)
    annotation (Line(points={{-8,-20},{-2,-20},{-2,-20},{4,-20}},color={0,127,255}));
  connect(weaBus,bou[1].weaBus)
    annotation (Line(points={{-40,50},{-40,-19.8},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[2].weaBus)
    annotation (Line(points={{-40,50},{-40,-20},{-28,-20},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[3].weaBus)
    annotation (Line(points={{-40,50},{-40,-19.8},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[4].weaBus)
    annotation (Line(points={{-40,50},{-40,-20},{-28,-20},{-28,-19.8}},color={255,204,51},thickness=0.5));
  connect(res1[1].port_b,flo.portsSou[1])
    annotation (Line(points={{24,-20},{51.7217,-20},{51.7217,4.46154}},color={0,127,255}));
  connect(res1[2].port_b,flo.portsEas[1])
    annotation (Line(points={{24,-20},{78.487,-20},{78.487,12.7692}},color={0,127,255}));
  connect(res1[3].port_b,flo.portsNor[1])
    annotation (Line(points={{24,-20},{46,-20},{46,20.6154},{51.7217,20.6154}},color={0,127,255}));
  connect(res1[4].port_b,flo.portsWes[1])
    annotation (Line(points={{24,-20},{38,-20},{38,12.7692},{37.1652,12.7692}},color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SmallOffice/Unconditioned.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Test case of the small office DOE reference building without an HVAC system.
Each thermal zone has a constant air flow rate of unconditioned outside air.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 4, 2020, by Michael Wetter:<br/>
Set the outside air infiltration to a realistic value.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2381\">#2381</a>.
</li>
<li>
March 4, 2020, by Milica Grahovac:<br/>
Declared the floor model as replaceable.
</li>
<li>
March 5, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Unconditioned;
