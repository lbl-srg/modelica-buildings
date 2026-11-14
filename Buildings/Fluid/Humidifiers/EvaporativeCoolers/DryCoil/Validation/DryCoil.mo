within Buildings.Fluid.Humidifiers.EvaporativeCoolers.DryCoil.Validation;
model DryCoil "Validation for the dry coil model"
  extends Modelica.Icons.Example;

  replaceable package MediumW = Buildings.Media.Water
    "Medium water"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Nominal water mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    displayUnit="Pa")=6000
    "Nominal pressure difference of water side"
    annotation (Dialog(group="Nominal condition"));

  parameter Buildings.Fluid.Humidifiers.EvaporativeCoolers.DryCoil.Data.Generic dat(
    Q_flow_nominal=-m_flow_nominal*4200*(35 - 30),
    TCooIn_nominal=308.15,
    TCooOut_nominal=303.15,
    dp_nominal=dp_nominal,
    TAirIn_nominal=298.15)
    "Performance data for dry coil"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.DryCoil.DryCoil dryCoi(
    redeclare final package Medium = MediumW,
    final dat=dat)
    "Dry coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumW,
    addPowerToMedium=false,
    m_flow_nominal=m_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for cooling water loop"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TEnt(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_nominal)
    "Water entering temperature sensor"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo(
    Q_flow=0.5*m_flow_nominal*4200*5)
    "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_nominal,
    V=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume of water loop"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Fluid.Sources.Boundary_pT exp(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Expansion vessel"
    annotation (Placement(transformation(extent={{140,0},{120,20}})));

  Modelica.Blocks.Logical.OnOffController onOffCon(
    bandwidth=2,
    reference(unit="K", displayUnit="degC"),
    u(unit="K", displayUnit="degC"))
    "On/off controller"
    annotation (Placement(transformation(extent={{-110,120},{-90,140}})));

  Modelica.Blocks.Logical.Switch swi
    "Control switch for cooling water pump"
    annotation (Placement(transformation(extent={{-70,120},{-50,140}})));

  Modelica.Blocks.Sources.Constant TSwi(
    k=273.15 + 22)
    "Switch temperature for switching cooling water pump on"
    annotation (Placement(transformation(extent={{-170,115},{-150,135}})));

  Modelica.Blocks.Sources.Constant zer(
    k=0)
    "Zero flow rate"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));

  Modelica.Blocks.Sources.Constant m_flow(
    k=m_flow_nominal)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature sensor"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));

  Modelica.Blocks.Sources.Constant TSetLea(
    k=273.15 + 18)
    "Setpoint for leaving water temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.Continuous.LimPID conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for coil fan"
    annotation (Placement(transformation(extent={{-110,-80},{-90,-60}})));

  Modelica.Blocks.Math.Gain gaiMAir_flow(
    final k=m_flow_nominal/dat.ratCooAir_nominal)
    "Gain to convert fan control signal to air mass flow rate"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));

  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-110,-150},{-70,-110}}), iconTransformation(
          extent={{-184,-120},{-164,-100}})));
equation
  connect(pum.port_b, TEnt.port_a)
    annotation (Line(points={{-120,30},{-100,30}}, color={0,127,255}));
  connect(TEnt.port_b, dryCoi.port_a)
    annotation (Line(points={{-80,30},{-45,30},{-45,0},{-10,0}}, color={0,127,255}));
  connect(dryCoi.port_b, vol.ports[1])
    annotation (Line(points={{10,0},{49,0},{49,60}}, color={0,127,255}));
  connect(exp.ports[1], dryCoi.port_b)
    annotation (Line(points={{120,10},{60,10},{60,0},{10,0}}, color={0,127,255}));
  connect(vol.ports[2], pum.port_a)
    annotation (Line(points={{51,60},{-160,60},{-160,30},{-140,30}},
      color={0,127,255}));
  connect(fixHeaFlo.port, vol.heatPort)
    annotation (Line(points={{20,110},{20,90},{40,90},{40,70}}, color={191,0,0}));
  connect(onOffCon.y, swi.u2)
    annotation (Line(points={{-89,130},{-72,130}}, color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-89,100},{-80,100},{-80,122},{-72,122}},
      color={0,0,127}));
  connect(m_flow.y, swi.u1)
    annotation (Line(points={{-89,160},{-80,160},{-80,138},{-72,138}},
      color={0,0,127}));
  connect(onOffCon.u, TSwi.y)
    annotation (Line(points={{-112,124},{-132,124},{-132,125},{-149,125}},
                                                     color={0,0,127}));
  connect(TVol.T, onOffCon.reference)
    annotation (Line(points={{-139,170},{-130,170},{-130,136},{-112,136}},
      color={0,0,127}));
  connect(vol.heatPort, TVol.port)
    annotation (Line(points={{40,70},{-190,70},{-190,170},{-160,170}},
      color={191,0,0}));
  connect(swi.y, pum.m_flow_in)
    annotation (Line(points={{-49,130},{-30,130},{-30,42},{-130,42}},
      color={0,0,127}));
  connect(TSetLea.y, conFan.u_s)
    annotation (Line(points={{-139,-70},{-112,-70}}, color={0,0,127}));
  connect(dryCoi.TLvg, conFan.u_m)
    annotation (Line(points={{11,-6},{20,-6},{20,-100},{-100,-100},{-100,-82}},
      color={0,0,127}));
  connect(conFan.y, gaiMAir_flow.u)
    annotation (Line(points={{-89,-70},{-62,-70}}, color={0,0,127}));
  connect(gaiMAir_flow.y, dryCoi.mAir_flow)
    annotation (Line(points={{-39,-70},{-30,-70},{-30,8},{-12,8}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-140,-130},{-90,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, dryCoi.TDryBul) annotation (Line(
      points={{-89.9,-129.9},{-20,-129.9},{-20,4},{-12,4}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-180},{180,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StartTime=21600000,
      StopTime=21686400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/DryCoil/Validation/DryCoil.mos"
      "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model validates the dry coil model
<code>Buildings.Fluid.Humidifiers.EvaporativeCoolers.DryCoil.DryCoil</code>
in a closed cooling water loop with time-varying outdoor air dry-bulb
temperature from a weather file.
</p>
<p>
A constant heat load is added to the water loop via <code>fixHeaFlo</code>.
An on/off controller <code>onOffCon</code> switches the cooling water pump
<code>pum</code> on and off based on the water volume temperature
<code>TVol.T</code> and the switch temperature <code>TSwi.k</code> with a
deadband of <code>onOffCon.bandwidth</code>.
</p>
<p>
A PID controller <code>conFan</code> tracks the leaving water temperature
setpoint <code>TSetLea.k</code> by modulating the fan air mass flow rate
<code>dryCoi.mAir_flow</code> through the gain block
<code>gaiMAir_flow</code>. As the fan control signal varies across the
minimum threshold <code>dryCoi.yMin</code>, the dry coil transitions between
the free-convection and forced-convection heat transfer regimes while
responding to variations in entering air dry-bulb temperature
<code>dryCoi.TDryBul</code> and cooling fluid inlet temperature
<code>TEnt.T</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 14, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCoil;
