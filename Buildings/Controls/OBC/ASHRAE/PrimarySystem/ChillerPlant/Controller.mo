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
    annotation (Placement(transformation(extent={{-580,230},{-520,290}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna
    annotation (Placement(transformation(extent={{-660,-380},{-618,-338}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot
    annotation (Placement(transformation(extent={{-158,450},{-118,490}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller heaPreCon(
      haveHeaPreConSig=false, haveWSE=true)
    annotation (Placement(transformation(extent={{-480,130},{-420,190}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller minBypValCon
    annotation (Placement(transformation(extent={{-580,-170},{-440,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller conWatPumCon
    annotation (Placement(transformation(extent={{-150,354},{-90,414}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller chiWatPumCon
    annotation (Placement(transformation(extent={{-150,254},{-90,314}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset chiWatPlaRes
    annotation (Placement(transformation(extent={{-560,-320},{-480,-240}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet
    annotation (Placement(transformation(extent={{-380,230},{-300,310}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(have_WSE=
        true)
    annotation (Placement(transformation(extent={{-156,-46},{-40,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller towCon(
    final nTowCel=nTowCel)
    annotation (Placement(transformation(extent={{-340,-440},{-220,-196}})));

  CDL.Interfaces.RealInput VChiWat_flow(final quantity=
        "VolumeFlowRate", final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-840,170},{-800,210}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));

  CDL.Interfaces.RealInput TChiWatRetDow(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-840,210},{-800,250}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Interfaces.RealInput TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-840,250},{-800,290}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.RealInput TOutWet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-840,290},{-800,330}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Interfaces.IntegerInput chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-840,-170},{-800,-130}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-840,-20},{-800,20}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));

  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa",
      final quantity="PressureDifference") if
                                            not serChi
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-840,20},{-800,60}}),
    iconTransformation(extent={{-140,30},{-100,70}})));

  CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-840,120},{-800,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-840,90},{-800,130}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation (Placement(transformation(extent={{-840,-50},{-800,-10}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation (Placement(transformation(extent={{-840,-80},{-800,-40}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Staging.Processes.Down dowProCon
    annotation (Placement(transformation(extent={{112,-100},{188,52}})));
  Staging.Processes.Up upProCon
    annotation (Placement(transformation(extent={{100,150},{176,302}})));
  CDL.Continuous.MultiMax mulMax(nin=nTowCel)
    annotation (Placement(transformation(extent={{-200,-390},{-180,-370}})));
equation
  connect(staSetCon.uPla, plaEna.yPla) annotation (Line(points={{-167.6,-75.0625},
          {-380,-75.0625},{-380,-358},{-498,-358},{-498,-359},{-615.9,-359}},
                                               color={255,0,255}));
  connect(TOutWet, wseSta.TOutWet) annotation (Line(points={{-820,310},{-690,
          310},{-690,284},{-586,284}}, color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation (Line(points={{-820,270},{
          -586,270},{-586,272}}, color={0,0,127}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation (Line(points={{-820,
          230},{-690,230},{-690,260},{-586,260}}, color={0,0,127}));
  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation (Line(points={{-820,190},
          {-660,190},{-660,248},{-586,248}}, color={0,0,127}));
  connect(TOutWet, plaEna.TOut) annotation (Line(points={{-820,310},{-720,310},{
          -720,-384},{-664.2,-384},{-664.2,-367.82}},
                                                  color={0,0,127}));
  connect(chiWatSupResReq, plaEna.chiWatSupResReq) annotation (Line(points={{-820,
          -150},{-710,-150},{-710,-350.6},{-664.2,-350.6}},color={255,127,0}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (Line(
        points={{-292,246},{-280,246},{-280,157.438},{-167.6,157.438}},
                                                                color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation (Line(points={{-820,110},
          {-320,110},{-320,145.812},{-167.6,145.812}},
                                                 color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation (Line(points={{-820,
          190},{-660,190},{-660,-51},{-594,-51}},      color={0,0,127}));
  connect(heaPreCon.TConWatRet, TChiWatRet) annotation (Line(points={{-486,178},
          {-696,178},{-696,270},{-820,270}}, color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation (Line(points={{-820,270},
          {-700,270},{-700,90},{-320,90},{-320,17.9375},{-167.6,17.9375}},
                                                                       color={0,
          0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation (Line(points={{-167.6,6.3125},
          {-360,6.3125},{-360,212},{-460,212},{-460,260},{-517,260}},
        color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation (Line(points={{-820,190},
          {-660,190},{-660,104},{-324,104},{-324,-5.3125},{-167.6,-5.3125}},
        color={0,0,127}));
  connect(TChiWatSup, heaPreCon.TChiWatSup) annotation (Line(points={{-820,110},
          {-680,110},{-680,166},{-486,166}}, color={0,0,127}));
  connect(wseSta.y, heaPreCon.uWSE) annotation (Line(points={{-517,275},{-500,
          275},{-500,142},{-486,142}}, color={255,0,255}));
  connect(chiWatSupResReq, chiWatPlaRes.TChiWatSupResReq) annotation (Line(
        points={{-820,-150},{-680,-150},{-680,-280},{-568,-280}}, color={255,
          127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-472,-280},{-400,-280},{-400,270},{-388,270}},
                                                                color={0,0,127}));
  connect(dpChiWatPum, staSetCon.dpChiWatPum) annotation (Line(points={{-820,40},
          {-528,40},{-528,87.6875},{-167.6,87.6875}},
                                                    color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet) annotation (
      Line(points={{-292,294},{-272,294},{-272,76.0625},{-167.6,76.0625}},
                                                                   color={0,0,
          127}));
  connect(uChi, towCon.uChi) annotation (Line(points={{-820,-30},{-688,-30},{-688,
          -214.3},{-352,-214.3}},       color={255,0,255}));
  connect(wseSta.y, staSetCon.uWseSta) annotation (Line(points={{-517,275},{-394,
          275},{-394,-40.1875},{-167.6,-40.1875}},
                                                color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation (Line(points={{-517,275},{-396,275},
          {-396,-226.5},{-352,-226.5}}, color={255,0,255}));
  connect(uTowSta, towCon.uTowSta) annotation (Line(points={{-820,-60},{-674,-60},
          {-674,-200},{-440,-200},{-440,-299.7},{-352,-299.7}},     color={255,
          0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation (Line(points={{-615.9,-359},{-440,
          -359},{-440,-311.9},{-352,-311.9}}, color={255,0,255}));
  connect(TOutWet, staSetCon.TOutWet) annotation (Line(points={{-820,310},{-720,
          310},{-720,60},{-167.6,60},{-167.6,58.625}}, color={0,0,127}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-517,245},
          {-514,245},{-514,47},{-167.6,47}}, color={0,0,127}));
  connect(towCon.yFanSpe, mulMax.u[1:4]) annotation (Line(points={{-208,-385.1},
          {-202,-385.1},{-202,-380}},   color={0,0,127}));
  connect(mulMax.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{-178,-380},
          {-160,-380},{-160,-122},{-200,-122},{-200,35.375},{-167.6,35.375}},
        color={0,0,127}));
annotation (
  defaultComponentName="chiPlaCon",
  Icon(coordinateSystem(extent={{-800,-740},{800,740}}),
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
          extent={{-800,-740},{800,740}}), graphics={Text(
          extent={{-96,500},{92,458}},
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
