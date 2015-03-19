within Buildings.Rooms.BaseClasses;
model MixedAirHeatGain "Model to convert internal heat gain signals"
  extends Buildings.BaseClasses.BaseIcon;

  replaceable package Medium =
     Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.Area AFlo "Floor area";
  parameter Modelica.SIunits.Temperature TWat=273.15+34
    "Temperature at which water vapor is released";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a QCon_flow
    "Convective heat gain"    annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));

public
  Modelica.Blocks.Interfaces.RealInput qGai_flow[3]
    "Radiant, convective and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput QRad_flow "Radiative heat gain"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b QLat_flow(redeclare final package
      Medium =
        Medium) "Latent heat gain"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
protected
  Modelica.SIunits.MassFlowRate mWat_flow
    "Water vapor flow rate released by latent gain";

  parameter Modelica.SIunits.SpecificEnergy h_fg = Medium.enthalpyOfCondensingGas(TWat)
    "Latent heat of water vapor";
 // constant Medium.MassFraction Xi[Medium.nXi] = {1}
 //   "Species concentration (water vapor only)";

protected
  parameter Real s[Medium.nX](each fixed=false)
    "Vector with zero everywhere except where water vapor is";
initial algorithm
  for i in 1:Medium.nX loop
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="water",
                                            caseSensitive=false)) then
      s[i] :=1;
    else
      s[i] :=0;
    end if;
   end for;
   assert(Medium.nX == 1 or abs(1-sum(s)) < 1E-4, "Substance 'water' is not present in medium '"
                  + Medium.mediumName + "'.\n"
                  + "Change medium model to one that has 'water' as a substance.");
equation
  QRad_flow = qGai_flow[1]*AFlo;
  QCon_flow.Q_flow = -qGai_flow[2]*AFlo;

  // Interface to fluid port
  // If a medium does not contain water vapor, then h_fg is equal to zero.
  if Medium.nXi == 0 or (h_fg == 0) then
    mWat_flow = 0;
  else
    mWat_flow = qGai_flow[3]*AFlo/h_fg;
  end if;

  QLat_flow.C_outflow  = fill(0, Medium.nC);
  QLat_flow.h_outflow  = h_fg;
  QLat_flow.Xi_outflow = s[1:Medium.nXi];
  QLat_flow.m_flow     = if (h_fg > 0) then
                           -qGai_flow[3]*AFlo/h_fg else
                            0;

 annotation(Documentation(info="<html>
This model computes the radiant, convective and latent heat flow.
Input into this model are these three components in units of [W/m2].
The inputs need to be positive quantities if heat or moisture is added
to the room.
The outputs are
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
If the medium model does not contain water vapor, then
the water vapor released into the air is zero, i.e.,
the mass flow rate at the fluid port is equal to zero.
</html>",
        revisions="<html>
<ul>
<li>
December 6, 2011, by Michael Wetter:<br/>
Fixed sign error in convective heat gain that is assigned to
<code>QCon_flow.Q_flow</code>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">issue 46</a>.
</li>
<li>
April 27, 2011, by Michael Wetter:<br/>
Changed assert statement to allow use of model for media without water vapor.
</li>
<li>
June 9, 2010, by Michael Wetter:<br/>
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
          lineColor={0,0,127},
          textString="q_flow"),
        Text(
          extent={{12,72},{86,50}},
          lineColor={0,0,127},
          textString="QRad_flow"),
        Text(
          extent={{10,12},{84,-10}},
          lineColor={0,0,127},
          textString="QCon_flow"),
        Text(
          extent={{12,-46},{86,-68}},
          lineColor={0,0,127},
          textString="mLat_flow")}),
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
June 25, by Michael Wetter:<br/>
Added missing <code>each</code> attribute.
</li>
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
end MixedAirHeatGain;
