within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayVariableReturn
  "Model illustrating the operation of an inversion circuit with two-way valve and variable secondary with return temperature control"
  extends InjectionTwoWayVariable(
    con(typVar=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.ReturnTemperature));

  BaseClasses.LoadTwoWayValveControl loaOpe(
    typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling,
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
    annotation (Placement(transformation(extent={{210,-120},{230,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupVal1(
    height=6,
    duration=16*3600,
    offset=TLiqEnt_nominal,
    startTime=6*3600,
    y(final unit="K", displayUnit="degC")) "Supply temperature"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Sources.Boundary_pT refOpe(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 10*(loa1.dpTer_nominal + loa1.dpValve_nominal),
    use_T_in=true,
    nPorts=1) "Pressure and temperature boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={160,-110})));
  Sources.Boundary_pT refOpe1(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1) "Pressure and temperature boundary condition" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={280,-110})));
  Sensors.TemperatureTwoPort TSupOpe(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqEnt_nominal) "Supply temperature sensor" annotation (
      Placement(transformation(extent={{182,-120},{202,-100}}, rotation=0)));
  Sensors.TemperatureTwoPort TRetOpe(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqLvg_nominal) "Return temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={250,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant  fraLoa1(k=0.7)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modOpe(
    k=1)
    "Operating mode"
    annotation (Placement(transformation(extent={{150,-90},{170,-70}})));
equation
  connect(TSupOpe.port_b, loaOpe.port_a)
    annotation (Line(points={{202,-110},{210,-110}},
                                               color={0,127,255}));
  connect(loaOpe.port_b, TRetOpe.port_a)
    annotation (Line(points={{230,-110},{240,-110}},
                                               color={0,127,255}));
  connect(TSupVal1.y, refOpe.T_in)
    annotation (Line(points={{142,-110},{148,-110},{148,-114}},
                                                        color={0,0,127}));
  connect(fraLoa1.y, loaOpe.u) annotation (Line(points={{142,-60},{202,-60},{
          202,-102},{208,-102}},
                    color={0,0,127}));
  connect(refOpe.ports[1], TSupOpe.port_a)
    annotation (Line(points={{170,-110},{182,-110}},
                                               color={0,127,255}));
  connect(TRetOpe.port_b, refOpe1.ports[1])
    annotation (Line(points={{260,-110},{270,-110}},
                                               color={0,127,255}));
  connect(modOpe.y, loaOpe.mode) annotation (Line(points={{172,-80},{200,-80},{
          200,-106},{208,-106}}, color={255,127,0}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayVariableReturn.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates a configuration that is not recommended,
that is an injection circuit with a two-way valve serving
a variable flow consumer circuit, and controlled based on the
return temperature.
When comparing this model to
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayConstantReturn\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayConstantReturn</a>
one can notice that the design load is not met (see plot #4
between 6h and 8h) despite the return temperature set point
being met (see plot #1) and the consumer circuit being operated
at design flow rate (see plot #2).
This is because, for the specific sizing of the cooling coil and
for certain operating conditions the \"process characteristic\" is not
monotonously decreasing as expected.
This is illustrated by the simulation of the load model with open loop
control (see plot #9).
That simulation shows that for a constant load, an increasing supply
temperature yields a decreasing return temperature.
However, the control logic is based on the consideration that a
decreasing return temperature is the signature of a decreasing load.
It thus triggers the closing of the control valve, which in turn
yields an increasing secondary flow recirculation, so an increasing
supply temperature that further decreases the return temperature.
The result is that the equilibrium point differs from the control intent,
here with a supply temperature much higher than the design value
(<i>6.6</i>&nbsp;&deg;C instead of <i>4.4</i>&nbsp;&deg;C).
</p>

</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{320,200}}), graphics={
          Rectangle(
          extent={{100,-20},{300,-140}},
          lineColor={28,108,200},
          fillColor={208,208,208},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{100,-20},{300,-40}},
          textColor={28,108,200},
          textString="Open loop simulation of consumer circuit")}));
end InjectionTwoWayVariableReturn;
