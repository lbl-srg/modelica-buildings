within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block TrimAndRespond "Trim and respond logic"
  extends Modelica.Blocks.Interfaces.DiscreteSISO;
  parameter Real uTri "Value to triggering the request for actuator";
  parameter Real yEqu0 "y setpoint when equipment starts";
  parameter Real yDec(max=0) "y decrement (must be negative)";
  parameter Real yInc(min=0) "y increment (must be positive)";

  Modelica.Blocks.Logical.GreaterEqualThreshold
                                           incY(threshold=0)
    "Outputs true if y needs to be increased"
    annotation (extent=[-20, 98; 0, 118], Placement(transformation(extent={{-20,
            50},{0,70}})));
  Modelica.Blocks.Logical.Switch swi annotation (extent=[100, 110; 120, 130],
      Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Discrete.Sampler sam(samplePeriod=samplePeriod) "Sampler"
    annotation (extent=[-60, 90; -40, 110], Placement(transformation(extent={{-60,
            50},{-40,70}})));

  Modelica.Blocks.Sources.Constant conYDec(k=yDec) "y decrease"
    annotation (extent=[26, 90; 46, 110], Placement(transformation(extent={{20,30},
            {40,50}})));
  Modelica.Blocks.Sources.Constant conYInc(k=yInc) "y increase"
    annotation (extent=[-20, 124; 0, 144], Placement(transformation(extent={{20,70},
            {40,90}})));
  Modelica.Blocks.Discrete.UnitDelay uniDel1(
    y_start=yEqu0,
    samplePeriod=samplePeriod,
    startTime=samplePeriod)
                   annotation (extent=[-52, -40; -32, -20], Placement(
        transformation(extent={{-60,-16},{-40,4}})));
  Modelica.Blocks.Math.Add add annotation (extent=[-20, -20; 0, 0], Placement(
        transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Nonlinear.Limiter lim(uMax=1, uMin=0) "State limiter"
    annotation (extent=[20, -20; 40, 0], Placement(transformation(extent={{20,-10},
            {40,10}})));
equation
  connect(lim.y, y) annotation (Line(
      points={{41,6.10623e-16},{70,6.10623e-16},{70,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add.y, lim.u) annotation (Line(
      points={{1,6.10623e-16},{9.5,6.10623e-16},{9.5,6.66134e-16},{18,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(uniDel1.y, add.u2) annotation (Line(
      points={{-39,-6},{-22,-6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(incY.y, swi.u2) annotation (Line(
      points={{1,60},{58,60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(sam.y, incY.u) annotation (Line(
      points={{-39,60},{-22,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lim.y, uniDel1.u) annotation (Line(
      points={{41,6.66134e-16},{60,6.66134e-16},{60,-40},{-80,-40},{-80,-6},{-62,
          -6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi.y, add.u1) annotation (Line(
      points={{81,60},{88,60},{88,20},{-30,20},{-30,6},{-22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi.u3, conYDec.y) annotation (Line(
      points={{58,52},{50,52},{50,40},{41,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conYInc.y, swi.u1) annotation (Line(
      points={{41,80},{50,80},{50,68},{58,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sam.u, u) annotation (Line(
      points={{-62,60},{-80,60},{-80,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="triAndRes",
    Documentation(info="<html>
<p>
   This model implements the trim and respond logic. The model samples the outputs of actuators every <code>tSam</code>.
   The control sequence is as follows:
</p>
<ul>
  <li>If <code>u &ge; 0</code>, then <code>y = y + nActInc</code>,</li>
  <li>If <code>u &lt; 0</code>, then <code>y = y - yDec</code>.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 5, 2012, by Michael Wetter:<br/>
Simplified implementation.
</li>
<li>
September 21, 2012, by Wangda Zuo:<br/>
Deleted the status input that was not needed for new control.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added comments, redefine variable names, and merged to library.
</li>
<li>
January 6 2011, by Michael Wetter and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespond;
