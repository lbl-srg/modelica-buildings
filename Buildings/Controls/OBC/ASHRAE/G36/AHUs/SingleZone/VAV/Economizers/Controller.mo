within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers;
block Controller "Single zone VAV AHU economizer control sequence"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneStd
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon
    "Economizer high limit control device";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));
  parameter Boolean have_heaCoi=true
    "True if the air handling unit has heating coil";
  parameter Real uMin(
    final min=0.1,
    final max=0.9,
    final unit="1") = 0.1
    "Lower limit of controller output at which the dampers are at their limits";
  parameter Real uMax(
    final min=0.1,
    final max=1,
    final unit="1") = 0.9
    "Upper limit of controller output at which the dampers are at their limits";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Modulation"));
  parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
    annotation(Dialog(group="Modulation"));
  parameter Real TiMod(
    final unit="s",
    final quantity="Time")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real delTOutHys(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real delEntHys(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Dialog(tab="Advanced", group="Hysteresis",
                      enable = ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                               or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb));
  parameter Real floHys(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.01
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real supFanSpe_min(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real supFanSpe_max(
    final min=0,
    final max=1,
    final unit="1") = 0.9 "Maximum supply fan operation speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamMinFloMinSpe(
    final min=outDamPhy_min,
    final max=outDamPhy_max,
    final unit="1") = 0.4
    "Outdoor air damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamMinFloMaxSpe(
    final min=outDamPhy_min,
    final max=outDamPhy_max,
    final unit="1") = 0.3
    "Outdoor air damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamDesFloMinSpe(
    final min=outDamMinFloMinSpe,
    final max=outDamPhy_max,
    final unit="1") = 0.9
    "Outdoor air damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamDesFloMaxSpe(
    final min=outDamMinFloMaxSpe,
    final max=outDamPhy_max,
    final unit="1") = 0.8
    "Outdoor air damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamPhy_max(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhy_min(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhy_max(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhy_min(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-180,200},{-140,240}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-180,160},{-140,200}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-180,120},{-140,160}}),
      iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hAirRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
     and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Return air enthalpy"
    annotation (Placement(transformation(extent={{-180,90},{-140,130}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupHeaEcoSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(
    final min=VOutMin_flow,
    final max=VOutDes_flow,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan_actual(
    final min=supFanSpe_min,
    final max=supFanSpe_max,
    final unit="1")
    "Actual supply fan speed"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan proven on"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam_min(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor damper minimum position"
    annotation (Placement(transformation(extent={{140,160},{180,200}}),
        iconTransformation(extent={{100,140},{140,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final unit="1",
    final min=0,
    final max=1) if have_heaCoi
    "Heating coil commanded valve position"
    annotation (Placement(transformation(extent={{140,100},{180,140}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis(
    final use_enthalpy=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                       or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final retDamPhy_max=retDamPhy_max,
    final delTOutHys=delTOutHys,
    final delEntHys=delEntHys,
    final retDamPhy_min=retDamPhy_min)
    "Single zone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits
    damLim(
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final outDamPhy_max=outDamPhy_max,
    final outDamPhy_min=outDamPhy_min,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final outDamMinFloMinSpe=outDamMinFloMinSpe,
    final outDamMinFloMaxSpe=outDamMinFloMaxSpe,
    final outDamDesFloMinSpe=outDamDesFloMinSpe,
    final outDamDesFloMaxSpe=outDamDesFloMaxSpe,
    final floHys=floHys)
    "Single zone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation
    mod(
    final have_heaCoi=have_heaCoi,
    final controllerType=controllerTypeMod,
    final k=kMod,
    final Ti=TiMod,
    final Td=TdMod,
    final uMin=uMin,
    final uMax=uMax)
    "Single zone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim(
    final eneStd=eneStd,
    final ecoHigLimCon=ecoHigLimCon,
    final ashCliZon=ashCliZon,
    final tit24CliZon=tit24CliZon) "High limits"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(u1SupFan, enaDis.u1SupFan) annotation (Line(points={{-160,-90},{-120,-90},
          {-120,-70},{18,-70}}, color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta)
    annotation (Line(points={{-160,-180},{-96,-180},{-96,-73},{18,-73}}, color={255,127,0}));
  connect(hOut, enaDis.hOut)
    annotation (Line(points={{-160,140},{-4,140},{-4,-65},{18,-65}},   color={0,0,127}));
  connect(TOut, enaDis.TOut)
    annotation (Line(points={{-160,220},{-68,220},{-68,-61},{18,-61}},  color={0,0,127}));
  connect(u1SupFan, damLim.u1SupFan) annotation (Line(points={{-160,-90},{-120,-90},
          {-120,10},{-102,10}}, color={255,0,255}));
  connect(uOpeMod, damLim.uOpeMod)
    annotation (Line(points={{-160,-120},{-116,-120},{-116,1.8},{-102,1.8}},
      color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta)
    annotation (Line(points={{-160,-180},{-110,-180},{-110,6},{-102,6}},
      color={255,127,0}));
  connect(damLim.yOutDam_max, enaDis.uOutDam_max) annotation (Line(points={{-78,
          16},{-60,16},{-60,-77},{18,-77}}, color={0,0,127}));
  connect(enaDis.yOutDam_max, mod.uOutDam_max) annotation (Line(points={{42,-64},
          {52,-64},{52,-4},{78,-4}}, color={0,0,127}));
  connect(enaDis.yRetDam_max, mod.uRetDam_max) annotation (Line(points={{42,-70},
          {56,-70},{56,2},{78,2}}, color={0,0,127}));
  connect(damLim.yOutDam_min, mod.uOutDam_min) annotation (Line(points={{-78,4},
          {-64,4},{-64,-6},{78,-6}}, color={0,0,127}));
  connect(enaDis.yRetDam_min, mod.uRetDam_min) annotation (Line(points={{42,-76},
          {60,-76},{60,0},{78,0}}, color={0,0,127}));
  connect(uZonSta, enaDis.uZonSta)
    annotation (Line(points={{-160,-150},{-100,-150},{-100,-75},{18,-75}}, color={255,127,0}));
  connect(uSupFan_actual, damLim.uSupFan_actual) annotation (Line(points={{-160,
          -20},{-126,-20},{-126,14},{-102,14}}, color={0,0,127}));
  connect(VOutMinSet_flow, damLim.VOutMinSet_flow)
    annotation (Line(points={{-160,10},{-130,10},{-130,18},{-102,18}},color={0,0,127}));
  connect(mod.yHeaCoi, yHeaCoi) annotation (Line(points={{102,6},{110,6},{110,120},
          {160,120}}, color={0,0,127}));
  connect(damLim.yOutDam_min, enaDis.uOutDam_min) annotation (Line(points={{-78,
          4},{-64,4},{-64,-79},{18,-79}}, color={0,0,127}));
  connect(TAirSup, mod.TSup) annotation (Line(points={{-160,70},{60,70},{60,8},{
          78,8}}, color={0,0,127}));
  connect(TSupHeaEcoSet, mod.TSupHeaEcoSet) annotation (Line(points={{-160,40},{
          56,40},{56,6},{78,6}}, color={0,0,127}));
  connect(u1SupFan, mod.u1SupFan) annotation (Line(points={{-160,-90},{-120,-90},
          {-120,-9},{78,-9}}, color={255,0,255}));
  connect(mod.yRetDam, yRetDam) annotation (Line(points={{102,0},{120,0},{120,50},
          {160,50}}, color={0,0,127}));
  connect(mod.yOutDam, yOutDam) annotation (Line(points={{102,-6},{120,-6},{120,
          -40},{160,-40}}, color={0,0,127}));
  connect(damLim.yOutDam_min, yOutDam_min) annotation (Line(points={{-78,4},{20,
          4},{20,180},{160,180}}, color={0,0,127}));
  connect(ecoHigLim.TCut, enaDis.TCut) annotation (Line(points={{-18,-24},{0,-24},
          {0,-63},{18,-63}}, color={0,0,127}));
  connect(ecoHigLim.hCut, enaDis.hCut) annotation (Line(points={{-18,-36},{-8,-36},
          {-8,-67},{18,-67}}, color={0,0,127}));
  connect(TAirRet, ecoHigLim.TRet) annotation (Line(points={{-160,180},{-52,180},
          {-52,-24},{-42,-24}}, color={0,0,127}));
  connect(hAirRet, ecoHigLim.hRet) annotation (Line(points={{-160,110},{-56,110},
          {-56,-36},{-42,-36}}, color={0,0,127}));
annotation (defaultComponentName = "conEco",
        Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
             graphics={Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-66,-118},{-32,-118},{20,120},{60,120}}, color={0,0,127},
          thickness=0.5),
        Line(
          points={{-68,120},{-40,120},{28,-120},{90,-120}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{60,120},{60,-36},{60,-104},{88,-104}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-240},
            {140,240}})),
Documentation(info="<html>
<p>
Single zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on Section 5.18.5, 5.18.6, 5.18.7, 5.1.17
of ASHRAE Guidline 36, May 2020.
</p>
<p>
The sequence consists of three subsequences.
<ul>
<li>
First, the block <code>damLim</code> computes the damper position limits to satisfy
outdoor air requirements. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits</a>
for a description.
</li>
<li>
Second, the block <code>enaDis</code> enables or disables the economizer based on
outdoor temperature and optionally enthalpy, and based on the supply fan status,
freeze protection stage and zone state.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
for a description.
The block <code>ecoHigLim</code> specifies the economizer high limit cutoff values
based on the energy standard, device type and climate zones. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits\">
Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits</a>
for a description.
</li>
<li>
Third, the block <code>mod</code> modulates the outdoor and return damper position
to track the supply air temperature setpoint for heating, subject to the limits of the damper positions
that were computed in the above two blocks.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 30, 2019, by Kun Zhang:<br/>
Added fixed plus differential dry bulb temperature high limit cut off.
</li>
<li>
October 31, 2018, by David Blum:<br/>
Added heating coil output.
</li>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
