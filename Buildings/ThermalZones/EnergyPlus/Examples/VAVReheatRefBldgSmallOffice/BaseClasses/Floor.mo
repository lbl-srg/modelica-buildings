within Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses;
model Floor "Model of a floor of the building"
  extends
    Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses.PartialFloor;

  final parameter Modelica.SIunits.Area AFloCor=cor.AFlo "Floor area corridor";
  final parameter Modelica.SIunits.Area AFloSou=sou.AFlo "Floor area south";
  final parameter Modelica.SIunits.Area AFloNor=nor.AFlo "Floor area north";
  final parameter Modelica.SIunits.Area AFloEas=eas.AFlo "Floor area east";
  final parameter Modelica.SIunits.Area AFloWes=wes.AFlo "Floor area west";
  final parameter Modelica.SIunits.Area AFlo=AFloCor+AFloSou+AFloNor+AFloEas+AFloWes "Total floor area";


  Modelica.SIunits.Temperature TAirCor = cor.TAir
    "Air temperature corridor";
  Modelica.SIunits.Temperature TAirSou = sou.TAir
    "Air temperature south zone";
  Modelica.SIunits.Temperature TAirNor = nor.TAir
    "Air temperature north zone";
  Modelica.SIunits.Temperature TAirEas = eas.TAir
    "Air temperature east zone";
  Modelica.SIunits.Temperature TAirWes = wes.TAir
    "Air temperature west zone";

  ThermalZone sou(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_1") "South zone"
    annotation (Placement(transformation(extent={{144,-44},{184,-4}})));
  ThermalZone eas(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_2") "East zone"
    annotation (Placement(transformation(extent={{304,56},{344,96}})));
  ThermalZone nor(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_3") "North zone"
    annotation (Placement(transformation(extent={{144,116},{184,156}})));
  ThermalZone wes(
    redeclare package Medium = Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_4") "West zone"
    annotation (Placement(transformation(extent={{12,36},{52,76}})));
  ThermalZone cor(
    redeclare package Medium = Medium,
    nPorts=11,
    zoneName="Core_ZN") "Core zone"
    annotation (Placement(transformation(extent={{144,36},{184,76}})));

  ThermalZone att(
    redeclare package Medium = Medium,
    zoneName="Attic") "Attic zone"
    annotation (Placement(transformation(extent={{310,400},{350,440}})));

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{214,420},{234,440}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{214,460},{234,480}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1 "Multiplex for internal gains"
    annotation (Placement(transformation(extent={{260,420},{280,440}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{214,380},{234,400}})));

protected
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";

  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";

  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=idfName,
    weaName=weaName)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{140,458},{160,478}})));

initial equation
  assert(abs(cor.V-VRooCor) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(sou.V-VRooSou) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(nor.V-VRooNor) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(eas.V-VRooEas) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(wes.V-VRooWes) < 0.01, "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(abs(opeWesCor.wOpe-4) == 0.0, "wOpe in west zone doesn't match");

  Modelica.Utilities.Streams.print(String(leaEas.s)+ ", MG test");
  Modelica.Utilities.Streams.print(String(VRooWes)+ ", MG test");
  Modelica.Utilities.Streams.print(String(opeWesCor.wOpe)+ ", MG test");
  Modelica.Utilities.Streams.print(String(nor.T_start)+ ", MG test");
equation
  connect(gai.y, cor.qGai_flow)          annotation (Line(
      points={{-79,110},{120,110},{120,66},{142,66}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(gai.y, eas.qGai_flow)          annotation (Line(
      points={{-79,110},{226,110},{226,86},{302,86}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(gai.y, wes.qGai_flow)          annotation (Line(
      points={{-79,110},{-14,110},{-14,66},{10,66}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(sou.heaPorAir, temAirSou.port) annotation (Line(
      points={{164,-24},{224,-24},{224,100},{264,100},{264,350},{290,350}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eas.heaPorAir, temAirEas.port) annotation (Line(
      points={{324,76},{286,76},{286,320},{292,320}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nor.heaPorAir, temAirNor.port) annotation (Line(
      points={{164,136},{164,136},{164,290},{292,290}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wes.heaPorAir, temAirWes.port) annotation (Line(
      points={{32,56},{70,56},{70,114},{186,114},{186,258},{292,258}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cor.heaPorAir, temAirPer5.port) annotation (Line(
      points={{164,56},{162,56},{162,228},{294,228}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], portsSou[1]) annotation (Line(
      points={{160.8,-43.1},{114,-43.1},{114,-36},{80,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], portsSou[2]) annotation (Line(
      points={{162.4,-43.1},{124,-43.1},{124,-36},{100,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(eas.ports[1], portsEas[1]) annotation (Line(
      points={{320.8,56.9},{300,56.9},{300,36},{320,36}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(eas.ports[2], portsEas[2]) annotation (Line(
      points={{322.4,56.9},{300,56.9},{300,36},{340,36}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(nor.ports[1], portsNor[1]) annotation (Line(
      points={{160.8,116.9},{114,116.9},{114,124},{80,124}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(nor.ports[2], portsNor[2]) annotation (Line(
      points={{162.4,116.9},{124,116.9},{124,124},{100,124}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wes.ports[1], portsWes[1]) annotation (Line(
      points={{28.8,36.9},{-12,36.9},{-12,44},{-40,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wes.ports[2], portsWes[2]) annotation (Line(
      points={{30.4,36.9},{-2,36.9},{-2,44},{-20,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cor.ports[1], portsCor[1]) annotation (Line(
      points={{160.364,36.9},{114,36.9},{114,46},{80,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cor.ports[2], portsCor[2]) annotation (Line(
      points={{161.091,36.9},{124,36.9},{124,46},{100,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leaSou.port_b, sou.ports[3]) annotation (Line(
      points={{-22,400},{-2,400},{-2,-72},{134,-72},{134,-43.1},{164,-43.1}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaEas.port_b, eas.ports[3]) annotation (Line(
      points={{-22,360},{246,360},{246,56.9},{324,56.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaNor.port_b, nor.ports[3]) annotation (Line(
      points={{-20,320},{138,320},{138,116.9},{164,116.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaWes.port_b, wes.ports[3]) annotation (Line(
      points={{-20,280},{2,280},{2,36.9},{32,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_b1, cor.ports[3]) annotation (Line(
      points={{104,16},{116,16},{116,36.9},{161.818,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_a2, cor.ports[4]) annotation (Line(
      points={{104,4},{116,4},{116,36.9},{162.545,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_a1, sou.ports[4]) annotation (Line(
      points={{84,16},{74,16},{74,-20},{134,-20},{134,-43.1},{165.6,-43.1}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_b2, sou.ports[5]) annotation (Line(
      points={{84,4},{74,4},{74,-20},{134,-20},{134,-43.1},{167.2,-43.1}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_b1, eas.ports[4]) annotation (Line(
      points={{270,54},{290,54},{290,56.9},{325.6,56.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_a2, eas.ports[5]) annotation (Line(
      points={{270,42},{290,42},{290,56.9},{327.2,56.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_a1, cor.ports[5]) annotation (Line(
      points={{250,54},{190,54},{190,34},{142,34},{142,36.9},{163.273,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_b2, cor.ports[6]) annotation (Line(
      points={{250,42},{190,42},{190,34},{142,34},{142,36.9},{164,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_b1, nor.ports[4]) annotation (Line(
      points={{100,90},{124,90},{124,116.9},{165.6,116.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_a2, nor.ports[5]) annotation (Line(
      points={{100,78},{124,78},{124,116.9},{167.2,116.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_a1, cor.ports[7]) annotation (Line(
      points={{80,90},{76,90},{76,60},{142,60},{142,36.9},{164.727,36.9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(opeNorCor.port_b2, cor.ports[8]) annotation (Line(
      points={{80,78},{76,78},{76,60},{142,60},{142,36.9},{165.455,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_b1, cor.ports[9]) annotation (Line(
      points={{40,-4},{56,-4},{56,34},{116,34},{116,36.9},{166.182,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_a2, cor.ports[10]) annotation (Line(
      points={{40,-16},{56,-16},{56,34},{116,34},{116,36.9},{166.909,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_a1, wes.ports[4]) annotation (Line(
      points={{20,-4},{2,-4},{2,36.9},{33.6,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_b2, wes.ports[5]) annotation (Line(
      points={{20,-16},{2,-16},{2,36.9},{35.2,36.9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cor.ports[11], senRelPre.port_a) annotation (Line(
      points={{167.636,36.9},{112,36.9},{112,250},{60,250}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(gaiIntNor.y, nor.qGai_flow) annotation (Line(
      points={{-39,144},{52,144},{52,146},{142,146}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gaiIntSou.y, sou.qGai_flow) annotation (Line(
      points={{-39,-28},{68,-28},{68,-14},{142,-14}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(multiplex3_1.u1[1], qRadGai_flow.y) annotation (Line(points={{258,437},
          {250,437},{250,470},{235,470}}, color={0,0,127}));
  connect(multiplex3_1.u2[1], qConGai_flow.y)
    annotation (Line(points={{258,430},{235,430}}, color={0,0,127}));
  connect(multiplex3_1.u3[1], qLatGai_flow.y) annotation (Line(points={{258,423},
          {258,422},{248,422},{248,390},{235,390}}, color={0,0,127}));
  connect(multiplex3_1.y, att.qGai_flow)
    annotation (Line(points={{281,430},{308,430}}, color={0,0,127}));
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
Model of one floor of the DOE reference office building.
</p>
<h4>Implementation</h4>
<p>
Compared to the base class, which has been built for the models in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a> which are for a larger building,
the instances of
<a href=\"modelica://Buildings.Airflow.Multizone.DoorDiscretizedOpen\">
Buildings.Airflow.Multizone.DoorDiscretizedOpen</a> are made smaller.
Their length has been reduced proportionally
to the difference in length of the walls of the core zone of the two buildings.
See also <a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice\">
Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice</a>
for a description of the differences in these buildings.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 15, 2019, by Milica Grahovac:<br/>
Added extend from a partial floor model.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
</ul>
</html>"));
end Floor;