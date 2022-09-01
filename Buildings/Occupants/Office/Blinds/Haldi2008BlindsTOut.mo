within Buildings.Occupants.Office.Blinds;
model Haldi2008BlindsTOut
  "A model to predict occupants' blinds behavior with outdoor temperature"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A(final unit="1/K") = 0.139 "Slope of outdoor temperature";
  parameter Real B(final unit="1") = -3.54 "Intercept";
  parameter Integer seed = 20 "Seed for the random number generator";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC") "Outdoor air temperature" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput blindState(
    final min=0,
    final max=1,
    final unit="1")
    "State of blinds, 1 being blinds down"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pDown(
    final unit="1",
    final min=0,
    final max=1) "The probability of lowering the blinds";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
  Real curSeed "Current value for seed as a real-valued variable";

initial equation
  t0 = time;
  blindState = 0;
  pDown = 0;
  curSeed = t0*seed;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    curSeed = time*seed;
    if occ then
      pDown = 1-Modelica.Math.exp(A*(TOut-273.15)+B)/(Modelica.Math.exp(A*(TOut-273.15)+B)+1);
      if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pDown, globalSeed=integer(curSeed)) then
        blindState = 0;
      else
        blindState = 1;
      end if;
    else
      pDown = 0;
      blindState = 1;
    end if;
  end when;

  annotation (Icon(graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            textColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Blinds_TOut")}),
defaultComponentName="bli",
Documentation(info="<html>
<p>
Model predicting the state of the blinds with the outdoor temperature.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds are always down. When the
space is occupied, the lower <code>TOut</code>, the higher
the chance that the blind is up.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Haldi, F. and Robinson, D., 2008.
On the behaviour and adaptation of office occupants. Building and environment,
43(12), pp.2163-2177.&quot;
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
</html>"));
end Haldi2008BlindsTOut;
