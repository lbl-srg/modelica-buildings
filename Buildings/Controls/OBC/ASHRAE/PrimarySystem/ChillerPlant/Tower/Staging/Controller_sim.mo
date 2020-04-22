within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging;
block Controller_sim "Sequence of staging cooling tower cells"

  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Boolean hasWSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Integer totChiSta=6
    "Total number of stages, stage zero should be counted as one stage";
  parameter Real staVec[totChiSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE";
  parameter Real towCelOnSet[totChiSta] = {0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));
  parameter Modelica.SIunits.Time chaTowCelIsoTim=90
    "Time to slowly change isolation valve"
    annotation (Dialog(group="Enable cell isolation valve"));
  parameter Real iniValPos=0
    "Initial valve position, if it needs to turn on tower cell, the value should be 0"
    annotation (Dialog(group="Enable cell isolation valve"));
  parameter Real endValPos=1
    "Ending valve position, if it needs to turn on tower cell, the value should be 1"
    annotation (Dialog(group="Enable cell isolation valve"));
  parameter Modelica.SIunits.Time fallDelay = 1
    "Fan cells stage off delay time, so it can trigger the cell disable output"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-140,-106},{-100,-66}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower cell enabling status"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

  Subsequences.EnableCells_sim enaTowCel
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Subsequences.EnableProcesses towCelStaPro
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  CDL.Interfaces.IntegerInput uChiStaSet "Current chiller stage setpoint"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  CDL.Interfaces.BooleanInput uTowStaCha
    "Cooling tower stage change command from plant staging process" annotation
    (Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(
          extent={{-120,40},{-80,80}})));
  CDL.Interfaces.BooleanInput uLeaConWatPum
    "Enabling status of lead condenser water pump" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-110,-24},{-70,16}})));
  CDL.Interfaces.RealInput uConWatPumSpe "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-122,-40},{-82,0}})));
protected
  final parameter Integer towCelInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";

equation

  connect(uChiSta, enaTowCel.uChiSta) annotation (Line(points={{-120,130},{-74,
          130},{-74,99},{-42,99}}, color={255,127,0}));
  connect(uChiStaSet, enaTowCel.uChiStaSet) annotation (Line(points={{-120,100},
          {-80,100},{-80,96},{-42,96}}, color={255,127,0}));
  connect(enaTowCel.uTowStaCha, uTowStaCha) annotation (Line(points={{-42,92},{
          -80,92},{-80,60},{-120,60}}, color={255,0,255}));
  connect(uWse, enaTowCel.uWse) annotation (Line(points={{-120,30},{-74,30},{
          -74,88},{-42,88}}, color={255,0,255}));
  connect(enaTowCel.uLeaConWatPum, uLeaConWatPum) annotation (Line(points={{-42,
          84},{-68,84},{-68,0},{-120,0}}, color={255,0,255}));
  connect(enaTowCel.uConWatPumSpe, uConWatPumSpe) annotation (Line(points={{-42,
          81},{-62,81},{-62,-40},{-120,-40}}, color={0,0,127}));
annotation (
  defaultComponentName="towSta",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{100,140}})),
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block controls cooling tower fan staging. This is implemented accoding to 
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), section 5.2.12.1, 
which specifies tower fan staging process. It includes two subsequences and one
implementation for disabling tower fan:
</p>
<ul>
<li>
Sequence of staging tower fans. It generates targeting tower cell status. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells</a>
for a description.
</li>
<li>
Sequence of process for enabling cells. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses</a>
for a description.
</li>
<li>
When disabling a tower cell, command the fan off and shut its supply isolation valve 
<code>yIsoVal = 0</code>.
</li>
</ul>
<p>
Note that in this implementation, inputs <code>uTowStaUp</code> and <code>uTowStaDow</code>
are from chiller staging process sequence. These inputs are also used for the 
condenser water pump staging. Thus, the tower stage changes are initiated concurrentlyl
with condenser water pump stage.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller_sim;
