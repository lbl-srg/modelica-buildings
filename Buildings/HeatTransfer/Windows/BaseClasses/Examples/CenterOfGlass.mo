within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model CenterOfGlass "Test model for center of glas heat transfer"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Area A=1 "Window surface area";
  parameter Boolean linearize = false "Set to true to linearize emissive power";

  Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass sha(
    A=A,
    linearize=linearize,
    til=1.5707963267949,
    glaSys=glaSys) "Model for fraction of window that has a shade"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.Ramp uSha(
    height=0.9,
    duration=1,
    offset=0.05) "Control signal for shade"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Modelica.Blocks.Sources.Constant TOut(k=273.15) "Outside temperature"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-10})));

  Buildings.HeatTransfer.Radiosity.OpaqueSurface radIn(A=A, absIR=0.8,
    linearize=false) "Model for inside radiosity"
    annotation (Placement(transformation(extent={{100,-140},{80,-120}})));
  Modelica.Blocks.Sources.Constant TRoo(k=293.15) "Room temperature"
    annotation (Placement(transformation(extent={{158,-20},{138,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRadRoo
    "Room radiative temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-140})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaInt
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{60,-22},{40,-2}})));

  Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass nonSha(
    A=A,
    linearize=linearize,
    til=1.5707963267949,
    glaSys=glaSys) "Model for fraction of window that has no shade"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=true,
    haveInteriorShade=true,
    UFra=2) "Parameters for glazing system"
    annotation (Placement(transformation(extent={{120,122},{140,142}})));
  Buildings.HeatTransfer.Radiosity.OutdoorRadiosity radOut(A=A,
     vieFacSky=0.5) "Outdoor radiosity"
    annotation (Placement(transformation(extent={{-90,-152},{-70,-132}})));

  Modelica.Thermal.HeatTransfer.Components.Convection conRooSha
    "Convection for room-facing surface of shaded part of window"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conOutSha(dT(start=0))
    "Convection for outside-facing surface of shaded part of window"
    annotation (Placement(transformation(extent={{-40,30},{-60,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conOutNonSha1(dT(start=0))
    "Convection for outside-facing surface of non-shaded part of window"
    annotation (Placement(transformation(extent={{-40,-100},{-60,-80}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conRooNonSha
    "Convection for room-facing surface of non-shaded part of window"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.Constant hA(k=4*A)
    "Convection coefficient times total area"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Modelica.Blocks.Math.Product hASha "Convection of shaded part of window"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Modelica.Blocks.Math.Product hANonSha
    "Convection of non-shaded part of window"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal shaCon(haveShade=
        glaSys.haveExteriorShade or glaSys.haveInteriorShade)
    "Bounds the shading signal"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Modelica.Blocks.Sources.Constant QAbs[size(glaSys.glass, 1)](each k=0)
    "Solar radiation absorbed by glass"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Modelica.Blocks.Math.MultiSum sumJ(nu=2)
    "Sum of radiosities from the two surfaces"
    annotation (Placement(transformation(extent={{50,-140},{62,-128}})));
equation
  connect(TOut.y, TAirOut.T) annotation (Line(
      points={{-139,-30},{-122,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.y, TAirRoo.T)  annotation (Line(
      points={{137,-10},{129.5,-10},{129.5,-10},{122,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRadRoo.port, radIn.heatPort) annotation (Line(
      points={{100,-140},{89.2,-140},{89.2,-139.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRadRoo.T, TRoo.y)  annotation (Line(
      points={{122,-140},{128,-140},{128,-10},{137,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radIn.JOut, radShaInt.JIn) annotation (Line(
      points={{79,-126},{72,-126},{72,-6},{61,-6}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radOut.JOut, radShaOut.JIn) annotation (Line(
      points={{-69,-142},{-64,-142},{-64,-4},{-51,-4}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(hA.y, hANonSha.u1) annotation (Line(
      points={{1,150},{30,150},{30,146},{58,146}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASha.u1, hA.y) annotation (Line(
      points={{58,116},{20,116},{20,150},{1,150}},
      color={0,0,127},
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
      points={{81,140},{94,140},{94,-60},{-50,-60},{-50,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hANonSha.y, conRooNonSha.Gc) annotation (Line(
      points={{81,140},{94,140},{94,-60},{50,-60},{50,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conOutSha.solid, sha.glass_a) annotation (Line(
      points={{-40,40},{-5.55112e-16,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conOutSha.fluid, TAirOut.port) annotation (Line(
      points={{-60,40},{-90,40},{-90,-30},{-100,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nonSha.glass_a, conOutNonSha1.solid) annotation (Line(
      points={{-5.55112e-16,-90},{-40,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conOutNonSha1.fluid, TAirOut.port) annotation (Line(
      points={{-60,-90},{-90,-90},{-90,-30},{-100,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nonSha.glass_b, conRooNonSha.solid) annotation (Line(
      points={{20,-90},{40,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRooNonSha.fluid, TAirRoo.port) annotation (Line(
      points={{60,-90},{88,-90},{88,-10},{100,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRooSha.fluid, TAirRoo.port) annotation (Line(
      points={{60,40},{88,40},{88,-10},{100,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRooSha.solid, sha.glass_b) annotation (Line(
      points={{40,40},{20,40}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radShaOut.JOut_1, sha.JIn_a) annotation (Line(
      points={{-29,-4},{-20,-4},{-20,44},{-1,44}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, nonSha.JIn_a) annotation (Line(
      points={{-29,-16},{-20,-16},{-20,-86},{-1,-86}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_1, sha.JIn_b) annotation (Line(
      points={{39,-6},{26,-6},{26,36},{21,36}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaInt.JOut_2, nonSha.JIn_b) annotation (Line(
      points={{39,-18},{26,-18},{26,-94},{21,-94}},
      color={0,127,0},
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
      points={{-99,110},{-72,110},{-72,-16},{-52,-16}},
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
  connect(uSha.y, shaCon.u) annotation (Line(
      points={{-139,110},{-122,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.y, hASha.u2) annotation (Line(
      points={{-99,110},{40,110},{40,104},{58,104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, nonSha.QAbs_flow) annotation (Line(
      points={{-139,-110},{10,-110},{10,-101}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, sha.QAbs_flow) annotation (Line(
      points={{-139,-110},{-4,-110},{-4,20},{10,20},{10,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.TOut, TOut.y) annotation (Line(
      points={{-92,-146},{-132,-146},{-132,-30},{-139,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, radOut.TBlaSky) annotation (Line(
      points={{-139,-30},{-132,-30},{-132,-138},{-92,-138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radIn.JIn, sumJ.y)     annotation (Line(
      points={{79,-134},{63.02,-134}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sha.JOut_b, sumJ.u[1])     annotation (Line(
      points={{21,44},{32,44},{32,-131.9},{50,-131.9}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(nonSha.JOut_b, sumJ.u[2])     annotation (Line(
      points={{21,-86},{28,-86},{28,-136.1},{50,-136.1}},
      color={0,127,0},
      smooth=Smooth.None));
    annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/CenterOfGlass.mos"
        "Simulate and plot"),
              Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-160},
            {160,160}}),
                      graphics),
    Documentation(info="<html>
This model tests the heat transfer for the center of the glass, with and without a shading device.
</html>", revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
</ul>
</html>"));
end CenterOfGlass;
