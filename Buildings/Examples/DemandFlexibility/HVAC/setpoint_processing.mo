within Buildings.Examples.DemandFlexibility.HVAC;
block setpoint_processing

  parameter Real temRes=0.5556
    "temperature setpoint resolution";
  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s",
    min=1E-3) = 10
    "Sample period of component";
  Subsequences.thermostatSetpointResolution thermostatSetpointResolutionCoo(temRes=
        temRes)
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=
        samplePeriod,                                                   y_start
      =293.15)        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={22,46})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(samplePeriod=
        samplePeriod,
      y_start=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,-52})));
  Subsequences.thermostatSetpointResolution thermostatSetpointResolutionHea(temRes=
        temRes)
    annotation (Placement(transformation(extent={{-66,40},{-46,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput  TZonHeaSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{-140,28},{-100,68}}),
                                       iconTransformation(extent={{-140,30},{
            -100,70}})),
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{-140,-82},{-100,-42}}), iconTransformation(extent={{-140,-62},
            {-100,-22}})),
                        __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
                sh:path ref:hasExternalReference .", naturalLanguage="en"
          "<cdl_instance_name> is a temperature heating setpoint input")));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSetPro(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint processed output" annotation (Placement(
        transformation(extent={{100,28},{140,68}}), iconTransformation(extent={{100,26},
            {140,66}})),         __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
                sh:path ref:hasExternalReference .", naturalLanguage="en"
          "<cdl_instance_name> is a temperature heating setpoint input")));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSetPro(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint processed output" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-60},
            {140,-20}})),         __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
                sh:path ref:hasExternalReference .", naturalLanguage="en"
          "<cdl_instance_name> is a temperature heating setpoint input")));
equation
  connect(TZonHeaSetCom, thermostatSetpointResolutionHea.setpointCommand)
    annotation (Line(points={{-120,48},{-72,48},{-72,50},{-67.6,50}}, color={0,
          0,127}));
  connect(thermostatSetpointResolutionHea.actualSetpoint, uniDel.u) annotation
    (Line(points={{-44.4,50},{0,50},{0,46},{10,46}}, color={0,0,127}));
  connect(uniDel.y, TZonHeaSetPro) annotation (Line(points={{34,46},{96,46},{96,
          48},{120,48}}, color={0,0,127}));
  connect(TZonCooSetCom, thermostatSetpointResolutionCoo.setpointCommand)
    annotation (Line(points={{-120,-62},{-78,-62},{-78,-40},{-71.6,-40}}, color
        ={0,0,127}));
  connect(thermostatSetpointResolutionCoo.actualSetpoint, uniDel1.u)
    annotation (Line(points={{-48.4,-40},{12,-40},{12,-52},{20,-52}}, color={0,
          0,127}));
  connect(uniDel1.y, TZonCooSetPro) annotation (Line(points={{44,-52},{94,-52},
          {94,-60},{120,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end setpoint_processing;
