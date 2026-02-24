within Buildings.Controls.OBC.DemandFlexibility;
block SingleZoneRatchet "single zone ratchet"

  parameter Real loadShedHourStart=16;
  parameter Real loadShedHourEnd=21;
    parameter Real occStaHourStart=7;
  parameter Real occStaHourEnd=20;
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
      parameter Real samplePeriodRatchet(unit="s")=loadShedDurationTypical*0.3333*TRat/loadShedTempAmount
    "Sample period of the demand flexibility control";
          parameter Real samplePeriodRebound(unit="s")=reboundDuration*TReb/loadShedTempAmount
    "Sample period of rebound";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone room air temperature" annotation (Placement(transformation(
          extent={{-320,102},{-280,142}}),iconTransformation(extent={{-322,42},{
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetCur(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-318,-20},{-278,20}}), iconTransformation(extent={{-322,10},{
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{282,98},{322,138}}),iconTransformation(extent={{280,18},{320,
            58}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle" "@prefix brick: <https://brickschema.org/schema/Brick#> .
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSetCom(
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetCur(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-318,-152},{-278,-112}}),
                                           iconTransformation(extent={{-322,-24},
            {-282,16}})),
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

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable loaShe(
    table=[0,0; loadShedHourStart,1; loadShedHourEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-184,182},{-164,202}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable occSta(
    table=[0,0; occStaHourStart,1; occStaHourEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-174,142},{-154,162}})));
  Subsequences.SingleZoneRatchetBase single_zone_ratchet_base(
    loadShedHourStart=loadShedHourStart,
    loadShedHourEnd=loadShedHourEnd,
    TZonHeaSetNomOcc=TZonHeaSetNomOcc,
    TZonHeaSetNomUnocc=TZonHeaSetNomUnocc,
    TZonCooSetNomOcc=TZonCooSetNomOcc,
    TZonCooSetNomUnocc=TZonCooSetNomUnocc,
    reboundDuration=reboundDuration,
    loadShedTempAmount=loadShedTempAmount,
    loaSheHeaAct=loaSheHeaAct,
    loaSheCooAct=loaSheCooAct,
    TRatThreshold=TRatThreshold,
    TRat=TRat,
    TReb=TReb)
    annotation (Placement(transformation(extent={{-88,-52},{118,96}})));

equation
  connect(single_zone_ratchet_base.TZonHeaSetCom, TZonHeaSetCom) annotation (
      Line(points={{128.3,63.0364},{128.3,118},{302,118}}, color={0,0,127}));
  connect(single_zone_ratchet_base.TZonCooSetCom, TZonCooSetCom) annotation (
      Line(points={{128.3,-10.9636},{128.3,-124},{302,-124}}, color={0,0,127}));
  connect(occSta.y[1], single_zone_ratchet_base.occSta) annotation (Line(points={{-152,
          152},{-122,152},{-122,56},{-97.27,56},{-97.27,54.9636}},       color={
          255,0,255}));
  connect(loaShe.y[1], single_zone_ratchet_base.loaShe) annotation (Line(points={{-162,
          192},{-99.33,192},{-99.33,82.5455}},       color={255,0,255}));
  connect(TZon, single_zone_ratchet_base.TZon) annotation (Line(points={{-300,
          122},{-224,122},{-224,34},{-116,34},{-116,36},{-98.3,36},{-98.3,
          21.3273}},
        color={0,0,127}));
  connect(TZonHeaSetCur, single_zone_ratchet_base.TZonHeaSetCur) annotation (
      Line(points={{-298,0},{-116,0},{-116,8},{-97.27,8},{-97.27,-6.92727}},
        color={0,0,127}));
  connect(TZonCooSetCur, single_zone_ratchet_base.TZonCooSetCur) annotation (
      Line(points={{-298,-132},{-97.27,-132},{-97.27,-33.8364}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,-220},
            {280,220}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-220},{280,220}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-family: Arial; font-size: 9pt;\">This is a multiple zone ratchet model.</span></p>
<p><span style=\"font-family: Arial; font-size: 9pt;\">Basically, the model dynamically adjusts how fast the zone cooling setpoint is ratchated up based on the number of zones, the length of the DF event, and the amount of temperature delta that the cooling setpoint is allowed to change. For example, if we have 10 zones, the DF event lasts for 2 hours, and the temperature delta is 5 degF, if the ratchet amount is 1 degF and one zone at each iteration, then we need 50 iterations for all 10 zones to raise the zone cooling setpoint by 5degF. I specifically say that, all zones should have its zone cooling setpoint raised by 5 degF during the first one-third of 2 hours (0.67 hours, or 40 minutes). Thus, the ratcheting frequency (aka the time period between 2 consecutive iterations) would be 0.8 minutes / iteration (= 40 minutes / 50 iterations). </span></p>
<p><span style=\"font-family: Arial; font-size: 9pt;\">For rebound, using the same example, we need 50 iterations for all 10 zones to reduce the zone cooling setpoint by 5degF. If we specify that the total time for rebound is 1 hour, then the rebounding frequency should be 1.2 minutes / iteration (=60 minutes / 50 iterations).</span></p>
</html>"));
end SingleZoneRatchet;
