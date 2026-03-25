within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SingleTemperatureSetpointMock

    parameter Real TRes(unit="K")=0.5556
    "temperature setpoint resolution";
  parameter Real delSetCha(
    final quantity="Time",
    final unit="s",
    min=1E-3) = 10
    "setpoint change delay";
  CDL.Discrete.UnitDelay                        uniDel(samplePeriod=
        delSetCha, y_start=293.15)
                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,0})));
  TemperatureSetpointResolution
    thermostatSetpointResolutionHea(TRes=TRes)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  CDL.Interfaces.RealInput uTSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Temperature setpoint command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})), __cdl(semantic(
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
                sh:path ref:hasExternalReference .", naturalLanguage="en"
          "<cdl_instance_name> is a temperature heating setpoint input")));
  CDL.Interfaces.RealOutput yTSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature setpoint processed output" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={
            {100,-20},{140,20}})), __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle"
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
  connect(uTSet, thermostatSetpointResolutionHea.uSet)
    annotation (Line(points={{-120,0},{-67.6,0}}, color={0,0,127}));
  connect(thermostatSetpointResolutionHea.ySet,uniDel. u) annotation (Line(
        points={{-44.4,0},{12,0}},                 color={0,0,127}));
  connect(uniDel.y, yTSet)
    annotation (Line(points={{36,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleTemperatureSetpointMock;
