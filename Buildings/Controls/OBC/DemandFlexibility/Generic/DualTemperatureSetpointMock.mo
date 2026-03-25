within Buildings.Controls.OBC.DemandFlexibility.Generic;
block DualTemperatureSetpointMock

  parameter Real TRes=0.5556
    "temperature setpoint resolution";
  parameter Real delSetCha(
    final quantity="Time",
    final unit="s",
    min=1E-3) = 10
    "setpoint change delay";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSetHea(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating temperature setpoint command" annotation (Placement(transformation(
          extent={{-140,28},{-100,68}}), iconTransformation(extent={{-140,30},{-100,
            70}})), __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle" "@prefix brick: <https://brickschema.org/schema/Brick#> .
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSetCoo(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling temperature setpoint command" annotation (Placement(transformation(
          extent={{-140,-82},{-100,-42}}), iconTransformation(extent={{-140,-62},
            {-100,-22}})), __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTSetHea(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating temperature setpoint processed output" annotation (Placement(
        transformation(extent={{100,28},{140,68}}), iconTransformation(extent={{
            100,26},{140,66}})), __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTSetCoo(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling temperature setpoint processed output" annotation (Placement(
        transformation(extent={{100,-82},{140,-42}}), iconTransformation(extent
          ={{100,-60},{140,-20}})), __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
  SingleTemperatureSetpointMock singleTemperatureSetpointMock(TRes=TRes,
      delSetCha=delSetCha)
    annotation (Placement(transformation(extent={{-12,38},{8,58}})));
  SingleTemperatureSetpointMock singleTemperatureSetpointMock1(TRes=TRes,
      delSetCha=delSetCha)
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
equation
  connect(uTSetHea, singleTemperatureSetpointMock.uTSet)
    annotation (Line(points={{-120,48},{-14,48}}, color={0,0,127}));
  connect(singleTemperatureSetpointMock.yTSet, yTSetHea)
    annotation (Line(points={{10,48},{120,48}}, color={0,0,127}));
  connect(uTSetCoo, singleTemperatureSetpointMock1.uTSet)
    annotation (Line(points={{-120,-62},{-12,-62}}, color={0,0,127}));
  connect(singleTemperatureSetpointMock1.yTSet, yTSetCoo)
    annotation (Line(points={{12,-62},{120,-62}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DualTemperatureSetpointMock;
