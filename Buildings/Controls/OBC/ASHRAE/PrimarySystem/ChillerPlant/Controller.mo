within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block Controller "Head pressure controller"
  parameter Real minTowSpe=0.1 "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe=0.1 "Minimum condenser water pump speed"
    annotation (Dialog(enable= not ((not haveWSE) and fixSpePum)));
  parameter Real minHeaPreValPos=0.1 "Minimum head pressure control valve position"
    annotation (Dialog(enable= (not ((not haveWSE) and (not fixSpePum)))));
  parameter Boolean haveHeaPreConSig = false
    "Flag indicating if there is head pressure control signal from chiller controller"
    annotation (Dialog(group="Plant"));
  parameter Boolean haveWSE = true
    "Flag indicating if the plant has waterside economizer"
    annotation (Dialog(group="Plant"));
  parameter Boolean fixSpePum = true
    "Flag indicating if the plant has fixed speed condenser water pumps"
    annotation (Dialog(group="Plant", enable=not haveWSE));
  parameter Modelica.SIunits.TemperatureDifference minChiLif=10
    "Minimum allowable lift at minimum load for chiller"
    annotation (Dialog(tab="Loop signal", enable=not haveHeaPreConSig));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not haveHeaPreConSig));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not haveHeaPreConSig));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not haveHeaPreConSig));

  Economizer.Controller wseSta
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Generic.PlantEnable plaEna
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Generic.EquipmentRotation.ControllerTwo equRot
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  HeadPressure.Controller heaPreCon
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  MinimumFlowBypass.Controller minBypValCon
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Pumps.CondenserWater.Controller conWatPumCon
    annotation (Placement(transformation(extent={{0,-118},{20,-98}})));
  Pumps.ChilledWater.Controller chiWatPumCon
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  SetPoints.ChilledWaterPlantReset chiWatPlaRes
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  SetPoints.ChilledWaterSupply chiWatSupSet
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Staging.SetpointController staSetCon
    annotation (Placement(transformation(extent={{60,6},{80,26}})));
  Tower.Controller towCon
    annotation (Placement(transformation(extent={{60,80},{80,120}})));
equation

  connect(staSetCon.uPla, plaEna.yPla) annotation (Line(points={{58,-5},{34,-5},
          {34,-2},{4,-2},{4,70},{-19,70}}, color={255,0,255}));
annotation (
  defaultComponentName="heaPreCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-200},{140,200}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-200},{140,200}})),
  Documentation(info="<html>
<p>
fixme
</p>
</html>",
revisions="<html>
<ul>
<li>
January 30, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
