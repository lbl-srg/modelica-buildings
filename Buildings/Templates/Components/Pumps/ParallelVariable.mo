within Buildings.Templates.Components.Pumps;
model ParallelVariable "Parallel pumps (identical) - Variable speed"
  extends Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
    final typ=Buildings.Templates.Components.Types.Pump.ParallelVariable);

  replaceable Fluid.Movers.SpeedControlled_y pum[nPum](
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare each final package Medium=Medium,
      each final per=per,
      each final inputType=Buildings.Fluid.Types.InputType.Continuous,
      each addPowerToMedium=false)
    "Pumps"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.FixedResistances.CheckValve cheVal [nPum](
    redeclare each final replaceable package Medium = Medium,
    each final dpFixed_nominal=0,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final dpValve_nominal=dpValve_nominal,
    each final m_flow_nominal=m_flow_nominal)
    "Check valve"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Controls.OBC.CDL.Conversions.BooleanToReal sigSta[nPum]
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Controls.OBC.CDL.Continuous.Multiply sigCon[nPum]
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Controls.OBC.CDL.Routing.RealScalarReplicator repSig(
    final nout=nPum)
    "Replicate signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,70})));
  Controls.OBC.CDL.Continuous.GreaterThreshold evaSta[nPum](
    each t=1E-2,
    each h=0.5E-2)
    "Evaluate pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-40})));
  Fluid.Delays.DelayFirstOrder volInl(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    final nPorts=nPum+1)
    "Fluid volume at inlet"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Fluid.Delays.DelayFirstOrder volOut(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    final nPorts=nPum+1)
    "Fluid volume at outet"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));
equation
  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{10,0},{30,0}},  color={0,127,255}));
  connect(sigSta.y, sigCon.u2) annotation (Line(points={{-20,58},{-20,50},{-6,50},
          {-6,42}},      color={0,0,127}));
  connect(repSig.y, sigCon.u1) annotation (Line(points={{20,58},{20,50},{6,50},{
          6,42}},    color={0,0,127}));
  connect(pum.y_actual, evaSta.u)
    annotation (Line(points={{11,7},{20,7},{20,-20},{1.77636e-15,-20},{
          1.77636e-15,-28}},                          color={0,0,127}));
  connect(evaSta.y, bus.y1_actual) annotation (Line(points={{-2.22045e-15,-52},
          {-2.22045e-15,-60},{60,-60},{60,96},{4,96},{4,100},{0,100}},
                                  color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(volInl.ports[1:nPum], pum.port_a)
    annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
  connect(cheVal.port_b, volOut.ports[1:nPum])
    annotation (Line(points={{50,0},{80,0}}, color={0,127,255}));
  connect(volOut.ports[nPum+1], port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, volInl.ports[nPum+1])
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));


  connect(bus.y, repSig.u) annotation (Line(
      points={{0,100},{0,90},{20,90},{20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y1, sigSta[1].u) annotation (Line(
      points={{0,100},{0,90},{-20,90},{-20,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
This is a model for a parallel arrangement of identical variable
speed pumps (with dedicated VFDs). 
</p>
<ul>
<li>
Each pump is commanded on with a dedicated Boolean signal <code>y1</code> (VFD Run).
</li>
<li>
The speed of all pumps is modulated with the same fractional speed signal <code>y</code>.
<code>y = 0</code> corresponds to 0 Hz.
<code>y = 1</code> corresponds to the maximum speed set in the VFD.
</li>
<li>
Each pump returns a dedicated status signal <code>y1_actual</code> (Boolean).
<code>y1_actual = true</code> means that the pump is on.
</li>
</ul>
</html>"));
end ParallelVariable;
