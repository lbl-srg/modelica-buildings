within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Validation;
model SwitchBox "Validation of flow switch box"
  extends Modelica.Icons.Example;

  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal water mass flow rate";
  Fluid.Delays.DelayFirstOrder volSup(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final m_flow_nominal=m_flow_nominal,
    tau=60,
    nPorts=3) "Mixing volume supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,0})));
  Fluid.Delays.DelayFirstOrder volRet(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final m_flow_nominal=m_flow_nominal,
    tau=60,
    nPorts=3) "Mixing volume return" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={70,0})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum1(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum2(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.SwitchBox
    floSwiBox(final m_flow_nominal=m_flow_nominal, redeclare final package
      Medium = Medium,
    trueHoldDuration=300)
                       "Flow switch box"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium) "District water mass flow rate"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={0,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setMasFlo1(k=0.5)
    "Set point for mass flow rate (normalized)"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Fluid.Sources.Boundary_pT disWatBou(redeclare package Medium = Medium,
      nPorts=2) "District water boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-90})));
  Modelica.Blocks.Sources.CombiTimeTable setMasFlo2(
    tableName="tab1",
    table=[0,0; 0.6,1; 0.7,0; 1,1],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    timeScale=1000) "Set point for mass flow rate (normalized)"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(final k=
        m_flow_nominal) "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-46,70},{-26,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(final k=
        m_flow_nominal) "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-46,30},{-26,50}})));
equation
  connect(pum1.port_b, volSup.ports[1]) annotation (Line(points={{-10,0},{-60,0},
          {-60,-2.66667}}, color={0,127,255}));
  connect(volSup.ports[2], pum2.port_a) annotation (Line(points={{-60,-4.44089e-16},
          {-60,60},{-10,60}}, color={0,127,255}));
  connect(pum2.port_b, volRet.ports[1]) annotation (Line(points={{10,60},{60,60},
          {60,-2.66667}}, color={0,127,255}));
  connect(volRet.ports[2], pum1.port_a) annotation (Line(points={{60,8.88178e-16},
          {60,0},{10,0}}, color={0,127,255}));
  connect(floSwiBox.port_bSup, volSup.ports[3]) annotation (Line(points={{-6,-40},
          {-6,-20},{-60,-20},{-60,2.66667}}, color={0,127,255}));
  connect(floSwiBox.port_aRet, volRet.ports[3]) annotation (Line(points={{6,-40},
          {6,-20},{60,-20},{60,2.66667}}, color={0,127,255}));
  connect(floSwiBox.port_bRet, senMasFlo.port_a) annotation (Line(points={{6,-60},
          {6,-80},{60,-80},{60,-100},{10,-100}},
                                       color={0,127,255}));
  connect(senMasFlo.port_b, disWatBou.ports[1]) annotation (Line(points={{-10,
          -100},{-60,-100},{-60,-88}},
                                     color={0,127,255}));
  connect(disWatBou.ports[2], floSwiBox.port_aSup) annotation (Line(points={{-60,-92},
          {-60,-80},{-6,-80},{-6,-60}},
                                    color={0,127,255}));
  connect(pum1.m_flow_actual, floSwiBox.mRev_flow) annotation (Line(points={{-11,
          5},{-20,5},{-20,-54},{-12,-54}}, color={0,0,127}));
  connect(setMasFlo2.y[1], gai2.u)
    annotation (Line(points={{-69,80},{-48,80}}, color={0,0,127}));
  connect(gai2.y, pum2.m_flow_in)
    annotation (Line(points={{-24,80},{0,80},{0,72}}, color={0,0,127}));
  connect(setMasFlo1.y, gai1.u)
    annotation (Line(points={{-68,40},{-48,40}}, color={0,0,127}));
  connect(gai1.y, pum1.m_flow_in)
    annotation (Line(points={{-24,40},{0,40},{0,12}}, color={0,0,127}));
  connect(pum2.m_flow_actual, floSwiBox.mPos_flow) annotation (Line(points={{11,
          65},{20,65},{20,-28},{-16,-28},{-16,-46},{-12,-46}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p>
This model validates that
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.SwitchBox\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.SwitchBox</a>
maintains a positive flow rate in the district line outside of the temporization
period set by the controller.
</p>
</html>"),
  experiment(
      StopTime=1000,
      Tolerance=1e-06),
    __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Subsystems/Validation/SwitchBox.mos"
    "Simulate and plot"));
end SwitchBox;
