within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayConstant
  "Model illustrating the operation of an inversion circuit with two-way valve and constant secondary"
  extends
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.PartialInjectionTwoWay(
    del2(nPorts=3),
    dat(dp2_nominal=dpPip_nominal + loa1.dat.dp2_nominal + loa1.dat.dpValve_nominal));

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl
    loa(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal) "Load"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl
    loa1(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal) "Load"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mTer_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable setOff(table=[0,0; 12,
        0; 13,-5; 14,-7; 16,-2; 24,0], timeScale=3600)
    "Offset applied to design supply temperature to compute set point"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter set(
    final p=TLiqEnt_nominal,
    y(final unit="K", displayUnit="degC"))
    "Compute supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
equation
  connect(setOff.y[1], set.u)
    annotation (Line(points={{-98,80},{-72,80}}, color={0,0,127}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-98,120},{20,120},{20,106},
          {38,106}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-98,120},{80,120},{80,106},
          {98,106}}, color={0,0,127}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{24,20},{24,80},{40,
          80},{40,100}},
                     color={0,127,255}));
  connect(del2.ports[2], loa1.port_b)
    annotation (Line(points={{60,20},{120,20},{120,100}},
                                                        color={0,127,255}));
  connect(loa.port_b, del2.ports[3])
    annotation (Line(points={{60,100},{60,20},{60,20}},
                                                      color={0,127,255}));
  connect(set.y, con.set)
    annotation (Line(points={{-48,80},{0,80},{0,6},{18,6}}, color={0,0,127}));
  connect(con.port_b2, res2.port_a)
    annotation (Line(points={{24,20},{24,60},{70,60}}, color={0,127,255}));
  connect(res2.port_b, loa1.port_a)
    annotation (Line(points={{90,60},{100,60},{100,100}}, color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayConstant.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a two-way valve
that serves as the interface between a variable flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units circuits are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
</ul>

</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end InjectionTwoWayConstant;
