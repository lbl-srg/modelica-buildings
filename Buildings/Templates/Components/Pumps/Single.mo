within Buildings.Templates.Components.Pumps;
model Single "Single pump"
  extends Buildings.Templates.Components.Pumps.Interfaces.PartialSingle(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple);

  replaceable Buildings.Fluid.Movers.SpeedControlled_y pum(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare final package Medium=Medium,
      final per=dat.per,
      final inputType=Buildings.Fluid.Types.InputType.Continuous,
      addPowerToMedium=false)
    "Pumps"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,70})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply sigCon
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(each t=1E-2, each h=
        0.5E-2) "Evaluate pump status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-50})));
  Fluid.FixedResistances.CheckValve cheVal[nPum](
    redeclare each final replaceable package Medium = Medium,
    each final dpFixed_nominal=0,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=dat.dpValve_nominal,
    final m_flow_nominal=dat.m_flow_nominal)
    "Check valve"
    annotation (Placement(transformation(extent={{46,-28},{66,-8}})));
equation

  // Single port_a

  // Multiple port_a

  // Single port_b

  // Multiple port_b

  // Controls

  connect(bus.y, sigCon.u1)
    annotation (Line(
      points={{0,100},{0,88},{20,88},{20,50},{6,50},{6,42}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(bus.y1, sigSta.u)
    annotation (Line(
      points={{0,100},{0,88},{-20,88},{-20,82}},
      color={255,204,51},
      thickness=0.5));
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-20,58},{-20,50},{-6,50},{-6,42}},
      color={0,0,127}));

  connect(sigCon.y, pum.y)
    annotation (Line(points={{0,18},{0,15},{0,12}}, color={0,0,127}));

  connect(pum.y_actual, evaSta.u)
    annotation (Line(points={{11,7},{20,7},{20,-38}}, color={0,0,127}));
  connect(evaSta.y, bus.y1_actual)
    annotation (Line(points={{20,-62},{20,-80},{60,-80},{60,88},{0,88},
      {0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This is a model for a parallel arrangement of identical variable
speed pumps (with dedicated VFDs).
</p>
<ul>
<li>
Each pump is commanded On with a dedicated Boolean signal <code>y1</code> (VFD Run).
</li>
<li>
The speed of all pumps is modulated with the same
fractional speed signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to 0 Hz.
<code>y = 1</code> corresponds to the maximum speed set in the VFD.
</li>
<li>
Each pump returns a dedicated status signal <code>y1_actual</code> (Boolean).<br/>
<code>y1_actual = true</code> means that the pump is on.
</li>
</ul>
</html>"));
end Single;
