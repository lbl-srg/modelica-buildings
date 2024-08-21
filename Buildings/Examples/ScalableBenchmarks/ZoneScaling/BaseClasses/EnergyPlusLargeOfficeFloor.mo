within Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses;
model EnergyPlusLargeOfficeFloor
  "Model of a single floor of a large office building using EnergyPlus envelope models"
  parameter Integer floId "Floor id";

  extends Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(
      final VRooSou=861.86,
      final VRooEas=546.523,
      final VRooNor=861.295,
      final VRooWes=555.389,
      final VRooCor=6964.62,
      final AFloCor=cor.AFlo,
      final AFloSou=sou.AFlo,
      final AFloNor=nor.AFlo,
      final AFloEas=eas.AFlo,
      final AFloWes=wes.AFlo,
      opeWesCor(wOpe=4),
      opeSouCor(wOpe=9),
      opeNorCor(wOpe=9),
      opeEasCor(wOpe=4),
      leaWes(s=18.46/27.69),
      leaSou(s=27.69/18.46),
      leaNor(s=27.69/18.46),
      leaEas(s=18.46/27.69));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSou
    "Heat port to air volume South"
    annotation (Placement(transformation(extent={{106,-46},{126,-26}}),
        iconTransformation(extent={{128,-36},{148,-16}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorEas
    "Heat port to air volume East"
    annotation (Placement(transformation(extent={{320,42},{340,62}}),
        iconTransformation(extent={{318,64},{338,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorNor
    "Heat port to air volume North"
    annotation (Placement(transformation(extent={{106,114},{126,134}}),
        iconTransformation(extent={{126,106},{146,126}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWes
    "Heat port to air volume West"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}}),
        iconTransformation(extent={{-36,64},{-16,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorCor
    "Heat port to air volume Core"
    annotation (Placement(transformation(extent={{106,36},{126,56}}),
        iconTransformation(extent={{130,38},{150,58}})));

  Modelica.Units.SI.Temperature TAirCor = cor.TAir
    "Air temperature core";
  Modelica.Units.SI.Temperature TAirSou = sou.TAir
    "Air temperature south zone";
  Modelica.Units.SI.Temperature TAirNor = nor.TAir
    "Air temperature north zone";
  Modelica.Units.SI.Temperature TAirEas = eas.TAir
    "Air temperature east zone";
  Modelica.Units.SI.Temperature TAirWes = wes.TAir
    "Air temperature west zone";

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone sou(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_fl" + String(floId) + "_ZN_1") "South zone"
    annotation (Placement(transformation(extent={{144,-44},{184,-4}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone eas(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_fl" + String(floId) + "_ZN_2") "East zone"
    annotation (Placement(transformation(extent={{300,68},{340,108}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone nor(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_fl" + String(floId) + "_ZN_3") "North zone"
    annotation (Placement(transformation(extent={{144,116},{184,156}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone wes(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_fl" + String(floId) + "_ZN_4") "West zone"
    annotation (Placement(transformation(extent={{12,58},{52,98}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone cor(
    redeclare package Medium = Medium,
    nPorts=11,
    zoneName="Core_fl" + String(floId)) "Core zone"
    annotation (Placement(transformation(extent={{144,60},{184,100}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone att(
    redeclare package Medium = Medium,
    zoneName="Plenum_fl" + String(floId),
    T_start=275.15) "Attic zone"
    annotation (Placement(transformation(extent={{300,-60},{340,-20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant qGai_flow[3](k={0, 0, 0})
    "Internal heat gain (computed already in EnergyPlus"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

initial equation
  assert(abs(cor.V-VRooCor) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(sou.V-VRooSou) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(nor.V-VRooNor) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(eas.V-VRooEas) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(wes.V-VRooWes) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(opeWesCor.wOpe-4) < 0.01, "wOpe in west zone doesn't match");

equation
  connect(sou.heaPorAir, temAirSou.port) annotation (Line(
      points={{164,-24},{224,-24},{224,100},{264,100},{264,350},{290,350}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eas.heaPorAir, temAirEas.port) annotation (Line(
      points={{320,88},{286,88},{286,320},{292,320}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nor.heaPorAir, temAirNor.port) annotation (Line(
      points={{164,136},{164,136},{164,290},{292,290}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wes.heaPorAir, temAirWes.port) annotation (Line(
      points={{32,78},{70,78},{70,114},{186,114},{186,258},{292,258}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cor.heaPorAir, temAirCor.port) annotation (Line(
      points={{164,80},{164,228},{294,228}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], portsSou[1]) annotation (Line(
      points={{162.4,-43.1},{164,-43.1},{164,-54},{86,-54},{86,-36},{85,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], portsSou[2]) annotation (Line(
      points={{163.2,-43.1},{164,-43.1},{164,-54},{86,-54},{86,-36},{95,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(eas.ports[1], portsEas[1]) annotation (Line(
      points={{318.4,68.9},{300,68.9},{300,36},{325,36}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(eas.ports[2], portsEas[2]) annotation (Line(
      points={{319.2,68.9},{300,68.9},{300,36},{335,36}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(nor.ports[1], portsNor[1]) annotation (Line(
      points={{162.4,116.9},{164,116.9},{164,106},{88,106},{88,124},{85,124}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(nor.ports[2], portsNor[2]) annotation (Line(
      points={{163.2,116.9},{164,116.9},{164,106},{88,106},{88,124},{95,124}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wes.ports[1], portsWes[1]) annotation (Line(
      points={{30.4,58.9},{30,58.9},{30,44},{-35,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wes.ports[2], portsWes[2]) annotation (Line(
      points={{31.2,58.9},{-2,58.9},{-2,44},{-25,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cor.ports[1], portsCor[1]) annotation (Line(
      points={{162.182,60.9},{164,60.9},{164,26},{90,26},{90,46},{85,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cor.ports[2], portsCor[2]) annotation (Line(
      points={{162.545,60.9},{164,60.9},{164,26},{90,26},{90,46},{95,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leaSou.port_b, sou.ports[3]) annotation (Line(
      points={{-22,400},{-2,400},{-2,-72},{134,-72},{134,-54},{164,-54},{164,-43.1}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaEas.port_b, eas.ports[3]) annotation (Line(
      points={{-22,360},{246,360},{246,68.9},{320,68.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaNor.port_b, nor.ports[3]) annotation (Line(
      points={{-20,320},{138,320},{138,116.9},{164,116.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaWes.port_b, wes.ports[3]) annotation (Line(
      points={{-20,280},{2,280},{2,58.9},{32,58.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_b1, cor.ports[3]) annotation (Line(
      points={{104,16},{164,16},{164,34},{162.909,34},{162.909,60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_a2, cor.ports[4]) annotation (Line(
      points={{104,4},{164,4},{164,60.9},{163.273,60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_a1, sou.ports[4]) annotation (Line(
      points={{84,16},{74,16},{74,-20},{134,-20},{134,-54},{162,-54},{162,-46},
          {164,-46},{164,-43.1},{164.8,-43.1}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_b2, sou.ports[5]) annotation (Line(
      points={{84,4},{74,4},{74,-20},{134,-20},{134,-54},{164,-54},{164,-43.1},
          {165.6,-43.1}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_b1, eas.ports[4]) annotation (Line(
      points={{270,54},{290,54},{290,68.9},{320.8,68.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_a2, eas.ports[5]) annotation (Line(
      points={{270,42},{290,42},{290,68.9},{321.6,68.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_a1, cor.ports[5]) annotation (Line(
      points={{250,54},{190,54},{190,34},{142,34},{142,60.9},{163.636,60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_b2, cor.ports[6]) annotation (Line(
      points={{250,42},{190,42},{190,34},{142,34},{142,60.9},{164,60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_b1, nor.ports[4]) annotation (Line(
      points={{100,90},{108,90},{108,106},{164,106},{164,116.9},{164.8,116.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_a2, nor.ports[5]) annotation (Line(
      points={{100,78},{108,78},{108,106},{164,106},{164,116.9},{165.6,116.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_a1, cor.ports[7]) annotation (Line(
      points={{80,90},{76,90},{76,60},{142,60},{142,60.9},{164.364,60.9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(opeNorCor.port_b2, cor.ports[8]) annotation (Line(
      points={{80,78},{76,78},{76,60},{142,60},{142,60.9},{164.727,60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_b1, cor.ports[9]) annotation (Line(
      points={{40,-4},{56,-4},{56,26},{164,26},{164,36},{165.091,36},{165.091,
          60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_a2, cor.ports[10]) annotation (Line(
      points={{40,-16},{56,-16},{56,26},{164,26},{164,60.9},{165.455,60.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_a1, wes.ports[4]) annotation (Line(
      points={{20,-4},{14,-4},{14,44},{30,44},{30,58.9},{32.8,58.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_b2, wes.ports[5]) annotation (Line(
      points={{20,-16},{14,-16},{14,44},{30,44},{30,58.9},{33.6,58.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cor.ports[11], senRelPre.port_a) annotation (Line(
      points={{165.818,60.9},{164,60.9},{164,24},{128,24},{128,250},{60,250}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(sou.qGai_flow, qGai_flow.y) annotation (Line(points={{142,-14},{64,
          -14},{64,-30},{-118,-30}}, color={0,0,127}));
  connect(wes.qGai_flow, qGai_flow.y) annotation (Line(points={{10,88},{-60,88},
          {-60,-30},{-118,-30}}, color={0,0,127}));
  connect(eas.qGai_flow, qGai_flow.y) annotation (Line(points={{298,98},{200,98},
          {200,110},{-60,110},{-60,-30},{-118,-30}}, color={0,0,127}));
  connect(cor.qGai_flow, qGai_flow.y) annotation (Line(points={{142,90},{130,90},
          {130,110},{-60,110},{-60,-30},{-118,-30}}, color={0,0,127}));
  connect(nor.qGai_flow, qGai_flow.y) annotation (Line(points={{142,146},{-60,
          146},{-60,-30},{-118,-30}}, color={0,0,127}));
  connect(att.qGai_flow, qGai_flow.y) annotation (Line(points={{298,-30},{240,
          -30},{240,-80},{-60,-80},{-60,-30},{-118,-30}}, color={0,0,127}));
  connect(sou.heaPorAir, heaPorSou) annotation (Line(points={{164,-24},{140,-24},
          {140,-36},{116,-36}}, color={191,0,0}));
  connect(eas.heaPorAir, heaPorEas)
    annotation (Line(points={{320,88},{330,88},{330,52}}, color={191,0,0}));
  connect(nor.heaPorAir, heaPorNor)
    annotation (Line(points={{164,136},{116,136},{116,124}}, color={191,0,0}));
  connect(wes.heaPorAir, heaPorWes)
    annotation (Line(points={{32,78},{-30,78},{-30,66}}, color={191,0,0}));
  connect(cor.heaPorAir, heaPorCor)
    annotation (Line(points={{164,80},{116,80},{116,46}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
        extent={{-160,-100},{380,500}},
        initialScale=0.1)),     Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-80,-80},{380,180}}),   graphics={
        Rectangle(
          extent={{-80,-80},{380,180}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,160},{360,-60}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{0,-80},{294,-60}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-74},{294,-66}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,8},{294,100}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,88},{280,22}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-56,170},{20,94},{12,88},{-62,162},{-56,170}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{290,16},{366,-60},{358,-66},{284,8},{290,16}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{284,96},{360,168},{368,162},{292,90},{284,96}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,120},{-60,-20}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,120},{-66,-20}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-64,-56},{18,22},{26,16},{-58,-64},{-64,-56}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{360,122},{380,-18}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{366,122},{374,-18}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,170},{296,178}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,160},{296,180}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,166},{296,174}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
          Bitmap(extent={{192,-58},{342,-18}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxmedres.png",
          visible=not usePrecompiledFMU)}),
    Documentation(info="<html>
<p>
Model of a large office floor composed of 5 thermal zones based on
the reference large office building.<br/>
The exterior envelope construction is representative of the New (2004)
construction reference for the climate zone 5A (Chicago).<br/>
The envelope heat transfer is modeled with EnergyPlus.
</p>
<h4>References</h4>
<p>
Deru, M. et al. (2011). U.S. Department of Energy Commercial
Reference Building Models of the National Building Stock. 
<i>NREL</i>, TP-5500-46861.
https://www.nrel.gov/docs/fy11osti/46861.pdf.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyPlusLargeOfficeFloor;
