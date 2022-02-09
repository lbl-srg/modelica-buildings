within Buildings.Occupants.Office.Blinds;
model Newsham1994BlindsSolarIntensity
    "A model to predict occupants' blinds behavior with solar intensity"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real HSet = 233 "Threshold for moving blinds up or down";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

    Modelica.Blocks.Interfaces.RealInput H(unit="W/m2") "Solar intensity at the room-side of the window"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
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

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
    output Boolean sampleTrigger "True, if sample time instant";

initial equation
    t0 = time;
    blindState = 0;

equation
    sampleTrigger = sample(t0,samplePeriod);
    when sampleTrigger then
      if occ then
        if H < HSet then
          blindState = 1;
        else
          blindState = 0;
        end if;
      else
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
              textString="Blinds_SI")}),
  defaultComponentName="bli",
  Documentation(info="<html>
<p>
Model predicting the state of the blinds with the solar intensity at the window
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds are always down. When the
space is occupied, if the solar intensity is above the threshold, the blinds are up.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Newsham, G.R., 1994. Manual control of window blinds
and electric lighting: implications for comfort and energy consumption. Indoor Environment, 3, pp.135-144.&quot;
</p>
<p>
The solar intensity threshold was first identified by a field study in
an office building in Japan, and was utilized by Newsham for a simulation
study in an office building in Toronto.
</p>
</html>",
  revisions="<html>
<ul>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.</li>
<li>
August 31, 2018, by Zhe Wang:<br/>
First Revision.
</li>
</ul>
</html>"));
end Newsham1994BlindsSolarIntensity;
