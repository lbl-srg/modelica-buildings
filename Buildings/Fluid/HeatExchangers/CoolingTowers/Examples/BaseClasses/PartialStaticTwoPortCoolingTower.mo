within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
partial model PartialStaticTwoPortCoolingTower
  "Base class for test models of cooling towers"

  package Medium_W = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal = 0.5
    "Design water flow rate"
      annotation (Dialog(group="Nominal condition"));

  replaceable
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower tow
     constrainedby
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower(
    redeclare final package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    show_T=true) "Cooling tower"
    annotation (Placement(transformation(extent={{24,-60},{44,-40}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for chilled water loop"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Modelica.Blocks.Logical.OnOffController onOffController(bandwidth=4)
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
  Modelica.Blocks.Sources.Constant TSwi(k=273.15 + 22)
    "Switch temperature for switching tower pump on"
    annotation (Placement(transformation(extent={{-80,-206},{-60,-186}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero flow rate"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Modelica.Blocks.Sources.Constant mWat_flow(k=mWat_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-20,-168},{0,-148}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=3,
    redeclare package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    V=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Fluid.Sources.FixedBoundary exp(
    redeclare package Medium = Medium_W,
    nPorts=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-120})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo(Q_flow=0.5*
        mWat_flow_nominal*4200*5) "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature"
    annotation (Placement(transformation(extent={{-70,-160},{-50,-140}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,50},{-60,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(onOffController.y, switch1.u2) annotation (Line(
      points={{1,-190},{18,-190}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(zer.y, switch1.u3) annotation (Line(
      points={{1,-220},{8,-220},{8,-198},{18,-198}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, switch1.u1) annotation (Line(
      points={{1,-158},{8,-158},{8,-182},{18,-182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.ports[1], pum.port_a) annotation (Line(
      points={{27.3333,-120},{-60,-120},{-60,-50},{-40,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixHeaFlo.port, vol.heatPort) annotation (Line(
      points={{-20,-90},{10,-90},{10,-110},{20,-110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, TVol.port) annotation (Line(
      points={{20,-110},{-80,-110},{-80,-150},{-70,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tow.port_b, vol.ports[2]) annotation (Line(
      points={{44,-50},{60,-50},{60,-120},{30,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, tow.port_a) annotation (Line(
      points={{-20,-50},{24,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onOffController.u, TSwi.y) annotation (Line(
      points={{-22,-196},{-59,-196}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TVol.T, onOffController.reference) annotation (Line(
      points={{-50,-150},{-40,-150},{-40,-184},{-22,-184}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, pum.m_flow_in) annotation (Line(
      points={{41,-190},{70,-190},{70,-240},{-100,-240},{-100,-30},{-30.2,-30},
          {-30.2,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(exp.ports[1], vol.ports[3]) annotation (Line(
      points={{82,-120},{32.6667,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,
            -260},{140,100}}),
                      graphics));
end PartialStaticTwoPortCoolingTower;
