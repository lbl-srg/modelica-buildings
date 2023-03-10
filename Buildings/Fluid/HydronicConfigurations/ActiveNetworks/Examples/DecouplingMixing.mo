within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model DecouplingMixing
  "Model illustrating the operation of a decoupling circuit serving a single mixing circuit"
  extends
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.PartialDecoupling(
    ctlPum2(k=0.1, r=1e4),
    typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling,
    con(typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
    mode(table=[0,0; 6,0; 6,1; 15,1; 15,1; 22,1; 22,0; 24,0]),
    del2(nPorts=4));

  PassiveNetworks.SingleMixing con1(
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.VariableInput,
    redeclare final package Medium=MediumLiq,
    typCtl=typ,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=m2_flow_nominal,
    final dp2_nominal=dp2_nominal,
    dp1_nominal=con.dpBal3_nominal)
    "Single mixing connection"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.PIDWithOperatingMode resT2(
    k=1,
    Ti=60,
    reverseActing=false,
    y_reset=1) "PI controller for consumer circuit temperature reset"
    annotation (Placement(transformation(extent={{-104,180},{-84,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Line T2SetVar(
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature set point (reset)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,190})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValSet(k=0.9, y(
        final unit="1"))
    "Valve opening set point"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,230})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1.0,
                                                                        y(
        final unit="1"))
    "One"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,230})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0.0,
                                                                         y(
        final unit="1"))
    "Zero"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,230})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2SetLim0(k=
    TLiqEnt_nominal + 5,
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature limiting set point "
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,190})));
  Buildings.Controls.OBC.CDL.Continuous.Max yValMax(
    y(final unit="1"))
    "Maximum valve opening"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2SetLim1(
    final k=TLiqEnt_nominal,
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature design set point "
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,154})));
equation
  connect(resT2.y,T2SetVar. u)
    annotation (Line(points={{-82,190},{-62,190}},
                                                 color={0,0,127}));
  connect(yValSet.y,resT2. u_s)
    annotation (Line(points={{-118,230},{-110,230},{-110,190},{-106,190}},
                                                   color={0,0,127}));
  connect(zer1.y, T2SetVar.x1) annotation (Line(points={{-78,230},{-72,230},{-72,
          198},{-62,198}}, color={0,0,127}));
  connect(one.y,T2SetVar. x2) annotation (Line(points={{-38,230},{-34,230},{-34,
          210},{-68,210},{-68,186},{-62,186}},
                                   color={0,0,127}));
  connect(T2SetLim0.y,T2SetVar. f1) annotation (Line(points={{-118,190},{-114,190},
          {-114,206},{-76,206},{-76,194},{-62,194}},
                                                 color={0,0,127}));
  connect(yValMax.y, resT2.u_m)
    annotation (Line(points={{-2,170},{-94,170},{-94,178}}, color={0,0,127}));
  connect(T2SetVar.y, con1.set) annotation (Line(points={{-38,190},{-28,190},{-28,
          58},{-8,58},{-8,26},{-2,26}},
                        color={0,0,127}));
  connect(T2SetLim1.y, T2SetVar.f2) annotation (Line(points={{-118,154},{-68,154},
          {-68,182},{-62,182}}, color={0,0,127}));
  connect(con.port_b2, con1.port_a1)
    annotation (Line(points={{4,20},{4,20}}, color={0,127,255}));
  connect(con.port_a2, con1.port_b1)
    annotation (Line(points={{16,20},{16,20}},   color={0,127,255}));
  connect(loa.yVal_actual, yValMax.u2) annotation (Line(points={{42,108},{50,108},
          {50,164},{22,164}}, color={0,0,127}));
  connect(loa1.yVal_actual, yValMax.u1) annotation (Line(points={{102,108},{110,
          108},{110,176},{22,176}}, color={0,0,127}));
  connect(mode.y[1], con1.mode) annotation (Line(points={{-118,80},{-10,80},{-10,
          38},{-2,38}}, color={255,127,0}));
  connect(ctlPum2.y, con1.yPum) annotation (Line(points={{-28,20},{-20,20},{-20,
          34},{-2,34}}, color={0,0,127}));
  connect(mode.y[1], resT2.mode) annotation (Line(points={{-118,80},{-100,80},{-100,
          178}}, color={255,127,0}));
  connect(con1.port_b2, jun.port_1)
    annotation (Line(points={{4,40},{4,60},{10,60}}, color={0,127,255}));
  connect(con1.port_a2, del2.ports[4])
    annotation (Line(points={{16,40},{40,40}}, color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DecouplingMixing.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model represents a cooling system where the configuration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling</a>
is used in conjunction with
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>.
The combined configuration serves as the interface between a
variable flow primary circuit
and a variable flow consumer circuit.
The primary circuit has a constant supply temperature.
The consumer circuit has a varying supply temperature set point
that is reset based on the terminal valve opening, with the most
open valve being kept <i>90%</i> open.
</p>
<p>
Note the following settings.
</p>
<ul>
<li>
<code>con1.dp1_nominal=con.dpBal3_nominal</code>
which is used to size the control valve and the pump of
the mixing configuration,
and avoids a reverse flow in the bypass at partial load
due to the opposing differential pressure created by
the decoupling configuration.
See
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.SingleMixingOpenLoop\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.SingleMixingOpenLoop</a>
for further details on that behavior.
</li>
<li>
The controller <code>resT2</code> that is used to reset the secondary
supply temperature uses <code>y_reset=1</code> which
yields the design supply temperature at the time when the controller
is enabled.
Otherwise there is a significant delay in satisfying the load,
followed by a large overshoot, and the control loop is hard to tune.
</li>
</ul>
<p>
The fact that the load seems unmet at partial load (see plot #4) is due to the
load model that does not guarantee a linear variation of the load
with the input signal in cooling mode, see
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load\">
Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-160},{180,260}})));
end DecouplingMixing;
