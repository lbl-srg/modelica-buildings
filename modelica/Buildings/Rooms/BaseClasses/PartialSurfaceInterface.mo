within Buildings.Rooms.BaseClasses;
partial model PartialSurfaceInterface
  "Partial model that is used for infrared radiation balance"
  import Buildings;
  extends Buildings.Rooms.BaseClasses.ConstructionRecords;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExt[NConExt]
    "Heat port that connects to room-side surface of exterior constructions"
                              annotation (Placement(transformation(extent={{230,210},
            {250,230}},          rotation=0)));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWin[NConExtWin]
    "Heat port that connects to room-side surface of exterior constructions that contain a window"
                              annotation (Placement(transformation(extent={{230,170},
            {250,190}},          rotation=0)));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWinFra[NConExtWin]
    "Heat port that connects to room-side surface of window frame"
                              annotation (Placement(transformation(extent={{232,-10},
            {252,10}},           rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_a[NConPar]
    "Heat port that connects to room-side surface a of partition constructions"
                              annotation (Placement(transformation(extent={{232,-70},
            {252,-50}},          rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_b[NConPar]
    "Heat port that connects to room-side surface b of partition constructions"
                              annotation (Placement(transformation(extent={{232,
            -110},{252,-90}},    rotation=0)));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conBou[NConBou]
    "Heat port that connects to room-side surface of constructions that expose their other surface to the outside"
                              annotation (Placement(transformation(extent={{232,
            -170},{252,-150}},   rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conSurBou[NSurBou]
    "Heat port to surfaces of models that compute the heat conduction outside of this room"
                              annotation (Placement(transformation(extent={{231,
            -230},{251,-210}},   rotation=0)));
protected
  final parameter Modelica.SIunits.Area AConExt[NConExt] = datConExt.A
    "Areas of exterior constructions";
  final parameter Modelica.SIunits.Area AConExtWinOpa[NConExtWin] = datConExtWin.AOpa
    "Opaque areas of exterior construction that have a window";
  final parameter Modelica.SIunits.Area AConExtWinGla[NConExtWin] = (1 .- datConExtWin.fFra) .* datConExtWin.AWin
    "Glass areas of exterior construction that have a window";
  final parameter Modelica.SIunits.Area AConExtWinFra[NConExtWin] = datConExtWin.fFra .* datConExtWin.AWin
    "Frame areas of exterior construction that have a window";
  final parameter Modelica.SIunits.Area AConPar[NConPar] = datConPar.A
    "Areas of partition constructions";
  final parameter Modelica.SIunits.Area AConBou[NConBou] = datConBou.A
    "Areas of constructions with exterior boundary conditions exposed to outside of room model";
  final parameter Modelica.SIunits.Area ASurBou[NSurBou] = surBou.A
    "Area of surface models of constructions that are modeled outside of this room";

  parameter Modelica.SIunits.Emissivity epsConExt[NConExt] = datConExt.layers.absIR_b
    "Absorptivity of exterior constructions";
  parameter Modelica.SIunits.Emissivity epsConExtWinOpa[NConExtWin] = datConExtWin.layers.absIR_b
    "Absorptivity of opaque part of exterior constructions that contain a window";
  parameter Modelica.SIunits.Emissivity epsConExtWinUns[NConExtWin]=
    {(datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].absIR_b) for i in 1:NConExtWin}
    "Absorptivity of unshaded part of window constructions";
  parameter Modelica.SIunits.Emissivity epsConExtWinSha[NConExtWin] = datConExtWin.glaSys.shade.absIR_a
    "Absorptivity of shaded part of window constructions";
  parameter Modelica.SIunits.Emissivity epsConExtWinFra[NConExtWin] = datConExtWin.glaSys.absIRFra
    "Absorptivity of window frame";
  parameter Modelica.SIunits.Emissivity epsConPar_a[NConPar] = datConPar.layers.absIR_a
    "Absorptivity of partition constructions surface a";
  parameter Modelica.SIunits.Emissivity epsConPar_b[NConPar] = datConPar.layers.absIR_b
    "Absorptivity of partition constructions surface b";
  parameter Modelica.SIunits.Emissivity epsConBou[NConBou] = datConBou.layers.absIR_b
    "Absorptivity of constructions with exterior boundary conditions exposed to outside of room model";
  parameter Modelica.SIunits.Emissivity epsSurBou[NSurBou] = surBou.absIR
    "Absorptivity of surface models of constructions that are modeled outside of this room";
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,
            -240},{240,240}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-240,-240},{240,240}}),
                                      graphics={
        Rectangle(
          extent={{-240,240},{240,-240}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{148,206},{174,-206}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-170,-200},{172,-224}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-170,206},{-144,-224}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-170,208},{174,184}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-234,328},{242,244}},
          lineColor={0,0,127},
          textString="%name"),
        Rectangle(
          extent={{-144,184},{148,-198}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
This partial model is used as a base class for models that need to exchange
heat with room-facing surfaces. It defines parameters for the surface area,
the absorptivity, and the products of area times absorptivity.
</p>
<p>
There are also parameters that contain the number of constructions,
such as the number of exterior constructions <code>nConExt</code>. 
This parameter may take on the value <code>0</code>. 
If this parameter were to be used to declare the size of vectors of
component models, then there may be vectors with zero components.
This can cause problems in Dymola 7.4. 
We therefore also introduced the parameter
<pre>
  NConExt = max(1, nConExt)

</pre>
which can be used to set the size of the vector of component models.
</p>
<p>
There are also parameters that can be used to conditionally remove components,
such as <code>haveConExt</code>, which is set to 
<pre>
  haveConExt = nConExt > 0;

</pre>
</p>
</html>",
revisions="<html>
<ul>
<li>
November 6, 2011, by Michael Wetter:<br>
Changed parameters that contain radiative properties from final to non-final, as
they need to be overwritten by 
<a href=\"modelica://Buildings.Rooms.BaseClasses.SolarRadiationExchange\">
Buildings.Rooms.BaseClasses.SolarRadiationExchange</a>.
</li>
<li>
November 16 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialSurfaceInterface;
