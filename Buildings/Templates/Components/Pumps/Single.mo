within Buildings.Templates.Components.Pumps;
model Single "Single pump"
  extends Buildings.Templates.Components.Interfaces.PartialPumpSingle(
    final typ=Buildings.Templates.Components.Types.Pump.Single);

  replaceable Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare final package Medium=Medium,
    final per=dat.per,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=addPowerToMedium,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Pump"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,70})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply sigCon
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(
    t=1E-2,
    h=0.5E-2)
    "Evaluate pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-50})));
  Fluid.FixedResistances.CheckValve valChe(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValChe) if have_valChe
    "Check valve"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Routing.PassThroughFluid pas(
    redeclare final package Medium=Medium) if not have_valChe
    "Fluid pass through if no check valve"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant speCst(
    final k=1) if not have_var
    "Constant signal in case of constant speed pump"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
  Modelica.Blocks.Routing.RealPassThrough pasSpe if have_var
    "Direct pass through for variable speed signal"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,70})));
equation
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-60,58},{-60,50},{-6,50},{-6,42}},
      color={0,0,127}));
  connect(sigCon.y, pum.y)
    annotation (Line(points={{0,18},{0,15},{0,12}}, color={0,0,127}));
  connect(pum.y_actual, evaSta.u)
    annotation (Line(points={{11,7},{20,7},{20,-38}}, color={0,0,127}));
  connect(evaSta.y, bus.y1_actual)
    annotation (Line(points={{20,-62},{20,-80},{80,-80},{80,88},{0,88},{0,100}},
                color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(bus.y, pasSpe.u) annotation (Line(
      points={{0,100},{2.22045e-15,100},{2.22045e-15,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasSpe.y, sigCon.u1)
    annotation (Line(points={{0,59},{0,50},{6,50},{6,42}}, color={0,0,127}));
  connect(speCst.y, sigCon.u1)
    annotation (Line(points={{60,58},{60,50},{6,50},{6,42}}, color={0,0,127}));
  connect(bus.y1, sigSta.u) annotation (Line(
      points={{0,100},{0,88},{-60,88},{-60,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pum.port_b, valChe.port_a) annotation (Line(points={{10,0},{28,0},{28,
          20},{40,20}}, color={0,127,255}));
  connect(valChe.port_b, port_b) annotation (Line(points={{60,20},{70,20},{70,0},
          {100,0}}, color={0,127,255}));
  connect(pum.port_b, pas.port_a) annotation (Line(points={{10,0},{28,0},{28,-20},
          {40,-20}}, color={0,127,255}));
  connect(pas.port_b, port_b) annotation (Line(points={{60,-20},{70,-20},{70,0},
          {100,0}}, color={0,127,255}));
  annotation (
  defaultComponentName="pum",
  Documentation(info="<html>
  TODO: update doc.
<p>
This is a model for a single pump.
</p>
<ul>
<li>
The pump is commanded On with a dedicated Boolean signal <code>y1</code>
(VFD Run or starter contact).
</li>
<li>
For a variable speed pump, the speed is modulated with the fractional speed signal
<code>y</code> (real).<br/>
<code>y = 0</code> corresponds to 0 Hz.
<code>y = 1</code> corresponds to the maximum speed set in the VFD.
</li>
<li>
The pump returns a status signal <code>y1_actual</code> (Boolean).<br/>
<code>y1_actual = true</code> means that the pump is proven On.
</li>
</ul>
</html>"));
end Single;
