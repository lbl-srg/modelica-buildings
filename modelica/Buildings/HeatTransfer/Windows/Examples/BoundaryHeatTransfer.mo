within Buildings.HeatTransfer.Windows.Examples;
model BoundaryHeatTransfer
  "Test model for the heat transfer at the window boundary condition"
  import Buildings;
  parameter Modelica.SIunits.Area A=1 "Window surface area";
  parameter Real fFra=0.2
    "Fraction of frame, = frame area divided by total area";
  parameter Boolean linearize = false "Set to true to linearize emissive power";

  Buildings.HeatTransfer.Windows.ExteriorHeatTransfer extCon(A=A, fFra=fFra,
    linearize=linearize,
    epsLWSha_air=glaSys.shade.epsLW_a,
    epsLWSha_glass=glaSys.shade.epsLW_b,
    tauLWSha_air=glaSys.shade.tauLW_a,
    tauLWSha_glass=glaSys.shade.tauLW_b,
    haveExteriorShade=glaSys.haveExteriorShade,
    haveInteriorShade=glaSys.haveInteriorShade,
    F_sky=0.5) "Exterior convective heat transfer"
    annotation (Placement(transformation(extent={{-56,-34},{-36,-14}})));
  Modelica.Blocks.Sources.Constant TOut(y(unit="K"), k=273.15)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Constant TRooAir(k=293.15, y(unit="K"))
    "Room air temperature"
    annotation (Placement(transformation(extent={{20,62},{40,82}})));
  Modelica.Blocks.Sources.Constant TRooRad(k=293.15, y(unit="K"))
    "Room radiative temperature"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Ramp uSha(duration=1, startTime=0)
    "Shading control signal"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant vWin(k=1) "Wind speed"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOuts
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant fClr(k=0) "Fraction of sky that is clear"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys2(
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    UFra=2,
    haveInteriorShade=false,
    haveExteriorShade=false) "Parameters for glazing system"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.HeatTransfer.Data.GlazingSystems.SingleClear3 glaSys1(UFra=2)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.HeatTransfer.Data.GlazingSystems.TripleClearAir13ClearAir13Clear
    glaSys3(UFra=1) "Parameters for glazing system"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    UFra=1.5,
    haveExteriorShade=true,
    haveInteriorShade=false) "Parameters for glazing system"
    annotation (Placement(transformation(extent={{80,-56},{100,-36}})));
 Buildings.HeatTransfer.Radiosity.IndoorRadiosity radIn(
    final linearize=linearize, final A=A) "Indoor radiosity"
    annotation (Placement(transformation(extent={{44,-30},{24,-10}})));
protected
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{8,-32},{-12,-12}})));
public
  Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal shaSig(haveShade=true)
    "Conversion for shading signal"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRAir1
    "Room air temperature"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRAir2
    "Room air temperature"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRAir3
    "Room air temperature"
    annotation (Placement(transformation(extent={{60,-26},{80,-6}})));
  Modelica.Blocks.Sources.Constant QAbsSW_flow(k=0) "Absorbed solar radiation"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(uSha.y, extCon.uSha) annotation (Line(
      points={{-79,30},{-70,30},{-70,-16},{-56.8,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOuts.port, extCon.air) annotation (Line(
      points={{-40,70},{-30,70},{-30,40},{-64,40},{-64,-24},{-56,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRooAir.y, TRAir.T) annotation (Line(
      points={{41,72},{50,72},{50,70},{58,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fClr.y, extCon.f_clr) annotation (Line(
      points={{-79,-50},{-68,-50},{-68,-32},{-56.8,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.vWin, vWin.y) annotation (Line(
      points={{-56.8,-20},{-74,-20},{-74,-10},{-79,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOuts.T, TOut.y) annotation (Line(
      points={{-62,70},{-70,70},{-70,90},{-79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.y,radShaOut. u) annotation (Line(
      points={{1,30},{16,30},{16,-28},{10,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radIn.JOut, radShaOut.JIn) annotation (Line(
      points={{23,-16},{9,-16}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shaSig.u, uSha.y) annotation (Line(
      points={{-22,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, extCon.JInUns) annotation (Line(
      points={{-13,-28},{-22,-28},{-22,-18},{-35,-18}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, extCon.JInSha) annotation (Line(
      points={{-13,-16},{-24,-16},{-24,-32},{-35,-32}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radIn.heatPort, TRAir.port) annotation (Line(
      points={{33.2,-29.8},{92,-29.8},{92,70},{80,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extCon.JOutUns, radIn.JIn) annotation (Line(
      points={{-35,-16},{-26,-16},{-26,-6},{28,-6},{28,-24},{23,-24}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extCon.JOutSha, radIn.JIn) annotation (Line(
      points={{-35,-30},{-28,-30},{-28,-6},{20,-6},{20,-24},{23,-24}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(TRooAir.y, TRAir1.T)
                              annotation (Line(
      points={{41,72},{44.5,72},{44.5,40},{58,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooAir.y, TRAir2.T)
                              annotation (Line(
      points={{41,72},{44.5,72},{44.5,10},{58,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooAir.y, TRAir3.T)
                              annotation (Line(
      points={{41,72},{44.5,72},{44.5,-16},{58,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRAir1.port, extCon.glaUns) annotation (Line(
      points={{80,40},{90,40},{90,-34},{-28,-34},{-28,-22},{-36,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRAir2.port, extCon.glaSha) annotation (Line(
      points={{80,10},{86,10},{86,-42},{-32,-42},{-32,-26},{-36,-26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRAir3.port, extCon.frame) annotation (Line(
      points={{80,-16},{82,-16},{82,-44},{-39,-44},{-39,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extCon.QAbs_flow, QAbsSW_flow.y) annotation (Line(
      points={{-46,-35},{-46,-90},{-79,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
  Commands(file=
          "BoundaryHeatTransfer.mos" "run"));
end BoundaryHeatTransfer;
