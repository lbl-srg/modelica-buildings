within Buildings.Experimental.DistrictHeatingCooling.Examples.BaseClasses;
partial model HeatingCoolingHotWater3Clusters
  "Load models for Buildings.Experimental.DistrictHeatingCooling.Examples.HeatingCoolingHotWater3Clusters"
  package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.Temperature TChiSup_nominal = 273.15 + 16
    "Chilled water leaving temperature at the evaporator"
     annotation (Dialog(group="Nominal conditions"));

  parameter Modelica.SIunits.Temperature THeaSup_nominal = 273.15+30
    "Supply temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaRet_nominal = 273.15+25
    "Return temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff1(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret1(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff2(
      redeclare package Medium = Medium,
      filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{-60,60},{-20,100}})));
  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT apa1(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgMidriseApartmentNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Midrise apartment"
    annotation (Placement(transformation(extent={{220,60},{260,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff3(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{360,60},{400,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff4(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    show_T=true,
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{500,60},{540,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT apa2(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgMidriseApartmentNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Midrise apartment"
    annotation (Placement(transformation(extent={{220,-160},{260,-120}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret2(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    final TChiSup_nominal=TChiSup_nominal,
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{360,-160},{400,-120}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      computeWetBulbTemperature=false) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-400,180},{-380,200}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
     annotation (Placement(
        transformation(extent={{-348,182},{-332,198}}), iconTransformation(
          extent={{-328,64},{-308,84}})));

  Modelica.Blocks.Math.MultiSum PHea(nu=16)
    "Electrical energy use for space heating and hot water"
    annotation (Placement(transformation(extent={{604,364},{616,376}})));
  Modelica.Blocks.Math.MultiSum PCoo(nu=8) "Electrical energy use for cooling"
    annotation (Placement(transformation(extent={{604,324},{616,336}})));
  Modelica.Blocks.Continuous.Integrator EEleHea(y(unit="J"))
    "Electrical energy for space heating and hot water"
    annotation (Placement(transformation(extent={{640,360},{660,380}})));
  Modelica.Blocks.Continuous.Integrator EEleCoo(y(unit="J"))
    "Electrical energy for cooling"
    annotation (Placement(transformation(extent={{640,320},{660,340}})));
  Modelica.Blocks.Math.MultiSum QHea(nu=8)
    "Thermal energy use for space heating"
    annotation (Placement(transformation(extent={{604,284},{616,296}})));
  Modelica.Blocks.Math.MultiSum QHotWat(nu=8)
    "Thermal energy use for hot water"
    annotation (Placement(transformation(extent={{604,244},{616,256}})));
  Modelica.Blocks.Math.MultiSum QCoo(nu=8) "Thermal energy use for cooling"
    annotation (Placement(transformation(extent={{604,204},{616,216}})));
  Modelica.Blocks.Continuous.Integrator ETheHea(y(unit="J"))
    "Thermal energy for space heating"
    annotation (Placement(transformation(extent={{640,280},{660,300}})));
  Modelica.Blocks.Continuous.Integrator ETheHotWat(y(unit="J"))
    "Thermal energy for hot water"
    annotation (Placement(transformation(extent={{640,240},{660,260}})));
  Modelica.Blocks.Continuous.Integrator ETheCoo(y(unit="J"))
    "Thermal energy for cooling"
    annotation (Placement(transformation(extent={{640,200},{660,220}})));

  Modelica.Blocks.Sources.RealExpression SPFHea(y=(ETheHea.y + ETheHotWat.y)/
        max(1, EEleHea.y)) "Seasonal performance factor for heating"
    annotation (Placement(transformation(extent={{700,340},{720,360}})));
  Modelica.Blocks.Sources.RealExpression SPFCoo(y=-ETheCoo.y/max(1, EEleCoo.y))
    "Seasonal performance factor for cooling"
    annotation (Placement(transformation(extent={{700,280},{720,300}})));
equation
  connect(weaBus, larOff1.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{-280,190},{-280,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, ret1.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{-160,190},{-160,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus,larOff2. weaBus) annotation (Line(
      points={{-340,190},{-340,190},{-40,190},{-40,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, apa1.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{240,190},{240,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, larOff3.weaBus) annotation (Line(
      points={{-340,190},{380,190},{380,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus,larOff4. weaBus) annotation (Line(
      points={{-340,190},{-340,190},{520,190},{520,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, apa2.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{120,190},{120,-44},{240,-44},{240,-123.286}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, ret2.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{120,190},{120,-44},{380,-44},{380,-123.286}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-380,190},{-340,190},{-340,190}},
      color={255,204,51},
      thickness=0.5));
  connect(PHea.y, EEleHea.u) annotation (Line(points={{617.02,370},{627.51,370},
          {638,370}}, color={0,0,127}));
  connect(PCoo.y, EEleCoo.u) annotation (Line(points={{617.02,330},{627.51,330},
          {638,330}}, color={0,0,127}));

  connect(larOff1.PHea, PHea.u[1]) annotation (Line(points={{-259.286,100},{
          -250,100},{-250,373.938},{604,373.938}},
                                              color={0,0,127}));
  connect(ret1.PHea, PHea.u[2]) annotation (Line(points={{-139.286,100},{-130,
          100},{-130,373.413},{604,373.413}},
                                     color={0,0,127}));
  connect(larOff2.PHea, PHea.u[3]) annotation (Line(points={{-19.2857,100},{-10,
          100},{-10,372.887},{604,372.887}}, color={0,0,127}));
  connect(apa1.PHea, PHea.u[4]) annotation (Line(points={{260.714,100},{260.714,
          100},{270,100},{270,372.363},{604,372.363}}, color={0,0,127}));
  connect(larOff3.PHea, PHea.u[5]) annotation (Line(points={{400.714,100},{412,
          100},{412,371.837},{604,371.837}},
                                color={0,0,127}));
  connect(larOff4.PHea, PHea.u[6]) annotation (Line(points={{540.714,100},{552,
          100},{552,371.312},{604,371.312}},
                                        color={0,0,127}));
  connect(apa2.PHea, PHea.u[7]) annotation (Line(points={{260.714,-120},{
          260.714,-120},{280,-120},{280,-20},{572,-20},{572,370.788},{604,
          370.788}},
        color={0,0,127}));
  connect(ret2.PHea, PHea.u[8]) annotation (Line(points={{400.714,-120},{410,
          -120},{410,-20},{572,-20},{572,370.262},{604,370.262}},
                                                        color={0,0,127}));

  connect(larOff1.PHotWat, PHea.u[9])  annotation (Line(points={{-259.286,
          97.1429},{-250,97.1429},{-250,369.738},{604,369.738}},
                                              color={0,0,127}));
  connect(ret1.PHotWat, PHea.u[10]) annotation (Line(points={{-139.286,97.1429},
          {-130,97.1429},{-130,369.212},{604,369.212}},
                                     color={0,0,127}));
  connect(larOff2.PHotWat, PHea.u[11]) annotation (Line(points={{-19.2857,
          97.1429},{-10,97.1429},{-10,368.688},{604,368.688}},
                                             color={0,0,127}));
  connect(apa1.PHotWat, PHea.u[12]) annotation (Line(points={{260.714,97.1429},
          {260.714,97.1429},{270,97.1429},{270,368.163},{604,368.163}},
                                                       color={0,0,127}));
  connect(larOff3.PHotWat, PHea.u[13]) annotation (Line(points={{400.714,
          97.1429},{412,97.1429},{412,367.637},{604,367.637}},
                                color={0,0,127}));
  connect(larOff4.PHotWat, PHea.u[14]) annotation (Line(points={{540.714,
          97.1429},{552,97.1429},{552,367.113},{604,367.113}},
                                        color={0,0,127}));
  connect(apa2.PHotWat, PHea.u[15]) annotation (Line(points={{260.714,-122.857},
          {270,-122.857},{270,-122},{280,-122},{280,-120},{280,-20},{572,-20},{
          572,366.587},{604,366.587}},
        color={0,0,127}));
  connect(ret2.PHotWat, PHea.u[16]) annotation (Line(points={{400.714,-122.857},
          {410,-122.857},{410,-20},{572,-20},{572,366.062},{604,366.062}},
                                                        color={0,0,127}));

  connect(larOff1.PCoo, PCoo.u[1]) annotation (Line(points={{-259.286,94.2857},
          {-250,94.2857},{-250,333.675},{604,333.675}},
                                              color={0,0,127}));
  connect(ret1.PCoo, PCoo.u[2]) annotation (Line(points={{-139.286,94.2857},{
          -130,94.2857},{-130,332.625},{604,332.625}},
                                     color={0,0,127}));
  connect(larOff2.PCoo, PCoo.u[3]) annotation (Line(points={{-19.2857,94.2857},
          {-10,94.2857},{-10,331.575},{604,331.575}},
                                             color={0,0,127}));
  connect(apa1.PCoo, PCoo.u[4]) annotation (Line(points={{260.714,94.2857},{
          260.714,94.2857},{270,94.2857},{270,330.525},{604,330.525}},
                                                       color={0,0,127}));
  connect(larOff3.PCoo, PCoo.u[5]) annotation (Line(points={{400.714,94.2857},{
          412,94.2857},{412,329.475},{604,329.475}},
                                color={0,0,127}));
  connect(larOff4.PCoo, PCoo.u[6]) annotation (Line(points={{540.714,94.2857},{
          552,94.2857},{552,328.425},{604,328.425}},
                                        color={0,0,127}));
  connect(apa2.PCoo, PCoo.u[7]) annotation (Line(points={{260.714,-125.714},{
          270,-125.714},{270,-126},{280,-126},{280,-120},{280,-20},{572,-20},{
          572,327.375},{604,327.375}},
        color={0,0,127}));
  connect(ret2.PCoo, PCoo.u[8]) annotation (Line(points={{400.714,-125.714},{
          410,-125.714},{410,-20},{572,-20},{572,326.325},{604,326.325}},
                                                        color={0,0,127}));

  connect(QHea.y, ETheHea.u) annotation (Line(points={{617.02,290},{627.51,290},
          {638,290}}, color={0,0,127}));
  connect(QCoo.y, ETheCoo.u) annotation (Line(points={{617.02,210},{627.51,210},
          {638,210}}, color={0,0,127}));

  connect(larOff1.QHea_flow, QHea.u[1]) annotation (Line(points={{-259.286,90},
          {-259.286,90},{-240,90},{-240,293.675},{604,293.675}},
                                                            color={0,0,127}));
  connect(ret1.QHea_flow, QHea.u[2]) annotation (Line(points={{-139.286,90},{
          -120,90},{-120,292.625},{604,292.625}},
                                             color={0,0,127}));
  connect(larOff2.QHea_flow, QHea.u[3]) annotation (Line(points={{-19.2857,90},
          {0,90},{0,291.575},{604,291.575}},color={0,0,127}));
  connect(apa1.QHea_flow, QHea.u[4]) annotation (Line(points={{260.714,90},{280,
          90},{280,290.525},{604,290.525}},
                                    color={0,0,127}));
  connect(larOff3.QHea_flow, QHea.u[5]) annotation (Line(points={{400.714,90},{
          400.714,90},{420,90},{420,289.475},{604,289.475}},  color={0,0,127}));
  connect(larOff4.QHea_flow, QHea.u[6]) annotation (Line(points={{540.714,90},{
          560,90},{560,288.425},{604,288.425}},
                                            color={0,0,127}));
  connect(apa2.QHea_flow, QHea.u[7]) annotation (Line(points={{260.714,-130},{
          290,-130},{290,-30},{580,-30},{580,287.375},{604,287.375}},
                                                              color={0,0,127}));
  connect(ret2.QHea_flow, QHea.u[8]) annotation (Line(points={{400.714,-130},{
          420,-130},{420,-30},{580,-30},{580,286.325},{604,286.325}},
                                                                  color={0,0,127}));

//////

  connect(larOff1.QHotWat_flow, QHotWat.u[1]) annotation (Line(points={{
          -259.286,87.1429},{-259.286,87.1429},{-240,87.1429},{-240,253.675},{
          604,253.675}},                                    color={0,0,127}));
  connect(ret1.QHotWat_flow, QHotWat.u[2]) annotation (Line(points={{-139.286,
          87.1429},{-120,87.1429},{-120,252.625},{604,252.625}},
                                             color={0,0,127}));
  connect(larOff2.QHotWat_flow, QHotWat.u[3]) annotation (Line(points={{
          -19.2857,87.1429},{0,87.1429},{0,251.575},{604,251.575}},
                                            color={0,0,127}));
  connect(apa1.QHotWat_flow, QHotWat.u[4]) annotation (Line(points={{260.714,
          87.1429},{280,87.1429},{280,250.525},{604,250.525}},
                                    color={0,0,127}));
  connect(larOff3.QHotWat_flow, QHotWat.u[5]) annotation (Line(points={{400.714,
          87.1429},{410,87.1429},{410,90},{420,90},{420,249.475},{604,249.475}},
                                                              color={0,0,127}));
  connect(larOff4.QHotWat_flow, QHotWat.u[6]) annotation (Line(points={{540.714,
          87.1429},{560,87.1429},{560,248.425},{604,248.425}},
                                            color={0,0,127}));
  connect(apa2.QHotWat_flow, QHotWat.u[7]) annotation (Line(points={{260.714,
          -132.857},{290,-132.857},{290,-30},{580,-30},{580,247.375},{604,
          247.375}},                                          color={0,0,127}));
  connect(ret2.QHotWat_flow, QHotWat.u[8]) annotation (Line(points={{400.714,
          -132.857},{420,-132.857},{420,-30},{580,-30},{580,246.325},{604,
          246.325}},                                              color={0,0,127}));

////
  connect(larOff1.QCoo_flow, QCoo.u[1]) annotation (Line(points={{-259.286,
          84.2857},{-259.286,84.2857},{-240,84.2857},{-240,213.675},{604,
          213.675}},                                        color={0,0,127}));
  connect(ret1.QCoo_flow, QCoo.u[2]) annotation (Line(points={{-139.286,84.2857},
          {-120,84.2857},{-120,212.625},{604,212.625}},
                                             color={0,0,127}));
  connect(larOff2.QCoo_flow, QCoo.u[3]) annotation (Line(points={{-19.2857,
          84.2857},{0,84.2857},{0,211.575},{604,211.575}},
                                            color={0,0,127}));
  connect(apa1.QCoo_flow, QCoo.u[4]) annotation (Line(points={{260.714,84.2857},
          {280,84.2857},{280,210.525},{604,210.525}},
                                    color={0,0,127}));
  connect(larOff3.QCoo_flow, QCoo.u[5]) annotation (Line(points={{400.714,
          84.2857},{410,84.2857},{410,90},{420,90},{420,209.475},{604,209.475}},
                                                              color={0,0,127}));
  connect(larOff4.QCoo_flow, QCoo.u[6]) annotation (Line(points={{540.714,
          84.2857},{560,84.2857},{560,208.425},{604,208.425}},
                                            color={0,0,127}));
  connect(apa2.QCoo_flow, QCoo.u[7]) annotation (Line(points={{260.714,-135.714},
          {290,-135.714},{290,-30},{580,-30},{580,207.375},{604,207.375}},
                                                              color={0,0,127}));
  connect(ret2.QCoo_flow, QCoo.u[8]) annotation (Line(points={{400.714,-135.714},
          {420,-135.714},{420,-30},{580,-30},{580,206.325},{604,206.325}},
                                                                  color={0,0,127}));

  connect(QHotWat.y, ETheHotWat.u) annotation (Line(points={{617.02,250},{
          627.51,250},{638,250}}, color={0,0,127}));
  annotation (
    Documentation(
    info="<html>
<p>
Model with loads for bi-directional energy system.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
<li>
February 12, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-580,-260},{780,
            400}})));
end HeatingCoolingHotWater3Clusters;
