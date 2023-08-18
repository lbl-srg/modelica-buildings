within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Example.BaseClasses;
block ZoneTemperatureSetpoint
  "Set point scheduler for zone temperature"
  parameter Modelica.Units.SI.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.Units.SI.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.Units.SI.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.Units.SI.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Zone occupancy signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonSetHea
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonSetCoo
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSetHeaOcc(
    final k=THeaOn)
    "Occupied zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiTSetHea
    "Switch between occupied and unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSetHeaUnocc(
    final k=THeaOff)
    "Unoccupied zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiTSetCoo
    "Switch between occupied and unoccupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSetCooOcc(
    final k=TCooOn)
    "Occupied zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonSetCooUnocc(
    final k=TCooOff)
    "Unoccupied zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(TZonSetHeaOcc.y, swiTSetHea.u1) annotation (Line(points={{-18,80},{20,
          80},{20,58},{38,58}}, color={0,0,127}));
  connect(TZonSetHeaUnocc.y, swiTSetHea.u3) annotation (Line(points={{-18,20},{20,
          20},{20,42},{38,42}}, color={0,0,127}));
  connect(uOcc, swiTSetHea.u2) annotation (Line(points={{-120,0},{-60,0},{-60,50},
          {38,50}}, color={255,0,255}));
  connect(swiTSetHea.y, TZonSetHea)
    annotation (Line(points={{62,50},{120,50}}, color={0,0,127}));
  connect(swiTSetCoo.y, TZonSetCoo) annotation (Line(points={{62,-50},{88,-50},{
          88,-50},{120,-50}}, color={0,0,127}));
  connect(TZonSetCooOcc.y, swiTSetCoo.u1) annotation (Line(points={{-18,-20},{20,
          -20},{20,-42},{38,-42}}, color={0,0,127}));
  connect(uOcc, swiTSetCoo.u2) annotation (Line(points={{-120,0},{-60,0},{-60,-50},
          {38,-50}}, color={255,0,255}));
  connect(TZonSetCooUnocc.y, swiTSetCoo.u3) annotation (Line(points={{-18,-80},{
          20,-80},{20,-58},{38,-58}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
      <p>
      This block is used to generate the zone heating and cooling setpoints based 
      on whether the zone is occupied or not. The temperature setpoints are setback 
      when the zone is not occupied.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"), Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,100},{100,140}},
        textString="%name",
        textColor={0,0,255})}),
      defaultComponentName="TZonSet");
end ZoneTemperatureSetpoint;
