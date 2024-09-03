within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model GlassLayer "Test model for glass layer heat transfer"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Area A=1 "Window surface area";
  parameter Boolean linearize = false "Set to true to linearize emissive power";

  Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer sha(
    A=A,
    absIR_a=0.5,
    tauIR=0.2,
    x=0.015,
    k=1,
    linearize=linearize,
    absIR_b=0.5) "Model for fraction of window that has a shade"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-110,-40},{-90,-20}})));
  Modelica.Blocks.Sources.Constant TOut(k=273.15) "Outside temperature"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,20})));
  Buildings.HeatTransfer.Radiosity.OpaqueSurface radOut(A=A, absIR=0.8,
    linearize=false) "Model for outside radiosity"
    annotation (Placement(transformation(extent={{-98,-70},{-78,-48}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadOut
    "Outside radiative temperature"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.HeatTransfer.Radiosity.OpaqueSurface radIn(A=A, absIR=0.8,
    linearize=false) "Model for inside radiosity"
    annotation (Placement(transformation(extent={{102,-60},{82,-40}})));
  Modelica.Blocks.Sources.Constant TRoo(k=293.15) "Room temperature"
    annotation (Placement(transformation(extent={{160,10},{140,30}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadRoo
    "Room radiative temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={114,-60})));
  Modelica.Blocks.Sources.Constant QAbs_flow(k=0) "Absorbed solar heat flow"
    annotation (Placement(transformation(extent={{-60,74},{-40,94}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaInt
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{60,-22},{40,-2}})));

  Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer nonSha(
    A=A,
    absIR_a=0.5,
    tauIR=0.2,
    x=0.015,
    k=1,
    linearize=linearize,
    absIR_b=0.5) "Model for fraction of window that has no shade"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Modelica.Thermal.HeatTransfer.Components.Convection conRooSha
    "Convection for room-facing surface of shaded part of window"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conRooNonSha
    "Convection for room-facing surface of non-shaded part of window"
    annotation (Placement(transformation(extent={{58,-100},{78,-80}})));
  Modelica.Blocks.Sources.Constant hA(k=4*A)
    "Convection coefficient times total area"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Modelica.Blocks.Math.Product hASha "Convection of shaded part of window"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Modelica.Blocks.Math.Product hANonSha
    "Convection of non-shaded part of window"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conOutSha(
    dT(start=0))
    "Convection for outside-facing surface of shaded part of window"
    annotation (Placement(transformation(extent={{-40,30},{-60,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conOutNonSha1(
    dT(start=0))
    "Convection for outside-facing surface of non-shaded part of window"
    annotation (Placement(transformation(extent={{-40,-100},{-60,-80}})));
  Modelica.Blocks.Sources.Ramp uSha(
    height=0.9,
    duration=1,
    offset=0.05) "Control signal for shade"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal shaCon(haveShade=
        true) "Bounds the shading signal"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Modelica.Blocks.Math.MultiSum sumJOut(nu=2)
    "Sum of radiosities at outer surface"
    annotation (Placement(transformation(extent={{-30,-68},{-42,-56}})));
  Modelica.Blocks.Math.MultiSum sumJRoo(nu=2)
    "Sum of radiosities at room surface"
    annotation (Placement(transformation(extent={{44,-60},{56,-48}})));
equation
  connect(TOut.y, TAirOut.T) annotation (Line(
      points={{-139,-30},{-112,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRadOut.port, radOut.heatPort) annotation (Line(
      points={{-100,-70},{-94,-69.8},{-87.2,-69.78}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadOut.T, TOut.y) annotation (Line(
      points={{-122,-70},{-128,-70},{-128,-30},{-139,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.y, TAirRoo.T)  annotation (Line(
      points={{139,20},{122,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRadRoo.port, radIn.heatPort) annotation (Line(
      points={{104,-60},{91.2,-60},{91.2,-59.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadRoo.T, TRoo.y)  annotation (Line(
      points={{126,-60},{130,-60},{130,20},{139,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs_flow.y, sha.QAbs_flow) annotation (Line(
      points={{-39,84},{-24,84},{-24,24},{10,24},{10,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.JIn, radOut.JOut) annotation (Line(
      points={{-61,-4},{-66,-4},{-66,-54.6},{-77,-54.6}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(radIn.JOut, radShaInt.JIn) annotation (Line(
      points={{81,-46},{72,-46},{72,-6},{61,-6}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, sha.JIn_a)    annotation (Line(
      points={{-39,-4},{-20,-4},{-20,44},{-1,44}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, nonSha.JIn_a) annotation (Line(
      points={{-39,-16},{-20,-16},{-20,-86},{-1,-86}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_1, sha.JIn_b)    annotation (Line(
      points={{39,-6},{30,-6},{30,36},{21,36}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_2, nonSha.JIn_b) annotation (Line(
      points={{39,-18},{30,-18},{30,-94},{21,-94}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(QAbs_flow.y, nonSha.QAbs_flow) annotation (Line(
      points={{-39,84},{-6,84},{-6,-110},{10,-110},{10,-101}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hA.y, hANonSha.u1) annotation (Line(
      points={{1,150},{30,150},{30,146},{58,146}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASha.u1, hA.y) annotation (Line(
      points={{58,116},{20,116},{20,150},{1,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nonSha.port_a, conOutNonSha1.solid) annotation (Line(
      points={{-5.55112e-16,-90},{-40,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conOutNonSha1.fluid, TAirOut.port) annotation (Line(
      points={{-60,-90},{-70,-90},{-70,-30},{-90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sha.port_a, conOutSha.solid) annotation (Line(
      points={{-5.55112e-16,40},{-40,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conOutSha.fluid, TAirOut.port) annotation (Line(
      points={{-60,40},{-70,40},{-70,-30},{-90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nonSha.port_b, conRooNonSha.solid) annotation (Line(
      points={{20,-90},{58,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sha.port_b, conRooSha.solid) annotation (Line(
      points={{20,40},{40,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRooSha.fluid, TAirRoo.port) annotation (Line(
      points={{60,40},{80,40},{80,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRooNonSha.fluid, TAirRoo.port) annotation (Line(
      points={{78,-90},{80,-90},{80,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hASha.y, conOutSha.Gc) annotation (Line(
      points={{81,110},{90,110},{90,68},{-50,68},{-50,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASha.y, conRooSha.Gc) annotation (Line(
      points={{81,110},{90,110},{90,68},{50,68},{50,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hANonSha.y, conOutNonSha1.Gc) annotation (Line(
      points={{81,140},{96,140},{96,-32},{-50,-32},{-50,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hANonSha.y, conRooNonSha.Gc) annotation (Line(
      points={{81,140},{96,140},{96,-32},{68,-32},{68,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.yCom, hANonSha.u2) annotation (Line(
      points={{-99,104},{4,104},{4,134},{58,134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.yCom, nonSha.u) annotation (Line(
      points={{-99,104},{-10,104},{-10,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, radShaOut.u) annotation (Line(
      points={{-99,110},{-72,110},{-72,-16},{-62,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, radShaInt.u) annotation (Line(
      points={{-99,110},{20,110},{20,80},{80,80},{80,-18},{62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, sha.u) annotation (Line(
      points={{-99,110},{-14,110},{-14,48},{-1,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha.y,shaCon. u) annotation (Line(
      points={{-139,110},{-122,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, hASha.u2) annotation (Line(
      points={{-99,110},{40,110},{40,104},{58,104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.JIn, sumJOut.y) annotation (Line(
      points={{-77,-63.4},{-60,-63.4},{-60,-62},{-43.02,-62}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sha.JOut_a, sumJOut.u[1]) annotation (Line(
      points={{-1,36},{-26,36},{-26,-59.9},{-30,-59.9}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(nonSha.JOut_a, sumJOut.u[2]) annotation (Line(
      points={{-1,-94},{-26,-94},{-26,-64.1},{-30,-64.1}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radIn.JIn, sumJRoo.y) annotation (Line(
      points={{81,-54},{57.02,-54}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sha.JOut_b, sumJRoo.u[1]) annotation (Line(
      points={{21,44},{28,44},{28,-51.9},{44,-51.9}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(nonSha.JOut_b, sumJRoo.u[2]) annotation (Line(
      points={{21,-86},{28,-86},{28,-56.1},{44,-56.1}},
      color={0,127,0},
      smooth=Smooth.None));
    annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/GlassLayer.mos"
        "Simulate and plot"),
              Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,
            -160},{160,160}}),
                      graphics),
    Documentation(info="<html>
This model tests one glas layer.
</html>", revisions="<html>
<ul>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
</ul>
</html>"));
end GlassLayer;
