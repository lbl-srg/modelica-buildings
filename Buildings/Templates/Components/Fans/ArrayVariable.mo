within Buildings.Templates.Components.Fans;
model ArrayVariable "Fan array - Variable speed"
  extends Buildings.Templates.Components.Fans.Interfaces.PartialFan(
    final typ=Buildings.Templates.Components.Types.Fan.ArrayVariable);

  Buildings.Fluid.Movers.SpeedControlled_y fan[nFan](
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare each final package Medium=Medium,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final per=dat.per)
    "Fan"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repSig(
    final nout=nFan)
    "Replicate signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,40})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,80})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply sigCon
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,50})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta[nFan](
    each t=1E-2,
    each h=0.5E-2) "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-40})));
  Fluid.Delays.DelayFirstOrder volInl(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    final nPorts=nFan+1)
    "Fluid volume at inlet"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Fluid.Delays.DelayFirstOrder volOut(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    final nPorts=nFan+1)
    "Fluid volume at outet"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Controls.OBC.CDL.Logical.MultiAnd evaStaArr(
    final nin=nFan)
    "Evaluate fan array status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-70})));
equation
  connect(repSig.y, fan.y)
    annotation (Line(points={{-2.22045e-15,28},{-2.22045e-15,25},{0,25},{0,12}},
                                             color={0,0,127}));
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-46,68},{-46,62}}, color={0,0,127}));
  connect(sigCon.y, repSig.u) annotation (Line(points={{-40,38},{-40,30},{-20,30},
          {-20,60},{2.22045e-15,60},{2.22045e-15,52}},
                                   color={0,0,127}));
  connect(bus.y, sigCon.u1) annotation (Line(
      points={{0,100},{0,68},{-34,68},{-34,62}},
      color={255,204,51},
      thickness=0.5));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,7},{20,7},{20,-20},
          {2.22045e-15,-20},{2.22045e-15,-28}},
                            color={0,0,127}));
  connect(bus.y1, sigSta.u) annotation (Line(
      points={{0,100},{0,96},{-46,96},{-46,92}},
      color={255,204,51},
      thickness=0.5));
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
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<ul>
<li>
All fans are identical.
</li>
<li>
All fans are commanded with the same on/off signal (VFD run).
</li>
<li>
All fans are controlled to the same speed.
</li>
<li>
A single common status signal is returned
(true when all fans are on).
</li>
</ul>
</html>"));
end ArrayVariable;
