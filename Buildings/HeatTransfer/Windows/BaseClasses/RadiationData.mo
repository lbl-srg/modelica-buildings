within Buildings.HeatTransfer.Windows.BaseClasses;
record RadiationData "Radiation data of a window"
  extends Modelica.Icons.Record;
  extends Buildings.HeatTransfer.Windows.BaseClasses.RadiationBaseData;
  final parameter Real glass[3, N, NSta]={tauGlaSol, rhoGlaSol_a, rhoGlaSol_b}
    "Glass solar transmissivity, solar reflectivity at surface a and b, at normal incident angle";
  final parameter Real traRefShaDev[2, 2]={{tauShaSol_a,tauShaSol_b},{
      rhoShaSol_a,rhoShaSol_b}} "Shading device property";
  final parameter Integer NDIR=10 "Number of incident angles";
  final parameter Integer HEM=NDIR + 1 "Index of hemispherical integration";
  final parameter Modelica.Units.SI.Angle psi[NDIR]=
      Buildings.HeatTransfer.Windows.Functions.getAngle(NDIR)
    "Incident angles used for solar radiation calculation";
  final parameter Real layer[3, N, HEM, NSta]=
    Buildings.HeatTransfer.Windows.Functions.glassProperty(
      N=N,
      NSta=NSta,
      HEM=HEM,
      glass=glass,
      xGla=xGla,
      psi=psi) "Angular and hemispherical transmissivity, front (outside-facing) and back (room facing) reflectivity
      of each glass pane";
  final parameter Real traRef[3, N, N, HEM, NSta]=
    Buildings.HeatTransfer.Windows.Functions.getGlassTR(
      N=N,
      NSta=NSta,
      HEM=HEM,
      layer=layer) "Angular and hemispherical transmissivity, front (outside-facing) and back (room facing) reflectivity
      between glass panes for exterior or interior irradiation without shading";
  final parameter Real absExtIrrNoSha[N, HEM, NSta]=
      Buildings.HeatTransfer.Windows.Functions.glassAbsExteriorIrradiationNoShading(
      traRef=traRef,
      N=N,
      NSta=NSta,
      HEM=HEM) "Angular and hemispherical absorptivity of each glass pane
      for exterior irradiation without shading";
  final parameter Real absIntIrrNoSha[N, NSta]=
      Buildings.HeatTransfer.Windows.Functions.glassAbsInteriorIrradiationNoShading(
      traRef=traRef,
      N=N,
      NSta=NSta,
      HEM=HEM) "Hemispherical absorptivity of each glass pane
      for interior irradiation without shading";
  final parameter Real winTraExtIrrExtSha[HEM, NSta]=
      Buildings.HeatTransfer.Windows.Functions.winTExteriorIrradiatrionExteriorShading(
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Angular and hemispherical transmissivity of a window system (glass + exterior shading device)
     for exterior irradiation";
  final parameter Real absExtIrrExtSha[N, HEM, NSta]=
      Buildings.HeatTransfer.Windows.Functions.glassAbsExteriorIrradiationExteriorShading(
      absExtIrrNoSha=absExtIrrNoSha,
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Angular and hemispherical absorptivity of each glass pane
      for exterior irradiation with exterior shading";
  final parameter Real winTraExtIrrIntSha[HEM, NSta]=
      Buildings.HeatTransfer.Windows.Functions.winTExteriorIrradiationInteriorShading(
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Angular and hemispherical transmissivity of a window system (glass and interior shading device)
      for exterior irradiation";
  final parameter Real absExtIrrIntSha[N, HEM, NSta]=
      Buildings.HeatTransfer.Windows.Functions.glassAbsExteriorIrradiationInteriorShading(
      absExtIrrNoSha=absExtIrrNoSha,
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Angular and hemispherical absorptivity of each glass layer
     for exterior irradiation with interior shading";
  final parameter Real devAbsExtIrrIntShaDev[HEM, NSta]=
      Buildings.HeatTransfer.Windows.Functions.devAbsExteriorIrradiationInteriorShading(
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Angular and hemispherical absorptivity of an interior shading device
      for exterior irradiation";
  final parameter Real winTraRefIntIrrExtSha[3, NSta]=
      Buildings.HeatTransfer.Windows.Functions.winTRInteriorIrradiationExteriorShading(
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Hemisperical transmissivity and reflectivity of a window system (glass and exterior shadig device)
      for interior irradiation. traRefIntIrrExtSha[1]: transmissivity,
      traRefIntIrrExtSha[2]: Back reflectivity; traRefIntIrrExtSha[3]: dummy value";
  final parameter Real absIntIrrExtSha[N, NSta]=
      Buildings.HeatTransfer.Windows.Functions.glassAbsInteriorIrradiationExteriorShading(
      absIntIrrNoSha=absIntIrrNoSha,
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Hemispherical absorptivity of each glass pane
      for interior irradiation with exterior shading";
  final parameter Real absIntIrrIntSha[N, NSta]=
      Buildings.HeatTransfer.Windows.Functions.glassAbsInteriorIrradiationInteriorShading(
      absIntIrrNoSha=absIntIrrNoSha,
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Hemispherical absorptivity of each glass pane
      for interior irradiation with interior shading";
  final parameter Real winTraRefIntIrrIntSha[3, NSta]=
      Buildings.HeatTransfer.Windows.Functions.winTRInteriorIrradiationInteriorShading(
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM) "Hemisperical transmissivity and back reflectivity of a window system (glass and interior shadig device)
      for interior irradiation";
  final parameter Real devAbsIntIrrIntSha[NSta]=
      Buildings.HeatTransfer.Windows.Functions.devAbsInteriorIrradiationInteriorShading(
      traRef=traRef,
      traRefShaDev=traRefShaDev,
      N=N,
      NSta=NSta,
      HEM=HEM)
    "Hemiperical absorptivity of an interior shading device for interior irradiation";
  annotation (Documentation(info="<html>
Record that computes the solar radiation data for a glazing system.
</html>", revisions="<html>
<ul>
<li>
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter for glassProperty(). It is needed by the calculation of property for uncoated glass.
</li>
<li>
December 12, 2010, by Michael Wetter:<br/>
Replaced record
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> with the
parameters used by this model.
This was needed to integrate the radiation model into the room model.
</li>
<li>
December 10, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadiationData;
