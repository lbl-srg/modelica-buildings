within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Validation;
model Controller_Disable
  "Validation model for disabling the multi zone VAV AHU economizer modulation and damper position limit control loops"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller
    eco(
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A,
    final minOAConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multi zone VAV AHU economizer "
    annotation (Placement(transformation(extent={{20,0},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller
    eco1(
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A,
    final minOAConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Multi zone VAV AHU economizer"
    annotation (Placement(transformation(extent={{100,-40},{120,0}})));

protected
  final parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Real hOutCutoff(
    final unit="J/kg",
    final quantity="SpecificEnergy")=65100
    "Outdoor air enthalpy high limit cutoff";
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
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta2(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage2)
    "Freeze protection stage is 2"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 40000) "Outdoor air enthalpy is below the cutoff"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 30) "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VOutMinSet_flow(
    final k=minVOutSet_flow)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp VOut_flow(
    final height=incVOutSet_flow,
    final offset=VOutMin_flow,
    final duration=1800) "Measured outdoor air volumetric airflow"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup(
    final duration=1800,
    final height=2,
    final offset=-1)
                    "Supply air temperature control signal"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

equation
  connect(fanSta.y, eco.u1SupFan) annotation (Line(points={{-58,-70},{-12,-70},
          {-12,6},{18,6}}, color={255,0,255}));
  connect(freProSta.y, eco.uFreProSta) annotation (Line(points={{-98,-120},
          {0,-120},{0,1},{18,1}}, color={255,127,0}));
  connect(TOutBelowCutoff.y, eco.TOut) annotation (Line(points={{-98,100},{-12,
          100},{-12,16},{18,16}},                color={0,0,127}));
  connect(VOut_flow.y, eco.VOut_flow_normalized) annotation (Line(points={{-58,80},
          {-6,80},{-6,37},{18,37}},                    color={0,0,127}));
  connect(VOutMinSet_flow.y, eco.VOutMinSet_flow_normalized) annotation (
     Line(points={{-58,120},{0,120},{0,39},{18,39}},       color={0,0,127}));
  connect(TOutBelowCutoff.y, eco1.TOut) annotation (Line(points={{-98,100},{68,
          100},{68,-24},{98,-24}},                    color={0,0,127}));
  connect(VOut_flow.y, eco1.VOut_flow_normalized) annotation (Line(
        points={{-58,80},{74,80},{74,-3},{98,-3}},           color={0,0,127}));
  connect(VOutMinSet_flow.y, eco1.VOutMinSet_flow_normalized)
    annotation (Line(points={{-58,120},{80,120},{80,-1},{98,-1}},     color={0,
          0,127}));
  connect(fanSta.y, eco1.u1SupFan) annotation (Line(points={{-58,-70},{-12,-70},
          {-12,-34},{98,-34}}, color={255,0,255}));
  connect(opeMod.y, eco.uOpeMod) annotation (Line(points={{-58,-100},{-6,-100},
          {-6,3},{18,3}},                  color={255,127,0}));
  connect(opeMod.y, eco1.uOpeMod) annotation (Line(points={{-58,-100},{-6,-100},
          {-6,-37},{98,-37}},                  color={255,127,0}));
  connect(uTSup.y, eco.uTSup) annotation (Line(points={{-98,40},{-40,40},{-40,
          19},{18,19}},                 color={0,0,127}));
  connect(uTSup.y, eco1.uTSup) annotation (Line(points={{-98,40},{-40,40},{-40,
          -21},{98,-21}},                                color={0,0,127}));
  connect(freProSta2.y, eco1.uFreProSta) annotation (Line(points={{42,-120},
          {60,-120},{60,-39},{98,-39}}, color={255,127,0}));
  connect(hOutBelowCutoff.y, eco1.hAirOut) annotation (Line(points={{-98,0},{-60,
          0},{-60,-29},{98,-29}}, color={0,0,127}));

  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Validation/Controller_Disable.mos"
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
            220,160}})),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller</a>
for control signals which disable modulation control loop only (<code>eco</code> block)
and both minimum outdoor airflow and modulation control loops (<code>eco1</code> block).
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller_Disable;
