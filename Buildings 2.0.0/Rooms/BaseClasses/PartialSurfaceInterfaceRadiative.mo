within Buildings.Rooms.BaseClasses;
partial model PartialSurfaceInterfaceRadiative
  "Partial model that is used for infrared radiation balance"
  extends Buildings.Rooms.BaseClasses.PartialSurfaceInterface;

protected
  parameter Modelica.SIunits.Emissivity epsConExt[NConExt] = datConExt.layers.absIR_b
    "Absorptivity of exterior constructions";
  parameter Modelica.SIunits.Emissivity epsConExtWinOpa[NConExtWin] = datConExtWin.layers.absIR_b
    "Absorptivity of opaque part of exterior constructions that contain a window";
  parameter Modelica.SIunits.Emissivity epsConExtWinUns[NConExtWin]=
    {(datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].absIR_b) for i in 1:NConExtWin}
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
        Text(
          extent={{-234,328},{242,244}},
          lineColor={0,0,127},
          textString="%name")}),
        Documentation(info="<html>
<p>
This partial model is used as a base class for models that need to exchange
heat with room-facing surfaces by radiation. It declares parameters that are
needed for the radiative balance.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
July 12, 2013, by Michael Wetter:<br/>
First implementation to facilitate the separation of the convective and radiative model.
</li>
</ul>
</html>"));
end PartialSurfaceInterfaceRadiative;
