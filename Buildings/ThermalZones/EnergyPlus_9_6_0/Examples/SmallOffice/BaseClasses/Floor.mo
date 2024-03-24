within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.BaseClasses;
model Floor
  "Model of a floor of the building"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(
    VRooCor=456.455,
    VRooSou=346.022,
    VRooNor=346.022,
    VRooEas=205.265,
    VRooWes=205.265,
    AFloCor=cor.AFlo,
    AFloSou=sou.AFlo,
    AFloNor=nor.AFlo,
    AFloEas=eas.AFlo,
    AFloWes=wes.AFlo,
    opeWesCor(
      wOpe=4),
    opeSouCor(
      wOpe=9),
    opeNorCor(
      wOpe=9),
    opeEasCor(
      wOpe=4),
    leaWes(
      s=18.46/27.69),
    leaSou(
      s=27.69/18.46),
    leaNor(
      s=27.69/18.46),
    leaEas(
      s=18.46/27.69));

  final parameter Modelica.Units.SI.Area AFlo=AFloCor + AFloSou + AFloNor +
      AFloEas + AFloWes "Total floor area";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSou
    "Heat port to air volume South"
    annotation (Placement(transformation(extent={{106,-46},{126,-26}}),iconTransformation(extent={{128,-36},{148,-16}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorEas
    "Heat port to air volume East"
    annotation (Placement(transformation(extent={{320,42},{340,62}}),iconTransformation(extent={{318,64},{338,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorNor
    "Heat port to air volume North"
    annotation (Placement(transformation(extent={{106,114},{126,134}}),iconTransformation(extent={{126,106},{146,126}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWes
    "Heat port to air volume West"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}}),iconTransformation(extent={{-36,64},{-16,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorCor
    "Heat port to air volume corridor"
    annotation (Placement(transformation(extent={{106,36},{126,56}}),iconTransformation(extent={{130,38},{150,58}})));
  Modelica.Units.SI.Temperature TAirCor=cor.TAir "Air temperature corridor";
  Modelica.Units.SI.Temperature TAirSou=sou.TAir "Air temperature south zone";
  Modelica.Units.SI.Temperature TAirNor=nor.TAir "Air temperature north zone";
  Modelica.Units.SI.Temperature TAirEas=eas.TAir "Air temperature east zone";
  Modelica.Units.SI.Temperature TAirWes=wes.TAir "Air temperature west zone";
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone sou(
    redeclare package Medium=Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_1")
    "South zone"
    annotation (Placement(transformation(extent={{144,-44},{184,-4}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone eas(
    redeclare package Medium=Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_2")
    "East zone"
    annotation (Placement(transformation(extent={{300,68},{340,108}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone nor(
    redeclare package Medium=Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_3")
    "North zone"
    annotation (Placement(transformation(extent={{144,116},{184,156}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone wes(
    redeclare package Medium=Medium,
    nPorts=5,
    zoneName="Perimeter_ZN_4")
    "West zone"
    annotation (Placement(transformation(extent={{12,58},{52,98}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone cor(
    redeclare package Medium=Medium,
    nPorts=11,
    zoneName="Core_ZN")
    "Core zone"
    annotation (Placement(transformation(extent={{144,60},{184,100}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone att(
    redeclare package Medium=Medium,
    zoneName="Attic",
    T_start=275.15)
    "Attic zone"
    annotation (Placement(transformation(extent={{300,-60},{340,-20}})));

  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String epwName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";
  parameter String weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";

protected
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=idfName,
    epwName=epwName,
    weaName=weaName,
    computeWetBulbTemperature=false)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{140,460},{160,480}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGai_flow[3](
    k={0,0,0})
    "Internal heat gain (computed already in EnergyPlus)"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

initial equation
  assert(
    abs(
      cor.V-VRooCor) < 0.01,
    "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(
    abs(
      sou.V-VRooSou) < 0.01,
    "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(
    abs(
      nor.V-VRooNor) < 0.01,
    "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(
    abs(
      eas.V-VRooEas) < 0.01,
    "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");
  assert(
    abs(
      wes.V-VRooWes) < 0.01,
    "Volumes don't match. These had to be entered manually to avoid using a non-literal value.");

  // Other models may override the assignment for AFlo. Hence we check below for consistency.
  assert(
    abs(
      cor.AFlo-AFloCor) < 0.01,
    "Areas don't match. Make sure model that overrides these parameter defaults uses the same values as the idf file uses.");
  assert(
    abs(
      sou.AFlo-AFloSou) < 0.01,
    "Areas don't match. Make sure model that overrides these parameter defaults uses the same values as the idf file uses.");
  assert(
    abs(
      nor.AFlo-AFloNor) < 0.01,
    "Areas don't match. Make sure model that overrides these parameter defaults uses the same values as the idf file uses.");
  assert(
    abs(
      eas.AFlo-AFloEas) < 0.01,
    "Areas don't match. Make sure model that overrides these parameter defaults uses the same values as the idf file uses.");
  assert(
    abs(
      wes.AFlo-AFloWes) < 0.01,
    "Areas don't match. Make sure model that overrides these parameter defaults uses the same values as the idf file uses.");

equation
  connect(sou.heaPorAir,temAirSou.port)
    annotation (Line(points={{164,-24},{224,-24},{224,100},{264,100},{264,350},{290,350}},color={191,0,0},smooth=Smooth.None));
  connect(eas.heaPorAir,temAirEas.port)
    annotation (Line(points={{320,88},{286,88},{286,320},{292,320}},color={191,0,0},smooth=Smooth.None));
  connect(nor.heaPorAir,temAirNor.port)
    annotation (Line(points={{164,136},{164,136},{164,290},{292,290}},color={191,0,0},smooth=Smooth.None));
  connect(wes.heaPorAir,temAirWes.port)
    annotation (Line(points={{32,78},{70,78},{70,114},{186,114},{186,258},{292,258}},color={191,0,0},smooth=Smooth.None));
  connect(cor.heaPorAir,temAirCor.port)
    annotation (Line(points={{164,80},{164,228},{294,228}},color={191,0,0},smooth=Smooth.None));
  connect(sou.ports[1],portsSou[1])
    annotation (Line(points={{160.8,-43.1},{164,-43.1},{164,-54},{86,-54},{86,-36},
          {80,-36}},                                                                         color={0,127,255},smooth=Smooth.None));
  connect(sou.ports[2],portsSou[2])
    annotation (Line(points={{162.4,-43.1},{164,-43.1},{164,-54},{86,-54},{86,-36},
          {100,-36}},                                                                         color={0,127,255},smooth=Smooth.None));
  connect(eas.ports[1],portsEas[1])
    annotation (Line(points={{316.8,68.9},{300,68.9},{300,36},{320,36}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(eas.ports[2],portsEas[2])
    annotation (Line(points={{318.4,68.9},{300,68.9},{300,36},{340,36}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(nor.ports[1],portsNor[1])
    annotation (Line(points={{160.8,116.9},{164,116.9},{164,106},{88,106},{88,124},
          {80,124}},                                                                         color={0,127,255},smooth=Smooth.None));
  connect(nor.ports[2],portsNor[2])
    annotation (Line(points={{162.4,116.9},{164,116.9},{164,106},{88,106},{88,124},
          {100,124}},                                                                         color={0,127,255},smooth=Smooth.None));
  connect(wes.ports[1],portsWes[1])
    annotation (Line(points={{28.8,58.9},{30,58.9},{30,44},{-40,44}},color={0,127,255},smooth=Smooth.None));
  connect(wes.ports[2],portsWes[2])
    annotation (Line(points={{30.4,58.9},{-2,58.9},{-2,44},{-20,44}},color={0,127,255},smooth=Smooth.None));
  connect(cor.ports[1],portsCor[1])
    annotation (Line(points={{160.364,60.9},{164,60.9},{164,26},{90,26},{90,46},
          {80,46}},                                                                      color={0,127,255},smooth=Smooth.None));
  connect(cor.ports[2],portsCor[2])
    annotation (Line(points={{161.091,60.9},{164,60.9},{164,26},{90,26},{90,46},
          {100,46}},                                                                      color={0,127,255},smooth=Smooth.None));
  connect(leaSou.port_b,sou.ports[3])
    annotation (Line(points={{-22,400},{-2,400},{-2,-72},{134,-72},{134,-54},{164,-54},{164,-43.1}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(leaEas.port_b,eas.ports[3])
    annotation (Line(points={{-22,360},{246,360},{246,68.9},{320,68.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(leaNor.port_b,nor.ports[3])
    annotation (Line(points={{-20,320},{138,320},{138,116.9},{164,116.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(leaWes.port_b,wes.ports[3])
    annotation (Line(points={{-20,280},{2,280},{2,58.9},{32,58.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_b1,cor.ports[3])
    annotation (Line(points={{104,16},{164,16},{164,34},{161.818,34},{161.818,
          60.9}},                                                                    color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_a2,cor.ports[4])
    annotation (Line(points={{104,4},{164,4},{164,60.9},{162.545,60.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_a1,sou.ports[4])
    annotation (Line(points={{84,16},{74,16},{74,-20},{134,-20},{134,-54},{162,-54},
          {162,-46},{164,-46},{164,-43.1},{165.6,-43.1}},                                                                          color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_b2,sou.ports[5])
    annotation (Line(points={{84,4},{74,4},{74,-20},{134,-20},{134,-54},{164,-54},
          {164,-43.1},{167.2,-43.1}},                                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_b1,eas.ports[4])
    annotation (Line(points={{270,54},{290,54},{290,68.9},{321.6,68.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_a2,eas.ports[5])
    annotation (Line(points={{270,42},{290,42},{290,68.9},{323.2,68.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_a1,cor.ports[5])
    annotation (Line(points={{250,54},{190,54},{190,34},{142,34},{142,60.9},{
          163.273,60.9}},                                                                   color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_b2,cor.ports[6])
    annotation (Line(points={{250,42},{190,42},{190,34},{142,34},{142,60.9},{164,60.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeNorCor.port_b1,nor.ports[4])
    annotation (Line(points={{100,90},{108,90},{108,106},{164,106},{164,116.9},{
          165.6,116.9}},                                                                      color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeNorCor.port_a2,nor.ports[5])
    annotation (Line(points={{100,78},{108,78},{108,106},{164,106},{164,116.9},{
          167.2,116.9}},                                                                      color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeNorCor.port_a1,cor.ports[7])
    annotation (Line(points={{80,90},{76,90},{76,60},{142,60},{142,60.9},{
          164.727,60.9}},                                                                color={0,127,255},smooth=Smooth.None));
  connect(opeNorCor.port_b2,cor.ports[8])
    annotation (Line(points={{80,78},{76,78},{76,60},{142,60},{142,60.9},{
          165.455,60.9}},                                                                color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_b1,cor.ports[9])
    annotation (Line(points={{40,-4},{56,-4},{56,26},{164,26},{164,36},{166.182,
          36},{166.182,60.9}},                                                                      color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_a2,cor.ports[10])
    annotation (Line(points={{40,-16},{56,-16},{56,26},{164,26},{164,60.9},{
          166.909,60.9}},                                                                  color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_a1,wes.ports[4])
    annotation (Line(points={{20,-4},{14,-4},{14,44},{30,44},{30,58.9},{33.6,58.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_b2,wes.ports[5])
    annotation (Line(points={{20,-16},{14,-16},{14,44},{30,44},{30,58.9},{35.2,58.9}},color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(cor.ports[11],senRelPre.port_a)
    annotation (Line(points={{167.636,60.9},{164,60.9},{164,24},{128,24},{128,
          250},{60,250}},                                                                    color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(sou.qGai_flow,qGai_flow.y)
    annotation (Line(points={{142,-14},{64,-14},{64,-30},{-118,-30}},color={0,0,127}));
  connect(wes.qGai_flow,qGai_flow.y)
    annotation (Line(points={{10,88},{-60,88},{-60,-30},{-118,-30}},color={0,0,127}));
  connect(eas.qGai_flow,qGai_flow.y)
    annotation (Line(points={{298,98},{200,98},{200,110},{-60,110},{-60,-30},{-118,-30}},color={0,0,127}));
  connect(cor.qGai_flow,qGai_flow.y)
    annotation (Line(points={{142,90},{130,90},{130,110},{-60,110},{-60,-30},{-118,-30}},color={0,0,127}));
  connect(nor.qGai_flow,qGai_flow.y)
    annotation (Line(points={{142,146},{-60,146},{-60,-30},{-118,-30}},color={0,0,127}));
  connect(att.qGai_flow,qGai_flow.y)
    annotation (Line(points={{298,-30},{240,-30},{240,-80},{-60,-80},{-60,-30},{-118,-30}},color={0,0,127}));
  connect(sou.heaPorAir,heaPorSou)
    annotation (Line(points={{164,-24},{140,-24},{140,-36},{116,-36}},color={191,0,0}));
  connect(eas.heaPorAir,heaPorEas)
    annotation (Line(points={{320,88},{330,88},{330,52}},color={191,0,0}));
  connect(nor.heaPorAir,heaPorNor)
    annotation (Line(points={{164,136},{116,136},{116,124}},color={191,0,0}));
  connect(wes.heaPorAir,heaPorWes)
    annotation (Line(points={{32,78},{-30,78},{-30,66}},color={191,0,0}));
  connect(cor.heaPorAir,heaPorCor)
    annotation (Line(points={{164,80},{116,80},{116,46}},color={191,0,0}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-160,-100},{380,500}},
        initialScale=0.1)),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-80,-80},{380,180}}),
      graphics={
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
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Model of a floor that consists
of five thermal zones.
</p>
<p>
The five room model is representative of one floor of the
new construction small office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks
(Deru et al, 2009). There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
</p>
<p>
Each thermal zone can have air flow from the HVAC system,
through leakages of the building envelope (except for the core zone)
and through bi-directional air exchange through open doors that connect adjacent zones.
The bi-directional air exchange is modeled based on the differences in
static pressure between adjacent rooms at a reference height plus the
difference in static pressure across the door height as a function of the difference in air density.
Infiltration is a function of the
flow imbalance of the HVAC system.
</p>
<h4>Implementation</h4>
<p>
Compared to the base class, which has been built for the models in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a> which are for a larger building,
the instances of
<a href=\"modelica://Buildings.Airflow.Multizone.DoorOpen\">
Buildings.Airflow.Multizone.DoorOpen</a> are made smaller.
Their length has been reduced proportionally
to the difference in length of the walls of the core zone of the two buildings.
See also <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice</a>
for a description of the differences in these buildings.
</p>
<h4>References</h4>
<p>
Deru M., K. Field, D. Studer, K. Benne, B. Griffith, P. Torcellini,
 M. Halverson, D. Winiarski, B. Liu, M. Rosenberg, J. Huang, M. Yazdanian, and D. Crawley.
<i>DOE commercial building research benchmarks for commercial buildings</i>.
Technical report, U.S. Department of Energy, Energy Efficiency and
Renewable Energy, Office of Building Technologies, Washington, DC, 2009.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 23, 2024, by Michael Wetter:<br/>
Corrected wrong annotation.
</li>
<li>
February 16, 2022, by Michael Wetter:<br/>
Removed assertion on <code>opeWesCor.wOpe</code> as there is no need to enforce this width.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
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
