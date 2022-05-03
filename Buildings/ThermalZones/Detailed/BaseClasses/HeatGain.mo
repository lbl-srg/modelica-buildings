within Buildings.ThermalZones.Detailed.BaseClasses;
model HeatGain "Model to convert internal heat gain signals"
  extends Buildings.BaseClasses.BaseIcon;

  parameter Modelica.Units.SI.Area AFlo "Floor area";

  Modelica.Blocks.Interfaces.RealInput qGai_flow[3]
    "Radiant, convective sensible and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput QRad_flow(unit="W")
    "Radiant heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(unit="W")
    "Convective sensible heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(unit="W")
    "Latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
equation
  {QRad_flow, QCon_flow, QLat_flow} = AFlo .* qGai_flow;

 annotation(Documentation(info="<html>
<p>
This model computes the radiant, convective sensible and latent heat flow rate.
Input into this model are these three components in units of [W/m2].
The inputs need to be positive quantities if heat or moisture is added
to the room.
The outputs are
</p>
<ul>
<li>
the radiant heat flow in Watts,
</li>
<li>
the convective heat flow in Watts, and
</li>
<li>
the water vapor released into the air.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
October 25, 2021, by Michael Wetter:<br/>
Updated documentation to improve clarity.
</li>
<li>
May 2, 2016, by Michael Wetter:<br/>
Refactored implementation of latent heat gain.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">issue 515</a>.
</li>
<li>
August 1, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Line(
          points={{-48,-66},{-24,-18},{0,-68}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-24,-18},{-24,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-52,24},{-24,38}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-24,38},{8,22}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-40,76},{-8,46}},  lineColor={0,0,255}),
        Text(
          extent={{-98,30},{-38,-26}},
          textColor={0,0,127},
          textString="q_flow"),
        Text(
          extent={{20,74},{94,52}},
          textColor={0,0,127},
          textString="QRad_flow"),
        Text(
          extent={{18,14},{92,-8}},
          textColor={0,0,127},
          textString="QCon_flow"),
        Text(
          extent={{20,-44},{94,-66}},
          textColor={0,0,127},
          textString="QLat_flow")}),
        Documentation(info = "<html>
This is a dummy model that is required to implement the room
model with a variable number of surface models.
The model is required since arrays of models, such as used for the surfaces
that model the construction outside of the room,
must have at least one element, unless the whole array
is conditionally removed if its size is zero.
However, conditionally removing the surface models does not work in this
situation since some models, such as for computing the radiative heat exchange
between the surfaces, require access to the area and absorptivity of the surface models.

</html>",
        revisions="<html>
<ul>
<li>
February 22, by Michael Wetter:<br/>
Improved the code that searches for the index of 'water' in the medium model.
</li>
<li>
June 8 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatGain;
