within Buildings.Templates.Components.Pumps;
model Multiple "Multiple pumps in parallel"
  extends Buildings.Templates.Components.Interfaces.PartialPumpMultiple(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple);

  replaceable Buildings.Fluid.Movers.SpeedControlled_y pum[nPum](
    redeclare each final package Medium=Medium,
    final per=dat.per,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final addPowerToMedium=addPowerToMedium,
    each final energyDynamics=energyDynamics,
    each final tau=tau,
    each final allowFlowReversal=allowFlowReversal)
    "Pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.FixedResistances.CheckValve valChe[nPum](
    redeclare each final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValChe_nominal)
    if have_valChe "Check valve"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Routing.PassThroughFluid pas[nPum](
    redeclare each final package Medium = Medium) if not have_valChe
    "Fluid pass through if no check valve"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta[nPum]
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,70})));
  Buildings.Controls.OBC.CDL.Reals.Multiply sigCon[nPum]
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaSpe(
    final nout=nPum) if have_var and have_varCom
    "Replicate signal in case of common unique commanded speed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speCst[nPum](
    final k=fill(1, nPum)) if not have_var
    "Constant signal in case of constant speed pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasSpe(
    final nin=nPum,
    final nout=nPum) if have_var and not have_varCom
    "Direct pass through for dedicated speed signals" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,70})));
  Controls.StatusEmulator sta[nPum] "Emulate pump status"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(pum.port_b,valChe. port_a)
    annotation (Line(points={{10,0},{30,0},{30,20},{40,20}}, color={0,127,255}));
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-60,58},{-60,46},{-6,46},{-6,42}},
      color={0,0,127}));
  connect(sigCon.y, pum.y)
    annotation (Line(points={{0,18},{0,15},{0,12}}, color={0,0,127}));
  connect(valChe.port_b, ports_b)
    annotation (Line(points={{60,20},{70,20},{70,0},{100,0}}, color={0,127,255}));
  connect(ports_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(bus.y1, sigSta.u) annotation (Line(
      points={{0,100},{0,88},{-60,88},{-60,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaSpe.y, sigCon.u1) annotation (Line(points={{-20,58},{-20,50},{6,50},
          {6,42}}, color={0,0,127}));
  connect(bus.y, reaSpe.u) annotation (Line(
      points={{0,100},{0,88},{-20,88},{-20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(speCst.y, sigCon.u1)
    annotation (Line(points={{60,58},{60,50},{6,50},{6,42}}, color={0,0,127}));
  connect(bus.y, pasSpe.u) annotation (Line(
      points={{0,100},{0,88},{20,88},{20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasSpe.y, sigCon.u1)
    annotation (Line(points={{20,58},{20,50},{6,50},{6,42}}, color={0,0,127}));
  connect(pum.port_b, pas.port_a) annotation (Line(points={{10,0},{30,0},{30,-20},
          {40,-20}}, color={0,127,255}));
  connect(pas.port_b, ports_b) annotation (Line(points={{60,-20},{70,-20},{70,0},
          {100,0}}, color={0,127,255}));
  connect(sta.y1_actual, bus.y1_actual) annotation (Line(points={{12,-60},{80,
          -60},{80,96},{0,96},{0,100}}, color={255,0,255}));
  connect(bus.y1, sta.y1) annotation (Line(
      points={{0,100},{0,88},{-80,88},{-80,-60},{-12,-60}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  defaultComponentName="pum",
  Documentation(info="<html>
<p>
This is a model for a parallel arrangement of <code>nPum</code> pumps
with optional check valves (depending on the value of the parameter
<code>have_valChe</code>).
</p>
<p>
Note that the inlet and outlet manifolds are not included in this model.
The manifolds may be modeled with
<a href=\"modelica://Buildings.Templates.Components.Routing.MultipleToMultiple\">
Buildings.Templates.Components.Routing.MultipleToMultiple</a>.
This allows representing both headered and dedicated arrangements.
</p>
<p>
By default, variable speed pumps are modeled.
Constant speed pumps can be modeled by setting the parameter
<code>have_var</code> to <code>false</code>.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Pump Start/Stop command (VFD Run or motor starter contact)
<code>y1</code>:
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Pump speed command (VFD Speed) <code>y</code> for variable speed pumps only:
<ul>
<li>
If <code>have_varCom</code>: AO signal common to all units,
with a dimensionality of zero
</li>
<li>
If <code>not have_varCom</code>: AO signal dedicated to each unit,
with a dimensionality of one
</li>
</ul>
</li>
<li>
Pump status (through VFD interface, VFD status contact,
or current switch) <code>y1_actual</code>:
DI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
<h4>Model parameters</h4>
<p>
The design parameters and the pump characteristics are specified with an instance of
<a href=\"modelica://Buildings.Templates.Components.Data.PumpMultiple\">
Buildings.Templates.Components.Data.PumpMultiple</a>.
The documentation of this record class provides further details on how to
properly parameterize the model.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Multiple;
