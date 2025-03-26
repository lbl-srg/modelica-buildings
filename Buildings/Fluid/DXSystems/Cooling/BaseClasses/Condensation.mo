within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
block Condensation "Calculates rate of condensation"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput Q_flow(
    max=0,
    unit="W") "Heat flow"
     annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput SHR(
    min=0,
    max=1) "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  mWat_flow = (1-SHR)*Q_flow/Buildings.Utilities.Psychrometrics.Constants.h_fg;

annotation (defaultComponentName="conRat",
Documentation(info="<html>
<p>
This block computes the water mass flow rate that condenses.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature dependency.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Changed algorithm to equation section.
</li>
<li>
September 20, 2012 by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
        Icon(graphics={
          Ellipse(
          extent={{-40,16},{0,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{-20,60},{-40,0},{0,0},{-20,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{4,-66},{16,-78}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{10,-54},{4,-70},{16,-70},{10,-54}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{44,-44},{64,-66}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{54,-14},{44,-54},{64,-54},{54,-14}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end Condensation;
