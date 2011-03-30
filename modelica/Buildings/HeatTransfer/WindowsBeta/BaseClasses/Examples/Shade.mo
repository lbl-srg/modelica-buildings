within Buildings.HeatTransfer.WindowsBeta.BaseClasses.Examples;
model Shade "Test model for exterior shade heat transfer"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area A=1 "Window surface area";
  parameter Boolean linearize = true "Set to true to linearize emissive power";

  Buildings.HeatTransfer.WindowsBeta.BaseClasses.Shade extSha(
    A=A,
    linearize=false,
    epsLW_air=0.3,
    epsLW_glass=0.3,
    tauLW_air=0.3,
    tauLW_glass=0.3,
    thisSideHasShade=true) "Model of exterior shade"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Sources.Ramp uSha(
    height=0.9,
    duration=1,
    offset=0.05) "Control signal for shade"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Modelica.Blocks.Sources.Constant TOut(k=273.15) "Outside temperature"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.HeatTransfer.Radiosity.OpaqueSurface radOut(A=A, epsLW=0.8,
    linearize=false) "Model for outside radiosity"
    annotation (Placement(transformation(extent={{-104,-72},{-84,-52}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadOut
    "Outside radiative temperature"
    annotation (Placement(transformation(extent={{-114,-100},{-94,-80}})));

  Buildings.HeatTransfer.Radiosity.OpaqueSurface radIn(A=A, epsLW=0.8,
    linearize=false) "Model for inside radiosity"
    annotation (Placement(transformation(extent={{102,-62},{82,-42}})));
  Modelica.Blocks.Sources.Constant TRoo(k=293.15) "Room temperature"
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadRoo
    "Room radiative temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={112,-70})));
  Modelica.Blocks.Sources.Constant QSW_shade(k=0)
    "Short-wave heat flow absorbed by shade"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaInt
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{60,-22},{40,-2}})));

  Buildings.HeatTransfer.WindowsBeta.BaseClasses.Shade extNonSha(
    A=A,
    linearize=false,
    thisSideHasShade=false,
    epsLW_air=0,
    epsLW_glass=0,
    tauLW_air=0.3,
    tauLW_glass=0.3) "Model for fraction of window that has no shade"
    annotation (Placement(transformation(extent={{2,-62},{22,-42}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirRoo
    "Room-side air temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,20})));
  Buildings.HeatTransfer.WindowsBeta.BaseClasses.ShadingSignal shaCon(haveShade=
        true)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Blocks.Math.Gain GConSha(k=10*A, y(unit="W/K"))
    "Convection coefficient for shade part of window"
    annotation (Placement(transformation(extent={{-46,40},{-26,60}})));
  Modelica.Blocks.Math.Gain GConUns(k=10*A, y(unit="W/K"))
    "Convection coefficient for unshade part of window"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
equation
  connect(TRadOut.port, radOut.heatPort) annotation (Line(
      points={{-94,-90},{-78,-90},{-78,-71.8},{-93.2,-71.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadOut.T, TOut.y) annotation (Line(
      points={{-116,-90},{-139,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRadRoo.port, radIn.heatPort) annotation (Line(
      points={{102,-70},{91.2,-70},{91.2,-61.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadRoo.T, TRoo.y)  annotation (Line(
      points={{124,-70},{139,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.JIn, radOut.JOut) annotation (Line(
      points={{-61,-4},{-78,-4},{-78,-58},{-83,-58}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(radIn.JOut, radShaInt.JIn) annotation (Line(
      points={{81,-48},{72,-48},{72,-6},{61,-6}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extSha.JOut_air, radOut.JIn) annotation (Line(
      points={{-1,12},{-26,12},{-26,-86},{-76,-86},{-76,-66},{-83,-66}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extNonSha.JOut_air, radOut.JIn) annotation (Line(
      points={{1,-60},{-26,-60},{-26,-86},{-76,-86},{-76,-66},{-83,-66}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, extSha.JIn_air) annotation (Line(
      points={{-39,-4},{-30,-4},{-30,16},{-1,16}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, extNonSha.JIn_air) annotation (Line(
      points={{-39,-16},{-30,-16},{-30,-56},{1,-56}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(QSW_shade.y, extSha.QAbs_flow) annotation (Line(
      points={{-19,110},{-10,110},{-10,0},{10,0},{10,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaInt.JOut_1, extSha.JIn_glass) annotation (Line(
      points={{39,-6},{30,-6},{30,12},{21,12}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_2, extNonSha.JIn_glass) annotation (Line(
      points={{39,-18},{30,-18},{30,-60},{23,-60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extNonSha.JOut_glass, radIn.JIn) annotation (Line(
      points={{23,-56},{81,-56}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extSha.JOut_glass, radIn.JIn) annotation (Line(
      points={{21,16},{34,16},{34,-56},{81,-56}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(TAirOut.port, extSha.air) annotation (Line(
      points={{-100,20},{-5.55112e-16,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirOut.T, TOut.y) annotation (Line(
      points={{-122,20},{-130,20},{-130,-90},{-139,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAirRoo.port, extSha.glass) annotation (Line(
      points={{100,20},{19.4,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirRoo.port, extNonSha.glass) annotation (Line(
      points={{100,20},{80,20},{80,-52},{21.4,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirOut.port, extNonSha.air) annotation (Line(
      points={{-100,20},{-20,20},{-20,-52},{2,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirRoo.T, TRoo.y) annotation (Line(
      points={{122,20},{132,20},{132,-70},{139,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QSW_shade.y, extNonSha.QAbs_flow) annotation (Line(
      points={{-19,110},{-10,110},{-10,-70},{12,-70},{12,-63}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, extSha.u) annotation (Line(
      points={{-89,80},{-54,80},{-54,28},{-1,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, radShaOut.u) annotation (Line(
      points={{-89,80},{-68,80},{-68,-16},{-62,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha.y, shaCon.u) annotation (Line(
      points={{-139,80},{-112,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.yCom, extNonSha.u) annotation (Line(
      points={{-89,74},{-72,74},{-72,-44},{1,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GConSha.y, extSha.Gc) annotation (Line(
      points={{-25,50},{-14,50},{-14,24},{-1,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GConUns.y, extNonSha.Gc) annotation (Line(
      points={{-39,-120},{-18,-120},{-18,-48},{1,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GConSha.u, shaCon.y) annotation (Line(
      points={{-48,50},{-68,50},{-68,80},{-89,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.yCom, GConUns.u) annotation (Line(
      points={{-89,74},{-72,74},{-72,-120},{-62,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, radShaInt.u) annotation (Line(
      points={{-89,80},{68,80},{68,-18},{62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Commands(file="Shade.mos" "run"),
              Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
            -160},{160,160}}),
                      graphics),
    Documentation(info="<html>
This model tests the shading device. Note that the temperature of the shading device changes
slightly as the shade control signal changes (i.e., as the shade is lowered). 
This is because the shade has a different emissive power than the glass, which changes the 
energy balance.
</html>"));
end Shade;
