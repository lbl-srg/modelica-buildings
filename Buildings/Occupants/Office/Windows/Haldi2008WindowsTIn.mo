within Buildings.Occupants.Office.Windows;
model Haldi2008WindowsTIn "A model to predict occupants' window behavior with indoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A = 0.22 "Slope of the logistic relation";
  parameter Real B = -5.64 "Intercept of the logistic relation";
  parameter Integer seed = 30 "Seed for the random number generator";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit="degC") "Indoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "State of window, true for open"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real p(
    unit="1",
    min=0,
    max=1) "Probability of window opened";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Real curSeed "Current value for seed as a real-valued variable";

initial equation
  t0 = time;
  curSeed = t0*seed;
  p = Modelica.Math.exp(A*(TIn - 273.15)+B)/(Modelica.Math.exp(A*(TIn - 273.15)+B) + 1);
  on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=integer(seed*time));
equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    curSeed = seed*time;
    if occ then
      p = Modelica.Math.exp(A*(TIn - 273.15)+B)/(Modelica.Math.exp(A*(TIn - 273.15)+B) + 1);
      on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=integer(curSeed));
    else
      p = 0;
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
            textString="WindowAll_TIn")}),
defaultComponentName="win",
Documentation(info="<html>
<p>
Model predicting the state of the window with the indoor air temperature 
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the window is always closed. When the 
space is occupied, the lower the indoor temperature is, the lower 
the chance to open the window.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Haldi, F. and Robinson, D., 2008. 
On the behaviour and adaptation of office occupants. Building and environment, 
43(12), pp.2163-2177.&quot;
</p>
<p>
The model parameters are regressed from the field study in eight Swiss office 
buildings in 2006. The indoor air temperature range during the study is 5 ~ 35 degC.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 25, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Haldi2008WindowsTIn;
