within Buildings.Experimental.OpenBuildingControl.CDL.Discrete;
block ConditionalHoldReal
  "Output the input signal with a zero order hold based on reference parameter"

  parameter Real refVal = 2 "Reference value used for hold input";

  parameter Modelica.SIunits.Time holTim(min=100*1e-15) = 10 "On-hold time length";

  output Real uSample(start=0, fixed=true);


  parameter Modelica.SIunits.Time startTime=0 "First sample time instant";

  Interfaces.RealInput u "Continuous input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Continuous output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Real pre_uSample "Value of previous sample";

protected
  output Boolean samTri "True, if sample time instant";

equation
    when (abs(u-refVal)<1E-15) then
      samTri = True;
      startTime = time;
      uSample = u;
      pre_uSample = pre(uSample);
    end when;

    when samTri then
      startTime = time;
      // if time <= startTime+holTim
      y = pre_uSample;
    end when;




protected
  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

equation
  // Declarations that are used for all discrete blocks
  sampleTrigger = sample(startTime, holTim);
  when sampleTrigger then
    firstTrigger = time <= startTime + samplePeriod/2;
  end when;

  // Declarations specific to this type of discrete block
  when {sampleTrigger, initial()} then
    ySample = u;

  end when;

  /* Define y=ySample with an infinitesimal delay to break potential
       algebraic loops if both the continuous and the discrete part have
       direct feedthrough
    */
  y = pre(ySample);
  annotation (
    defaultComponentName="zerOrdHol",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={                     Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
      Line(points={{-78.0,-42.0},{-52.0,-42.0},{-52.0,0.0},{-26.0,0.0},{-26.0,24.0},{-6.0,24.0},{-6.0,64.0},{18.0,64.0},{18.0,20.0},{38.0,20.0},{38.0,0.0},{44.0,0.0},{44.0,0.0},{62.0,0.0}},
        color={0,0,127})}),
    Documentation(info="<html>
<p>
Block that outputs the sampled input signal at sample
time instants. The output signal is held at the value of the last
sample instant during the sample points.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end ConditionalHoldReal;
