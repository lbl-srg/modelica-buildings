within Buildings.Occupants.Office.Blinds;
model Newsham1994BlindsSI
  "A model to predict occupants' blinds behavior with Solar Intensity"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real SI_threshold = 233 "Threshold for turning on/off the blinds";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput SI(
    unit="W/m2") "Solar Intensity" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput BlindState
    "The State of Blinds, 1 for 100% on, 0 for 100% off"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    if occ then
      if SI < SI_threshold then
        BlindState = 1;
      else
        BlindState = 0;
      end if;
    else
      BlindState = 1;
    end if;
  end when;

  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Blinds_SI")},
defaultComponentName="bli",
Documentation(info="<html>
<p>
Model predicting the state of the blinds with the solar intensity at the window 
and occupancy.
</p>
<h4>Inputs</h4>
<p>
SI: solar intensity at the window, should be input with the unit of W/m2.
</p>
<p>
Occupancy: a boolean variable, true indicates the space is occupied, 
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of blinds: a real variable, 1 indicates the blind 
is 100% on, 0 indicates the blind is 100% off.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds is always on. When the 
space is occupied, if the Solar intensity is above the threshold, the blinds would be turned off.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Newsham, G.R., 1994. Manual control of window blinds 
and electric lighting: implications for comfort and energy consumption. Indoor Environment, 3, pp.135-144.&quot;.
</p>
<p>
The Solar Intensity threshold was first identified by a field study in 
an office building in Japan, and was utilized by Newsham for a simulation
study in an office building in Toronto.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Newsham1994BlindsSI;
