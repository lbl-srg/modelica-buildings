within Buildings.Templates.Components.Chillers;
model Compression "Compression chiller"
  extends Buildings.Templates.Components.Interfaces.PartialChiller;
  Buildings.Fluid.Chillers.ElectricReformulatedEIR chi(
    redeclare final package Medium1 = MediumCon,
    redeclare final package Medium2 = MediumChiWat,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mChiWat_flow_nominal,
    final dp1_nominal=if have_dpCon then dpCon_nominal else 0,
    final dp2_nominal=if have_dpChiWat then dpChiWat_nominal else 0,
    final have_switchover=have_switchover,
    final per=dat.perSca,
    final tau1=tau,
    final tau2=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final show_T=show_T,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));
  Controls.StatusEmulator y1_actual "Compute chiller status" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,0})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal reqConWat(
    final nin=1,
    final nout=1,
    final extract={1})
    if typ==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Compute CW request" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,80})));
  Buildings.Controls.OBC.CDL.Logical.Not off "Return true if status is off"
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delOff(delayTime=180)
    "Delay off status"
    annotation (Placement(transformation(extent={{-10,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not reqFlo "Compute flow request"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-40,50})));
equation
  connect(port_a1, chi.port_a1) annotation (Line(points={{-100,60},{-80,60},{
          -80,-48},{-10,-48}},
                       color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{10,-48},{80,-48},{80,
          60},{100,60}},
                    color={0,127,255}));
  connect(port_b2, chi.port_b2) annotation (Line(points={{-100,-60},{-10,-60}},
                           color={0,127,255}));
  connect(chi.port_a2, port_a2) annotation (Line(points={{10,-60},{100,-60}},
                      color={0,127,255}));
  connect(bus.y1, chi.on) annotation (Line(
      points={{0,100},{0,-20},{-20,-20},{-20,-51},{-12,-51}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TSupSet, chi.TSet) annotation (Line(
      points={{0,100},{0,-20},{-20,-20},{-20,-57},{-12,-57}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1Coo, chi.coo) annotation (Line(
      points={{0,100},{0,-20},{-8,-20},{-8,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1, y1_actual.y1) annotation (Line(
      points={{0,100},{0,-20},{60,-20},{60,-12}},
      color={255,204,51},
      thickness=0.5));
  connect(y1_actual.y1_actual, bus.y1_actual) annotation (Line(points={{60,12},
          {60,94},{0,94},{0,100}},        color={255,0,255}));
  connect(reqConWat.y[1], bus.reqConWat) annotation (Line(points={{-60,92},{-60,
          96},{0,96},{0,100}},
                           color={255,0,255}));
  connect(y1_actual.y1_actual, off.u)
    annotation (Line(points={{60,12},{60,20},{42,20}}, color={255,0,255}));
  connect(off.y, delOff.u)
    annotation (Line(points={{18,20},{-8,20}}, color={255,0,255}));
  connect(delOff.y, reqFlo.u)
    annotation (Line(points={{-32,20},{-40,20},{-40,38}}, color={255,0,255}));
  connect(reqFlo.y, bus.reqChiWat) annotation (Line(points={{-40,62},{-40,94},{
          0,94},{0,100}}, color={255,0,255}));
  connect(reqFlo.y, reqConWat.u[1]) annotation (Line(points={{-40,62},{-40,64},
          {-60,64},{-60,68}}, color={255,0,255}));
  annotation(defaultComponentName="chi",
  Documentation(info="<html>
<p>
Model of an electric compression chiller based on the reformulated DOE-2.1 model
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
On/off command <code>y1</code>: 
DO signal
</li>
<li>
(Only if <code>have_switchover=true</code>) Operating mode command <code>y1Coo</code>: 
DO signal, true for cooling, false for heating
</li>
<li>
Supply temperature setpoint <code>TSupSet</code>:
AO signal corresponding to the
<ul>
<li>CHW supply temperature setpoint if
<code>have_switchover=false</code> or if 
<code>have_switchover=true</code> and <code>y1Coo=true</code>, or
<li>HW supply temperature setpoint if
<code>have_switchover=true</code> and <code>y1Coo=false</code>.
</li>
</ul>
<li>
Chiller status <code>y1_actual</code>: DI signal
</li>
<li>
CHW request <code>reqChiWat</code>: DI signal
</li>
<li>
(Only if <code>typ=Buildings.Templates.Components.Types.Chiller.WaterCooled</code>) 
CW request <code>reqConWat</code>: DI signal
</li>
</ul>
<h4>Model parameters</h4>
<p>
The design parameters and the chiller performance data are specified with an instance of
<a href=\"modelica://Buildings.Templates.Components.Data.Chiller\">
Buildings.Templates.Components.Data.Chiller</a>.
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
end Compression;
