within Buildings.Controls.OBC.ASHRAE.G36.Generic;
block AirEconomizerHighLimits "Specify the economizer high liimits"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneStd
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon
    "Economizer high limit control device";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb)
    "Return air temperature"
    annotation (Placement(transformation(extent={{-580,550},{-540,590}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
     and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Return air enthalpy. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-580,-10},{-540,30}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Outdoor air temperature high limit cutoff"
    annotation (Placement(transformation(extent={{540,790},{580,830}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput hCut(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Outdoor air enthalpy high limit cutoff"
    annotation (Placement(transformation(extent={{540,20},{580,60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fixDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb)
    "Fixed dry bulb"
    annotation (Placement(transformation(extent={{-520,1000},{-500,1020}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant difDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb)
    "Differential dry bulb"
    annotation (Placement(transformation(extent={{-520,960},{-500,980}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fixEntFixDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Fixed enthalpy with fixed dry bulb"
    annotation (Placement(transformation(extent={{-520,920},{-500,940}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant difEntFixDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Differential enthalpy with fixed dry bulb"
    annotation (Placement(transformation(extent={{-520,840},{-500,860}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash1A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 1A"
    annotation (Placement(transformation(extent={{-460,1220},{-440,1240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash1B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 1B"
    annotation (Placement(transformation(extent={{-380,1220},{-360,1240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash2A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_2A)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 2A"
    annotation (Placement(transformation(extent={{-300,1220},{-280,1240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash2B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_2B)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 2B"
    annotation (Placement(transformation(extent={{-220,1220},{-200,1240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash3A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3A)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 3A"
    annotation (Placement(transformation(extent={{-140,1220},{-120,1240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash3B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 3B"
    annotation (Placement(transformation(extent={{-460,1160},{-440,1180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash3C(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3C)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 3C"
    annotation (Placement(transformation(extent={{-380,1160},{-360,1180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash4A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4A)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 4A"
    annotation (Placement(transformation(extent={{-300,1160},{-280,1180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash4B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4B)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 4B"
    annotation (Placement(transformation(extent={{-220,1160},{-200,1180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash4C(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4C)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 4C"
    annotation (Placement(transformation(extent={{-140,1160},{-120,1180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash5A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5A)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 5A"
    annotation (Placement(transformation(extent={{-460,1100},{-440,1120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash5B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5B)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 5B"
    annotation (Placement(transformation(extent={{-380,1100},{-360,1120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash5C(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5C)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 5C"
    annotation (Placement(transformation(extent={{-300,1100},{-280,1120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash6A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_6A)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 6A"
    annotation (Placement(transformation(extent={{-220,1100},{-200,1120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash6B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_6B)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 6B"
    annotation (Placement(transformation(extent={{-140,1100},{-120,1120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash7(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_7)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 7"
    annotation (Placement(transformation(extent={{-460,1040},{-440,1060}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash8(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_8)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "ASHRAE zone 8"
    annotation (Placement(transformation(extent={{-380,1040},{-360,1060}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 1b, 2b or 3b"
    annotation (Placement(transformation(extent={{-40,840},{-20,860}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 3c, 4b or 4c"
    annotation (Placement(transformation(extent={{-40,800},{-20,820}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or2
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 5b, 5c or 6b"
    annotation (Placement(transformation(extent={{-40,760},{-20,780}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or4
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical or"
    annotation (Placement(transformation(extent={{20,800},{40,820}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 7 or 8"
    annotation (Placement(transformation(extent={{-40,720},{-20,740}})));
  Buildings.Controls.OBC.CDL.Logical.Or or7
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical or"
    annotation (Placement(transformation(extent={{80,800},{100,820}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 5a or 6a"
    annotation (Placement(transformation(extent={{80,660},{100,680}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,800},{240,820}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,660},{240,680}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,400},{240,420}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{460,800},{480,820}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=273.15 + 24)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off temperature"
    annotation (Placement(transformation(extent={{220,840},{240,860}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{420,660},{440,680}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=273.15 + 21)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off temperature"
    annotation (Placement(transformation(extent={{220,700},{240,720}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{380,580},{400,600}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=273.15 + 18)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off temperature"
    annotation (Placement(transformation(extent={{220,620},{240,640}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or10
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 1b, 2b or 3b"
    annotation (Placement(transformation(extent={{-40,540},{-20,560}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or11
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 3c, 4b or 4c"
    annotation (Placement(transformation(extent={{-40,500},{-20,520}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or12
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 5a, 5b or 5c"
    annotation (Placement(transformation(extent={{-40,460},{-20,480}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or13
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 6a, 6b or 7"
    annotation (Placement(transformation(extent={{-40,420},{-20,440}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or14
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical or"
    annotation (Placement(transformation(extent={{20,500},{40,520}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or15
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical or"
    annotation (Placement(transformation(extent={{80,400},{100,420}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{340,420},{360,440}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or8
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 1a, 2a or 3a"
    annotation (Placement(transformation(extent={{-40,340},{-20,360}})));
  Buildings.Controls.OBC.CDL.Logical.Or or9
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Zone 1a, 2a, 3a or 4a"
    annotation (Placement(transformation(extent={{20,360},{40,380}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,360},{240,380}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: Differential dry bulb high-limit-control device is not allowed in climate zone 1A, 2A, 3A and 4A!")
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Warning when the wrong device being used"
    annotation (Placement(transformation(extent={{480,360},{500,380}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical not"
    annotation (Placement(transformation(extent={{440,360},{460,380}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=273.15 + 24)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off temperature"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air enthalpy"
    annotation (Placement(transformation(extent={{380,30},{400,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(
    final k=66000)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Enthalpy cutoff value, J/kg"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon1(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_1)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 1"
    annotation (Placement(transformation(extent={{-460,-60},{-440,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon2(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_2)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 2"
    annotation (Placement(transformation(extent={{-380,-60},{-360,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon3(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_3)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 3"
    annotation (Placement(transformation(extent={{-300,-60},{-280,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon4(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_4)
 if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 4"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon5(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_5)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 5"
    annotation (Placement(transformation(extent={{-460,-120},{-440,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon6(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_6)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 6"
    annotation (Placement(transformation(extent={{-380,-120},{-360,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon8(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_8)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 8"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon9(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_9)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 9"
    annotation (Placement(transformation(extent={{-460,-180},{-440,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon10(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_10)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 10"
    annotation (Placement(transformation(extent={{-380,-180},{-360,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon11(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_11)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 11"
    annotation (Placement(transformation(extent={{-300,-180},{-280,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon12(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_12)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 12"
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon13(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_13)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 13"
    annotation (Placement(transformation(extent={{-460,-240},{-440,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon14(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_14)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 14"
    annotation (Placement(transformation(extent={{-380,-240},{-360,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon15(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_15)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 15"
    annotation (Placement(transformation(extent={{-300,-240},{-280,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon16(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_16)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Title 24, zone 16"
    annotation (Placement(transformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or16
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Zone 1, 3 or 5"
    annotation (Placement(transformation(extent={{-40,-300},{-20,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or17
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Zone 11, 12 or 13"
    annotation (Placement(transformation(extent={{-40,-340},{-20,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or18
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Zone 14, 15 or 16"
    annotation (Placement(transformation(extent={{-40,-380},{-20,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or20
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Zone 1, 3, 5, or 11 to 16"
    annotation (Placement(transformation(extent={{20,-340},{40,-320}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-340},{220,-320}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{480,-340},{500,-320}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con5(
    final k=273.15 + 24)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{200,-300},{220,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or19
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Zone 2, 4 or 10"
    annotation (Placement(transformation(extent={{-40,-430},{-20,-410}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-430},{220,-410}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{440,-430},{460,-410}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    final k=273.15 + 23)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{200,-390},{220,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or21
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Zone 6, 8 or 9"
    annotation (Placement(transformation(extent={{-40,-510},{-20,-490}})));
  Buildings.Controls.OBC.CDL.Logical.And and7
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-510},{220,-490}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=273.15 + 22)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{200,-470},{220,-450}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi7
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{400,-510},{420,-490}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=273.15 + 21)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{200,-550},{220,-530}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi8
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{360,-590},{380,-570}})));
  Buildings.Controls.OBC.CDL.Logical.And and8
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-660},{220,-640}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi9
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{480,-640},{500,-620}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-740},{220,-720}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi10
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{440,-740},{460,-720}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-1) if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{280,-700},{300,-680}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi11
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{400,-820},{420,-800}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-820},{220,-800}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-2)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{280,-780},{300,-760}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi12
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{360,-900},{380,-880}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=-3)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{280,-860},{300,-840}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(
    final k=273.15 + 24)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off temperature"
    annotation (Placement(transformation(extent={{200,-1240},{220,-1220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=66000)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titEngSta(
    final k=eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Check if Title 24 energy standard is used"
    annotation (Placement(transformation(extent={{-460,-720},{-440,-700}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Check if Title 24 energy standard is used and the device type is differential enthalpy with fixed dry bulb"
    annotation (Placement(transformation(extent={{-380,-680},{-360,-660}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: When Title 24 energy standard is used, the device type cannot be differential enthalpy with fixed dry bulb!")
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Warning when the wrong device being used"
    annotation (Placement(transformation(extent={{-280,-680},{-260,-660}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical not"
    annotation (Placement(transformation(extent={{-320,-680},{-300,-660}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con10(
    final k=0)
    if (eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
     and not ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Constant 0"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con11(
    final k=0)
    if not (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb)
    "Constant 0"
    annotation (Placement(transformation(extent={{-220,600},{-200,620}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fixDryBulDifDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb)
    "Fixed dry bulb with differential dry bulb"
    annotation (Placement(transformation(extent={{-520,880},{-500,900}})));
  Buildings.Controls.OBC.CDL.Logical.And and12
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,270},{240,290}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Smaller input"
    annotation (Placement(transformation(extent={{220,310},{240,330}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi13
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{300,270},{320,290}})));
  Buildings.Controls.OBC.CDL.Logical.And and13
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,180},{240,200}})));
  Buildings.Controls.OBC.CDL.Reals.Min min2
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Smaller input"
    annotation (Placement(transformation(extent={{220,220},{240,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con12(
    final k=273.15 + 21)
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off temperature"
    annotation (Placement(transformation(extent={{20,250},{40,270}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi14
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{260,180},{280,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and14
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical and"
    annotation (Placement(transformation(extent={{220,120},{240,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Logical not"
    annotation (Placement(transformation(extent={{300,120},{320,140}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: Fixed dry bulb with differential dry bulb high-limit-control device is not allowed in climate zone 1A, 2A, 3A and 4A!")
 if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
    "Warning when the wrong device being used"
    annotation (Placement(transformation(extent={{340,120},{360,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and15
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-990},{220,-970}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi15
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{480,-990},{500,-970}})));
  Buildings.Controls.OBC.CDL.Reals.Min min3
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Smaller input"
    annotation (Placement(transformation(extent={{360,-960},{380,-940}})));
  Buildings.Controls.OBC.CDL.Logical.And and16
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-1060},{220,-1040}})));
  Buildings.Controls.OBC.CDL.Reals.Min min4
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Smaller input"
    annotation (Placement(transformation(extent={{360,-1030},{380,-1010}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi16
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{440,-1060},{460,-1040}})));
  Buildings.Controls.OBC.CDL.Logical.And and17
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Logical and"
    annotation (Placement(transformation(extent={{200,-1130},{220,-1110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi17
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{440,-1130},{460,-1110}})));
  Buildings.Controls.OBC.CDL.Reals.Min min5
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Smaller input"
    annotation (Placement(transformation(extent={{360,-1100},{380,-1080}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi18
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{440,-1200},{460,-1180}})));
  Buildings.Controls.OBC.CDL.Reals.Min min6
    if eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24
    "Smaller input"
    annotation (Placement(transformation(extent={{360,-1170},{380,-1150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noAshCli(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified)
    "No ASHRAE climate zone"
    annotation (Placement(transformation(extent={{320,940},{340,960}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noTit24Cli(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified)
    "No Title 24 climate zone"
    annotation (Placement(transformation(extent={{320,900},{340,920}})));
  Buildings.Controls.OBC.CDL.Logical.And noCli
    "Climate zone is not specified"
    annotation (Placement(transformation(extent={{360,940},{380,960}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{400,940},{420,960}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: Climate zone is not specified!")
    "Warning when the climate zone is not specified"
    annotation (Placement(transformation(extent={{440,940},{460,960}})));

equation
  connect(ash1B.y, or3.u1) annotation (Line(points={{-358,1230},{-320,1230},{-320,
          858},{-42,858}}, color={255,0,255}));
  connect(ash2B.y, or3.u2) annotation (Line(points={{-198,1230},{-160,1230},{-160,
          850},{-42,850}}, color={255,0,255}));
  connect(ash3B.y, or3.u3) annotation (Line(points={{-438,1170},{-410,1170},{-410,
          842},{-42,842}}, color={255,0,255}));
  connect(ash3C.y, or1.u1) annotation (Line(points={{-358,1170},{-330,1170},{-330,
          818},{-42,818}}, color={255,0,255}));
  connect(ash4B.y, or1.u2) annotation (Line(points={{-198,1170},{-170,1170},{-170,
          810},{-42,810}}, color={255,0,255}));
  connect(ash4C.y, or1.u3) annotation (Line(points={{-118,1170},{-90,1170},{-90,
          802},{-42,802}}, color={255,0,255}));
  connect(ash5B.y, or2.u1) annotation (Line(points={{-358,1110},{-340,1110},{-340,
          778},{-42,778}}, color={255,0,255}));
  connect(ash5C.y, or2.u2) annotation (Line(points={{-278,1110},{-260,1110},{-260,
          770},{-42,770}}, color={255,0,255}));
  connect(ash6B.y, or2.u3) annotation (Line(points={{-118,1110},{-100,1110},{-100,
          762},{-42,762}}, color={255,0,255}));
  connect(or3.y, or4.u1) annotation (Line(points={{-18,850},{0,850},{0,818},{18,
          818}}, color={255,0,255}));
  connect(or1.y, or4.u2)
    annotation (Line(points={{-18,810},{18,810}}, color={255,0,255}));
  connect(or2.y, or4.u3) annotation (Line(points={{-18,770},{0,770},{0,802},{18,
          802}}, color={255,0,255}));
  connect(ash7.y, or6.u1) annotation (Line(points={{-438,1050},{-430,1050},{-430,
          730},{-42,730}}, color={255,0,255}));
  connect(ash8.y, or6.u2) annotation (Line(points={{-358,1050},{-350,1050},{-350,
          722},{-42,722}}, color={255,0,255}));
  connect(or4.y, or7.u1)
    annotation (Line(points={{42,810},{78,810}}, color={255,0,255}));
  connect(or6.y, or7.u2) annotation (Line(points={{-18,730},{60,730},{60,802},{78,
          802}}, color={255,0,255}));
  connect(ash5A.y, or5.u1) annotation (Line(points={{-438,1110},{-420,1110},{-420,
          670},{78,670}}, color={255,0,255}));
  connect(ash6A.y, or5.u2) annotation (Line(points={{-198,1110},{-180,1110},{-180,
          662},{78,662}}, color={255,0,255}));
  connect(or7.y, and2.u1)
    annotation (Line(points={{102,810},{218,810}}, color={255,0,255}));
  connect(fixDryBul.y, and2.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,802},{218,802}}, color={255,0,255}));
  connect(fixDryBul.y, and1.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,662},{218,662}}, color={255,0,255}));
  connect(or5.y, and1.u1)
    annotation (Line(points={{102,670},{218,670}}, color={255,0,255}));
  connect(and2.y, swi.u2)
    annotation (Line(points={{242,810},{458,810}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{242,850},{420,850},{420,818},
          {458,818}}, color={0,0,127}));
  connect(con1.y, swi1.u1) annotation (Line(points={{242,710},{380,710},{380,678},
          {418,678}}, color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{242,670},{418,670}}, color={255,0,255}));
  connect(fixDryBul.y, swi2.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,590},{378,590}}, color={255,0,255}));
  connect(con2.y, swi2.u1) annotation (Line(points={{242,630},{340,630},{340,598},
          {378,598}}, color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{402,590},{410,590},{410,662},
          {418,662}}, color={0,0,127}));
  connect(ash1B.y, or10.u1) annotation (Line(points={{-358,1230},{-320,1230},{-320,
          558},{-42,558}}, color={255,0,255}));
  connect(ash2B.y, or10.u2) annotation (Line(points={{-198,1230},{-160,1230},{-160,
          550},{-42,550}}, color={255,0,255}));
  connect(ash3B.y, or10.u3) annotation (Line(points={{-438,1170},{-410,1170},{-410,
          542},{-42,542}}, color={255,0,255}));
  connect(ash3C.y, or11.u1) annotation (Line(points={{-358,1170},{-330,1170},{-330,
          518},{-42,518}}, color={255,0,255}));
  connect(ash4B.y, or11.u2) annotation (Line(points={{-198,1170},{-170,1170},{-170,
          510},{-42,510}}, color={255,0,255}));
  connect(ash4C.y, or11.u3) annotation (Line(points={{-118,1170},{-90,1170},{-90,
          502},{-42,502}}, color={255,0,255}));
  connect(ash5A.y, or12.u1) annotation (Line(points={{-438,1110},{-420,1110},{-420,
          478},{-42,478}}, color={255,0,255}));
  connect(ash5B.y, or12.u2) annotation (Line(points={{-358,1110},{-340,1110},{-340,
          470},{-42,470}}, color={255,0,255}));
  connect(ash5C.y, or12.u3) annotation (Line(points={{-278,1110},{-260,1110},{-260,
          462},{-42,462}}, color={255,0,255}));
  connect(ash6A.y, or13.u1) annotation (Line(points={{-198,1110},{-180,1110},{-180,
          438},{-42,438}}, color={255,0,255}));
  connect(ash6B.y, or13.u2) annotation (Line(points={{-118,1110},{-100,1110},{-100,
          430},{-42,430}}, color={255,0,255}));
  connect(ash7.y, or13.u3) annotation (Line(points={{-438,1050},{-430,1050},{-430,
          422},{-42,422}}, color={255,0,255}));
  connect(or10.y, or14.u1) annotation (Line(points={{-18,550},{0,550},{0,518},{18,
          518}}, color={255,0,255}));
  connect(or11.y, or14.u2)
    annotation (Line(points={{-18,510},{18,510}}, color={255,0,255}));
  connect(or12.y, or14.u3) annotation (Line(points={{-18,470},{0,470},{0,502},{18,
          502}}, color={255,0,255}));
  connect(or14.y, or15.u1) annotation (Line(points={{42,510},{60,510},{60,418},{
          78,418}}, color={255,0,255}));
  connect(or13.y, or15.u2) annotation (Line(points={{-18,430},{40,430},{40,410},
          {78,410}}, color={255,0,255}));
  connect(ash8.y, or15.u3) annotation (Line(points={{-358,1050},{-350,1050},{-350,
          402},{78,402}}, color={255,0,255}));
  connect(or15.y, and3.u1)
    annotation (Line(points={{102,410},{218,410}}, color={255,0,255}));
  connect(difDryBul.y, and3.u2) annotation (Line(points={{-498,970},{140,970},{140,
          402},{218,402}}, color={255,0,255}));
  connect(and3.y, swi3.u2)
    annotation (Line(points={{242,410},{280,410},{280,430},{338,430}}, color={255,0,255}));
  connect(TRet, swi3.u1) annotation (Line(points={{-560,570},{170,570},{170,438},
          {338,438}}, color={0,0,127}));
  connect(ash1A.y, or8.u3) annotation (Line(points={{-438,1230},{-400,1230},{-400,
          342},{-42,342}}, color={255,0,255}));
  connect(ash2A.y, or8.u2) annotation (Line(points={{-278,1230},{-240,1230},{-240,
          350},{-42,350}}, color={255,0,255}));
  connect(ash3A.y, or8.u1) annotation (Line(points={{-118,1230},{-80,1230},{-80,
          358},{-42,358}}, color={255,0,255}));
  connect(or8.y, or9.u2) annotation (Line(points={{-18,350},{0,350},{0,362},{18,
          362}}, color={255,0,255}));
  connect(ash4A.y, or9.u1) annotation (Line(points={{-278,1170},{-250,1170},{-250,
          370},{18,370}}, color={255,0,255}));
  connect(or9.y, and4.u1)
    annotation (Line(points={{42,370},{218,370}}, color={255,0,255}));
  connect(difDryBul.y, and4.u2) annotation (Line(points={{-498,970},{140,970},{140,
          362},{218,362}}, color={255,0,255}));
  connect(and4.y, not1.u)
    annotation (Line(points={{242,370},{438,370}}, color={255,0,255}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{462,370},{478,370}}, color={255,0,255}));
  connect(swi1.y, swi.u3) annotation (Line(points={{442,670},{450,670},{450,802},
          {458,802}}, color={0,0,127}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{362,430},{370,430},{370,582},
          {378,582}}, color={0,0,127}));
  connect(con4.y, swi4.u1) annotation (Line(points={{242,80},{340,80},{340,48},{
          378,48}}, color={0,0,127}));
  connect(fixEntFixDryBul.y, swi4.u2) annotation (Line(points={{-498,930},{130,930},
          {130,40},{378,40}}, color={255,0,255}));
  connect(hRet, swi4.u3) annotation (Line(points={{-560,10},{20,10},{20,32},{378,
          32}}, color={0,0,127}));
  connect(swi.y, TCut)
    annotation (Line(points={{482,810},{560,810}}, color={0,0,127}));
  connect(swi4.y, hCut)
    annotation (Line(points={{402,40},{560,40}}, color={0,0,127}));
  connect(titZon1.y, or16.u1) annotation (Line(points={{-438,-50},{-400,-50},{-400,
          -282},{-42,-282}}, color={255,0,255}));
  connect(titZon3.y, or16.u2) annotation (Line(points={{-278,-50},{-240,-50},{-240,
          -290},{-42,-290}}, color={255,0,255}));
  connect(titZon5.y, or16.u3) annotation (Line(points={{-438,-110},{-410,-110},{
          -410,-298},{-42,-298}}, color={255,0,255}));
  connect(titZon11.y, or17.u1) annotation (Line(points={{-278,-170},{-260,-170},
          {-260,-322},{-42,-322}}, color={255,0,255}));
  connect(titZon12.y, or17.u2) annotation (Line(points={{-198,-170},{-180,-170},
          {-180,-330},{-42,-330}}, color={255,0,255}));
  connect(titZon13.y, or17.u3) annotation (Line(points={{-438,-230},{-430,-230},
          {-430,-338},{-42,-338}}, color={255,0,255}));
  connect(titZon14.y, or18.u1) annotation (Line(points={{-358,-230},{-350,-230},
          {-350,-362},{-42,-362}}, color={255,0,255}));
  connect(titZon15.y, or18.u2) annotation (Line(points={{-278,-230},{-270,-230},
          {-270,-370},{-42,-370}}, color={255,0,255}));
  connect(titZon16.y, or18.u3) annotation (Line(points={{-198,-230},{-190,-230},
          {-190,-378},{-42,-378}}, color={255,0,255}));
  connect(or16.y, or20.u1) annotation (Line(points={{-18,-290},{0,-290},{0,-322},
          {18,-322}}, color={255,0,255}));
  connect(or17.y, or20.u2)
    annotation (Line(points={{-18,-330},{18,-330}}, color={255,0,255}));
  connect(or18.y, or20.u3) annotation (Line(points={{-18,-370},{0,-370},{0,-338},
          {18,-338}}, color={255,0,255}));
  connect(or20.y, and5.u1)
    annotation (Line(points={{42,-330},{198,-330}}, color={255,0,255}));
  connect(fixDryBul.y, and5.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,-338},{198,-338}}, color={255,0,255}));
  connect(and5.y, swi5.u2)
    annotation (Line(points={{222,-330},{478,-330}}, color={255,0,255}));
  connect(con5.y, swi5.u1) annotation (Line(points={{222,-290},{240,-290},{240,-322},
          {478,-322}}, color={0,0,127}));
  connect(titZon2.y, or19.u1) annotation (Line(points={{-358,-50},{-320,-50},{-320,
          -412},{-42,-412}}, color={255,0,255}));
  connect(titZon4.y, or19.u2) annotation (Line(points={{-198,-50},{-160,-50},{-160,
          -420},{-42,-420}}, color={255,0,255}));
  connect(titZon10.y, or19.u3) annotation (Line(points={{-358,-170},{-340,-170},
          {-340,-428},{-42,-428}}, color={255,0,255}));
  connect(or19.y, and6.u1)
    annotation (Line(points={{-18,-420},{198,-420}}, color={255,0,255}));
  connect(fixDryBul.y, and6.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,-428},{198,-428}}, color={255,0,255}));
  connect(and6.y, swi6.u2)
    annotation (Line(points={{222,-420},{438,-420}}, color={255,0,255}));
  connect(con6.y, swi6.u1) annotation (Line(points={{222,-380},{250,-380},{250,-412},
          {438,-412}}, color={0,0,127}));
  connect(swi6.y, swi5.u3) annotation (Line(points={{462,-420},{470,-420},{470,-338},
          {478,-338}}, color={0,0,127}));
  connect(and7.y, swi7.u2)
    annotation (Line(points={{222,-500},{398,-500}}, color={255,0,255}));
  connect(con7.y, swi7.u1) annotation (Line(points={{222,-460},{260,-460},{260,-492},
          {398,-492}}, color={0,0,127}));
  connect(titZon6.y, or21.u1) annotation (Line(points={{-358,-110},{-330,-110},{
          -330,-492},{-42,-492}}, color={255,0,255}));
  connect(or21.y, and7.u1)
    annotation (Line(points={{-18,-500},{198,-500}}, color={255,0,255}));
  connect(titZon8.y, or21.u2) annotation (Line(points={{-198,-110},{-170,-110},{
          -170,-500},{-42,-500}}, color={255,0,255}));
  connect(titZon9.y, or21.u3) annotation (Line(points={{-438,-170},{-420,-170},{
          -420,-508},{-42,-508}}, color={255,0,255}));
  connect(fixDryBul.y, and7.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,-508},{198,-508}}, color={255,0,255}));
  connect(swi7.y, swi6.u3) annotation (Line(points={{422,-500},{430,-500},{430,-428},
          {438,-428}}, color={0,0,127}));
  connect(con8.y, swi8.u1) annotation (Line(points={{222,-540},{270,-540},{270,-572},
          {358,-572}}, color={0,0,127}));
  connect(fixDryBul.y, swi8.u2) annotation (Line(points={{-498,1010},{150,1010},
          {150,-580},{358,-580}}, color={255,0,255}));
  connect(or20.y, and8.u1) annotation (Line(points={{42,-330},{60,-330},{60,-650},
          {198,-650}}, color={255,0,255}));
  connect(difDryBul.y, and8.u2) annotation (Line(points={{-498,970},{140,970},{140,
          -658},{198,-658}}, color={255,0,255}));
  connect(and8.y, swi9.u2)
    annotation (Line(points={{222,-650},{320,-650},{320,-630},{478,-630}},
                                                     color={255,0,255}));
  connect(TRet, swi9.u1) annotation (Line(points={{-560,570},{170,570},{170,-622},
          {478,-622}}, color={0,0,127}));
  connect(swi10.y, swi9.u3) annotation (Line(points={{462,-730},{470,-730},{470,
          -638},{478,-638}}, color={0,0,127}));
  connect(or19.y, and9.u1) annotation (Line(points={{-18,-420},{50,-420},{50,-730},
          {198,-730}}, color={255,0,255}));
  connect(difDryBul.y, and9.u2) annotation (Line(points={{-498,970},{140,970},{140,
          -738},{198,-738}}, color={255,0,255}));
  connect(TRet, addPar.u) annotation (Line(points={{-560,570},{170,570},{170,-690},
          {278,-690}}, color={0,0,127}));
  connect(and9.y, swi10.u2)
    annotation (Line(points={{222,-730},{438,-730}}, color={255,0,255}));
  connect(addPar.y, swi10.u1) annotation (Line(points={{302,-690},{320,-690},{320,
          -722},{438,-722}}, color={0,0,127}));
  connect(and10.y, swi11.u2)
    annotation (Line(points={{222,-810},{398,-810}}, color={255,0,255}));
  connect(swi11.y, swi10.u3) annotation (Line(points={{422,-810},{430,-810},{430,
          -738},{438,-738}}, color={0,0,127}));
  connect(or21.y, and10.u1) annotation (Line(points={{-18,-500},{40,-500},{40,-810},
          {198,-810}}, color={255,0,255}));
  connect(difDryBul.y, and10.u2) annotation (Line(points={{-498,970},{140,970},{
          140,-818},{198,-818}}, color={255,0,255}));
  connect(addPar1.y, swi11.u1) annotation (Line(points={{302,-770},{330,-770},{330,
          -802},{398,-802}}, color={0,0,127}));
  connect(TRet, addPar1.u) annotation (Line(points={{-560,570},{170,570},{170,-770},
          {278,-770}}, color={0,0,127}));
  connect(addPar2.y, swi12.u1) annotation (Line(points={{302,-850},{340,-850},{340,
          -882},{358,-882}}, color={0,0,127}));
  connect(swi12.y, swi11.u3) annotation (Line(points={{382,-890},{390,-890},{390,
          -818},{398,-818}}, color={0,0,127}));
  connect(difDryBul.y, swi12.u2) annotation (Line(points={{-498,970},{140,970},{
          140,-890},{358,-890}}, color={255,0,255}));
  connect(TRet, addPar2.u) annotation (Line(points={{-560,570},{170,570},{170,-850},
          {278,-850}}, color={0,0,127}));
  connect(swi8.y, swi7.u3) annotation (Line(points={{382,-580},{390,-580},{390,-508},
          {398,-508}}, color={0,0,127}));
  connect(swi9.y, swi8.u3) annotation (Line(points={{502,-630},{520,-630},{520,-602},
          {340,-602},{340,-588},{358,-588}}, color={0,0,127}));
  connect(fixEntFixDryBul.y, booToRea.u) annotation (Line(points={{-498,930},{130,
          930},{130,-10},{218,-10}},     color={255,0,255}));
  connect(swi5.y, TCut) annotation (Line(points={{502,-330},{520,-330},{520,810},
          {560,810}}, color={0,0,127}));
  connect(booToRea.y, hCut) annotation (Line(points={{242,-10},{440,-10},{440,40},
          {560,40}},     color={0,0,127}));
  connect(titEngSta.y, and11.u2) annotation (Line(points={{-438,-710},{-420,-710},
          {-420,-678},{-382,-678}}, color={255,0,255}));
  connect(difEntFixDryBul.y, and11.u1) annotation (Line(points={{-498,850},{-480,
          850},{-480,-670},{-382,-670}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{-298,-670},{-282,-670}}, color={255,0,255}));
  connect(and11.y, not2.u)
    annotation (Line(points={{-358,-670},{-322,-670}}, color={255,0,255}));
  connect(con10.y, swi4.u3) annotation (Line(points={{-18,70},{20,70},{20,32},{378,
          32}}, color={0,0,127}));
  connect(con11.y, swi3.u1) annotation (Line(points={{-198,610},{170,610},{170,438},
          {338,438}},                     color={0,0,127}));
  connect(con11.y, swi9.u1) annotation (Line(points={{-198,610},{170,610},{170,-622},
          {478,-622}},                      color={0,0,127}));
  connect(con11.y, addPar.u) annotation (Line(points={{-198,610},{170,610},{170,
          -690},{278,-690}},                     color={0,0,127}));
  connect(con11.y, addPar1.u) annotation (Line(points={{-198,610},{170,610},{170,
          -770},{278,-770}},                     color={0,0,127}));
  connect(con11.y, addPar2.u) annotation (Line(points={{-198,610},{170,610},{170,
          -850},{278,-850}},                     color={0,0,127}));
  connect(fixDryBulDifDryBul.y, and12.u2) annotation (Line(points={{-498,890},{120,
          890},{120,272},{218,272}}, color={255,0,255}));
  connect(or7.y, and12.u1) annotation (Line(points={{102,810},{160,810},{160,280},
          {218,280}},color={255,0,255}));
  connect(and12.y, swi13.u2)
    annotation (Line(points={{242,280},{298,280}}, color={255,0,255}));
  connect(con3.y, min1.u1) annotation (Line(points={{42,160},{100,160},{100,326},
          {218,326}},color={0,0,127}));
  connect(TRet, min1.u2) annotation (Line(points={{-560,570},{170,570},{170,314},
          {218,314}},color={0,0,127}));
  connect(min1.y, swi13.u1) annotation (Line(points={{242,320},{280,320},{280,288},
          {298,288}},color={0,0,127}));
  connect(swi13.y, swi3.u3) annotation (Line(points={{322,280},{330,280},{330,422},
          {338,422}}, color={0,0,127}));
  connect(or5.y, and13.u2) annotation (Line(points={{102,670},{110,670},{110,182},
          {218,182}}, color={255,0,255}));
  connect(fixDryBulDifDryBul.y, and13.u1) annotation (Line(points={{-498,890},{120,
          890},{120,190},{218,190}}, color={255,0,255}));
  connect(con12.y, min2.u1) annotation (Line(points={{42,260},{80,260},{80,236},
          {218,236}}, color={0,0,127}));
  connect(TRet, min2.u2) annotation (Line(points={{-560,570},{170,570},{170,224},
          {218,224}},color={0,0,127}));
  connect(and13.y, swi14.u2)
    annotation (Line(points={{242,190},{258,190}}, color={255,0,255}));
  connect(min2.y, swi14.u1) annotation (Line(points={{242,230},{252,230},{252,198},
          {258,198}},color={0,0,127}));
  connect(con3.y, swi14.u3) annotation (Line(points={{42,160},{250,160},{250,182},
          {258,182}}, color={0,0,127}));
  connect(swi14.y, swi13.u3) annotation (Line(points={{282,190},{290,190},{290,272},
          {298,272}},color={0,0,127}));
  connect(and14.y, not3.u)
    annotation (Line(points={{242,130},{298,130}},   color={255,0,255}));
  connect(or9.y, and14.u2) annotation (Line(points={{42,370},{60,370},{60,122},{
          218,122}},   color={255,0,255}));
  connect(not3.y, assMes2.u)
    annotation (Line(points={{322,130},{338,130}},   color={255,0,255}));
  connect(fixDryBulDifDryBul.y, and14.u1) annotation (Line(points={{-498,890},{120,
          890},{120,130},{218,130}},   color={255,0,255}));
  connect(and15.y, swi15.u2)
    annotation (Line(points={{222,-980},{478,-980}},   color={255,0,255}));
  connect(con5.y, min3.u1) annotation (Line(points={{222,-290},{240,-290},{240,-944},
          {358,-944}},  color={0,0,127}));
  connect(TRet, min3.u2) annotation (Line(points={{-560,570},{170,570},{170,-956},
          {358,-956}},  color={0,0,127}));
  connect(min3.y, swi15.u1) annotation (Line(points={{382,-950},{400,-950},{400,
          -972},{478,-972}},   color={0,0,127}));
  connect(fixDryBulDifDryBul.y, and15.u2) annotation (Line(points={{-498,890},{120,
          890},{120,-988},{198,-988}},   color={255,0,255}));
  connect(fixDryBulDifDryBul.y, and16.u2) annotation (Line(points={{-498,890},{120,
          890},{120,-1058},{198,-1058}}, color={255,0,255}));
  connect(or20.y, and15.u1) annotation (Line(points={{42,-330},{60,-330},{60,-980},
          {198,-980}},  color={255,0,255}));
  connect(or19.y, and16.u1) annotation (Line(points={{-18,-420},{50,-420},{50,-1050},
          {198,-1050}}, color={255,0,255}));
  connect(con6.y, min4.u2) annotation (Line(points={{222,-380},{250,-380},{250,-1026},
          {358,-1026}}, color={0,0,127}));
  connect(addPar.y, min4.u1) annotation (Line(points={{302,-690},{320,-690},{320,
          -1014},{358,-1014}}, color={0,0,127}));
  connect(min4.y, swi16.u1) annotation (Line(points={{382,-1020},{400,-1020},{400,
          -1042},{438,-1042}}, color={0,0,127}));
  connect(and16.y, swi16.u2)
    annotation (Line(points={{222,-1050},{438,-1050}}, color={255,0,255}));
  connect(swi16.y, swi15.u3) annotation (Line(points={{462,-1050},{470,-1050},{470,
          -988},{478,-988}},   color={0,0,127}));
  connect(con7.y, min5.u2) annotation (Line(points={{222,-460},{260,-460},{260,-1096},
          {358,-1096}}, color={0,0,127}));
  connect(addPar1.y, min5.u1) annotation (Line(points={{302,-770},{330,-770},{330,
          -1084},{358,-1084}},     color={0,0,127}));
  connect(min5.y, swi17.u1) annotation (Line(points={{382,-1090},{400,-1090},{400,
          -1112},{438,-1112}}, color={0,0,127}));
  connect(and17.y, swi17.u2)
    annotation (Line(points={{222,-1120},{438,-1120}}, color={255,0,255}));
  connect(or21.y, and17.u1) annotation (Line(points={{-18,-500},{40,-500},{40,-1120},
          {198,-1120}}, color={255,0,255}));
  connect(fixDryBulDifDryBul.y, and17.u2) annotation (Line(points={{-498,890},{120,
          890},{120,-1128},{198,-1128}}, color={255,0,255}));
  connect(swi17.y, swi16.u3) annotation (Line(points={{462,-1120},{480,-1120},{480,
          -1080},{420,-1080},{420,-1058},{438,-1058}}, color={0,0,127}));
  connect(fixDryBulDifDryBul.y, swi18.u2) annotation (Line(points={{-498,890},{120,
          890},{120,-1190},{438,-1190}}, color={255,0,255}));
  connect(con8.y, min6.u2) annotation (Line(points={{222,-540},{270,-540},{270,-1166},
          {358,-1166}}, color={0,0,127}));
  connect(addPar2.y, min6.u1) annotation (Line(points={{302,-850},{340,-850},{340,
          -1154},{358,-1154}},     color={0,0,127}));
  connect(min6.y, swi18.u1) annotation (Line(points={{382,-1160},{400,-1160},{400,
          -1182},{438,-1182}}, color={0,0,127}));
  connect(con9.y, swi18.u3) annotation (Line(points={{222,-1230},{400,-1230},{400,
          -1198},{438,-1198}}, color={0,0,127}));
  connect(swi18.y, swi17.u3) annotation (Line(points={{462,-1190},{480,-1190},{480,
          -1150},{420,-1150},{420,-1128},{438,-1128}}, color={0,0,127}));
  connect(swi15.y, swi12.u3) annotation (Line(points={{502,-980},{520,-980},{520,
          -920},{350,-920},{350,-898},{358,-898}},     color={0,0,127}));
  connect(con11.y, min3.u2) annotation (Line(points={{-198,610},{170,610},{170,-956},
          {358,-956}},                      color={0,0,127}));
  connect(con11.y, min1.u2) annotation (Line(points={{-198,610},{170,610},{170,314},
          {218,314}}, color={0,0,127}));
  connect(con11.y, min2.u2) annotation (Line(points={{-198,610},{170,610},{170,224},
          {218,224}}, color={0,0,127}));
  connect(noAshCli.y,noCli. u1)
    annotation (Line(points={{342,950},{358,950}}, color={255,0,255}));
  connect(noTit24Cli.y,noCli. u2) annotation (Line(points={{342,910},{350,910},{
          350,942},{358,942}},  color={255,0,255}));
  connect(noCli.y,not4. u)
    annotation (Line(points={{382,950},{398,950}}, color={255,0,255}));
  connect(not4.y,assMes3. u)
    annotation (Line(points={{422,950},{438,950}}, color={255,0,255}));
annotation (defaultComponentName="ecoHigLim",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,68},{-72,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TRet",
          visible=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb),
        Text(
          extent={{-100,-52},{-72,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="hRet",
          visible=(eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
               and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)),
        Text(
          extent={{70,-50},{98,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="hCut",
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
               or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)),
        Text(
          extent={{70,70},{98,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCut")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-540,-1260},{540,
            1260}})),
Documentation(info="<html>
<p>
This block outputs the air economizer high limits according to the energy standard,
device type and climate zone. The implementation is according to the Section 5.1.17 of ASHRAE
Guideline 36, May 2020.
</p>
<p>When ASHRAE 90.1-2016 is used.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Device type</th> <th>Allowed only in these ASHRAE Climate Zones</th><th>Required High Limit (Economizer OFF when)</th></tr>
<tr>
<td rowspan=\"3\">Fixed dry bulb</td><td>1b, 2b, 3b, 3c, 4b, 4c, 5b, 5c, 6b, 7, 8</td>
<td>outdoor air temperature is higher than 24 &deg;C (<code>TCut=24&deg;C</code>)</td>
</tr>
<tr>
<td>5a, 6a</td><td>outdoor air temperature is higher than 21 &deg;C (<code>TCut=21&deg;C</code>)</td>
</tr>
<tr>
<td>1a, 2a, 3a, 4a</td><td>outdoor air temperature is higher than 18 &deg;C (<code>TCut=18&deg;C</code>)</td>
</tr>
<tr>
<td>Differential dry bulb</td><td>1b, 2b, 3b, 3c, 4b, 4c, 5a, 5b, 5c, 6a, 6b, 7, 8</td>
<td>outdoor air temperature is higher than the return air temperature (<code>TCut=TRet</code>)</td>
</tr>
<tr>
<td>Fixed enthalpy with fixed dry bulb</td><td>All</td>
<td>outdoor air temperature is higher than 24 &deg;C or the enthalpy is higher than 66 kJ/kg (<code>TCut=24&deg;C</code> or <code>hCut=66kJ/kg</code>)</td>
</tr>
<tr>
<td>Differential enthalpy with fixed dry bulb</td><td>All</td>
<td>outdoor air temperature is higher than 24 &deg;C or the outdoor air enthalpy is higher than the return air enthalpy (<code>TCut=24&deg;C</code> or <code>hCut=hRet</code>)</td>
</tr>
<tr>
<td rowspan=\"2\">Fixed dry bulb with differential dry bulb</td>
<td>1b, 2b, 3b, 3c, 4b, 4c, 5b, 5c, 6b, 7, 8</td>
<td>outdoor air temperature is higher than 24 &deg;C or the return air temperature (<code>TCut=min(24&deg;C, TRet)</code>)</td>
</tr>
<tr>
<td>5a, 6a</td>
<td>outdoor air temperature is higher than 21 &deg;C or the return air temperature (<code>TCut=min(21&deg;C, TRet)</code>)</td>
</tr>
</table>
<p>When California Title 24-2016 is used.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Device type</th> <th>California Climate Zones</th><th>Required High Limit (Economizer OFF when)</th></tr>
<tr>
<td rowspan=\"4\">Fixed dry bulb</td><td>1, 3, 5, 11 to 16</td><td>outdoor air temperature is higher than 24 &deg;C (<code>TCut=24&deg;C</code>)</td>
</tr>
<tr>
<td>2, 4, 10</td><td>outdoor air temperature is higher than 23 &deg;C (<code>TCut=23&deg;C</code>)</td>
</tr>
<tr>
<td>6, 8, 9</td><td>outdoor air temperature is higher than 22 &deg;C (<code>TCut=22&deg;C</code>)</td>
</tr>
<tr>
<td>7</td><td>outdoor air temperature is higher than 21 &deg;C (<code>TCut=21&deg;C</code>)</td>
</tr>
<tr>
<td rowspan=\"4\">Differential dry bulb</td><td>1, 3, 5, 11 to 16</td><td>outdoor air temperature is higher than the return air temperature (<code>TCut=TRet</code>)</td>
</tr>
<tr>
<td>2, 4, 10</td><td>outdoor air temperature is higher than the return air temperature minus 1 &deg;C (<code>TCut=TRet-1&deg;C</code>)</td>
</tr>
<tr>
<td>6, 8, 9</td><td>outdoor air temperature is higher than the return air temperature minus 2 &deg;C (<code>TCut=TRet-2&deg;C</code>)</td>
</tr>
<tr>
<td>7</td><td>outdoor air temperature is higher than the return air temperature minus 3 &deg;C (<code>TCut=TRet-3&deg;C</code>)</td>
</tr>
<tr>
<td>Fixed enthalpy with fixed dry bulb</td><td>All</td>
<td>outdoor air temperature is higher than 24 &deg;C or the enthalpy is higher than 66 kJ/kg (<code>TCut=24&deg;C</code> or <code>hCut=66kJ/kg</code>)</td>
</tr>
<tr>
<td rowspan=\"4\">Fixed dry bulb with differential dry bulb</td><td>1, 3, 5, 11 to 16</td>
<td>outdoor air temperature is higher than 24 &deg;C or the return air temperature (<code>TCut=24&deg;C</code> or <code>TCut=TRet</code>)</td>
</tr>
<tr>
<td>2, 4, 10</td>
<td>outdoor air temperature is higher than 23 &deg;C or the return air temperature minus 1 &deg;C (<code>TCut=min(23&deg;C, TRet-1&deg;C)</code>)</td>
</tr>
<tr>
<td>6, 8, 9</td>
<td>outdoor air temperature is higher than 22 &deg;C or the return air temperature minus 2 &deg;C (<code>TCut=min(22&deg;C, TRet-2&deg;C)</code>)</td>
</tr>
<tr>
<td>7</td>
<td>outdoor air temperature is higher than 21 &deg;C or the return air temperature minus 3 &deg;C (<code>TCut=min(21&deg;C, TRet-3&deg;C)</code>)</td>
</tr>
</table>
<br/>
<p>
Note that the device type <i>Fixed dry bulb with differential dry bulb</i> is not listed in either ASHRAE 90.1 or Title 24 standard.
But it is possible to use in practice. See Section 3.1.6.2 in Guideline 36.
</p>
</html>",revisions="<html>
<ul>
<li>
March 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirEconomizerHighLimits;
