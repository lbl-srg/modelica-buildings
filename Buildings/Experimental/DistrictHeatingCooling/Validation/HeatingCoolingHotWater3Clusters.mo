within Buildings.Experimental.DistrictHeatingCooling.Validation;
model HeatingCoolingHotWater3Clusters
  "Validation model for a system with three clusters of buildings"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 3*2E6
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+12
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+16
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";
  Plants.Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    TSetHeaLea=TSetHeaLea,
    TSetCooLea=TSetCooLea) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-520,130},{-500,150}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(redeclare package Medium = Medium,
      nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-540,-10})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-488,130},{-468,150}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-470,10},{-490,30}})));
  Buildings.Fluid.FixedResistances.Pipe pip2(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Fluid.FixedResistances.Pipe pip3(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{160,10},{140,30}})));
  Buildings.Fluid.FixedResistances.Pipe pip4(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Fluid.FixedResistances.Pipe pip5(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{160,-210},{140,-190}})));
  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT hos(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgHospitalNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Hospital"
    annotation (Placement(transformation(extent={{-420,60},{-380,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff1(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret1(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff2(
      redeclare package Medium = Medium,
      filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{-60,60},{-20,100}})));
  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT apa1(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgMidriseApartmentNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Midrise apartment"
    annotation (Placement(transformation(extent={{220,60},{260,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT sch(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgPrimarySchoolNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Primary school"
    annotation (Placement(transformation(extent={{360,60},{400,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff3(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15,
    show_T=true) "Large office"
    annotation (Placement(transformation(extent={{500,60},{540,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT apa2(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgMidriseApartmentNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Midrise apartment"
    annotation (Placement(transformation(extent={{220,-160},{260,-120}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret2(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{360,-160},{400,-120}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
      computeWetBulbTemperature=false) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-540,180},{-520,200}})));
equation

  connect(pla.port_b, pip.port_a) annotation (Line(points={{-500,140},{-492,140},
          {-488,140}},   color={0,127,255}));
  connect(pla.port_a, pip1.port_b) annotation (Line(points={{-520,140},{-540,
          140},{-540,20},{-490,20}},
                           color={0,127,255}));
  connect(pSet.ports[1], pip1.port_b) annotation (Line(points={{-540,0},{-540,
          20},{-490,20}},
                      color={0,127,255}));
  connect(pip2.port_a, pip.port_b)
    annotation (Line(points={{140,140},{140,140},{-468,140}},
                                                 color={0,127,255}));
  connect(pip3.port_b, pip1.port_a) annotation (Line(points={{140,20},{140,20},
          {-470,20}}, color={0,127,255}));
  connect(pip4.port_a, pip.port_b) annotation (Line(points={{140,-80},{100,-80},
          {100,140},{-468,140}},        color={0,127,255}));
  connect(pip5.port_b, pip1.port_a) annotation (Line(points={{140,-200},{60,
          -200},{60,20},{-470,20}},
                                color={0,127,255}));
  connect(weaDat.weaBus, hos.weaBus) annotation (Line(
      points={{-520,190},{-476,190},{-400,190},{-400,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, larOff1.weaBus) annotation (Line(
      points={{-520,190},{-406,190},{-280,190},{-280,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, ret1.weaBus) annotation (Line(
      points={{-520,190},{-346,190},{-160,190},{-160,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus,larOff2. weaBus) annotation (Line(
      points={{-520,190},{-186,190},{-40,190},{-40,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, apa1.weaBus) annotation (Line(
      points={{-520,190},{-94,190},{240,190},{240,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sch.weaBus) annotation (Line(
      points={{-520,190},{380,190},{380,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, larOff3.weaBus) annotation (Line(
      points={{-520,190},{10,190},{520,190},{520,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, apa2.weaBus) annotation (Line(
      points={{-520,190},{-222,190},{120,190},{120,-44},{240,-44},{240,-123.286}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, ret2.weaBus) annotation (Line(
      points={{-520,190},{-196,190},{120,190},{120,-44},{380,-44},{380,-123.286}},
      color={255,204,51},
      thickness=0.5));
  connect(hos.port_a, pip.port_b) annotation (Line(points={{-420,80},{-440,80},
          {-440,140},{-468,140}}, color={0,127,255}));
  connect(hos.port_b, pip1.port_a) annotation (Line(points={{-380.143,80},{-360,
          80},{-360,20},{-470,20}}, color={0,127,255}));
  connect(larOff1.port_a, pip.port_b) annotation (Line(points={{-300,80},{-320,
          80},{-320,140},{-468,140}}, color={0,127,255}));
  connect(ret1.port_a, pip.port_b) annotation (Line(points={{-180,80},{-200,80},
          {-200,140},{-468,140}}, color={0,127,255}));
  connect(larOff2.port_a, pip.port_b) annotation (Line(points={{-60,80},{-80,80},
          {-80,140},{-468,140}}, color={0,127,255}));
  connect(larOff1.port_b, pip1.port_a) annotation (Line(points={{-260.143,80},{
          -240,80},{-240,20},{-470,20}}, color={0,127,255}));
  connect(ret1.port_b, pip1.port_a) annotation (Line(points={{-140.143,80},{
          -120,80},{-120,20},{-470,20}}, color={0,127,255}));
  connect(larOff2.port_b, pip1.port_a) annotation (Line(points={{-20.1429,80},{
          0,80},{0,20},{-470,20}}, color={0,127,255}));
  connect(pip2.port_b, apa1.port_a) annotation (Line(points={{160,140},{180,140},
          {200,140},{200,80},{220,80}}, color={0,127,255}));
  connect(pip2.port_b, sch.port_a) annotation (Line(points={{160,140},{240,140},
          {340,140},{340,80},{360,80}}, color={0,127,255}));
  connect(pip2.port_b, larOff3.port_a) annotation (Line(points={{160,140},{328,
          140},{480,140},{480,80},{500,80}}, color={0,127,255}));
  connect(pip3.port_a, apa1.port_b) annotation (Line(points={{160,20},{220,20},
          {280,20},{280,80},{259.857,80}}, color={0,127,255}));
  connect(pip3.port_a, sch.port_b) annotation (Line(points={{160,20},{420,20},{
          420,80},{399.857,80}}, color={0,127,255}));
  connect(pip3.port_a, larOff3.port_b) annotation (Line(points={{160,20},{346,
          20},{560,20},{560,80},{539.857,80}}, color={0,127,255}));
  connect(pip4.port_b, apa2.port_a) annotation (Line(points={{160,-80},{200,-80},
          {200,-140},{220,-140}}, color={0,127,255}));
  connect(pip4.port_b, ret2.port_a) annotation (Line(points={{160,-80},{248,-80},
          {340,-80},{340,-140},{360,-140}}, color={0,127,255}));
  connect(pip5.port_a, apa2.port_b) annotation (Line(points={{160,-200},{280,
          -200},{280,-140},{259.857,-140}}, color={0,127,255}));
  connect(pip5.port_a, ret2.port_b) annotation (Line(points={{160,-200},{270,
          -200},{420,-200},{420,-140},{399.857,-140}}, color={0,127,255}));
  annotation(experiment(StopTime=2.6784e+06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Validation/HeatingCoolingHotWater3Clusters.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal anergy heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-580,-260},{
            580,220}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HeatingCoolingHotWater3Clusters;
