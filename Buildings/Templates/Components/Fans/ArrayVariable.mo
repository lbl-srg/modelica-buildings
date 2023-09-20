within Buildings.Templates.Components.Fans;
model ArrayVariable "Fan array - Variable speed"
  extends Buildings.Templates.Components.Interfaces.PartialFan(
    final typ=Buildings.Templates.Components.Types.Fan.ArrayVariable);

  Buildings.Fluid.Movers.SpeedControlled_y fan[nFan](
    redeclare each final package Medium=Medium,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final per=dat.per,
    each final energyDynamics=energyDynamics,
    each final tau=tau,
    each use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    each final allowFlowReversal=allowFlowReversal)
    "Fan array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repSig(
    final nout=nFan)
    "Replicate signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,80})));
  Buildings.Controls.OBC.CDL.Reals.Multiply sigCon
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,50})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold evaSta[nFan](
    each t=1E-2,
    each h=0.5E-2) "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-40})));
  Buildings.Fluid.Delays.DelayFirstOrder volInl(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    final nPorts=nFan+1)
    "Fluid volume at inlet"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Delays.DelayFirstOrder volOut(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    final nPorts=nFan+1)
    "Fluid volume at outet"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd evaStaArr(
    final nin=nFan)
    "Evaluate fan array status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-70})));
equation
  connect(repSig.y, fan.y)
    annotation (Line(points={{-2.22045e-15,18},{-2.22045e-15,25},{0,25},{0,12}},
                                             color={0,0,127}));
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-46,68},{-46,62}}, color={0,0,127}));
  connect(sigCon.y, repSig.u) annotation (Line(points={{-40,38},{-40,30},{-20,
          30},{-20,50},{0,50},{0,46},{2.22045e-15,46},{2.22045e-15,42}},
                                   color={0,0,127}));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,-20},
          {2.22045e-15,-20},{2.22045e-15,-28}},
                            color={0,0,127}));
  connect(volInl.ports[1:nFan], fan.port_a)
    annotation (Line(points={{-80,0},{-10,0}},         color={0,127,255}));
  connect(fan.port_b, volOut.ports[1:nFan])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(volOut.ports[nFan+1], V_flow.port_a)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(volInl.ports[nFan+1], port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(evaSta.y, evaStaArr.u) annotation (Line(points={{-2.22045e-15,-52},{-2.22045e-15,
          -55},{2.22045e-15,-55},{2.22045e-15,-58}}, color={255,0,255}));
  connect(evaStaArr.y, bus.y1_actual) annotation (Line(points={{0,-82},{0,-90},{40,
          -90},{40,96},{0,96},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y1, sigSta.u) annotation (Line(
      points={{0,100},{0,96},{-46,96},{-46,92}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y, sigCon.u1) annotation (Line(
      points={{0,100},{0,66},{-34,66},{-34,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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
</html>"));
end ArrayVariable;
