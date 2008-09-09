model IdealMotor "Ideal motor model with hysteresis" 
  extends Modelica.Blocks.Interfaces.SISO;
   annotation (Documentation(info="<html>
Ideal actuator motor model with hysteresis and finite actuation speed.
If the current actuator position <tt>y</tt> is below (or above) the
input signal <tt>u</tt> by an amount bigger than the hysteresis
<tt>delta</tt>, then the position <tt>y</tt> is increased (decreased)
until it reaches <tt>u</tt>.
The output <tt>y</tt> is bounded between <tt>0</tt> and <tt>1</tt>.
</p>
<p>
<b>Note:</b> This model can introduce state events which increase the computation time.
</p>
</html>", revisions="<html>
<ul>
<li>
September 8, 2008 by Michael Wetter:<br>
Added to instance <tt>int</tt> the attribute 
<tt>y(stateSelect=StateSelect.always)</tt>. Without this attribute,
the model <a href=\"Modelica:Buildings.Fluids.Examples.TwoWayValves\">
Buildings.Fluids.Examples.TwoWayValves</a> sets <tt>y=3</tt>
which is consistent with this model.
</li>
<li>
September 8, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(
      Line(points=[-8,-86; -8,68],     style(color=8)),
      Polygon(points=[-7,85; -15,63; 1,63; -7,85],         style(color=8,
            fillColor=8)),
      Line(points=[-90,-18; 82,-18],   style(color=8)),
      Polygon(points=[84,-18; 62,-10; 62,-26; 84,-18],     style(color=8,
            fillColor=8)),
      Text(
        extent=[66,-26; 94,-48],
        style(color=9),
        string="u-y"),
      Text(
        extent=[-3,83; 50,65],
        style(color=9),
        string="v"),
      Line(points=[-80,-74; -8,-74],   style(color=0, thickness=2)),
      Line(points=[-8,22; 80,22],    style(color=0, thickness=2)),
      Line(points=[-50,-18; -50,-74],  style(color=0, thickness=2)),
      Line(points=[30,22; 30,-18],   style(color=0, thickness=2)),
      Line(points=[-32,-69; -22,-74; -32,-79],  style(color=0, thickness=2)),
      Line(points=[16,27; 6,22; 16,17],       style(color=0, thickness=2)),
      Line(points=[-55,-46; -50,-56; -44,-46],    style(color=0, thickness=2)),
      Line(points=[25,-4; 30,7; 35,-4],        style(color=0, thickness=2)),
      Text(
        extent=[19,-35; 44,-18],
        style(color=0),
        string="+delta"),
      Text(
        extent=[-63,-18; -40,-2],
        style(color=0),
        string="-delta"),
      Line(points=[-8,22; -8,-74],   style(color=0, thickness=2)),
      Line(points=[-50,-18; 30,-18], style(color=0, thickness=2)),
      Text(
        extent=[-37,12; -10,32],
        style(color=0),
        string="vOpen"),
      Text(
        extent=[-4,-86; 30,-64],
        style(color=0),
        string="vClose"),
      Line(points=[-20,-13; -30,-18; -20,-23],style(color=0, thickness=2)),
      Line(points=[6,-13; 16,-18; 6,-23],       style(color=0, thickness=2))),
    Diagram);
  
  parameter Real delta(min=0, max=0.5) = 0.05 "Hysteresis";
  parameter Modelica.SIunits.Time tOpe(min=0) = 120 "Opening time";
  parameter Modelica.SIunits.Time tClo(min=0) = tOpe "Closing time";
  parameter Real y_start(min=0, max=1) = 0.5 "Start position";
  
  Modelica.Blocks.Logical.Hysteresis uppHys(final uLow=0, uHigh=delta,
    final pre_y_start=false) 
                       annotation (extent=[-60,20; -40,40]);
  Modelica.Blocks.Logical.Hysteresis lowHys(uLow=-delta, final uHigh=0,
    final pre_y_start=true) "Lower hysteresis" 
                                         annotation (extent=[-60,-40; -40,-20]);
  Modelica.Blocks.Logical.Switch uppSwi annotation (extent=[0,20; 20,40]);
  Modelica.Blocks.Continuous.LimIntegrator int(
    final y_start=y_start,
    final k=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    outMax=1,
    outMin=0,
    y(stateSelect=StateSelect.always)) "Integrator for valve opening position" 
    annotation (extent=[60,-10; 80,10]);
  
protected 
  final Modelica.Blocks.Sources.Constant zer(final k=0) "Zero signal" 
    annotation (extent=[-40,-10; -20,10]);
  Modelica.Blocks.Sources.Constant vOpe(final k=1/tOpe) "Opening speed" 
    annotation (extent=[-40,60; -20,80]);
  Modelica.Blocks.Sources.Constant vClo(final k=-1/tClo) "Closing speed" 
    annotation (extent=[-40,-80; -20,-60]);
  Modelica.Blocks.Logical.Switch lowSwi annotation (extent=[0,-40; 20,-20]);
  Modelica.Blocks.Math.Add add annotation (extent=[32,-10; 52,10]);
  Modelica.Blocks.Math.Feedback feeBac "Feedback to compute position error" 
                                         annotation (extent=[-90,-10; -70,10]);
equation 
  connect(zer.y, uppSwi.u3) annotation (points=[-19,6.10623e-16; -14,
        6.10623e-16; -14,22; -2,22], style(color=74, rgbcolor={0,0,127}));
  connect(uppHys.y, uppSwi.u2) 
    annotation (points=[-39,30; -2,30], style(color=5, rgbcolor={255,0,255}));
  connect(vOpe.y, uppSwi.u1) annotation (points=[-19,70; -16,70; -16,38; -2,38],
      style(color=74, rgbcolor={0,0,127}));
  connect(lowHys.y, lowSwi.u2) annotation (points=[-39,-30; -2,-30], style(
        color=5, rgbcolor={255,0,255}));
  connect(vClo.y, lowSwi.u3) annotation (points=[-19,-70; -14,-70; -14,-38; -2,
        -38], style(color=74, rgbcolor={0,0,127}));
  connect(zer.y, lowSwi.u1) annotation (points=[-19,6.10623e-16; -14,
        6.10623e-16; -14,-22; -2,-22], style(color=74, rgbcolor={0,0,127}));
  connect(add.y, int.u) annotation (points=[53,6.10623e-16; 64.5,6.10623e-16; 
        64.5,6.66134e-16; 58,6.66134e-16], style(color=74, rgbcolor={0,0,127}));
  connect(uppSwi.y, add.u1) annotation (points=[21,30; 24,30; 24,6; 30,6],
      style(color=74, rgbcolor={0,0,127}));
  connect(u, feeBac.u1)   annotation (points=[-120,1.11022e-15; -104,
        1.11022e-15; -104,6.66134e-16; -88,6.66134e-16], style(color=74,
        rgbcolor={0,0,127}));
  connect(feeBac.y, uppHys.u)   annotation (points=[-71,6.10623e-16; -66,
        6.10623e-16; -66,30; -62,30], style(color=74, rgbcolor={0,0,127}));
  connect(feeBac.y, lowHys.u)   annotation (points=[-71,6.10623e-16; -66,
        6.10623e-16; -66,-30; -62,-30], style(color=74, rgbcolor={0,0,127}));
  annotation (Diagram);
  connect(lowSwi.y, add.u2) annotation (points=[21,-30; 24,-30; 24,-6; 30,-6],
      style(color=74, rgbcolor={0,0,127}));
  connect(int.y, y) annotation (points=[81,6.10623e-16; 93.5,6.10623e-16; 93.5,
        5.55112e-16; 110,5.55112e-16], style(color=74, rgbcolor={0,0,127}));
  connect(int.y, feeBac.u2) annotation (points=[81,6.10623e-16; 94,6.10623e-16; 
        94,-88; -80,-88; -80,-8], style(color=74, rgbcolor={0,0,127}));
end IdealMotor;
