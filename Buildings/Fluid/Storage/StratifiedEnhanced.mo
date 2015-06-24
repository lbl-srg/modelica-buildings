within Buildings.Fluid.Storage;
model StratifiedEnhanced "Stratified tank model with enhanced discretization"
  extends Stratified(nSeg=4, nPorts=3, vol(each prescribedHeatFlowRate=true));

protected
  BaseClasses.ThirdOrderStratifier str(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    m_flow_small=m_flow_small) "Model to reduce numerical dissipation"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Modelica.Blocks.Sources.RealExpression mTan_flow(y=port_a.m_flow)
    "Mass flow rate at port a" annotation (Placement(transformation(extent={{-94,-42},
            {-74,-22}})));
equation
  connect(vol[1:nSeg].ports[3], str.fluidPort[2:nSeg+1])
                                                        annotation (Line(points={{16,-16},
          {16,-20},{-72,-20},{-72,-40},{-60,-40}},
                 color={0,127,255}));
  connect(H_a_flow.H_flow, str.H_flow[1]) annotation (Line(points={{-50,-69},{-50,
          -62},{-68,-62},{-68,-48},{-62,-48}},
                                          color={0,0,127}));
  connect(H_vol_flow[1:nSeg-1].H_flow, str.H_flow[2:nSeg])   annotation (Line(
        points={{-10,-29},{-10,-26},{-24,-26},{-24,-62},{-68,-62},{-68,-48},{
          -62,-48}},                                                color={0,0,
          127}));
  connect(H_b_flow.H_flow, str.H_flow[nSeg + 1]) annotation (Line(points={{60,-69},
          {60,-62},{-52,-62},{-68,-62},{-68,-48},{-62,-48}},
                                                  color={0,0,127}));
  connect(str.heatPort, vol.heatPort)    annotation (Line(points={{-40,-40},{
          -32,-40},{-32,10},{6,10},{6,-6}},      color={191,0,0}));
  connect(port_a, str.fluidPort[1]) annotation (Line(points={{-100,5.55112e-16},
          {-100,0},{-72,0},{-72,-40},{-60,-40}}, color={0,127,255}));
  connect(port_b, str.fluidPort[nSeg + 2]) annotation (Line(points={{100,
          5.55112e-16},{100,0},{80,0},{80,-88},{-72,-88},{-72,-40},{-60,-40}},
                           color={0,127,255}));
  connect(mTan_flow.y, str.m_flow) annotation (Line(points={{-73,-32},{-68.5,
          -32},{-68.5,-31.8},{-62,-31.8}}, color={0,0,127}));
  annotation (
defaultComponentName="tan",
Documentation(info="<html>
<p>
This is a model of a stratified storage tank for thermal energy storage.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">
Buildings.Fluid.Storage.UsersGuide</a>
for more information.
</p>
<h4>Limitations</h4>
<p>
The model requires at least 4 fluid segments. Hence, set <code>nSeg</code> to 4 or higher.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2012 by Wangda Zuo:<br/>
Revised the implementation to reduce the temperature overshoot.
</li>
<li>
June 23, 2010 by Michael Wetter and Wangda Zuo:<br/>
Changed model that is used to correct the numerical diffusion.
The previous version used the model from Stefan Wischhusen,
<a href=\"http://www.modelica.org/events/modelica2006/Proceedings/sessions/Session3a2.pdf\">
An Enhanced Discretization Method for Storage
Tank Models within Energy Systems</a>,
<i>Modelica Conference</i>,
Vienna, Austria, September 2006. However, for situations where there is a strong stratification,
this model can lead to a large overshoot in tank temperatures, leading to a violation of the
second law.
In this revision, the model that computes the volume outlet temperatures has been changed to a third order upwind scheme,
which is implemented in
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier\">
Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</a>.
</li>
<li>
October 23, 2008 by Michael Wetter:<br/>
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
          fillPattern=FillPattern.Solid)}));
end StratifiedEnhanced;
