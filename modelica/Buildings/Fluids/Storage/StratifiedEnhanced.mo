within Buildings.Fluids.Storage;
model StratifiedEnhanced "Stratified tank model with enhanced discretization"
  extends Stratified(nPorts=3);
  BaseClasses.Stratifier str(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    a=a) "Model to reduce numerical dissipation" 
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}}, rotation=
           0)));
  parameter Real a=1E-4
    "Tuning factor. a=0 is equivalent to not using this model";
  annotation (Documentation(info="<html>
<p>
This is a model of a stratified storage tank for thermal energy storage.
The model is identical to
<a href=\"Modelica:Buildings.Fluids.Storage.Stratified\">
Buildings.Fluids.Storage.Stratified</a>, 
except that it adds a correction that reduces the numerical
dissipation.
The correction is identical to the one described
by Wischhusen (2006).
</p>
<h4>References</h4>
<p>
Wischhusen Stefan, 
<a href=\"http://www.modelica.org/events/modelica2006/Proceedings/sessions/Session3a2.pdf\">An Enhanced Discretization Method for Storage
Tank Models within Energy Systems</a>, 
<i>Modelica Conference</i>,
Vienna, Austria, September 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
 Icon(graphics={
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-40,68},{-50,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
  Modelica.Blocks.Sources.RealExpression mTan_flow(y=port_a.m_flow)
    "Mass flow rate at port a" annotation (Placement(transformation(extent={{
            -96,-72},{-76,-52}}, rotation=0)));
equation
  connect(vol[1:nSeg].ports[3], str.fluidPort[2:nSeg+1]) 
                                                        annotation (Line(points={{-16,-10},
          {0,0},{-16,0},{-16,-20},{-72,-20},{-72,-70},{-60,-70}},
                 color={0,127,255}));
  connect(hA.H_flow, str.H_flow[1]) annotation (Line(points={{-62,-9},{-62,-4},
          {-68,-4},{-68,-78},{-62,-78}},  color={0,0,127}));
  connect(hVol_flow[1:nSeg-1].H_flow, str.H_flow[2:nSeg])   annotation (Line(
        points={{-12,-29},{-12,-26},{-24,-26},{-24,-84},{-68,-84},{-68,-78},{
          -62,-78}},                                                color={0,0,
          127}));
  connect(hB.H_flow, str.H_flow[nSeg + 1]) annotation (Line(points={{56,-21},{
          56,-14},{40,-14},{40,-84},{-68,-84},{-68,-78},{-62,-78}},
                                                  color={0,0,127}));
  connect(str.heatPort, vol.heatPort)    annotation (Line(points={{-40,-70},{
          -32,-70},{-32,10},{-26,10},{-26,0}},   color={191,0,0}));
  connect(port_a, str.fluidPort[1]) annotation (Line(points={{-100,0},{-100,0},
          {-72,0},{-72,-70},{-60,-70}},          color={0,127,255}));
  connect(port_b, str.fluidPort[nSeg + 2]) annotation (Line(points={{100,0},{92,
          0},{80,0},{80,-88},{-72,-88},{-72,-70},{-60,-70}},
                           color={0,127,255}));
  connect(mTan_flow.y, str.m_flow) annotation (Line(points={{-75,-62},{-68.5,
          -62},{-68.5,-61.8},{-62,-61.8}}, color={0,0,127}));
end StratifiedEnhanced;
