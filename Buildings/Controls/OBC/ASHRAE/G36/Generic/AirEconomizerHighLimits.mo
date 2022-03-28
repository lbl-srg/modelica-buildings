within Buildings.Controls.OBC.ASHRAE.G36.Generic;
block AirEconomizerHighLimits "Specify the economizer high liimits"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneSta
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon
    "Economizer high limit control device";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (Dialog(enable=eneSta==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (Dialog(enable=eneSta==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Return air temperature"
    annotation (Placement(transformation(extent={{-580,320},{-540,360}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
        and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Return air enthalpy. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-580,-20},{-540,20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Outdoor air temperature high limit cutoff"
    annotation (Placement(transformation(extent={{540,560},{580,600}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput hCut(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
        or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Outdoor air enthalpy high limit cutoff"
    annotation (Placement(transformation(extent={{540,0},{580,40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fixDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb)
    "Fixed dry bulb"
    annotation (Placement(transformation(extent={{-520,770},{-500,790}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant difDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb)
    "Differential dry bulb"
    annotation (Placement(transformation(extent={{-520,730},{-500,750}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fixEntFixDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Fixed enthalpy with fixed dry bulb"
    annotation (Placement(transformation(extent={{-520,690},{-500,710}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant difEntFixDryBul(
    final k=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Differential enthalpy with fixed dry bulb"
    annotation (Placement(transformation(extent={{-520,650},{-500,670}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash1A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 1A"
    annotation (Placement(transformation(extent={{-460,990},{-440,1010}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash1B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1B)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 1B"
    annotation (Placement(transformation(extent={{-380,990},{-360,1010}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash2A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_2A)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 2A"
    annotation (Placement(transformation(extent={{-300,990},{-280,1010}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash2B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_2B)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 2B"
    annotation (Placement(transformation(extent={{-220,990},{-200,1010}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash3A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3A)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 3A"
    annotation (Placement(transformation(extent={{-140,990},{-120,1010}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash3B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 3B"
    annotation (Placement(transformation(extent={{-460,930},{-440,950}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash3C(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3C)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 3C"
    annotation (Placement(transformation(extent={{-380,930},{-360,950}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash4A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4A)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 4A"
    annotation (Placement(transformation(extent={{-300,930},{-280,950}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash4B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4B)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 4B"
    annotation (Placement(transformation(extent={{-220,930},{-200,950}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash4C(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_4C)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 4C"
    annotation (Placement(transformation(extent={{-140,930},{-120,950}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash5A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5A)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 5A"
    annotation (Placement(transformation(extent={{-460,870},{-440,890}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash5B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5B)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 5B"
    annotation (Placement(transformation(extent={{-380,870},{-360,890}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash5C(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_5C)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 5C"
    annotation (Placement(transformation(extent={{-300,870},{-280,890}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash6A(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_6A)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 6A"
    annotation (Placement(transformation(extent={{-220,870},{-200,890}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash6B(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_6B)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 6B"
    annotation (Placement(transformation(extent={{-140,870},{-120,890}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash7(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_7)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 7"
    annotation (Placement(transformation(extent={{-460,810},{-440,830}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ash8(
    final k=ashCliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_8)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "ASHRAE zone 8"
    annotation (Placement(transformation(extent={{-380,810},{-360,830}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 1b, 2b or 3b"
    annotation (Placement(transformation(extent={{-40,610},{-20,630}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 3c, 4b or 4c"
    annotation (Placement(transformation(extent={{-40,570},{-20,590}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or2
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 5b, 5c or 6b"
    annotation (Placement(transformation(extent={{-40,530},{-20,550}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or4
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical or"
    annotation (Placement(transformation(extent={{20,570},{40,590}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 7 or 8"
    annotation (Placement(transformation(extent={{-40,490},{-20,510}})));
  Buildings.Controls.OBC.CDL.Logical.Or or7
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical or"
    annotation (Placement(transformation(extent={{80,570},{100,590}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 5a or 6a"
    annotation (Placement(transformation(extent={{80,430},{100,450}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,570},{200,590}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,430},{200,450}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{420,570},{440,590}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15 + 24) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,610},{200,630}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{380,430},{400,450}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=273.15 + 21) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,470},{200,490}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{340,350},{360,370}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=273.15 + 18) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,390},{200,410}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or10
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 1b, 2b or 3b"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or11
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 3c, 4b or 4c"
    annotation (Placement(transformation(extent={{-40,270},{-20,290}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or12
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 5a, 5b or 5c"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or13
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 6a, 6b or 7"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or14
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical or"
    annotation (Placement(transformation(extent={{20,270},{40,290}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or15
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical or"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{300,170},{320,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or8
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 1a, 2a or 3a"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or9
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Zone 1a, 2a, 3a or 4a"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,130},{200,150}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(final message="Warning: Differential dry bulb high-limit-control device is not allowed in climate zone 1A, 2A, 3A and 4A!")
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Warning when the wrong device being used"
    annotation (Placement(transformation(extent={{340,130},{360,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Logical not"
    annotation (Placement(transformation(extent={{300,130},{320,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=273.15 + 24) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Cut off outdoor air enthalpy"
    annotation (Placement(transformation(extent={{380,10},{400,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=66000) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    "Enthalpy cutoff value, J/kg"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon1(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_1)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 1"
    annotation (Placement(transformation(extent={{-460,-70},{-440,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon2(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_2)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 2"
    annotation (Placement(transformation(extent={{-380,-70},{-360,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon3(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_3)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 3"
    annotation (Placement(transformation(extent={{-300,-70},{-280,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon4(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_4)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 4"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon5(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_5)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 5"
    annotation (Placement(transformation(extent={{-460,-130},{-440,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon6(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_6)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 6"
    annotation (Placement(transformation(extent={{-380,-130},{-360,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon8(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_8)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 8"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon9(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_9)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 9"
    annotation (Placement(transformation(extent={{-460,-190},{-440,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon10(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_10)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 10"
    annotation (Placement(transformation(extent={{-380,-190},{-360,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon11(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_11)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 11"
    annotation (Placement(transformation(extent={{-300,-190},{-280,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon12(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_12)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 12"
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon13(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_13)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 13"
    annotation (Placement(transformation(extent={{-460,-250},{-440,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon14(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_14)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 14"
    annotation (Placement(transformation(extent={{-380,-250},{-360,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon15(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_15)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 15"
    annotation (Placement(transformation(extent={{-300,-250},{-280,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titZon16(
    final k=tit24CliZon == Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Zone_16)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Title 24, zone 16"
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or16
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Zone 1, 3 or 5"
    annotation (Placement(transformation(extent={{-40,-310},{-20,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or17
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Zone 11, 12 or 13"
    annotation (Placement(transformation(extent={{-40,-350},{-20,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or18
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Zone 14, 15 or 16"
    annotation (Placement(transformation(extent={{-40,-390},{-20,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or20
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Zone 1, 3, 5, or 11 to 16"
    annotation (Placement(transformation(extent={{20,-350},{40,-330}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,-350},{200,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{420,-350},{440,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
    final k=273.15 + 24) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,-310},{200,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or19
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Zone 2, 4 or 10"
    annotation (Placement(transformation(extent={{-40,-440},{-20,-420}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,-440},{200,-420}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi6
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{380,-440},{400,-420}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=273.15 + 23) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,-400},{200,-380}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or21
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Zone 6, 8 or 9"
    annotation (Placement(transformation(extent={{-40,-520},{-20,-500}})));
  Buildings.Controls.OBC.CDL.Logical.And and7
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,-520},{200,-500}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=273.15 + 22) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,-480},{200,-460}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi7
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{340,-520},{360,-500}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=273.15 + 21) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,-560},{200,-540}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi8
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{300,-600},{320,-580}})));
  Buildings.Controls.OBC.CDL.Logical.And and8
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,-670},{200,-650}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi9
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{420,-670},{440,-650}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,-750},{200,-730}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi10
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{380,-750},{400,-730}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-1) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{260,-710},{280,-690}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi11
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{340,-830},{360,-810}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical and"
    annotation (Placement(transformation(extent={{180,-830},{200,-810}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-2) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{260,-790},{280,-770}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi12
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off outdoor air temperature"
    annotation (Placement(transformation(extent={{300,-910},{320,-890}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=-3) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{260,-870},{280,-850}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(
    final k=273.15 + 24) if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Cut off temperature"
    annotation (Placement(transformation(extent={{180,-950},{200,-930}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=66000)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{180,-1010},{200,-990}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant titEngSta(
    final k=eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016)
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Check if Title 24 energy standard is used"
    annotation (Placement(transformation(extent={{-460,-730},{-440,-710}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Check if Title 24 energy standard is used and the device type is differential enthalpy with fixed dry bulb"
    annotation (Placement(transformation(extent={{-380,-690},{-360,-670}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: When Title 24 energy standard is used, the device type cannot be differential enthalpy with fixed dry bulb!")
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Warning when the wrong device being used"
    annotation (Placement(transformation(extent={{-280,-690},{-260,-670}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    if eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016
    "Logical not"
    annotation (Placement(transformation(extent={{-320,-690},{-300,-670}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con10(
    final k=0)
    if (eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
        and not ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Constant 0"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con11(
    final k=0)
    if not ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Constant 0"
    annotation (Placement(transformation(extent={{-40,370},{-20,390}})));
equation
  connect(ash1B.y, or3.u1) annotation (Line(points={{-358,1000},{-320,1000},{-320,
          628},{-42,628}}, color={255,0,255}));
  connect(ash2B.y, or3.u2) annotation (Line(points={{-198,1000},{-160,1000},{-160,
          620},{-42,620}}, color={255,0,255}));
  connect(ash3B.y, or3.u3) annotation (Line(points={{-438,940},{-410,940},{-410,
          612},{-42,612}}, color={255,0,255}));
  connect(ash3C.y, or1.u1) annotation (Line(points={{-358,940},{-330,940},{-330,
          588},{-42,588}}, color={255,0,255}));
  connect(ash4B.y, or1.u2) annotation (Line(points={{-198,940},{-170,940},{-170,
          580},{-42,580}}, color={255,0,255}));
  connect(ash4C.y, or1.u3) annotation (Line(points={{-118,940},{-90,940},{-90,572},
          {-42,572}}, color={255,0,255}));
  connect(ash5B.y, or2.u1) annotation (Line(points={{-358,880},{-340,880},{-340,
          548},{-42,548}}, color={255,0,255}));
  connect(ash5C.y, or2.u2) annotation (Line(points={{-278,880},{-260,880},{-260,
          540},{-42,540}}, color={255,0,255}));
  connect(ash6B.y, or2.u3) annotation (Line(points={{-118,880},{-100,880},{-100,
          532},{-42,532}}, color={255,0,255}));
  connect(or3.y, or4.u1) annotation (Line(points={{-18,620},{0,620},{0,588},{18,
          588}}, color={255,0,255}));
  connect(or1.y, or4.u2)
    annotation (Line(points={{-18,580},{18,580}}, color={255,0,255}));
  connect(or2.y, or4.u3) annotation (Line(points={{-18,540},{0,540},{0,572},{18,
          572}}, color={255,0,255}));
  connect(ash7.y, or6.u1) annotation (Line(points={{-438,820},{-430,820},{-430,500},
          {-42,500}}, color={255,0,255}));
  connect(ash8.y, or6.u2) annotation (Line(points={{-358,820},{-350,820},{-350,492},
          {-42,492}}, color={255,0,255}));
  connect(or4.y, or7.u1)
    annotation (Line(points={{42,580},{78,580}}, color={255,0,255}));
  connect(or6.y, or7.u2) annotation (Line(points={{-18,500},{60,500},{60,572},{78,
          572}}, color={255,0,255}));
  connect(ash5A.y, or5.u1) annotation (Line(points={{-438,880},{-420,880},{-420,
          440},{78,440}}, color={255,0,255}));
  connect(ash6A.y, or5.u2) annotation (Line(points={{-198,880},{-180,880},{-180,
          432},{78,432}}, color={255,0,255}));
  connect(or7.y, and2.u1)
    annotation (Line(points={{102,580},{178,580}}, color={255,0,255}));
  connect(fixDryBul.y, and2.u2) annotation (Line(points={{-498,780},{150,780},{150,
          572},{178,572}}, color={255,0,255}));
  connect(fixDryBul.y, and1.u2) annotation (Line(points={{-498,780},{150,780},{150,
          432},{178,432}}, color={255,0,255}));
  connect(or5.y, and1.u1)
    annotation (Line(points={{102,440},{178,440}}, color={255,0,255}));
  connect(and2.y, swi.u2)
    annotation (Line(points={{202,580},{418,580}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{202,620},{340,620},{340,588},
          {418,588}}, color={0,0,127}));
  connect(con1.y, swi1.u1) annotation (Line(points={{202,480},{320,480},{320,448},
          {378,448}}, color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{202,440},{378,440}}, color={255,0,255}));
  connect(fixDryBul.y, swi2.u2) annotation (Line(points={{-498,780},{150,780},{150,
          360},{338,360}}, color={255,0,255}));
  connect(con2.y, swi2.u1) annotation (Line(points={{202,400},{220,400},{220,368},
          {338,368}}, color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{362,360},{370,360},{370,432},
          {378,432}}, color={0,0,127}));
  connect(ash1B.y, or10.u1) annotation (Line(points={{-358,1000},{-320,1000},{-320,
          328},{-42,328}}, color={255,0,255}));
  connect(ash2B.y, or10.u2) annotation (Line(points={{-198,1000},{-160,1000},{-160,
          320},{-42,320}}, color={255,0,255}));
  connect(ash3B.y, or10.u3) annotation (Line(points={{-438,940},{-410,940},{-410,
          312},{-42,312}}, color={255,0,255}));
  connect(ash3C.y, or11.u1) annotation (Line(points={{-358,940},{-330,940},{-330,
          288},{-42,288}}, color={255,0,255}));
  connect(ash4B.y, or11.u2) annotation (Line(points={{-198,940},{-170,940},{-170,
          280},{-42,280}}, color={255,0,255}));
  connect(ash4C.y, or11.u3) annotation (Line(points={{-118,940},{-90,940},{-90,272},
          {-42,272}}, color={255,0,255}));
  connect(ash5A.y, or12.u1) annotation (Line(points={{-438,880},{-420,880},{-420,
          248},{-42,248}}, color={255,0,255}));
  connect(ash5B.y, or12.u2) annotation (Line(points={{-358,880},{-340,880},{-340,
          240},{-42,240}}, color={255,0,255}));
  connect(ash5C.y, or12.u3) annotation (Line(points={{-278,880},{-260,880},{-260,
          232},{-42,232}}, color={255,0,255}));
  connect(ash6A.y, or13.u1) annotation (Line(points={{-198,880},{-180,880},{-180,
          208},{-42,208}}, color={255,0,255}));
  connect(ash6B.y, or13.u2) annotation (Line(points={{-118,880},{-100,880},{-100,
          200},{-42,200}}, color={255,0,255}));
  connect(ash7.y, or13.u3) annotation (Line(points={{-438,820},{-430,820},{-430,
          192},{-42,192}}, color={255,0,255}));
  connect(or10.y, or14.u1) annotation (Line(points={{-18,320},{0,320},{0,288},{18,
          288}}, color={255,0,255}));
  connect(or11.y, or14.u2)
    annotation (Line(points={{-18,280},{18,280}}, color={255,0,255}));
  connect(or12.y, or14.u3) annotation (Line(points={{-18,240},{0,240},{0,272},{18,
          272}}, color={255,0,255}));
  connect(or14.y, or15.u1) annotation (Line(points={{42,280},{60,280},{60,188},{
          78,188}}, color={255,0,255}));
  connect(or13.y, or15.u2) annotation (Line(points={{-18,200},{40,200},{40,180},
          {78,180}}, color={255,0,255}));
  connect(ash8.y, or15.u3) annotation (Line(points={{-358,820},{-350,820},{-350,
          172},{78,172}}, color={255,0,255}));
  connect(or15.y, and3.u1)
    annotation (Line(points={{102,180},{178,180}}, color={255,0,255}));
  connect(difDryBul.y, and3.u2) annotation (Line(points={{-498,740},{140,740},{140,
          172},{178,172}}, color={255,0,255}));
  connect(and3.y, swi3.u2)
    annotation (Line(points={{202,180},{298,180}}, color={255,0,255}));
  connect(TRet, swi3.u1) annotation (Line(points={{-560,340},{240,340},{240,188},
          {298,188}}, color={0,0,127}));
  connect(ash1A.y, or8.u3) annotation (Line(points={{-438,1000},{-400,1000},{-400,
          112},{-42,112}}, color={255,0,255}));
  connect(ash2A.y, or8.u2) annotation (Line(points={{-278,1000},{-240,1000},{-240,
          120},{-42,120}}, color={255,0,255}));
  connect(ash3A.y, or8.u1) annotation (Line(points={{-118,1000},{-80,1000},{-80,
          128},{-42,128}}, color={255,0,255}));
  connect(or8.y, or9.u2) annotation (Line(points={{-18,120},{0,120},{0,132},{18,
          132}}, color={255,0,255}));
  connect(ash4A.y, or9.u1) annotation (Line(points={{-278,940},{-250,940},{-250,
          140},{18,140}}, color={255,0,255}));
  connect(or9.y, and4.u1)
    annotation (Line(points={{42,140},{178,140}}, color={255,0,255}));
  connect(difDryBul.y, and4.u2) annotation (Line(points={{-498,740},{140,740},{140,
          132},{178,132}}, color={255,0,255}));
  connect(and4.y, not1.u)
    annotation (Line(points={{202,140},{298,140}}, color={255,0,255}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{322,140},{338,140}}, color={255,0,255}));
  connect(swi1.y, swi.u3) annotation (Line(points={{402,440},{410,440},{410,572},
          {418,572}}, color={0,0,127}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{322,180},{330,180},{330,352},
          {338,352}}, color={0,0,127}));
  connect(con3.y, swi3.u3) annotation (Line(points={{202,100},{280,100},{280,172},
          {298,172}}, color={0,0,127}));
  connect(con4.y, swi4.u1) annotation (Line(points={{202,40},{220,40},{220,28},{
          378,28}}, color={0,0,127}));
  connect(fixEntFixDryBul.y, swi4.u2) annotation (Line(points={{-498,700},{130,700},
          {130,20},{378,20}}, color={255,0,255}));
  connect(hRet, swi4.u3) annotation (Line(points={{-560,0},{220,0},{220,12},{378,
          12}}, color={0,0,127}));
  connect(swi.y, TCut)
    annotation (Line(points={{442,580},{560,580}}, color={0,0,127}));
  connect(swi4.y, hCut)
    annotation (Line(points={{402,20},{560,20}}, color={0,0,127}));
  connect(titZon1.y, or16.u1) annotation (Line(points={{-438,-60},{-400,-60},{-400,
          -292},{-42,-292}}, color={255,0,255}));
  connect(titZon3.y, or16.u2) annotation (Line(points={{-278,-60},{-240,-60},{-240,
          -300},{-42,-300}}, color={255,0,255}));
  connect(titZon5.y, or16.u3) annotation (Line(points={{-438,-120},{-410,-120},{
          -410,-308},{-42,-308}}, color={255,0,255}));
  connect(titZon11.y, or17.u1) annotation (Line(points={{-278,-180},{-260,-180},
          {-260,-332},{-42,-332}}, color={255,0,255}));
  connect(titZon12.y, or17.u2) annotation (Line(points={{-198,-180},{-180,-180},
          {-180,-340},{-42,-340}}, color={255,0,255}));
  connect(titZon13.y, or17.u3) annotation (Line(points={{-438,-240},{-430,-240},
          {-430,-348},{-42,-348}}, color={255,0,255}));
  connect(titZon14.y, or18.u1) annotation (Line(points={{-358,-240},{-350,-240},
          {-350,-372},{-42,-372}}, color={255,0,255}));
  connect(titZon15.y, or18.u2) annotation (Line(points={{-278,-240},{-270,-240},
          {-270,-380},{-42,-380}}, color={255,0,255}));
  connect(titZon16.y, or18.u3) annotation (Line(points={{-198,-240},{-190,-240},
          {-190,-388},{-42,-388}}, color={255,0,255}));
  connect(or16.y, or20.u1) annotation (Line(points={{-18,-300},{0,-300},{0,-332},
          {18,-332}}, color={255,0,255}));
  connect(or17.y, or20.u2)
    annotation (Line(points={{-18,-340},{18,-340}}, color={255,0,255}));
  connect(or18.y, or20.u3) annotation (Line(points={{-18,-380},{0,-380},{0,-348},
          {18,-348}}, color={255,0,255}));
  connect(or20.y, and5.u1)
    annotation (Line(points={{42,-340},{178,-340}}, color={255,0,255}));
  connect(fixDryBul.y, and5.u2) annotation (Line(points={{-498,780},{150,780},{150,
          -348},{178,-348}}, color={255,0,255}));
  connect(and5.y, swi5.u2)
    annotation (Line(points={{202,-340},{418,-340}}, color={255,0,255}));
  connect(con5.y, swi5.u1) annotation (Line(points={{202,-300},{220,-300},{220,-332},
          {418,-332}}, color={0,0,127}));
  connect(titZon2.y, or19.u1) annotation (Line(points={{-358,-60},{-320,-60},{-320,
          -422},{-42,-422}}, color={255,0,255}));
  connect(titZon4.y, or19.u2) annotation (Line(points={{-198,-60},{-160,-60},{-160,
          -430},{-42,-430}}, color={255,0,255}));
  connect(titZon10.y, or19.u3) annotation (Line(points={{-358,-180},{-340,-180},
          {-340,-438},{-42,-438}}, color={255,0,255}));
  connect(or19.y, and6.u1)
    annotation (Line(points={{-18,-430},{178,-430}}, color={255,0,255}));
  connect(fixDryBul.y, and6.u2) annotation (Line(points={{-498,780},{150,780},{150,
          -438},{178,-438}}, color={255,0,255}));
  connect(and6.y, swi6.u2)
    annotation (Line(points={{202,-430},{378,-430}}, color={255,0,255}));
  connect(con6.y, swi6.u1) annotation (Line(points={{202,-390},{220,-390},{220,-422},
          {378,-422}}, color={0,0,127}));
  connect(swi6.y, swi5.u3) annotation (Line(points={{402,-430},{410,-430},{410,-348},
          {418,-348}}, color={0,0,127}));
  connect(and7.y, swi7.u2)
    annotation (Line(points={{202,-510},{338,-510}}, color={255,0,255}));
  connect(con7.y, swi7.u1) annotation (Line(points={{202,-470},{220,-470},{220,-502},
          {338,-502}}, color={0,0,127}));
  connect(titZon6.y, or21.u1) annotation (Line(points={{-358,-120},{-330,-120},{
          -330,-502},{-42,-502}}, color={255,0,255}));
  connect(or21.y, and7.u1)
    annotation (Line(points={{-18,-510},{178,-510}}, color={255,0,255}));
  connect(titZon8.y, or21.u2) annotation (Line(points={{-198,-120},{-170,-120},{
          -170,-510},{-42,-510}}, color={255,0,255}));
  connect(titZon9.y, or21.u3) annotation (Line(points={{-438,-180},{-420,-180},{
          -420,-518},{-42,-518}}, color={255,0,255}));
  connect(fixDryBul.y, and7.u2) annotation (Line(points={{-498,780},{150,780},{150,
          -518},{178,-518}}, color={255,0,255}));
  connect(swi7.y, swi6.u3) annotation (Line(points={{362,-510},{370,-510},{370,-438},
          {378,-438}}, color={0,0,127}));
  connect(con8.y, swi8.u1) annotation (Line(points={{202,-550},{220,-550},{220,-582},
          {298,-582}}, color={0,0,127}));
  connect(fixDryBul.y, swi8.u2) annotation (Line(points={{-498,780},{150,780},{150,
          -590},{298,-590}}, color={255,0,255}));
  connect(or20.y, and8.u1) annotation (Line(points={{42,-340},{60,-340},{60,-660},
          {178,-660}}, color={255,0,255}));
  connect(difDryBul.y, and8.u2) annotation (Line(points={{-498,740},{140,740},{140,
          -668},{178,-668}}, color={255,0,255}));
  connect(and8.y, swi9.u2)
    annotation (Line(points={{202,-660},{418,-660}}, color={255,0,255}));
  connect(TRet, swi9.u1) annotation (Line(points={{-560,340},{240,340},{240,-652},
          {418,-652}}, color={0,0,127}));
  connect(swi10.y, swi9.u3) annotation (Line(points={{402,-740},{410,-740},{410,
          -668},{418,-668}}, color={0,0,127}));
  connect(or19.y, and9.u1) annotation (Line(points={{-18,-430},{50,-430},{50,-740},
          {178,-740}}, color={255,0,255}));
  connect(difDryBul.y, and9.u2) annotation (Line(points={{-498,740},{140,740},{140,
          -748},{178,-748}}, color={255,0,255}));
  connect(TRet, addPar.u) annotation (Line(points={{-560,340},{240,340},{240,-700},
          {258,-700}}, color={0,0,127}));
  connect(and9.y, swi10.u2)
    annotation (Line(points={{202,-740},{378,-740}}, color={255,0,255}));
  connect(addPar.y, swi10.u1) annotation (Line(points={{282,-700},{300,-700},{300,
          -732},{378,-732}}, color={0,0,127}));
  connect(and10.y, swi11.u2)
    annotation (Line(points={{202,-820},{338,-820}}, color={255,0,255}));
  connect(swi11.y, swi10.u3) annotation (Line(points={{362,-820},{370,-820},{370,
          -748},{378,-748}}, color={0,0,127}));
  connect(or21.y, and10.u1) annotation (Line(points={{-18,-510},{40,-510},{40,-820},
          {178,-820}}, color={255,0,255}));
  connect(difDryBul.y, and10.u2) annotation (Line(points={{-498,740},{140,740},{
          140,-828},{178,-828}}, color={255,0,255}));
  connect(addPar1.y, swi11.u1) annotation (Line(points={{282,-780},{300,-780},{300,
          -812},{338,-812}}, color={0,0,127}));
  connect(TRet, addPar1.u) annotation (Line(points={{-560,340},{240,340},{240,-780},
          {258,-780}}, color={0,0,127}));
  connect(addPar2.y, swi12.u1) annotation (Line(points={{282,-860},{290,-860},{290,
          -892},{298,-892}}, color={0,0,127}));
  connect(swi12.y, swi11.u3) annotation (Line(points={{322,-900},{330,-900},{330,
          -828},{338,-828}}, color={0,0,127}));
  connect(difDryBul.y, swi12.u2) annotation (Line(points={{-498,740},{140,740},{
          140,-900},{298,-900}}, color={255,0,255}));
  connect(TRet, addPar2.u) annotation (Line(points={{-560,340},{240,340},{240,-860},
          {258,-860}}, color={0,0,127}));
  connect(swi8.y, swi7.u3) annotation (Line(points={{322,-590},{330,-590},{330,-518},
          {338,-518}}, color={0,0,127}));
  connect(swi9.y, swi8.u3) annotation (Line(points={{442,-660},{460,-660},{460,-620},
          {280,-620},{280,-598},{298,-598}}, color={0,0,127}));
  connect(con9.y, swi12.u3) annotation (Line(points={{202,-940},{280,-940},{280,
          -908},{298,-908}}, color={0,0,127}));
  connect(fixEntFixDryBul.y, booToRea.u) annotation (Line(points={{-498,700},{130,
          700},{130,-1000},{178,-1000}}, color={255,0,255}));
  connect(swi5.y, TCut) annotation (Line(points={{442,-340},{460,-340},{460,580},
          {560,580}}, color={0,0,127}));
  connect(booToRea.y, hCut) annotation (Line(points={{202,-1000},{480,-1000},{480,
          20},{560,20}}, color={0,0,127}));
  connect(titEngSta.y, and11.u2) annotation (Line(points={{-438,-720},{-420,-720},
          {-420,-688},{-382,-688}}, color={255,0,255}));
  connect(difEntFixDryBul.y, and11.u1) annotation (Line(points={{-498,660},{-480,
          660},{-480,-680},{-382,-680}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{-298,-680},{-282,-680}}, color={255,0,255}));
  connect(and11.y, not2.u)
    annotation (Line(points={{-358,-680},{-322,-680}}, color={255,0,255}));
  connect(con10.y, swi4.u3) annotation (Line(points={{-18,30},{20,30},{20,12},{378,
          12}}, color={0,0,127}));
  connect(con11.y, swi3.u1) annotation (Line(points={{-18,380},{20,380},{20,340},
          {240,340},{240,188},{298,188}}, color={0,0,127}));
  connect(con11.y, swi9.u1) annotation (Line(points={{-18,380},{20,380},{20,340},
          {240,340},{240,-652},{418,-652}}, color={0,0,127}));
  connect(con11.y, addPar.u) annotation (Line(points={{-18,380},{20,380},{20,340},
          {240,340},{240,-700},{258,-700}}, color={0,0,127}));
  connect(con11.y, addPar1.u) annotation (Line(points={{-18,380},{20,380},{20,340},
          {240,340},{240,-780},{258,-780}}, color={0,0,127}));
  connect(con11.y, addPar2.u) annotation (Line(points={{-18,380},{20,380},{20,340},
          {240,340},{240,-860},{258,-860}}, color={0,0,127}));
annotation (defaultComponentName="ecoHigLim",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,68},{-72,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TRet",
          visible=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb),
        Text(
          extent={{-100,-52},{-72,-68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="hRet",
          visible=(eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
               and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)),
        Text(
          extent={{70,-50},{98,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="hCut",
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
               or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)),
        Text(
          extent={{70,70},{98,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCut")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-540,-1020},{540,1020}})),
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
<td rowspan=\"3\">Fixed dry bulb</td><td>1b, 2b, 3b, 3c, 4b, 4c, 5b, 5c, 6b, 7, 8</td><td>outdoor air temperature is higher than 24 &deg;C (<code>TCut=24&deg;C</code>)</td>
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
<td>outdoor air temperature is higher than 24 &deg;C and the outdoor air enthalpy is higher than the return air enthalpy (<code>TCut=24&deg;C</code> and <code>hCut=hRet</code>)</td>
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
</table>
<br/>
</html>",revisions="<html>
<ul>
<li>
March 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirEconomizerHighLimits;
