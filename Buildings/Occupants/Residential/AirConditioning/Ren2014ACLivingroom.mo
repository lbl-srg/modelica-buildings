within Buildings.Occupants.Residential.AirConditioning;
model Ren2014ACLivingroom
  "A model to predict occupants' AC behavior in Livingroom with indoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real u1 = 303.40 "Threshold for turning off the AC of the Weibull Distribution";
  parameter Real u2 = 300.90 "Threshold for turning on the AC of the Weibull Distribution";
  parameter Real L1 = 152.88 "Normalization factor for turning off the AC of the Weibull Distribution";
  parameter Real L2 = 15.87 "Normalization factor for turning on the AC of the Weibull Distribution";
  parameter Real k1 = 1.30 "Shape factor for turning off the AC of the Weibull Distribution";
  parameter Real k2 = 2.22 "Shape factor for turning on the AC of the Weibull Distribution";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";
  parameter Integer seed = 10 "Seed for random number generator";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit="degC") "Indoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.BooleanOutput on "State of AC"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pOn(
    unit="1",
    min=0,
    max=1) "Probability of turning on the AC";
  Real pOff(
    unit="1",
    min=0,
    max=1) "Probability of turning off the AC";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Real curSeed "Current value for seed as a real-valued variable";

initial equation
  t0 = time;
  curSeed = t0*seed;
  on = false "The initial state of AC is off";
  pOn = 0;
  pOff = 0;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    curSeed = seed*time;
    pOff = if TIn <= u1 then 1 - Modelica.Math.exp(-((u1-TIn)/L1)^k1*samplePeriod) else 0;
    pOn = if TIn >= u2 then 1 - Modelica.Math.exp(-((TIn-u2)/L2)^k2*samplePeriod) else 0;
    if occ then
      if pre(on) then
        on = not Buildings.Occupants.BaseClasses.weibull1DOFF(
          x=TIn,
          u=u1,
          L=L1,
          k=k1,
          dt=samplePeriod,
          globalSeed=integer(curSeed));
      else
        on = Buildings.Occupants.BaseClasses.weibull1DON(
          x=TIn,
          u=u2,
          L=L2,
          k=k2,
          dt=samplePeriod,
          globalSeed=integer(curSeed));
      end if;
    else
      on = false;
    end if;
  end when;

  annotation (Icon(graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            textColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="AC_Tin")}),
defaultComponentName="ac",
Documentation(info="<html>
<p>
Model predicting the state of the AC with the indoor temperature
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the AC is always off. When the
space is occupied, the lower the indoor temperature is, the lower
the chance to turn on the AC and higher the chance to turn off the AC.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Ren, X., Yan, D. and Wang, C.,
2014. Air-conditioning usage conditional probability model for residential
buildings. Building and Environment, 81, pp.172-182.&quot;
</p>
<p>
The model parameters are regressed from the field study in China in 2014.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Ren2014ACLivingroom;
