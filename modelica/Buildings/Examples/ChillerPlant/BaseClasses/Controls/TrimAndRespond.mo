within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block TrimAndRespond "Trim and respond logic"
  extends Modelica.Blocks.Interfaces.DiscreteBlockIcon;
  parameter Integer n "Number of input singals";
  parameter Real uTri "Value to triggering the request for actuator";
  parameter Real yEqu0 "y setpoint when equipment starts";
  parameter Real yMax "Upper limit for y";
  parameter Real yMin "Lower limit for y";
  parameter Real yDec "y decrement (must be negative)";
  parameter Real yInc "y increment (must be positive)";
  parameter Integer nActDec
    "Number of actuators that can violate setpoints and y is still decreased";
  parameter Integer nActInc "Number of actuators requests needed to increase y";
  Modelica.Blocks.Interfaces.RealInput u[n] "Input singal" annotation (extent=[
        -190, 80; -150, 120], Placement(transformation(extent={{-190,-20},{-150,
            20}})));
  Modelica.Blocks.Logical.GreaterThreshold incY(threshold=nActInc - 0.5)
    "Outputs true if y needs to be increased"
    annotation (extent=[-20, 98; 0, 118]);
  Modelica.Blocks.Logical.Switch swi annotation (extent=[100, 110; 120, 130]);
  Modelica.Blocks.Discrete.Sampler sam(samplePeriod=tSam) "Sampler"
    annotation (extent=[-60, 90; -40, 110]);
  parameter Modelica.SIunits.Time tSam "Sample period of component";
  Modelica.Blocks.Sources.Constant conYDec(k=yDec) "y decrease"
    annotation (extent=[26, 90; 46, 110]);
  Modelica.Blocks.Math.IntegerToReal intToRea "Convert Integer to Real"
    annotation (extent=[-90, 90; -70, 110], Placement(transformation(extent={{-100,
            90},{-80,110}})));
  Modelica.Blocks.Sources.Constant conYInc(k=yInc) "y increase"
    annotation (extent=[-20, 124; 0, 144]);
  Modelica.Blocks.Discrete.UnitDelay uniDel1(
    samplePeriod=tSam,
    startTime=tSam,
    y_start=yEqu0) annotation (extent=[-52, -40; -32, -20], Placement(
        transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Add add annotation (extent=[-20, -20; 0, 0], Placement(
        transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Nonlinear.Limiter lim(uMax=yMax, uMin=yMin) "State limiter"
    annotation (extent=[20, -20; 40, 0], Placement(transformation(extent={{20,-10},
            {40,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (extent=[148, -10; 168, 10], Placement(transformation(extent={{
            150,-10},{170,10}})));
  Modelica.Blocks.Logical.LessThreshold decY(threshold=nActDec + 0.5)
    "Outputs true if y needs to be decreased"
    annotation (extent=[-20, 70; 0, 90]);
  Modelica.Blocks.Logical.Switch swi1 annotation (extent=[64, 70; 84, 90]);
  Modelica.Blocks.Sources.Constant zer1(k=0) "Set point when equipment is off"
    annotation (extent=[26, 52; 46, 72]);
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.RequestCounter req(uTri=
        uTri, nAct=n) "Count the number of request"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
equation
  connect(incY.y, swi.u2) annotation (points=[1, 108; 20, 108; 20, 120; 98, 120],
      style(color=5, rgbcolor={255,0,255}));
  connect(sam.y, incY.u) annotation (points=[-39, 100; -32, 100; -32, 108; -22,
        108], style(color=74, rgbcolor={0,0,127}));
  connect(zer1.y, swi1.u3) annotation (points=[47, 62; 56, 62; 56, 72; 62, 72],
      style(color=74, rgbcolor={0,0,127}));
  connect(swi1.y, swi.u3) annotation (points=[85, 80; 92, 80; 92, 112; 98, 112],
      style(color=74, rgbcolor={0,0,127}));
  connect(req.nInc, intToRea.u) annotation (Line(
      points={{-119,100},{-102,100}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(intToRea.y, sam.u) annotation (Line(
      points={{-79,100},{-62,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conYInc.y, swi.u1) annotation (Line(
      points={{1,134},{88,134},{88,128},{98,128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sam.y, decY.u) annotation (Line(
      points={{-39,100},{-32,100},{-32,80},{-22,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decY.y, swi1.u2) annotation (Line(
      points={{1,80},{62,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(conYDec.y, swi1.u1) annotation (Line(
      points={{47,100},{52,100},{52,88},{62,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi.y, add.u1) annotation (Line(
      points={{121,120},{132,120},{132,30},{-36,30},{-36,6},{-22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lim.y, y) annotation (Line(
      points={{41,6.10623e-16},{70,6.10623e-16},{70,5.55112e-16},{160,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add.y, lim.u) annotation (Line(
      points={{1,6.10623e-16},{9.5,6.10623e-16},{9.5,6.66134e-16},{18,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(uniDel1.y, add.u2) annotation (Line(
      points={{-39,-30},{-32,-30},{-32,-6},{-22,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uniDel1.u, lim.y) annotation (Line(
      points={{-62,-30},{-66,-30},{-66,-50},{60,-50},{60,6.10623e-16},{41,
          6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(u, req.uAct) annotation (Line(
      points={{-170,1.11022e-15},{-144,1.11022e-15},{-144,100},{-142,100}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="triAndRes",
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-150},{150,
            150}}), graphics),
    Icon(
      Rectangle(extent=[-150, 150; 150, -150], style(color=3, fillColor=52)),
      coordinateSystem(preserveAspectRatio=true, extent={{-150,-150},{150,150}}),
      Line(points=[-110, -118; -110, 112], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Polygon(points=[-110, 120; -115, 110; -105, 110; -110, 120], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Line(points=[-110, -118; 110, -118], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Polygon(points=[120, -118; 110, -123; 110, -113; 120, -118], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Line(points=[-130, -118; -110, -118; 2, 56; 62, 56], style(color=0)),
      Text(
        extent=[60, -126; 82, -138],
        string="u",
        style(color=10)),
      Text(
        extent=[-138, 126; -113, 106],
        string="y",
        style(color=10)),
      Text(
        extent=[-58, 198; 58, 156],
        style(color=3, rgbcolor={0,0,255}),
        string="%name")),
    Coordsys(extent=[-150, -150; 150, 150]),
    Documentation(info="<html>
<p>
   This model implements the trim and respond logic. The model samples the outputs of actuators every <code>tSam</code>.
   The control sequence is as follows:
   <ul>
<li>If <code>nReq &gt; nActInc</code>, then <code>y = y + nActInc</code>,</li> 
<li>If <code>nReq &lt; nActDec</code>, then <code>y = y - yDec</code>,</li>
<li>else <code>y = y</code>.</li>
</ul>
</p>
   </html>", revisions="<html>
<ul>
<li>
September 21, 2012, by Wangda Zuo:<br>
Deleted the status input that was not needed for new control.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br>
Added comments, redefine variable names, and merged to library.
</li>
<li>
January 6 2011, by Michael Wetter and Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespond;
