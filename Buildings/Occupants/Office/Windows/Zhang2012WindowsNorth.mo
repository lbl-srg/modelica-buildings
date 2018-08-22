within Buildings.Occupants.Office.Windows;
model Zhang2012WindowsNorth "A model to predict occupants' window behavior with outdoor temperature for North-oriented windows"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A = 0.12 "Slope of the logistic relation";
  parameter Real B = -4.38 "Intercept of the logistic relation";
  parameter Integer seed = 30 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TOut(
    unit="K",
    displayUnit="degC") "Outdoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "State of North-oriented window"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real p(
    unit="1",
    min=0,
    max=1) "Probability of window opened";

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
initial equation
  t0 = time;
  p = Modelica.Math.exp(A*(TOut - 273.15)+B)/(Modelica.Math.exp(A*(TOut - 273.15)+B) + 1);
  on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=seed);
equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    p = Modelica.Math.exp(A*(TOut - 273.15)+B)/(Modelica.Math.exp(A*(TOut - 273.15)+B) + 1);
    if occ then
      on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p, globalSeed=seed);
    else
      on = false;
    end if;
  end when;

  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="WindowNorth_Tout")},
defaultComponentName="win",
Documentation(info="<html>
<p>
Model predicting the state of the North-oriented window with the outdoor air temperature 
and occupancy.
</p>
<h4>Inputs</h4>
<p>
Outdoor temperature: should be input with the unit of K.
</p>
<p>
Occupancy: a boolean variable, true indicates the space is occupied, 
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of North-oriented window: a boolean variable, true indicates the window 
is open, false indicates the window is closed.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the window is always closed. When the 
space is occupied, the lower the outdoor temperature is, the lower 
the chance to open the window.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Zhang, Y. and Barrett, P., 2012. 
Factors influencing the occupants’ window opening behaviour in a naturally 
ventilated office building. Building and Environment, 50, pp.125-134.&quot;.
</p>
<p>
The model parameters are regressed from the field study in a naturally 
ventilated office building in Sheffield, UK in 2005/2006. The outdoor air
temperature range during the study is 0 ~ 30 degC.
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
end Zhang2012WindowsNorth;
