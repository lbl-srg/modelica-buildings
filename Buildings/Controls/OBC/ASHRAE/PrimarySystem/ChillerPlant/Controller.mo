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
    annotation (Placement(transformation(extent={{-260,240},{-200,300}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna
    annotation (Placement(transformation(extent={{-340,-380},{-320,-360}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot
    annotation (Placement(transformation(extent={{154,492},{194,532}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller heaPreCon(
      haveHeaPreConSig=false, haveWSE=true)
    annotation (Placement(transformation(extent={{-160,140},{-100,200}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller minBypValCon
    annotation (Placement(transformation(extent={{-260,-160},{-120,-20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller conWatPumCon
    annotation (Placement(transformation(extent={{170,364},{230,424}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller chiWatPumCon
    annotation (Placement(transformation(extent={{170,264},{230,324}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset chiWatPlaRes
    annotation (Placement(transformation(extent={{-240,-320},{-140,-220}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet
    annotation (Placement(transformation(extent={{-60,240},{20,320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetpointController staSetCon(have_WSE=
        true)
    annotation (Placement(transformation(extent={{80,-92},{216,126}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller towCon
    annotation (Placement(transformation(extent={{240,-420},{372,-160}})));

  CDL.Interfaces.RealInput                        VChiWat_flow(final quantity=
        "VolumeFlowRate", final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-420,180},{-380,220}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput                        TChiWatRetDow(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-420,220},{-380,260}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-420,260},{-380,300}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput                        TOutWet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-420,300},{-380,340}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.IntegerInput                        chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-420,-160},{-380,-120}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.BooleanInput                        uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-420,-10},{-380,30}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  CDL.Interfaces.RealInput                        dpChiWatPum(final unit="Pa",
      final quantity="PressureDifference") if
                                            not serChi
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-420,30},{-380,70}}),
    iconTransformation(extent={{-140,30},{-100,70}})));
  CDL.Interfaces.RealInput                        TConWatRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-420,130},{-380,170}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput                        TChiWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-420,100},{-380,140}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  CDL.Interfaces.BooleanInput                        uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation (Placement(transformation(extent={{-420,-40},{-380,0}}),
      iconTransformation(extent={{-140,150},{-100,190}})));
  CDL.Interfaces.BooleanInput                        uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation (Placement(transformation(extent={{-420,-70},{-380,-30}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
equation
  connect(staSetCon.uPla, plaEna.yPla) annotation (Line(points={{66.4,-112.438},
          {40,-112.438},{40,-370},{-319,-370}},
                                           color={255,0,255}));
  connect(TOutWet, wseSta.TOutWet) annotation (Line(points={{-400,320},{-330,
          320},{-330,294},{-266,294}}, color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation (Line(points={{-400,280},{
          -266,280},{-266,282}}, color={0,0,127}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation (Line(points={{-400,
          240},{-330,240},{-330,270},{-266,270}}, color={0,0,127}));
  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation (Line(points={{-400,200},
          {-300,200},{-300,258},{-266,258}}, color={0,0,127}));
  connect(TOutWet, plaEna.TOut) annotation (Line(points={{-400,320},{-360,320},
          {-360,-374},{-342,-374},{-342,-374.2}}, color={0,0,127}));
  connect(chiWatSupResReq, plaEna.chiWatSupResReq) annotation (Line(points={{
          -400,-140},{-350,-140},{-350,-366},{-342,-366}}, color={255,127,0}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (Line(
        points={{28,256},{40,256},{40,132.812},{66.4,132.812}}, color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation (Line(points={{-400,120},
          {40,120},{40,119.188},{66.4,119.188}}, color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation (Line(points={{
          -400,200},{-300,200},{-300,-41},{-274,-41}}, color={0,0,127}));
  connect(heaPreCon.TConWatRet, TChiWatRet) annotation (Line(points={{-166,188},
          {-336,188},{-336,280},{-400,280}}, color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation (Line(points={{-400,280},
          {-340,280},{-340,100},{40,100},{40,-3.4375},{66.4,-3.4375}}, color={0,
          0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation (Line(points={{66.4,
          -17.0625},{-40,-17.0625},{-40,222},{-140,222},{-140,270},{-197,270}},
        color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation (Line(points={{-400,
          200},{-300,200},{-300,114},{36,114},{36,-30.6875},{66.4,-30.6875}},
        color={0,0,127}));
  connect(TChiWatSup, heaPreCon.TChiWatSup) annotation (Line(points={{-400,120},
          {-320,120},{-320,176},{-166,176}}, color={0,0,127}));
  connect(wseSta.y, heaPreCon.uWSE) annotation (Line(points={{-197,285},{-180,
          285},{-180,152},{-166,152}}, color={255,0,255}));
  connect(chiWatSupResReq, chiWatPlaRes.TChiWatSupResReq) annotation (Line(
        points={{-400,-140},{-320,-140},{-320,-270},{-250,-270}}, color={255,
          127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-130,-270},{-80,-270},{-80,280},{-68,280}}, color={0,0,127}));
  connect(dpChiWatPum, staSetCon.dpChiWatPum) annotation (Line(points={{-400,50},
          {-168,50},{-168,51.0625},{66.4,51.0625}}, color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet) annotation (
      Line(points={{28,304},{48,304},{48,37.4375},{66.4,37.4375}}, color={0,0,
          127}));
  connect(uChi, towCon.uChi) annotation (Line(points={{-400,-20},{-328,-20},{
          -328,-179.5},{226.8,-179.5}}, color={255,0,255}));
  connect(wseSta.y, staSetCon.uWseSta) annotation (Line(points={{-197,285},{-74,
          285},{-74,-71.5625},{66.4,-71.5625}}, color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation (Line(points={{-197,285},{-76,285},
          {-76,-192.5},{226.8,-192.5}}, color={255,0,255}));
  connect(uTowSta, towCon.uTowSta) annotation (Line(points={{-400,-50},{-332,
          -50},{-332,-186},{200,-186},{200,-270.5},{226.8,-270.5}}, color={255,
          0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation (Line(points={{-319,-370},{200,
          -370},{200,-283.5},{226.8,-283.5}}, color={255,0,255}));
annotation (
  defaultComponentName="chiPlaCon",
  Icon(coordinateSystem(extent={{-380,-340},{380,340}}),
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
          extent={{-380,-340},{380,340}}), graphics={Text(
          extent={{216,542},{404,500}},
          lineColor={28,108,200},
          textString="for a version with 2 devices, add at the end")}),
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
