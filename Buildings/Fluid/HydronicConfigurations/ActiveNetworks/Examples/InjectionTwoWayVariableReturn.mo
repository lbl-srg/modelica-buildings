within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayVariableReturn
  "Model illustrating the operation of an inversion circuit with two-way valve and variable secondary with return temperature control"
  extends InjectionTwoWayVariable(T2Set(p=TLiqLvg_nominal), con(typCtl=
          Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.ReturnTemperature));

  BaseClasses.LoadTwoWayValveControl loaOpe(
    mAir_flow_nominal=mAir_flow_nominal,
    redeclare final package MediumLiq = MediumLiq,
    k=1,
    Ti=1,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final phiAirEnt_nominal=phiAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal) "Load with open loop control"
    annotation (Placement(transformation(extent={{230,-100},{250,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupVal1(
    height=6,
    duration=16*3600,
    offset=TLiqEnt_nominal,
    startTime=6*3600,
    y(final unit="K", displayUnit="degC")) "Supply temperature"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Sources.Boundary_pT refOpe(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 10*(loa1.dpTer_nominal + loa1.dpValve_nominal),
    use_T_in=true,
    nPorts=1) "Pressure and temperature boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={180,-90})));
  Sources.Boundary_pT refOpe1(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1) "Pressure and temperature boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={300,-90})));
  Sensors.TemperatureTwoPort TSupOpe(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqEnt_nominal) "Supply temperature sensor" annotation (
      Placement(transformation(extent={{202,-100},{222,-80}},
                                                            rotation=0)));
  Sensors.TemperatureTwoPort TRetOpe(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqLvg_nominal) "Return temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={270,-90})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant  fraLoa1(k=0.7)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
equation
  connect(TSupOpe.port_b, loaOpe.port_a)
    annotation (Line(points={{222,-90},{230,-90}},
                                               color={0,127,255}));
  connect(loaOpe.port_b, TRetOpe.port_a)
    annotation (Line(points={{250,-90},{260,-90}},
                                               color={0,127,255}));
  connect(TSupVal1.y, refOpe.T_in)
    annotation (Line(points={{162,-90},{168,-90},{168,-94}},
                                                        color={0,0,127}));
  connect(fraLoa1.y, loaOpe.u) annotation (Line(points={{162,-50},{222,-50},{
          222,-84},{228,-84}},
                    color={0,0,127}));
  connect(refOpe.ports[1], TSupOpe.port_a)
    annotation (Line(points={{190,-90},{202,-90}},
                                               color={0,127,255}));
  connect(TRetOpe.port_b, refOpe1.ports[1])
    annotation (Line(points={{280,-90},{290,-90}},
                                               color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayVariableReturn.mos"
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
    Diagram(coordinateSystem(extent={{-160,-160},{340,160}}), graphics={
          Rectangle(
          extent={{120,0},{320,-120}},
          lineColor={28,108,200},
          fillColor={208,208,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{120,0},{320,-20}},
          textColor={28,108,200},
          textString="Open loop simulation of consumer circuit")}));
end InjectionTwoWayVariableReturn;
