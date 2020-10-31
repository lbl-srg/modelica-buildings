within Buildings.ThermalZones.EnergyPlus.Validation.Actuator;
model ShadeControl
  "Validation model for one actuator that controls a shade"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/EMSWindowShadeControl/EMSWindowShadeControl.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    showWeatherData=true)
    "Building model"
    annotation (Placement(transformation(extent={{-190,60},{-170,80}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal[:]=0.3*1.2/3600*{113.3,113.3,169.9}
    "Design mass flow rate";
  Modelica.Blocks.Sources.Constant qIntGai[3](
    each k=0)
    "Internal heat gains"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone zonWes(
    redeclare package Medium=Medium,
    zoneName="West Zone",
    nPorts=2)
    "West zone"
    annotation (Placement(transformation(extent={{-28,-22},{12,18}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone zonEas(
    redeclare package Medium=Medium,
    zoneName="EAST ZONE",
    nPorts=2)
    "East zone"
    annotation (Placement(transformation(extent={{40,-22},{80,18}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone zonNor(
    redeclare package Medium=Medium,
    zoneName="NORTH ZONE",
    nPorts=2)
    "North zone"
    annotation (Placement(transformation(extent={{0,40},{40,80}})));
  Buildings.ThermalZones.EnergyPlus.Actuator actSha(
    unit=Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized,
    variableName="Zn001:Wall001:Win001",
    componentType="Window Shading Control",
    controlType="Control Status")
    "Actuator for window shade"
    annotation (Placement(transformation(extent={{170,-100},{190,-80}})));
  Buildings.ThermalZones.EnergyPlus.OutputVariable incBeaSou(
    name="Surface Outside Face Incident Beam Solar Radiation Rate per Area",
    key="Zn001:Wall001:Win001",
    y(
      final unit="W/m2"))
    "Block that reads incident beam solar radiation on south window from EnergyPlus"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.ThermalZones.EnergyPlus.OutputVariable shaAbsSol(
    name="Surface Window Shading Device Absorbed Solar Radiation Rate",
    key="Zn001:Wall001:Win001",
    y(
      unit="W"))
    "Window shade absorbed solar radiation"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.Shade.Shade_T shaT(
    THigh=297.15,
    TLow=295.15)
    "Shade control signal based on room air temperature"
    annotation (Placement(transformation(extent={{50,-78},{70,-60}})));
  Buildings.Controls.OBC.Shade.Shade_H shaH(
    HHigh=200,
    HLow=10)
    "Shade control decision based on direct solar irradiation"
    annotation (Placement(transformation(extent={{50,-108},{70,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{110,-100},{130,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquT(
    t=0.5)
    "Output conversion"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquH(
    t=0.5)
    "Output conversion"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    realTrue=6)
    "Type conversion (6 meaning shade is deployed)"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData bou[3](
    redeclare each package Medium=Medium,
    m_flow=m_flow_nominal,
    each nPorts=1)
    "Infiltration, used to avoid that the absolute humidity is continuously increasing"
    annotation (Placement(transformation(extent={{-168,-10},{-148,10}})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium=Medium,
    nPorts=1)
    "Outside condition"
    annotation (Placement(transformation(extent={{-168,-44},{-148,-24}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium=Medium,
    m_flow_nominal=sum(
      m_flow_nominal),
    dp_nominal=10,
    linearized=true)
    annotation (Placement(transformation(extent={{-114,-44},{-134,-24}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1[3](
    redeclare each package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    each dp_nominal=10,
    each linearized=true)
    "Small flow resistance for inlet"
    annotation (Placement(transformation(extent={{-134,-10},{-114,10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-190,30},{-170,50}}),iconTransformation(extent={{-160,-10},{-140,10}})));
  Cooling cooNor
    "Idealized cooling system"
    annotation (Placement(transformation(rotation=0,extent={{120,50},{100,70}})));
  Cooling cooWes
    "Idealized cooling system"
    annotation (Placement(transformation(rotation=0,extent={{120,20},{100,40}})));
  Cooling cooEas
    "Idealized cooling system"
    annotation (Placement(transformation(rotation=0,extent={{120,-12},{100,8}})));
equation
  connect(qIntGai.y,zonNor.qGai_flow)
    annotation (Line(points={{-99,70},{-2,70}},color={0,0,127}));
  connect(qIntGai.y,zonEas.qGai_flow)
    annotation (Line(points={{-99,70},{-80,70},{-80,28},{30,28},{30,8},{38,8}},color={0,0,127}));
  connect(qIntGai.y,zonWes.qGai_flow)
    annotation (Line(points={{-99,70},{-80,70},{-80,8},{-30,8}},color={0,0,127}));
  connect(shaT.y,greEquT.u)
    annotation (Line(points={{72,-70},{78,-70}},color={0,0,127}));
  connect(shaH.y,greEquH.u)
    annotation (Line(points={{72,-100},{78,-100}},color={0,0,127}));
  connect(greEquT.y,and2.u1)
    annotation (Line(points={{102,-70},{106,-70},{106,-90},{108,-90}},color={255,0,255}));
  connect(greEquH.y,and2.u2)
    annotation (Line(points={{102,-100},{106,-100},{106,-98},{108,-98}},color={255,0,255}));
  connect(and2.y,booToRea.u)
    annotation (Line(points={{132,-90},{138,-90}},color={255,0,255}));
  connect(actSha.u,booToRea.y)
    annotation (Line(points={{168,-90},{162,-90}},color={0,0,127}));
  connect(shaT.T,zonWes.TAir)
    annotation (Line(points={{48,-70},{20,-70},{20,11.8},{13,11.8}},color={0,0,127}));
  connect(shaH.H,incBeaSou.y)
    annotation (Line(points={{48,-100},{41,-100}},color={0,0,127}));
  connect(weaBus,out.weaBus)
    annotation (Line(points={{-180,40},{-180,-33.8},{-168,-33.8}},color={255,204,51},thickness=0.5));
  connect(bou[:].ports[1],res1[:].port_a)
    annotation (Line(points={{-148,0},{-134,0}},color={0,127,255}));
  connect(weaBus,bou[1].weaBus)
    annotation (Line(points={{-180,40},{-180,0.2},{-168,0.2}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[2].weaBus)
    annotation (Line(points={{-180,40},{-180,0},{-168,0},{-168,0.2}},color={255,204,51},thickness=0.5));
  connect(weaBus,bou[3].weaBus)
    annotation (Line(points={{-180,40},{-180,0.2},{-168,0.2}},color={255,204,51},thickness=0.5));
  connect(building.weaBus,weaBus)
    annotation (Line(points={{-170,70},{-164,70},{-164,40},{-180,40}},color={255,204,51},thickness=0.5));
  connect(res1[1].port_b,zonNor.ports[1])
    annotation (Line(points={{-114,0},{-38,0},{-38,36},{18,36},{18,40.9}},color={0,127,255}));
  connect(res1[2].port_b,zonWes.ports[1])
    annotation (Line(points={{-114,0},{-38,0},{-38,-26},{-10,-26},{-10,-21.1}},color={0,127,255}));
  connect(res1[3].port_b,zonEas.ports[1])
    annotation (Line(points={{-114,0},{-38,0},{-38,-26},{58,-26},{58,-21.1}},color={0,127,255}));
  connect(out.ports[1],res.port_b)
    annotation (Line(points={{-148,-34},{-134,-34}},color={0,127,255}));
  connect(res.port_a,zonNor.ports[2])
    annotation (Line(points={{-114,-34},{-46,-34},{-46,34},{22,34},{22,40.9}},color={0,127,255}));
  connect(res.port_a,zonWes.ports[2])
    annotation (Line(points={{-114,-34},{-6,-34},{-6,-21.1}},color={0,127,255}));
  connect(res.port_a,zonEas.ports[2])
    annotation (Line(points={{-114,-34},{62,-34},{62,-21.1}},color={0,127,255}));
protected
  model Cooling
    extends Modelica.Blocks.Icons.Block;
    HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
      "Prescribed heat flow rate"
      annotation (Placement(transformation(extent={{50,-10},{70,10}})));
    Controls.OBC.CDL.Continuous.Gain gai(
      k=-5000)
      "Gain"
      annotation (Placement(transformation(extent={{10,-10},{30,10}})));
    Controls.OBC.CDL.Continuous.PID conPID(
      Ti=120,
      reverseActing=false)
      annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
    Controls.OBC.CDL.Continuous.Sources.Constant TSet(
      k=273.15+25)
      "Set point temperature"
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPor
      "Heat port"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
      "Temperature sensor"
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  equation
    connect(TSet.y,conPID.u_s)
      annotation (Line(points={{-48,0},{-32,0}},color={0,0,127}));
    connect(gai.u,conPID.y)
      annotation (Line(points={{8,0},{-8,0}},color={0,0,127}));
    connect(gai.y,preHeaFlo.Q_flow)
      annotation (Line(points={{32,0},{50,0}},color={0,0,127}));
    connect(preHeaFlo.port,heaPor)
      annotation (Line(points={{70,0},{100,0}},color={191,0,0}));
    connect(temSen.T,conPID.u_m)
      annotation (Line(points={{-40,-50},{-20,-50},{-20,-12}},color={0,0,127}));
    connect(temSen.port,preHeaFlo.port)
      annotation (Line(points={{-60,-50},{-70,-50},{-70,-72},{84,-72},{84,0},{70,0},{70,0}},color={191,0,0}));
    annotation (
      Diagram(
        coordinateSystem(
          extent={{-100,-100},{100,100}})),
      Icon(
        coordinateSystem(
          extent={{-100,-100},{100,100}})));
  end Cooling;
equation
  connect(cooNor.heaPor,zonNor.heaPorAir)
    annotation (Line(points={{100,60},{20,60}},color={191,0,0}));
  connect(cooWes.heaPor,zonWes.heaPorAir)
    annotation (Line(points={{100,30},{24,30},{24,-2},{-8,-2}},color={191,0,0}));
  connect(cooEas.heaPor,zonEas.heaPorAir)
    annotation (Line(points={{100,-2},{60,-2}},color={191,0,0}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/Actuator/ShadeControl.mos" "Simulate and plot"),
    experiment(
      StartTime=8640000,
      StopTime=8899200,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-200,-160},{200,120}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
Validation case for a building that uses an EMS actuator.
The building has three thermal zones and is simulated in EnergyPlus.
The west-facing thermal zone has
a window blind that is open if its control signal is <i>0</i> or closed if it is <i>6</i>.
The instance <code>actSha</code> connects to the EMS actuator in EnergyPlus that activates this shade.
The shade is controlled based the incident solar radiation which is computed by EnergyPlus,
and the room air temperature.
An idealized cooling system keeps the room air temperature below <i>25</i>&deg;C.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 11, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShadeControl;
