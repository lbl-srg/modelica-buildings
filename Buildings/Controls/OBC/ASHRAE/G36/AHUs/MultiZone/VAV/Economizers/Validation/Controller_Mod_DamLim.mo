within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Validation;
model Controller_Mod_DamLim
  "Validation model for multi zone VAV AHU economizer operation: damper modulation and minimum ooutdoor air requirement damper position limits"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller
    eco(
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl.ReliefFan,
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A)
    "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{20,-20},{40,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller
    eco1(
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl.ReturnFanMeasuredAir,
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B,
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1)
    "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-60},{120,-20}})));

protected
  final parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";

  final parameter Real minVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  final parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.61
    "Minimal measured volumetric airflow";
  final parameter Real incVOutSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=(minVOutSet_flow - VOutMin_flow)*2.2
    "Maximum volumetric airflow increase during the example simulation";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanSta(final k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 5) "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VOutMinSet_flow(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp VOut_flow(
    final offset=VOutMin_flow,
    final duration=1800,
    final height=incVOutSet_flow) "Measured outdoor air volumetric airflow"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uTSup(
    final duration=1800,
    final height=2,
    final offset=-1)
    "Supply air temperature control signal"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supFanSpe(
    final duration=1800,
    final height=0.5,
    final offset=0.2) "Supply fan speed"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp dpDam2(
    final duration=1800,
    final offset=120,
    final height=52)  "Pressure accross outdoor air damper"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(fanSta.y, eco.u1SupFan) annotation (Line(points={{-58,-100},{-28,-100},
          {-28,-14},{18,-14}}, color={255,0,255}));
  connect(freProSta.y, eco.uFreProSta) annotation (Line(points={{-58,-140},{-20,
          -140},{-20,-19},{18,-19}}, color={255,127,0}));
  connect(opeMod.y, eco.uOpeMod) annotation (Line(points={{-98,-120},{-24,-120},
          {-24,-17},{18,-17}}, color={255,127,0}));
  connect(TOutBelowCutoff.y, eco.TOut) annotation (Line(points={{-98,80},{-20,
          80},{-20,-4},{18,-4}},
                             color={0,0,127}));
  connect(VOut_flow.y, eco.VOut_flow_normalized) annotation (Line(points={{-58,60},
          {-4,60},{-4,17},{18,17}}, color={0,0,127}));
  connect(VOutMinSet_flow.y, eco.VOutMinSet_flow_normalized) annotation (Line(
        points={{-58,100},{0,100},{0,19},{18,19}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, eco1.TOut) annotation (Line(points={{-98,80},{76,
          80},{76,-44},{98,-44}},
                              color={0,0,127}));
  connect(VOutMinSet_flow.y, eco1.VOutMinSet_flow_normalized) annotation (Line(
        points={{-58,100},{80,100},{80,-21},{98,-21}}, color={0,0,127}));
  connect(fanSta.y, eco1.u1SupFan) annotation (Line(points={{-58,-100},{-28,-100},
          {-28,-54},{98,-54}}, color={255,0,255}));
  connect(freProSta.y, eco1.uFreProSta) annotation (Line(points={{-58,-140},{-20,
          -140},{-20,-59},{98,-59}}, color={255,127,0}));
  connect(opeMod.y, eco1.uOpeMod) annotation (Line(points={{-98,-120},{-24,-120},
          {-24,-57},{98,-57}}, color={255,127,0}));
  connect(uTSup.y, eco.uTSup) annotation (Line(points={{-98,-40},{0,-40},{0,-1},
          {18,-1}},
                  color={0,0,127}));
  connect(uTSup.y, eco1.uTSup) annotation (Line(points={{-98,-40},{0,-40},{0,
          -41},{98,-41}},
                     color={0,0,127}));
  connect(supFanSpe.y, eco.uSupFan) annotation (Line(points={{-98,0},{-12,0},{-12,
          12},{18,12}}, color={0,0,127}));
  connect(supFanSpe.y, eco1.uSupFan) annotation (Line(points={{-98,0},{-12,0},{
          -12,-28},{98,-28}}, color={0,0,127}));
  connect(dpDam2.y, eco1.dpMinOutDam) annotation (Line(points={{-58,-60},{-32,
          -60},{-32,-38},{98,-38}},
                               color={0,0,127}));

annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Validation/Controller_Mod_DamLim.mos"
        "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{
            140,140}}), graphics={
        Text(
          extent={{92,14},{140,-10}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Economizer fully enabled -
validate damper position
and damper position limits
(example without
enthalpy measurement)"),
        Text(
          extent={{6,50},{56,28}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Economizer fully enabled -
validate damper position
and damper position limits")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller</a> control loops:
minimum outdoor air damper position limits control loop (<code>eco</code> block) and modulation
control loop (<code>eco1</code> block) for <code>VOut_flow</code> and <code>TSup</code> control signals.
Both control loops are enabled during the validation test.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller_Mod_DamLim;
