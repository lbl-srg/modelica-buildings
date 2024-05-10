within Buildings.Fluid.Geothermal.ZonedBorefields.Validation;
model SteadyStateBoreholeDynamics "Description"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Temperature T_start=273.15
    "Initial temperature of the soil";
  final parameter Integer nZon(min=1) = borFieDat.conDat.nZon
    "Total number of independent bore field zones";

  Buildings.Fluid.Geothermal.ZonedBorefields.OneUTube borHol(
    redeclare package Medium = Medium,
    nSeg=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    borFieDat=borFieDat,
    TExt0_start=T_start,
    dT_dz=0,
    tLoaAgg=3600,
    dynFil=false)
    "Borehole"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Movers.FlowControlled_m_flow pum[nZon](
    redeclare each package Medium = Medium,
    each T_start=T_start,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    each addPowerToMedium=false,
    each use_inputFilter=false,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    each nominalValuesDefineDefaultPressureCurve=true,
    each inputType=Buildings.Fluid.Types.InputType.Constant,
    each dp_nominal=60E3) "Circulation pump"
    annotation (Placement(transformation(extent={{0,10},{20,-10}})));
  Sensors.TemperatureTwoPort TBorFieIn[nZon](
    redeclare each package Medium = Medium,
    each T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    each tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Sensors.TemperatureTwoPort TBorFieOut[nZon](
    redeclare each package Medium = Medium,
    each T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    each tau=0) "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  parameter
    Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Example
    borFieDat(
    filDat=filDat,
    soiDat=soiDat,
    conDat=conDat) "Borefield data"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Sources.Boundary_ph sin[nZon](redeclare each package Medium =
        Medium, each nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  HeatExchangers.HeaterCooler_u hea[nZon](
    redeclare each package Medium = Medium,
    each dp_nominal=10000,
    each show_T=true,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    m_flow(start=borFieDat.conDat.mZon_flow_nominal),
    each p_start=100000,
    Q_flow_nominal=2*Modelica.Constants.pi*borFieDat.soiDat.kSoi*borFieDat.conDat.hBor
        *borFieDat.conDat.nBorPerZon) "Heater"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Sources.Pulse heaRat[nZon](
    each amplitude=1,
    each width=50,
    period=3600.*24*60*{1,2},
    startTime=3600.*24*30*{0,1}) "Heating rate into each zone"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  parameter ZonedBorefields.Data.Configuration.Example conDat
    "Borefield configuration data"
    annotation (Placement(transformation(extent={{-58,-40},{-38,-20}})));
  parameter ZonedBorefields.Data.Filling.Bentonite filDat
    "Borehole filling data"
    annotation (Placement(transformation(extent={{-36,-40},{-16,-20}})));
  parameter ZonedBorefields.Data.Soil.SandStone soiDat
    "Soil data"
    annotation (Placement(transformation(extent={{-14,-40},{6,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable timTabT(
    tableOnFile=true,
    tableName="tab1",
    columns={2,3,4,5},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Geothermal/ZonedBorefields/Validation/SteadyStateBoreholeDynamics.txt"),
    y(each unit="degC", each displayUnit="degC"),
    timeScale=3600)
    "Reference results for the average borehole wall temperature in each zone"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

equation
  connect(TBorFieIn.port_b,borHol. port_a)
    annotation (Line(points={{50,0},{60,0}},       color={0,127,255}));
  connect(borHol.port_b,TBorFieOut. port_a)
    annotation (Line(points={{80,0},{90,0}},              color={0,127,255}));
  connect(pum.port_b,TBorFieIn. port_a) annotation (Line(points={{20,0},{30,0}},
                                         color={0,127,255}));
  connect(sin[:].ports[1],TBorFieOut[:]. port_b) annotation (Line(points={{100,30},{
          120,30},{120,0},{110,0}},
                                  color={0,127,255}));
  connect(hea.port_b,pum. port_a)
    annotation (Line(points={{-10,0},{0,0}},           color={0,127,255}));
  connect(hea.port_a,TBorFieOut. port_b) annotation (Line(points={{-30,0},{-80,
          0},{-80,60},{120,60},{120,0},{110,0}},
                                      color={0,127,255}));
  connect(heaRat.y, hea.u) annotation (Line(points={{-49,20},{-40,20},{-40,6},{
          -32,6}},
               color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(extent={{-100,-60},{140,80}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Validation/SteadyStateBoreholeDynamics.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This validation cases tests the independent operation of borefield zones for the
borefield configured in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example</a>.
</p>
<p>
The model assumes no dynamics in the boreholes. The heating rate to a zone is
constant (when activated). The duration of heat injection into each zone is a
multiple of 1 month, with alternating signals to each zone to obtain all
possible combinations of activated and deactivated zones.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=124416000,
    Tolerance=1E-6));
end SteadyStateBoreholeDynamics;
