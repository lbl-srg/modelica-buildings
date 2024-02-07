within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model HeatPumpGroup "Validation of heat pump group model"
  extends Modelica.Icons.Example;

  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Fluid.HeatPumps.Data.EquationFitReversible.Generic dat(
    dpHeaLoa_nominal=50000,
    dpHeaSou_nominal=100,
    hea(
      mLoa_flow=dat.hea.Q_flow / 10 / 4186,
      mSou_flow=1E-4 * dat.hea.Q_flow,
      Q_flow=1E6,
      P=dat.hea.Q_flow / 2.2,
      coeQ={-5.64420084,  1.95212447,  9.96663913,  0.23316322, -5.64420084},
      coeP={-3.96682255,  6.8419453,   1.99606939,  0.01393387, -3.96682255},
      TRefLoa=298.15,
      TRefSou=253.15),
    coo(
      mLoa_flow=0,
      mSou_flow=0,
      Q_flow=-1,
      P=0,
      coeQ=fill(0, 5),
      coeP=fill(0, 5),
      TRefLoa=273.15,
      TRefSou=273.15))
    "Heat pump parameters (each unit)"
    annotation (Placement(transformation(extent={{90,92},{110,112}})));

  Buildings.Experimental.DHC.Plants.Combined.Subsystems.HeatPumpGroup heaPum(
    redeclare final package Medium = MediumHeaWat,
    redeclare final package MediumAir = MediumAir,
    show_T=true,
    nUni=2,
    final dat=dat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heat pump group"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumHeaWat,
    use_T_in=true,
    nPorts=2)
    "Boundary conditions for HW"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={2,-90})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=dat.hea.TRefLoa+ 10,
    y(displayUnit="degC", unit="K")) "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,1,1; 0.5,1,1; 0.5,1,0; 0.8,1,0; 0.8,0,0; 1,0,0],
    timeScale=1000,
    period=1000)
    "Heat pump On/Off command"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,20})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatRetBou(
    y(displayUnit="degC", unit="K"),
    height=+5,
    duration=1000,
    offset=dat.hea.TRefLoa) "HW return temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare package Medium = MediumHeaWat,
    final m_flow_nominal=heaPum.mHeaWat_flow_nominal)
    "HW supply temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,-40})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRet(
    redeclare package Medium = MediumHeaWat,
    final m_flow_nominal=heaPum.mHeaWat_flow_nominal)
    "HW return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-40})));
equation
  connect(THeaWatSupSet.y,heaPum. TSet) annotation (Line(points={{-88,60},{-60,60},
          {-60,-6},{-12,-6}},      color={0,0,127}));
  connect(y1.y,heaPum. y1) annotation (Line(points={{-88,100},{-40,100},{-40,6},
          {-12,6}},
               color={255,0,255}));
  connect(weaDat.weaBus,heaPum. weaBus) annotation (Line(
      points={{-90,20},{0,20},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatRetBou.y, bouHeaWat.T_in)
    annotation (Line(points={{-88,-60},{6,-60},{6,-78}}, color={0,0,127}));
  connect(heaPum.port_b, THeaWatSup.port_a)
    annotation (Line(points={{10,0},{20,0},{20,-30}}, color={0,127,255}));
  connect(THeaWatSup.port_b, bouHeaWat.ports[1])
    annotation (Line(points={{20,-50},{20,-100},{1,-100}}, color={0,127,255}));
  connect(bouHeaWat.ports[2], THeaWatRet.port_a) annotation (Line(points={{3,-100},
          {-20,-100},{-20,-50}}, color={0,127,255}));
  connect(THeaWatRet.port_b, heaPum.port_a)
    annotation (Line(points={{-20,-30},{-20,0},{-10,0}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/HeatPumpGroup.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Subsystems.HeatPumpGroup\">
Buildings.Experimental.DHC.Plants.Combined.Subsystems.HeatPumpGroup</a>
in a configuration with two heat pumps.
The heat pumps are initially On and they are switched Off one after the other
as they are exposed to an increasing HW return temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPumpGroup;
