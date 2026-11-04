within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences;
block Qualification "Qualification"

  parameter Integer nAHU(min=1)
    "Number of air handling units";
  parameter Real fanSpeMin[nAHU](
    each final unit="1")
    "Minimum fan speed of the air handling unit";
  parameter Real VMin_flow[nAHU](
    each final unit="m3/s")
    "Minimum volumetric air flow for the variable air volume served by the air handling unit";
  parameter Real TZonMax[nAHU](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Maximum zone temperature for the zone served by the air handling unit";
  parameter Real fanSpeHys(
    each final unit="1")
    "Fan speed hysteresis";
  parameter Real VHys_flow(
    each final unit="m3/s")
    "Volumetric air flow hysteresis";
  parameter Real TZonHys(
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature hysteresis";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpe[nAHU](
    each final unit="1")
    "Fan speed of the air handling unit"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow[nAHU](
    each final unit="m3/s")
    "Volumetric air flow for the variable air volume served by the air handling unit"
    annotation (Placement(transformation(extent={{-140,40},
            {-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nAHU](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature for the zone served by the air handling unit"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greVMin_flow[nAHU](final t=
        VMin_flow, final h=fill(VHys_flow, nAHU))
    "Check if the volumetric flow rate is greater than the minimum volumetric flow rate threshold"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greFanSpeMin[nAHU](final t=
        fanSpeMin, final h=fill(fanSpeHys, nAHU))
    "Check if the fan speed is greater than the minimum fan speed threshold"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesTZonMax[nAHU](final t=
        TZonMax, final h=fill(TZonHys, nAHU))
    "Check if the zone temperature is less than the maximum zone temperature threshold"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yQua[nAHU]
    "The air handling unit is qualified for fan speed limiting" annotation (
      Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.And andFanSpeV_flow[nAHU]
    "Check if both conditions for the fan speed and the volumetric air flow are met"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Logical.And andAll[nAHU]
    "Check if all 3 conditions are met"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(V_flow, greVMin_flow.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(fanSpe, greFanSpeMin.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(TZon, lesTZonMax.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={0,0,127}));
  connect(greVMin_flow.y, andFanSpeV_flow.u1) annotation (Line(points={{-58,60},
          {-40,60},{-40,30},{-22,30}}, color={255,0,255}));
  connect(greFanSpeMin.y, andFanSpeV_flow.u2) annotation (Line(points={{-58,0},{
          -40,0},{-40,22},{-22,22}}, color={255,0,255}));
  connect(andFanSpeV_flow.y, andAll.u1) annotation (Line(points={{2,30},{20,30},
          {20,0},{38,0}}, color={255,0,255}));
  connect(lesTZonMax.y, andAll.u2) annotation (Line(points={{-58,-60},{20,-60},{
          20,-8},{38,-8}}, color={255,0,255}));
  connect(andAll.y, yQua)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));
  annotation (defaultComponentName="qua",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Passes a Boolean signal through without modification.
</p>
</html>"));
end Qualification;
