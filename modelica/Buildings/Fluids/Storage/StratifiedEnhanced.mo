model StratifiedEnhanced "Stratified tank model with enhanced discretization" 
  extends Stratified(nP=3);
  BaseClasses.Stratifier str(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    a=a) "Model to reduce numerical dissipation" 
    annotation (extent=[-60,-80; -40,-60]);
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
 Icon(Rectangle(extent=[-40,20; 40,-20], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127})), Rectangle(extent=[-10,10; 10,-10], style(
          color=74,
          rgbcolor={0,0,127},
          gradient=3,
          fillColor=7,
          rgbfillColor={255,255,255})), 
      Rectangle(extent=[-40,68; -50,-66], style(
          pattern=0, 
          fillColor=6, 
          rgbfillColor={255,255,0})), 
      Rectangle(extent=[50,68; 40,-66], style(
          pattern=0, 
          fillColor=6, 
          rgbfillColor={255,255,0}))));
  Modelica.Blocks.Sources.RealExpression mTan_flow(y=port_a.m_flow) 
    "Mass flow rate at port a" annotation (extent=[-96,-72; -76,-52]);
equation 
  connect(vol[1:nSeg].port[3], str.fluidPort[2:nSeg+1]) annotation (points=[-16,
        5.55112e-16; 0,0; -16,0; -16,-20; -72,-20; -72,-70; -60,-70],
             style(color=69, rgbcolor={0,127,255}));
  connect(hA.H_flow, str.H_flow[1]) annotation (points=[-50,-11; -50,-20; -68,
        -20; -68,-78; -62,-78],
                             style(color=74, rgbcolor={0,0,127}));
  connect(hVol_flow[1:nSeg-1].H_flow, str.H_flow[2:nSeg])   annotation (points=[-12,-51;
        -12,-84; -68,-84; -68,-78; -62,-78],                      style(color=
          74, rgbcolor={0,0,127}));
  connect(hB.H_flow, str.H_flow[nSeg + 1]) annotation (points=[56,-43; 56,-84;
        -68,-84; -68,-78; -62,-78],
                               style(color=74, rgbcolor={0,0,127}));
  connect(str.heatPort, vol.thermalPort) annotation (points=[-40,-70; -32,-70;
        -32,10; -16,10; -16,9.8],             style(color=42, rgbcolor={191,0,0}));
  connect(port_a, str.fluidPort[1]) annotation (points=[-100,5.55112e-16; -100,
        0; -72,0; -72,-70; -60,-70],
                    style(color=69, rgbcolor={0,127,255}));
  connect(port_b, str.fluidPort[nSeg + 2]) annotation (points=[100,5.55112e-16; 
        92,5.55112e-16; 92,0; 80,0; 80,-88; -72,-88; -72,-70; -60,-70],
                                                                 style(color=69,
        rgbcolor={0,127,255}));
  connect(mTan_flow.y, str.m_flow) annotation (points=[-75,-62; -68.5,-62;
        -68.5,-61.8; -62,-61.8],
                        style(color=74, rgbcolor={0,0,127}));
end StratifiedEnhanced;
