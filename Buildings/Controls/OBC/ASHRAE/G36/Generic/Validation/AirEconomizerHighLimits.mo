within Buildings.Controls.OBC.ASHRAE.G36.Generic.Validation;
model AirEconomizerHighLimits
  "Model validates the block for specifying air economizer high limits"

  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B)
    "ASHRAE standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim1(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_1)
    "Title 24 standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim2(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5A)
    "ASHRAE standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim3(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A)
    "ASHRAE standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim4(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B)
    "ASHRAE standard, with differential dry bulb device"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim5(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B)
    "ASHRAE standard, with fixed enthalpy and fixed dry bulb device"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim6(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B)
    "ASHRAE standard, with differential enthalpy and fixed dry bulb device"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim7(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_2)
    "Title 24 standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim8(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_6)
    "Title 24 standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim9(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_7)
    "Title 24 standard, with fixed dry bulb device"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim10(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_1)
    "Title 24 standard, with differential dry bulb device"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim11(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_2)
    "Title 24 standard, with differential dry bulb device"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim12(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_6)
    "Title 24 standard, with differential dry bulb device"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim13(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_7)
    "Title 24 standard, with differential dry bulb device"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits ecoHigLim14(
    final eneStd=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24,
    final ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb,
    final tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_1)
    "Title 24 standard, with fixed enthalpy and fixed dry bulb device"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp retAirEnt(
    final height=5000,
    final duration=10,
    final offset=65000) "Return air enthalpy"
    annotation (Placement(transformation(extent={{-90,-6},{-70,14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp retAirTem(
    final height=5,
    final duration=10,
    final offset=295.15) "Return air temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

equation
  connect(retAirTem.y, ecoHigLim4.TRet) annotation (Line(points={{-68,-40},{-60,
          -40},{-60,76},{-52,76}}, color={0,0,127}));
  connect(retAirTem.y, ecoHigLim10.TRet) annotation (Line(points={{-68,-40},{-60,
          -40},{-60,-54},{-52,-54}}, color={0,0,127}));
  connect(retAirTem.y, ecoHigLim11.TRet) annotation (Line(points={{-68,-40},{-20,
          -40},{-20,-54},{-12,-54}}, color={0,0,127}));
  connect(retAirTem.y, ecoHigLim12.TRet) annotation (Line(points={{-68,-40},{20,
          -40},{20,-54},{28,-54}}, color={0,0,127}));
  connect(retAirTem.y, ecoHigLim13.TRet) annotation (Line(points={{-68,-40},{60,
          -40},{60,-54},{68,-54}}, color={0,0,127}));
  connect(retAirEnt.y, ecoHigLim6.hRet)
    annotation (Line(points={{-68,4},{-52,4}}, color={0,0,127}));
annotation (experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Generic/Validation/AirEconomizerHighLimits.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits\">
Buildings.Controls.OBC.ASHRAE.G36.Generic.AirEconomizerHighLimits</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end AirEconomizerHighLimits;
