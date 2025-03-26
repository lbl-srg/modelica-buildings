within Buildings.DHC.Plants.Combined.Subsystems.Validation;
model CoolingTowerGroup "Validation of cooling tower group model"
  extends Modelica.Icons.Example;

  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  Buildings.DHC.Plants.Combined.Subsystems.CoolingTowerGroup coo(
    redeclare final package Medium = MediumConWat,
    show_T=true,
    nUni=2,
    mConWatUni_flow_nominal=1,
    dpConWatFriUni_nominal=1E4,
    mAirUni_flow_nominal=coo.mConWatUni_flow_nominal/1.45,
    TWetBulEnt_nominal=297.05,
    TConWatRet_nominal=308.15,
    TConWatSup_nominal=302.55,
    PFanUni_nominal=340*coo.mConWatUni_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling tower group"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = MediumConWat,
    T=coo.TConWatRet_nominal,
    nPorts=2)
    "Boundary conditions for CW"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-70})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TConWatSupSet(
    height=+3,
    duration=500,
    offset=coo.TConWatSup_nominal,
    startTime=500,
    y(displayUnit="degC", unit="K"))
    "CW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,1,1; 0.4,1,1; 0.4,1,0; 0.8,1,0; 0.8,0,0; 1,0,0],
    timeScale=1000,
    period=1000)
    "On/Off command"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,20})));
  Fluid.Sensors.TemperatureTwoPort TConWatSup(
    redeclare package Medium =MediumConWat,
    final m_flow_nominal=coo.mConWat_flow_nominal)
    "CW supply temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,0})));
  Fluid.Sensors.TemperatureTwoPort TConWatRet(
    redeclare package Medium =MediumConWat,
    final m_flow_nominal=coo.mConWat_flow_nominal)
    "CW return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-40})));
  ETS.Combined.Controls.PIDWithEnable ctl(
    k=1,
    Ti=60,
    reverseActing=false) "Controller"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed pum(
    redeclare package Medium =MediumConWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final nPum=coo.nUni,
    have_var=false,
    have_valve=false,
    final mPum_flow_nominal=coo.mConWatUni_flow_nominal,
    final dpPum_nominal=coo.dpConWatFriUni_nominal)
    "CW pumps"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(y1.y, coo.y1) annotation (Line(points={{-88,100},{-40,100},{-40,6},{-12,
          6}}, color={255,0,255}));
  connect(weaDat.weaBus, coo.weaBus) annotation (Line(
      points={{-90,20},{0,20},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(coo.port_b, TConWatSup.port_a)
    annotation (Line(points={{10,0},{10,1.77636e-15},{20,1.77636e-15}},
                                                      color={0,127,255}));
  connect(bouConWat.ports[1],TConWatRet. port_a) annotation (Line(points={{-1,-80},
          {-60,-80},{-60,-50}},  color={0,127,255}));
  connect(TConWatRet.port_b, coo.port_a)
    annotation (Line(points={{-60,-30},{-60,0},{-10,0}}, color={0,127,255}));
  connect(coo.TConWatSup, ctl.u_m) annotation (Line(points={{12,4},{20,4},{20,
          40},{0,40},{0,48}}, color={0,0,127}));
  connect(y1.y[1], ctl.uEna) annotation (Line(points={{-88,100},{-40,100},{-40,
          40},{-4,40},{-4,48}}, color={255,0,255}));
  connect(TConWatSupSet.y, ctl.u_s)
    annotation (Line(points={{-88,60},{-12,60}}, color={0,0,127}));
  connect(ctl.y, coo.y) annotation (Line(points={{12,60},{20,60},{20,80},{-28,
          80},{-28,-6},{-12,-6}}, color={0,0,127}));
  connect(pum.port_b, bouConWat.ports[2]) annotation (Line(points={{70,0},{80,0},
          {80,-80},{1,-80}},   color={0,127,255}));
  connect(TConWatSup.port_b, pum.port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  connect(y1.y, pum.y1) annotation (Line(points={{-88,100},{40,100},{40,8},{48,8}},
        color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Subsystems/Validation/CoolingTowerGroup.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.Plants.Combined.Subsystems.CoolingTowerGroup\">
Buildings.DHC.Plants.Combined.Subsystems.CoolingTowerGroup</a>
in a configuration with two tower cells.
The tower cells are initially enabled and they are disabled one after the other
as the CW supply temperature setpoint is increasing after an initial
period where it is fixed at its design value.
The Start command of the CW pumps is the same signal
as the one used for the cooling towers.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerGroup;
