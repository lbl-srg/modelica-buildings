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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Controller wseSta
    annotation (Placement(transformation(extent={{-164,94},{-144,114}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna
    annotation (Placement(transformation(extent={{-260,160},{-240,180}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller heaPreCon
    annotation (Placement(transformation(extent={{-260,0},{-220,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller minBypValCon
    annotation (Placement(transformation(extent={{-260,-186},{-120,-54}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller conWatPumCon
    annotation (Placement(transformation(extent={{238,32},{258,52}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller chiWatPumCon
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset chiWatPlaRes
    annotation (Placement(transformation(extent={{-92,-114},{-72,-94}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet
    annotation (Placement(transformation(extent={{-60,-154},{-40,-134}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetpointController staSetCon
    annotation (Placement(transformation(extent={{60,-156},{182,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller towCon
    annotation (Placement(transformation(extent={{98,116},{158,236}})));

  CDL.Interfaces.RealInput                        VChiWat_flow(final quantity=
        "VolumeFlowRate", final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-320,30},{-280,70}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput                        TChiWatRetDow(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-320,90},{-280,130}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-320,130},{-280,170}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput                        TOutWet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-320,170},{-280,210}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
equation
  connect(staSetCon.uPla, plaEna.yPla) annotation (Line(points={{47.8,-174.375},
          {34,-174.375},{34,170},{-239,170}},
                                           color={255,0,255}));
  connect(heaPreCon.yMaxTowSpeSet, wseSta.uTowFanSpeMax) annotation (Line(
        points={{-218,32},{-190,32},{-190,96},{-166,96}}, color={0,0,127}));
annotation (
  defaultComponentName="chiPlaCon",
  Icon(graphics={
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
          extent={{-280,-200},{280,200}})),
  Documentation(info="<html>
<p>
fixme: Controller for plants with two devices or groups of devices (chillers, towers(4 cells), CW and C pumps)
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
