within Buildings.Templates.Components.Fans;
model ArrayVariable "Fan array - Variable speed"
  extends Buildings.Templates.Components.Interfaces.PartialFan(
    final typ=Buildings.Templates.Components.Types.Fan.ArrayVariable);

  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare final package Medium=Medium,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final per=dat.per,
    final energyDynamics=energyDynamics,
    final tau=tau,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal)
    "Fan array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,50})));
  Buildings.Controls.OBC.CDL.Reals.Multiply sigCon "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,40})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold evaSta(
    t=1E-2,
    h=0.5E-2)
    "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-40})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulInl(
    redeclare final package Medium = Medium,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulOut(
    redeclare final package Medium = Medium,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Templates.Components.Controls.MultipleCommands conCom(final nUni=nFan)
    "Convert command signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pow "Compute input power"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,50})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(final nout=
        nFan) "Replicate" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,80})));
equation
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-18,50},{-14,50},{-14,54},{-6,54},{-6,52}},
                                                 color={0,0,127}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,-20},
          {2.22045e-15,-20},{2.22045e-15,-28}},
                            color={0,0,127}));
  connect(bus.y, sigCon.u1) annotation (Line(
      points={{0,100},{6,100},{6,52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(V_flow.port_a, mulOut.port_b)
    annotation (Line(points={{70,0},{60,0}}, color={0,127,255}));
  connect(port_a, mulInl.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(mulInl.port_b, fan.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(fan.port_b, mulOut.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(conCom.y1One, sigSta.u) annotation (Line(points={{-58,56},{-46,56},{
          -46,50},{-42,50}},
                         color={255,0,255}));
  connect(conCom.nUniOnBou, mulOut.u) annotation (Line(points={{-58,44},{-50,44},
          {-50,24},{32,24},{32,6},{38,6}}, color={0,0,127}));
  connect(mulInl.u, mulOut.uInv) annotation (Line(points={{-82,6},{-90,6},{-90,20},
          {70,20},{70,6},{61,6}}, color={0,0,127}));
  connect(sigCon.y, fan.y)
    annotation (Line(points={{0,28},{0,12}}, color={0,0,127}));
  connect(conCom.nUniOn, pow.u1) annotation (Line(points={{-58,50},{-50,50},{
          -50,70},{60,70},{60,56},{68,56}},
                                        color={0,0,127}));
  connect(fan.P, pow.u2)
    annotation (Line(points={{11,9},{20,9},{20,44},{68,44}}, color={0,0,127}));
  connect(rep.y, conCom.y1) annotation (Line(points={{-82,80},{-90,80},{-90,50},
          {-82,50}}, color={255,0,255}));
  connect(bus.y1, rep.u) annotation (Line(
      points={{0,100},{0,80},{-58,80}},
      color={255,204,51},
      thickness=0.5));
  connect(evaSta.y, bus.y1_actual) annotation (Line(points={{0,-52},{0,-60},{26,
          -60},{26,96},{6,96},{6,100},{0,100}}, color={255,0,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a parallel arrangement of identical variable speed fans
(or fan array).
</p>
<ul>
<li>
All fans are commanded On with the same Boolean signal <code>y1</code> (VFD Run).
</li>
<li>
The speed of all fans is modulated with the same
fractional speed signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to 0 Hz.
<code>y = 1</code> corresponds to the maximum speed set in the VFD.
</li>
<li>
A unique status signal <code>y1_actual</code> (Boolean) is returned.<br/>
<code>y1_actual = true</code> means that all fans are On.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 26, 2023, by Antoine Gautier:<br/>
Refactored with flow rate multiplier.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3536\">#3536</a>.
</li>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ArrayVariable;
