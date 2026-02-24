within Buildings.Controls.OBC.DemandFlexibility;
block Controller
  parameter Real loadShedHourStart=0;
  parameter Real loadShedHourEnd=5;
    parameter Real occStaHourStart=15;
  parameter Real occStaHourEnd=4;
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
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix s223: <http://data.ashrae.org/standard223#> .
            @prefix obc: <urn:hpflex/shapes#> .
            @prefix ctrl: <urn:mycontroller.urn#> .
            
            ctrl:<cdl_instance_name> a s223:FunctionInput ;
              obc:binds obc:temp .",
          naturalLanguage="en"
            "<cdl_instance_name> is a TZon.")));
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
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix s223: <http://data.ashrae.org/standard223#> .
            @prefix obc: <urn:hpflex/shapes#> .
            @prefix ctrl: <urn:mycontroller.urn#> .
            
            ctrl:<cdl_instance_name> a s223:FunctionInput ;
              obc:binds obc:heaset .",
          naturalLanguage="en"
            "<cdl_instance_name> is a TZonHeaSetCur")));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{282,98},{322,138}}),iconTransformation(extent={{280,18},{320,
            58}})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
          "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix s223: <http://data.ashrae.org/standard223#> .
            @prefix obc: <urn:hpflex/shapes#> .
            @prefix ctrl: <urn:mycontroller.urn#> .
            
            ctrl:<cdl_instance_name> a s223:FunctionOutput ;
              obc:binds obc:heaset .",
          naturalLanguage="en"
          "<cdl_instance_name> is a TZonHeaSetCom")));
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
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix s223: <http://data.ashrae.org/standard223#> .
            @prefix obc: <urn:hpflex/shapes#> .
            @prefix ctrl: <urn:mycontroller.urn#> .
            
            ctrl:<cdl_instance_name> a s223:FunctionOutput ;
              obc:binds obc:cooset .",
          naturalLanguage="en"
            "<cdl_instance_name> is a TZonCooSetCom")));
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
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix s223: <http://data.ashrae.org/standard223#> .
            @prefix obc: <urn:hpflex/shapes#> .
            @prefix ctrl: <urn:mycontroller.urn#> .
            
            ctrl:<cdl_instance_name> a s223:FunctionInput ;
              obc:binds obc:cooset .",
          naturalLanguage="en"
            "<cdl_instance_name> is a TZonCooSetCur")));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable loaShe(
    table=[0,0; loadShedHourStart,1; loadShedHourEnd,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-184,182},{-164,202}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable occSta(
    table=[0,1; occStaHourEnd,0; occStaHourStart,1; 24,1],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-174,142},{-154,162}})));
  Buildings.Controls.OBC.DemandFlexibility.Subsequences.SingleZoneRatchetBase
    single_zone_ratchet_base(
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,
            -220},{280,220}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-220},{280,
            220}},
        grid={2,2})),
            __cdl(semantic(
          metadataLanguage="Brick 1.3 text/turtle"
            "@prefix brick: <https://brickschema.org/schema/Brick#> .
            @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
            @prefix sh: <http://www.w3.org/ns/shacl#> .
            @prefix s223: <http://data.ashrae.org/standard223#> .
            @prefix obc: <urn:hpflex/shapes#> .
            @prefix ctrl: <urn:mycontroller.urn#> .
            
            ctrl:<cdl_instance_name> obc:controls obc:zone ;
              obc:uses ctrl:TZonHeaSetCur, ctrl:TZonCooSetCur, ctrl:occSta, ctrl:TZonHeaSetCom, ctrl:TZonCooSetCom, ctrl:TZon .",
          naturalLanguage="en"
            "<cdl_instance_name> is a Controller")));
end Controller;
