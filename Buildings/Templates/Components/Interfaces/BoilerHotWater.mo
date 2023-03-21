within Buildings.Templates.Components.Interfaces;
model BoilerHotWater "Hot water boiler"
  extends Buildings.Templates.Components.Interfaces.PartialBoilerHotWater;

  replaceable Buildings.Fluid.Boilers.BaseClasses.PartialBoiler boi(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final m_flow_small=m_flow_small)
    "Boiler"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Controls.OBC.CDL.Continuous.PIDWithReset ctl(
    Ti=60,
    final yMax=1,
    final yMin=0,
    final reverseActing=true)
    "HW supply temperature controller"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiSet
    "Switch setpoint to measured value when disabled"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiSig
    "Switch control signal to zero when disabled"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant valDis(final k=0)
    "Value when disabled"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(port_a, boi.port_a)
    annotation (Line(points={{-100,0},{-80,0},{-80,-60},{-10,-60}},
                                                color={0,127,255}));
  connect(boi.port_b, port_b)
    annotation (Line(points={{10,-60},{80,-60},{80,0},{100,0}},
                                              color={0,127,255}));
  connect(boi.T, ctl.u_m) annotation (Line(points={{11,-52},{20,-52},{20,20},{
          -40,20},{-40,28}},
                         color={0,0,127}));
  connect(swiSet.y, ctl.u_s)
    annotation (Line(points={{-58,40},{-52,40}}, color={0,0,127}));
  connect(boi.T, swiSet.u3) annotation (Line(points={{11,-52},{20,-52},{20,20},
          {-90,20},{-90,32},{-82,32}}, color={0,0,127}));
  connect(bus.THeaWatSupSet, swiSet.u1) annotation (Line(
      points={{0,100},{0,80},{-90,80},{-90,48},{-82,48}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1, swiSet.u2) annotation (Line(
      points={{0,100},{0,80},{-90,80},{-90,40},{-82,40}},
      color={255,204,51},
      thickness=0.5));
  connect(swiSet.u2, ctl.trigger) annotation (Line(points={{-82,40},{-86,40},{
          -86,24},{-46,24},{-46,28}}, color={255,0,255}));
  connect(ctl.y, swiSig.u1) annotation (Line(points={{-28,40},{-20,40},{-20,48},
          {-2,48}}, color={0,0,127}));
  connect(valDis.y, swiSig.u3) annotation (Line(points={{-28,0},{-4,0},{-4,32},
          {-2,32}}, color={0,0,127}));
  connect(swiSet.u2, swiSig.u2) annotation (Line(points={{-82,40},{-86.1538,40},
          {-86.1538,24},{-10,24},{-10,40},{-2,40}}, color={255,0,255}));
  connect(swiSig.y, bus.y_actual) annotation (Line(points={{22,40},{40,40},{40,
          96},{0,96},{0,100}},
                         color={0,0,127}));
  connect(swiSig.y, boi.y) annotation (Line(points={{22,40},{40,40},{40,-40},{
          -20,-40},{-20,-52},{-12,-52}}, color={0,0,127}));
  connect(boi.T, bus.THeaWatSup) annotation (Line(points={{11,-52},{60,-52},{60,
          98},{0,98},{0,100}}, color={0,0,127}));
  annotation (
  defaultComponentName="boi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Boiler Enable command
<code>y1</code>: DO signal
</li>
<li>
Hot water supply temperature setpoint
<code>THeaWatSupSet</code>: AO signal
</li>
<li>Hot water supply temperature
<code>THeaWatSup</code>: AI signal
</li>
<li>Boiler firing rate 
<code>y_actual</code>: AI signal
</li>
</ul>
</html>"));
end BoilerHotWater;
