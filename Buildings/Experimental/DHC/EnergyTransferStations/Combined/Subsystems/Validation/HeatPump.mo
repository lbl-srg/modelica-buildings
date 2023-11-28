within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Validation;
model HeatPump
  "Validation of the base subsystem model with heat pump"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Modelica.Units.SI.Temperature TCon_nominal = 273.15+30 "Nominal condenser outlet temperature";
  parameter Modelica.Units.SI.Temperature TAmb_nominal = 273.15+15 "Nominal ambient loop temperature to evaporator";
  parameter Modelica.Units.SI.Power QLoa_nominal = 1000 "Nominal load";
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump
    heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    COP_nominal=2.3,
    TCon_nominal=TCon_nominal,
    TEva_nominal(displayUnit="K") = TAmb_nominal - heaPum.dT_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    Q1_flow_nominal=QLoa_nominal)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  Fluid.Sources.Boundary_pT supAmb(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    T=TAmb_nominal,
    nPorts=1) "Ambient water supply" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,-60})));
  Fluid.Sources.Boundary_pT sinAmb(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,10})));
  Fluid.Sources.Boundary_pT souLoa(
    redeclare final package Medium = Medium,
    T=TCon_nominal - heaPum.dT_nominal,
    nPorts=1) "Source for load (return from load)"
                                 annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-110,-52})));

  Modelica.Blocks.Sources.Sine sin(f=1/(86400/2)) "Load signal"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=1, uMin=0)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Math.Gain gain(k=QLoa_nominal/(4200*5))
    annotation (Placement(transformation(extent={{-48,80},{-28,100}})));
  Modelica.Blocks.Sources.Step TSetCon(
    height=-2,
    offset=TCon_nominal,
    startTime=86400/2) "Set point of condenser outlet"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Fluid.Sources.Boundary_pT sinLoa(redeclare final package Medium = Medium,
      nPorts=1) "Sink for load" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,0})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold enaHea(each t=1e-4)
    "Threshold comparison to enable heating"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Fluid.Sensors.TemperatureTwoPort senTLoaSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=QLoa_nominal/(4200*5),
    tau=0) "Load supply temperature sensor"
                                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,0})));
  Fluid.Sensors.MassFlowRate senMasFloAmb(redeclare package Medium = Medium)
    "Mass flow rate sensor for ambient loop"
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
equation
  connect(sinAmb.ports[1], heaPum.port_b2) annotation (Line(points={{50,10},{22,
          10},{22,4},{10,4}}, color={0,127,255}));
  connect(sin.y, limiter.u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(limiter.y, gain.u)
    annotation (Line(points={{-59,90},{-50,90}}, color={0,0,127}));
  connect(heaPum.m1_flow, gain.y) annotation (Line(points={{-12,-2},{-27,-2},{-27,
          90}},          color={0,0,127}));
  connect(TSetCon.y, heaPum.TSupSet) annotation (Line(points={{-99,30},{-22,30},
          {-22,1},{-12,1}}, color={0,0,127}));
  connect(souLoa.ports[1], heaPum.port_a1) annotation (Line(points={{-100,-52},{
          -20,-52},{-20,-8},{-10,-8}}, color={0,127,255}));
  connect(enaHea.y, heaPum.uEna) annotation (Line(points={{-58,50},{-18,50},{-18,
          8},{-12,8},{-12,7}}, color={255,0,255}));
  connect(limiter.y, enaHea.u) annotation (Line(points={{-59,90},{-56,90},{-56,68},
          {-92,68},{-92,50},{-82,50}}, color={0,0,127}));
  connect(sinLoa.ports[1], senTLoaSup.port_b) annotation (Line(points={{-100,
          -8.88178e-16},{-90,-8.88178e-16},{-90,0},{-80,0}}, color={0,127,255}));
  connect(senTLoaSup.port_a, heaPum.port_b1) annotation (Line(points={{-60,0},{
          -40,0},{-40,4},{-10,4}}, color={0,127,255}));
  connect(heaPum.port_a2, senMasFloAmb.port_b)
    annotation (Line(points={{10,-8},{20,-8},{20,-60}}, color={0,127,255}));
  connect(senMasFloAmb.port_a, supAmb.ports[1])
    annotation (Line(points={{40,-60},{50,-60}}, color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-100},{100,100}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Subsystems/Validation/HeatPump.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(
      revisions="<html>
<ul>
<li>
November 15, 2023, by David Blum:<br/>
Update for new heat pump subsystem model.
</li>
<li>
November 1, 2020, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump_Old\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump</a>.
</p>
</html>"));
end HeatPump;
