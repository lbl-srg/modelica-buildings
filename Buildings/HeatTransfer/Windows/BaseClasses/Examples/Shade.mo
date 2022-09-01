within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model Shade "Test model for exterior shade heat transfer"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Area A=1 "Window surface area";
  parameter Boolean linearize = true "Set to true to linearize emissive power";

  Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation extShaRad(
    A=A,
    linearize=false,
    absIR_air=0.3,
    absIR_glass=0.3,
    tauIR_air=0.3,
    tauIR_glass=0.3,
    thisSideHasShade=true) "Radiation model of exterior shade"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Sources.Ramp uSha(
    height=0.9,
    duration=1,
    offset=0.05) "Control signal for shade"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Modelica.Blocks.Sources.Constant TOut(k=273.15) "Outside temperature"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.HeatTransfer.Radiosity.OpaqueSurface radOut(A=A, absIR=0.8,
    linearize=false) "Model for outside radiosity"
    annotation (Placement(transformation(extent={{-104,-72},{-84,-52}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadOut
    "Outside radiative temperature"
    annotation (Placement(transformation(extent={{-114,-100},{-94,-80}})));

  Buildings.HeatTransfer.Radiosity.OpaqueSurface radIn(A=A, absIR=0.8,
    linearize=false) "Model for inside radiosity"
    annotation (Placement(transformation(extent={{102,-62},{82,-42}})));
  Modelica.Blocks.Sources.Constant TRoo(k=293.15) "Room temperature"
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadRoo
    "Room radiative temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={112,-70})));
  Modelica.Blocks.Sources.Constant QSol_shade(k=0)
    "Solar heat flow absorbed by shade"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaInt
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{60,-22},{40,-2}})));

  Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation extNonShaRad(
    A=A,
    linearize=false,
    thisSideHasShade=false,
    absIR_air=0,
    absIR_glass=0,
    tauIR_air=0.3,
    tauIR_glass=0.3) "Radiation model for fraction of window that has no shade"
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
  Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal shaCon(haveShade=
        true)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Blocks.Math.Gain GConSha(k=10*A, y(unit="W/K"))
    "Convection coefficient for shade part of window"
    annotation (Placement(transformation(extent={{-46,40},{-26,60}})));
  Modelica.Blocks.Math.Gain GConUns(k=10*A, y(unit="W/K"))
    "Convection coefficient for unshade part of window"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Modelica.Blocks.Math.MultiSum sumJRoo(nu=2) "Sum of room side radiosity"
    annotation (Placement(transformation(extent={{44,-76},{56,-64}})));
  Modelica.Blocks.Math.MultiSum sumJOut(nu=2) "Sum of outdoor side radiosity"
    annotation (Placement(transformation(extent={{-46,-72},{-58,-60}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ShadeConvection extShaCon(A=A,
      thisSideHasShade=true) "Convection model of exterior shade"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ShadeConvection extNonShaCon(A=A,
      thisSideHasShade=false)
    "Convection model for fraction of window that has no shade"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
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
      smooth=Smooth.None));
  connect(radIn.JOut, radShaInt.JIn) annotation (Line(
      points={{81,-48},{72,-48},{72,-6},{61,-6}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, extShaRad.JIn_air)
                                            annotation (Line(
      points={{-39,-4},{-30,-4},{-30,16},{-1,16}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, extNonShaRad.JIn_air)
                                               annotation (Line(
      points={{-39,-16},{-30,-16},{-30,-56},{1,-56}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_1, extShaRad.JIn_glass)
                                              annotation (Line(
      points={{39,-6},{30,-6},{30,12},{21,12}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_2, extNonShaRad.JIn_glass)
                                                 annotation (Line(
      points={{39,-18},{30,-18},{30,-60},{23,-60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(TAirOut.T, TOut.y) annotation (Line(
      points={{-122,20},{-130,20},{-130,-90},{-139,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAirRoo.T, TRoo.y) annotation (Line(
      points={{122,20},{132,20},{132,-70},{139,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, extShaRad.u)
                              annotation (Line(
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
  connect(shaCon.yCom, extNonShaRad.u)
                                    annotation (Line(
      points={{-89,74},{-72,74},{-72,-44},{1,-44}},
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
  connect(radIn.JIn, sumJRoo.y) annotation (Line(
      points={{81,-56},{70,-56},{70,-70},{57.02,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(radOut.JIn, sumJOut.y) annotation (Line(
      points={{-83,-66},{-59.02,-66}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(TAirRoo.port, extShaCon.glass) annotation (Line(
      points={{100,20},{74,20},{74,50},{19.4,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirRoo.port, extNonShaCon.glass) annotation (Line(
      points={{100,20},{74,20},{74,-90},{19.4,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extShaCon.air, TAirOut.port) annotation (Line(
      points={{-4.44089e-16,50},{-12,50},{-12,20},{-100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extNonShaCon.air, TAirOut.port) annotation (Line(
      points={{-4.44089e-16,-90},{-12,-90},{-12,20},{-100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GConUns.y, extNonShaCon.Gc) annotation (Line(
      points={{-39,-120},{-20,-120},{-20,-86},{-1,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GConSha.y, extShaCon.Gc) annotation (Line(
      points={{-25,50},{-14,50},{-14,54},{-1,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extShaCon.TSha, extShaRad.TSha) annotation (Line(
      points={{16,39},{16,39},{16,36},{24,36},{24,4},{15,4},{15,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extShaCon.QRadAbs_flow, extShaRad.QRadAbs_flow) annotation (Line(
      points={{4,39},{4,34},{26,34},{26,2},{5,2},{5,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extNonShaRad.TSha, extNonShaCon.TSha) annotation (Line(
      points={{17,-63},{17,-74},{26,-74},{26,-106},{16,-106},{16,-101}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extNonShaRad.QRadAbs_flow, extNonShaCon.QRadAbs_flow) annotation (
      Line(
      points={{7,-63},{7,-76},{24,-76},{24,-108},{4,-108},{4,-101}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extShaRad.JOut_air, sumJOut.u[1]) annotation (Line(
      points={{-1,12},{-28,12},{-28,-63.9},{-46,-63.9}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extNonShaRad.JOut_air, sumJOut.u[2]) annotation (Line(
      points={{1,-60},{-26,-60},{-26,-68.1},{-46,-68.1}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extShaRad.JOut_glass, sumJRoo.u[1]) annotation (Line(
      points={{21,16},{34,16},{34,-67.9},{44,-67.9}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extNonShaRad.JOut_glass, sumJRoo.u[2]) annotation (Line(
      points={{23,-56},{32,-56},{32,-72.1},{44,-72.1}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extShaRad.QSolAbs_flow, QSol_shade.y) annotation (Line(
      points={{10,9},{10,0},{-10,0},{-10,110},{-19,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extNonShaRad.QSolAbs_flow, QSol_shade.y) annotation (Line(
      points={{12,-63},{12,-70},{-10,-70},{-10,110},{-19,110}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/Shade.mos"
        "Simulate and plot"),
              Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,
            -160},{160,160}}),
                      graphics),
    Documentation(info="<html>
This model tests the shading device. Note that the temperature of the shading device changes
slightly as the shade control signal changes (i.e., as the shade is lowered).
This is because the shade has a different emissive power than the glass, which changes the
energy balance.
</html>", revisions="<html>
<ul>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
</ul>
</html>"));
end Shade;
