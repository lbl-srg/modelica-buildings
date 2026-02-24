within Buildings.Controls.OBC.DemandFlexibility;
block MultipleZoneRatchet "multiple zone ratchet"

  parameter Integer nZones=4;
  parameter Real loadShedHourStart=16;
  parameter Real loadShedHourEnd=21;
  parameter Real TZonHeaSetNomOcc(unit="K")=273.15+22.2222;
  parameter Real TZonHeaSetNomUnocc(unit="K")=273.15+15.5556;
  parameter Real TZonCooSetNomOcc(unit="K")=273.15+25.5556;
  parameter Real TZonCooSetNomUnocc(unit="K")=273.15+32.2222;
    parameter Real loadShedDurationTypical(unit="s")=(loadShedHourEnd-loadShedHourStart)*3600;
    parameter Real reboundDuration(unit="s")=3600;
    parameter Real loadShedTempAmount=5;
    parameter Boolean loaSheHeaAct=true;
    parameter Boolean loaSheCooAct=true;
     parameter Real TRatThreshold=1.1111
    "Threshold of zone air temperature setpoint difference below which ratcheting is triggerd";
    parameter Real TRat=0.5556
    "Ratcheting temperature (defined as >0)";
               parameter Real TReb=0.5556
    "rebound temperature (defined as >0)";
      parameter Real samplePeriodRatchet(unit="s")=loadShedDurationTypical*0.3333*TRat/loadShedTempAmount/nZones
    "Sample period of the demand flexibility control";
          parameter Real samplePeriodRebound(unit="s")=reboundDuration*TReb/loadShedTempAmount/nZones
    "Sample period of rebound";
  Subsequences.OneZoneRatchetHeating single_zone_ratchet_heating[nZones](
    samplePeriodRatchet=samplePeriodRatchet,
    samplePeriodRebound=samplePeriodRebound,
    TRatThreshold=TRatThreshold,
    TRat=TRat,
    TReb=TReb,
    reboundDuration=reboundDuration)
    annotation (Placement(transformation(extent={{204,-12},{254,16}})));
  Subsequences.MinTemperatureDifferenceSelection temDifSelectionMinHeaRat(
      nZones=nZones)
    annotation (Placement(transformation(extent={{118,96},{138,116}})));
  Subsequences.MaxTemperatureDifferenceSelection temDifSelectionMaxHeaReb(
      nZones=nZones)
    annotation (Placement(transformation(extent={{116,66},{136,86}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZones](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone room air temperature" annotation (Placement(transformation(
          extent={{-320,58},{-280,98}}),  iconTransformation(extent={{-322,42},{
            -282,82}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix hpfs: <http://hpflex/shapes#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix qudt: <http://qudt.org/schema/qudt/> .
            @prefix ref: <https://brickschema.org/schema/Brick/ref#> .
            @prefix unit: <http://qudt.org/vocab/unit/> .
            hpfs:<cdl_instance_name> a rdfs:Class, sh:NodeShape ;
              sh:class brick:Zone_Air_Temperature_Sensor ;
              sh:property hpfs:temperature_Kelvin, hpfs:temperature_ref .
            hpfs:temperature_Kelvin a sh:PropertyShape ;
              sh:hasValue unit:Kelvin ;
              sh:minCount 1 ;
              sh:path qudt:hasUnit .
            hpfs:temperature_ref a sh:PropertyShape ;
              sh:minCount 1 ;
              sh:path ref:hasExternalReference .",
          naturalLanguage="en"
            "<cdl_instance_name> is a temperature reading input that should be hardwired to the zone air temperature sensor")));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetCur[nZones](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-320,26},{-280,66}}),  iconTransformation(extent={{-322,10},{
            -282,50}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix hpfs: <http://hpflex/shapes#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix qudt: <http://qudt.org/schema/qudt/> .
            @prefix ref: <https://brickschema.org/schema/Brick/ref#> .
            @prefix unit: <http://qudt.org/vocab/unit/> .
            hpfs:<cdl_instance_name> a rdfs:Class, sh:NodeShape ;
              sh:class brick:Heating_Zone_Air_Temperature_Setpoint ;
              sh:property hpfs:temperature-setpoint_Kelvin, hpfs:temperature-setpoint_ref .
            hpfs:temperature-setpoint_Kelvin a sh:PropertyShape ;
              sh:hasValue unit:Kelvin ;
              sh:minCount 1 ;
              sh:path qudt:hasUnit .
            hpfs:temperature-setpoint_ref a sh:PropertyShape ;
                sh:minCount 1 ;
                sh:path ref:hasExternalReference .",
          naturalLanguage="en"
            "<cdl_instance_name> is a temperature heating setpoint input")));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSetCom[nZones](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{282,32},{322,72}}), iconTransformation(extent={{280,18},{320,
            58}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix hpfs: <http://hpflex/shapes#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix qudt: <http://qudt.org/schema/qudt/> .
            @prefix ref: <https://brickschema.org/schema/Brick/ref#> .
            @prefix unit: <http://qudt.org/vocab/unit/> .
            hpfs:<cdl_instance_name> a rdfs:Class, sh:NodeShape ;
              sh:class brick:Heating_Zone_Air_Temperature_Setpoint ;
              sh:property hpfs:temperature-setpoint_Kelvin, hpfs:temperature-setpoint_ref .
            hpfs:temperature-setpoint_Kelvin a sh:PropertyShape ;
              sh:hasValue unit:Kelvin ;
              sh:minCount 1 ;
              sh:path qudt:hasUnit .
            hpfs:temperature-setpoint_ref a sh:PropertyShape ;
                sh:minCount 1 ;
                sh:path ref:hasExternalReference .",
          naturalLanguage="en"
            "<cdl_instance_name> is a temperature heating setpoint input")));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nZones](k=
        loaSheHeaAct)
    annotation (Placement(transformation(extent={{0,158},{20,178}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=
        nZones) annotation (Placement(transformation(extent={{-158,108},{-138,128}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=nZones)
    annotation (Placement(transformation(extent={{-130,-84},{-110,-64}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(nout=
        nZones)
    annotation (Placement(transformation(extent={{-130,-42},{-110,-22}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(nout=
        nZones)
    annotation (Placement(transformation(extent={{-130,-142},{-110,-122}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(nout=
        nZones)
    annotation (Placement(transformation(extent={{-128,-200},{-108,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract subt[nZones]
    annotation (Placement(transformation(extent={{-64,68},{-44,88}})));
  Subsequences.MinTemperatureDifferenceSelection temDifSelectionMinCooReb(
      nZones=nZones)
    annotation (Placement(transformation(extent={{116,-158},{136,-138}})));
  Subsequences.MaxTemperatureDifferenceSelection temDifSelectionMaxCooRat(
      nZones=nZones)
    annotation (Placement(transformation(extent={{116,-118},{136,-98}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSetCom[nZones](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{282,-144},{322,-104}}), iconTransformation(extent={{280,-150},
            {320,-110}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix hpfs: <http://hpflex/shapes#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix qudt: <http://qudt.org/schema/qudt/> .
            @prefix ref: <https://brickschema.org/schema/Brick/ref#> .
            @prefix unit: <http://qudt.org/vocab/unit/> .
            hpfs:<cdl_instance_name> a rdfs:Class, sh:NodeShape ;
              sh:class brick:Cooling_Zone_Air_Temperature_Setpoint ;
              sh:property hpfs:temperature-setpoint_Kelvin, hpfs:temperature-setpoint_ref .
            hpfs:temperature-setpoint_Kelvin a sh:PropertyShape ;
              sh:hasValue unit:Kelvin ;
              sh:minCount 1 ;
              sh:path qudt:hasUnit .
            hpfs:temperature-setpoint_ref a sh:PropertyShape ;
                sh:minCount 1 ;
                sh:path ref:hasExternalReference .",
          naturalLanguage="en"
            "<cdl_instance_name> is a temperature cooling setpoint input")));
  Subsequences.OneZoneRatchetCooling single_zone_ratchet_cooling[nZones](
    samplePeriodRatchet=samplePeriodRatchet,
    samplePeriodRebound=samplePeriodRebound,
    TRatThreshold=TRatThreshold,
    TRat=TRat,
    TReb=TReb,
    reboundDuration=reboundDuration)
    annotation (Placement(transformation(extent={{192,-140},{242,-112}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetCur[nZones](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-320,-6},{-280,34}}),   iconTransformation(extent={{-320,-24},
            {-280,16}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix hpfs: <http://hpflex/shapes#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix qudt: <http://qudt.org/schema/qudt/> .
            @prefix ref: <https://brickschema.org/schema/Brick/ref#> .
            @prefix unit: <http://qudt.org/vocab/unit/> .
            hpfs:<cdl_instance_name> a rdfs:Class, sh:NodeShape ;
              sh:class brick:Cooling_Zone_Air_Temperature_Setpoint ;
              sh:property hpfs:temperature-setpoint_Kelvin, hpfs:temperature-setpoint_ref .
            hpfs:temperature-setpoint_Kelvin a sh:PropertyShape ;
              sh:hasValue unit:Kelvin ;
              sh:minCount 1 ;
              sh:path qudt:hasUnit .
            hpfs:temperature-setpoint_ref a sh:PropertyShape ;
                sh:minCount 1 ;
                sh:path ref:hasExternalReference .",
          naturalLanguage="en"
            "<cdl_instance_name> is a temperature cooling setpoint input")));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2
                                                  [nZones]
    annotation (Placement(transformation(extent={{118,136},{138,156}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3
                                                  [nZones]
    annotation (Placement(transformation(extent={{114,-82},{134,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nZones](k=false)
    annotation (Placement(transformation(extent={{6,-58},{26,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract subt1
                                                [nZones]
    annotation (Placement(transformation(extent={{-66,-108},{-46,-88}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nZones](k=
        loaSheCooAct)
    annotation (Placement(transformation(extent={{-4,-176},{16,-156}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occSta "occupancy status"
    annotation (Placement(transformation(extent={{-320,134},{-280,174}}),
        iconTransformation(extent={{-320,134},{-280,174}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix hpfs: <http://hpflex/shapes#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix qudt: <http://qudt.org/schema/qudt/> .
            @prefix ref: <https://brickschema.org/schema/Brick/ref#> .
            @prefix unit: <http://qudt.org/vocab/unit/> .
            hpfs:<cdl_instance_name> a rdfs:Class, sh:NodeShape ;
              sh:class brick:Occupancy_Sensor ;
              sh:property hpfs:occupancy_ref .
            hpfs:occupancy_ref a sh:PropertyShape ;
                sh:minCount 1 ;
                sh:path ref:hasExternalReference .",
          naturalLanguage="en"
            "<cdl_instance_name> is a temperature heating setpoint input")));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable loaShe(
    table=[0,0; loadShedHourStart,1; loadShedHourEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-208,108},{-188,128}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(k=loadShedTempAmount)
    annotation (Placement(transformation(extent={{-260,-142},{-240,-122}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract TZonHeaSetMin
    annotation (Placement(transformation(extent={{-190,-84},{-170,-64}})));
  Buildings.Controls.OBC.CDL.Reals.Add TZonCooSetMax
    annotation (Placement(transformation(extent={{-188,-142},{-168,-122}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal
                                          TZonHeaSetNom(realTrue=
        TZonHeaSetNomOcc, realFalse=TZonHeaSetNomUnocc)
    annotation (Placement(transformation(extent={{-240,-42},{-220,-22}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal
                                          TZonCooSetNom(realTrue=
        TZonCooSetNomOcc, realFalse=TZonCooSetNomUnocc)
    annotation (Placement(transformation(extent={{-240,-200},{-220,-180}})));
equation
  connect(reaScaRep1.y,single_zone_ratchet_heating. TZonHeaSetNom) annotation (
      Line(points={{-108,-32},{-34,-32},{-34,-18},{194,-18},{194,-2.2},{202,-2.2}},
        color={0,0,127}));
  connect(TZon,single_zone_ratchet_heating. TZon) annotation (Line(points={{-300,78},
          {-256,78},{-256,80},{-210,80},{-210,-2},{112,-2},{112,6},{194,6},{194,
          4.94},{202,4.94}},                    color={0,0,127}));
  connect(TZon, subt.u1) annotation (Line(points={{-300,78},{-252,78},{-252,48},
          {-110,48},{-110,84},{-66,84}}, color={0,0,127}));
  connect(subt.y, temDifSelectionMinHeaRat.TZonTemDif) annotation (Line(points={{-42,78},
          {16,78},{16,110.6},{116.621,110.6}},       color={0,0,127}));
  connect(subt.y, temDifSelectionMaxHeaReb.TZonTemDif) annotation (Line(points={{-42,78},
          {94,78},{94,80.6},{114.621,80.6}},             color={0,0,127}));
  connect(single_zone_ratchet_cooling.TZonCooSetCom, TZonCooSetCom) annotation (
     Line(points={{244,-116.06},{276,-116.06},{276,-124},{302,-124}}, color={0,
          0,127}));
  connect(single_zone_ratchet_heating.TZonSetHeaCom, TZonHeaSetCom) annotation (
     Line(points={{256,11.94},{276,11.94},{276,52},{302,52}}, color={0,0,127}));
  connect(con1.y, logSwi2.u2) annotation (Line(points={{22,168},{78,168},{78,146},
          {116,146}},
                    color={255,0,255}));
  connect(booScaRep1.y, logSwi2.u1) annotation (Line(points={{-136,118},{74,118},
          {74,154},{116,154}},
                             color={255,0,255}));
  connect(logSwi2.y, single_zone_ratchet_heating.loaShe) annotation (Line(
        points={{140,146},{188,146},{188,14},{194,14},{194,12.64},{202,12.64}},
                                                            color={255,0,255}));
  connect(logSwi3.y, single_zone_ratchet_cooling.loaShe) annotation (Line(
        points={{136,-72},{186,-72},{186,-115.36},{190,-115.36}},   color={255,
          0,255}));
  connect(con.y, logSwi2.u3) annotation (Line(points={{28,-48},{114,-48},{114,0},
          {110,0},{110,138},{116,138}},
                                      color={255,0,255}));
  connect(TZon, single_zone_ratchet_cooling.TZon) annotation (Line(points={{-300,78},
          {-286,78},{-286,46},{-64,46},{-64,-4},{86,-4},{86,-122},{152,-122},{152,
          -123.06},{190,-123.06}},            color={0,0,127}));
  connect(reaScaRep.y, single_zone_ratchet_heating.TZonHeaSetMin) annotation (
      Line(points={{-108,-74},{62,-74},{62,0.32},{202,0.32}},
        color={0,0,127}));
  connect(reaScaRep2.y, single_zone_ratchet_cooling.TZonCooSetMax) annotation (
      Line(points={{-108,-132},{-106,-132.58},{190,-132.58}},
                     color={0,0,127}));
  connect(reaScaRep3.y, single_zone_ratchet_cooling.TZonCooSetNom) annotation (
      Line(points={{-106,-190},{184,-190},{184,-140},{182,-140},{182,-135.1},{190.2,
          -135.1}},                                                   color={0,
          0,127}));
  connect(TZonHeaSetCur, single_zone_ratchet_heating.TZonHeaSetCur) annotation (
     Line(points={{-300,46},{-148,46},{-148,-8},{-2,-8},{-2,2.7},{202,2.7}},
        color={0,0,127}));
  connect(TZonCooSetCur, single_zone_ratchet_cooling.TZonCooSetCur) annotation (
     Line(points={{-300,14},{-252,14},{-252,-88},{-196,-88},{-196,-116},{-36,-116},
          {-36,-130},{144,-130},{144,-128},{182,-128},{182,-125.3},{190,-125.3}},
        color={0,0,127}));
  connect(temDifSelectionMinHeaRat.yAcnFla, single_zone_ratchet_heating.ratSig)
    annotation (Line(points={{139.379,106.2},{192,106.2},{192,10.54},{202,10.54}},
        color={255,0,255}));
  connect(temDifSelectionMaxHeaReb.yAcnFla, single_zone_ratchet_heating.rebSig)
    annotation (Line(points={{137.379,76},{186,76},{186,8.3},{202,8.3}}, color=
          {255,0,255}));
  connect(single_zone_ratchet_heating.reach_TZonHeaSetMin,
    temDifSelectionMinHeaRat.uIgnFla) annotation (Line(points={{256,2.42},{264,
          2.42},{264,124},{100,124},{100,100.2},{116.621,100.2}}, color={255,0,
          255}));
  connect(single_zone_ratchet_heating.reach_TZonHeaSetNom,
    temDifSelectionMaxHeaReb.uIgnFla) annotation (Line(points={{256,-0.52},{266,
          -0.52},{266,0},{274,0},{274,-30},{94,-30},{94,70.2},{114.621,70.2}},
        color={255,0,255}));
  connect(temDifSelectionMaxCooRat.yAcnFla, single_zone_ratchet_cooling.ratSig)
    annotation (Line(points={{137.379,-108},{182,-108},{182,-117.46},{190,
          -117.46}}, color={255,0,255}));
  connect(temDifSelectionMinCooReb.yAcnFla, single_zone_ratchet_cooling.rebSig)
    annotation (Line(points={{137.379,-147.8},{146,-147.8},{146,-122},{182,-122},
          {182,-119.7},{190,-119.7}}, color={255,0,255}));
  connect(single_zone_ratchet_cooling.reach_TZonCooSetNom,
    temDifSelectionMinCooReb.uIgnFla) annotation (Line(points={{244,-128.52},{
          244,-128},{248,-128},{248,-162},{106,-162},{106,-153.8},{114.621,
          -153.8}}, color={255,0,255}));
  connect(temDifSelectionMaxCooRat.uIgnFla, single_zone_ratchet_cooling.reach_TZonCooSetMax)
    annotation (Line(points={{114.621,-113.8},{106,-113.8},{106,-92},{254,-92},
          {254,-125.58},{244,-125.58}}, color={255,0,255}));
  connect(TZonHeaSetCur, subt.u2) annotation (Line(points={{-300,46},{-148,46},{
          -148,72},{-66,72}},                     color={0,0,127}));
  connect(TZon, subt1.u1) annotation (Line(points={{-300,78},{-252,78},{-252,50},
          {-76,50},{-76,-92},{-68,-92}}, color={0,0,127}));
  connect(TZonCooSetCur, subt1.u2) annotation (Line(points={{-300,14},{-252,14},
          {-252,-88},{-196,-88},{-196,-116},{-76,-116},{-76,-104},{-68,-104}},
                                color={0,0,127}));
  connect(subt1.y, temDifSelectionMaxCooRat.TZonTemDif)
    annotation (Line(points={{-44,-98},{102,-98},{102,-103.4},{114.621,-103.4}},
                                                             color={0,0,127}));
  connect(subt1.y, temDifSelectionMinCooReb.TZonTemDif) annotation (Line(points={{-44,-98},
          {16,-98},{16,-144},{88,-144},{88,-143.4},{114.621,-143.4}},
                                                      color={0,0,127}));
  connect(booScaRep1.y, logSwi3.u1) annotation (Line(points={{-136,118},{70,118},
          {70,-64},{112,-64}},
                             color={255,0,255}));
  connect(con.y, logSwi3.u3) annotation (Line(points={{28,-48},{36,-48},{36,-80},
          {112,-80}},             color={255,0,255}));
  connect(con2.y, logSwi3.u2) annotation (Line(points={{18,-166},{94,-166},{94,-72},
          {112,-72}},
        color={255,0,255}));
  connect(loaShe.y[1], booScaRep1.u) annotation (Line(points={{-186,118},{-160,118}},
                           color={255,0,255}));
  connect(TZonHeaSetNom.y, reaScaRep1.u) annotation (Line(points={{-218,-32},{-132,
          -32}},
        color={0,0,127}));
  connect(TZonHeaSetNom.y, TZonHeaSetMin.u1) annotation (Line(points={{-218,-32},
          {-202,-32},{-202,-68},{-192,-68}},                         color={0,0,
          127}));
  connect(con3.y, TZonHeaSetMin.u2) annotation (Line(points={{-238,-132},{-200,-132},
          {-200,-80},{-192,-80}},   color={0,0,127}));
  connect(TZonHeaSetMin.y, reaScaRep.u) annotation (Line(points={{-168,-74},{-132,
          -74}},
        color={0,0,127}));
  connect(TZonCooSetNom.y, reaScaRep3.u) annotation (Line(points={{-218,-190},{-130,
          -190}},                                              color={0,0,127}));
  connect(TZonCooSetNom.y, TZonCooSetMax.u2) annotation (Line(points={{-218,-190},
          {-208,-190},{-208,-138},{-190,-138}},                         color={0,
          0,127}));
  connect(con3.y, TZonCooSetMax.u1) annotation (Line(points={{-238,-132},{-200,-132},
          {-200,-126},{-190,-126}}, color={0,0,127}));
  connect(TZonCooSetMax.y, reaScaRep2.u) annotation (Line(points={{-166,-132},{-132,
          -132}},                       color={0,0,127}));
  connect(occSta, TZonHeaSetNom.u) annotation (Line(points={{-300,154},{-270,154},
          {-270,-32},{-242,-32}}, color={255,0,255}));
  connect(occSta, TZonCooSetNom.u) annotation (Line(points={{-300,154},{-270,154},
          {-270,-190},{-242,-190}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,-220},
            {280,220}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-220},{280,220}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-family: Arial; font-size: 9pt;\"><a name=\"docs-internal-guid-3a81ef97-7fff-7d02-c8a4-7cad7029a02b\">This is a multiple zone ratchet model that can dynamically adjust how many zones are in the system.</a></span></p>
<p><span style=\"font-family: Arial; font-size: 9pt;\"><a name=\"docs-internal-guid-3a81ef97-7fff-7d02-c8a4-7cad7029a02b\">B</a><span style=\"background-color: #ffffff;\">asically, the model dynamically adjusts how fast the zone cooling setpoint is ratchated up based on the number of zones, the length of the DF event, and the amount of temperature delta that the cooling setpoint is allowed to change. For example, if we have 10 zones, the DF event lasts for 2 hours, and the temperature delta is 5 degF, if the ratchet amount is 1 degF and one zone at each iteration, then&nbsp; we need 50 iterations for all 10 zones to raise the zone cooling setpoint by 5degF. I specifically say that, all zones should have its zone cooling setpoint raised by 5 degF during the first one-third of 2 hours (0.67 hours, or 40 minutes). Thus, the ratcheting frequency (aka the time period between 2 consecutive iterations) would be 0.8 minutes / iteration (= 40 minutes / 50 iterations).&nbsp;</span></p>
<p><span style=\"font-family: Arial; font-size: 9pt; background-color: #ffffff;\">For rebound, using the same example, we need 50 iterations for all 10 zones to reduce the zone cooling setpoint by 5degF. If we specify that the total time for rebound is 1 hour, then the rebounding frequency should be 1.2 minutes / iteration (=60 minutes / 50 iterations).</span></p>
</html>"));
end MultipleZoneRatchet;
