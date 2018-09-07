within Buildings.Occupants.Office.Blinds;
model Haldi2008BlindsTOut
  "A model to predict occupants' blinds behavior with outdoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A = 0.139 "Slope of outdoor temperature";
  parameter Real B = -3.54 "Intercept";
  parameter Integer seed = 20 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TOut(
    unit="K",
    displayUnit="degC") "Outdoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput blindState
    "State of blinds, 1 being blinds deployed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pdown(
    unit="1",
    min=0,
    max=1) "The probability of lowering the blinds";

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    if occ then
      pdown = 1-Modelica.Math.exp(A*(TOut-273.15)+B)/(Modelica.Math.exp(A*(TOut-273.15)+B)+1);
      if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pdown, globalSeed=integer(seed*1E6*time)) then
        blindState = 0;
      else
        blindState = 1;
      end if;
    else
      pdown = 0;
      blindState = 1;
    end if;
  end when;

  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Blinds_TOut")},
defaultComponentName="bli",
Documentation(info="<html>
<p>
Model predicting the state of the blinds with the outdoor temperature.
</p>
<h4>Inputs</h4>
<p>
TOut: outdoor air temperature, should be input with the unit of K.
</p>
<p>
occupancy: a boolean variable, true indicates the space is occupied, 
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of blinds: a real variable, 1 indicates the blind 
is 100% on, 0 indicates the blind is 100% off.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds is always on. When the 
space is occupied, the lower the TOut is, the higher 
the chance that the blind is on.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Haldi, F. and Robinson, D., 2008. 
On the behaviour and adaptation of office occupants. Building and environment, 
43(12), pp.2163-2177.&quot;.
</p>
<p>
The model parameters are regressed from the field study in eight Swiss office
buildings in 2006.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.
</li>
<li>
August 31, 2018, by Zhe Wang:<br/>
First revision.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-98,98},{94,-96}},
          lineColor={28,108,200},
          textString="ob.office
Blind")}));
end Haldi2008BlindsTOut;
