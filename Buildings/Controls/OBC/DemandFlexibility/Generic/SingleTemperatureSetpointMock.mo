within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SingleTemperatureSetpointMock

    parameter Real TRes(unit="K")=1
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
            {100,-20},{140,20}})), __cdl(semantic(metadataLanguage="Brick 1.3 text/turtle" "@prefix brick: <https://brickschema.org/schema/Brick#> .
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
  connect(uTSet, thermostatSetpointResolutionHea.uTSet)
    annotation (Line(points={{-120,0},{-67.6,0}}, color={0,0,127}));
  connect(thermostatSetpointResolutionHea.yTSet, uniDel.u)
    annotation (Line(points={{-44.4,0},{12,0}}, color={0,0,127}));
  connect(uniDel.y, yTSet)
    annotation (Line(points={{36,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This block is used to represent how a temperature setpoint in a typical Building Management System (BMS) changes.</span></p>
<p><span style=\"font-size: 9pt;\">First, a temperature setpoint can only fall into specific resolution intervals. The parameter <span style=\"font-family: Courier New;\">TRes</span> specifies the temperature resolution interval, which can be 0.5K, 1K, etc. when using temperature in Kelvin or Celsius units, or 0.5556K, 0.2778K, etc. when using temperature in the Fehrenheit unit. While the input variable <span style=\"font-family: Courier New; font-size: 9pt;\">uTSet</span> can take on any temperature value, the output variable <span style=\"font-family: Courier New; font-size: 9pt;\">yTSet</span> needs to be equal to an integer multiple of <span style=\"font-family: Courier New; font-size: 9pt;\">TRes</span> plus the base temperature of 273.15 + 20 K.</p>

<p>Second, when changing the temperature setpoint, the BMS likely has a small time delay before the actual temperature setpoint is successfully changed. This time delay is specified from the setpoint change delay parameter delSetCha, which can be around 10 seconds, for example. In this block, this is implemented such that with a change of value for the input variable uTSet, the output variable yTSet will be changed a delay of delSetCha later. This functionality also serves to prevent close-loop short-circuiting when performing a continuous Modelica simulation.</p>

</html>"));
end SingleTemperatureSetpointMock;
