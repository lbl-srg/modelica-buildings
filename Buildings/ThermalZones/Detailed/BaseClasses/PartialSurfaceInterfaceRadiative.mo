within Buildings.ThermalZones.Detailed.BaseClasses;
partial model PartialSurfaceInterfaceRadiative
  "Partial model that is used for infrared radiation balance"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialSurfaceInterface;

protected
  parameter Modelica.Units.SI.Emissivity epsConExt[NConExt]=datConExt.layers.absIR_b
    "Absorptivity of exterior constructions";
  parameter Modelica.Units.SI.Emissivity epsConExtWinOpa[NConExtWin]=
      datConExtWin.layers.absIR_b
    "Absorptivity of opaque part of exterior constructions that contain a window";
  parameter Modelica.Units.SI.Emissivity epsConExtWinUns[NConExtWin]={(
      datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].absIR_b)
      for i in 1:NConExtWin}
    "Absorptivity of unshaded part of window constructions";
  parameter Modelica.Units.SI.Emissivity epsConExtWinSha[NConExtWin]=
      datConExtWin.glaSys.shade.absIR_a
    "Absorptivity of shaded part of window constructions";
  parameter Modelica.Units.SI.Emissivity epsConExtWinFra[NConExtWin]=
      datConExtWin.glaSys.absIRFra "Absorptivity of window frame";
  parameter Modelica.Units.SI.Emissivity epsConPar_a[NConPar]=datConPar.layers.absIR_a
    "Absorptivity of partition constructions surface a";
  parameter Modelica.Units.SI.Emissivity epsConPar_b[NConPar]=datConPar.layers.absIR_b
    "Absorptivity of partition constructions surface b";
  parameter Modelica.Units.SI.Emissivity epsConBou[NConBou]=datConBou.layers.absIR_b
    "Absorptivity of constructions with exterior boundary conditions exposed to outside of room model";
  parameter Modelica.Units.SI.Emissivity epsSurBou[NSurBou]=surBou.absIR
    "Absorptivity of surface models of constructions that are modeled outside of this room";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,
            -240},{240,240}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-240,-240},{240,240}}),
                                      graphics={
        Text(
          extent={{-234,328},{242,244}},
          textColor={0,0,127},
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
