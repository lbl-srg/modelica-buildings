within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block PartialController "Interface class for plant controller"

  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Integer nPumChiWat(final min=1, start=1)
    "Number of CHW pumps operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal
    "Design (minimum) CHW supply temperature"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Integer nPumHeaWat(final min=1, start=1)
    "Number of HW pumps operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal
    "Design (maximum) HW supply temperature"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  parameter Integer nHeaPum(final min=1, start=1)
    "Number of heat pumps operating at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatCon(final min=1, start=1)
    "Number of CW pumps serving condenser barrels at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatEva(final min=1, start=1)
    "Number of CW pumps serving evaporator barrels at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);

  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);
  parameter Integer nPumConWatCoo(final min=1, start=1)
    "Number of CW pumps serving cooling towers at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);

  parameter Modelica.Units.SI.HeatFlowRate QChiWatChi_flow_nominal
    "Cooling design heat flow rate of cooling-only chillers (all units)"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaPum_flow_nominal
    "Heating design heat flow rate of heat pumps (all units)"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Real PLRStaTra(final unit="1", final min=0, final max=1) = 0.85
    "Part load ratio triggering stage transition";
  parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal_approx
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units), approximate for scaling"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    QChiWatChi_flow_nominal+QChiWatCasCoo_flow_nominal
    "Plant cooling design heat flow rate (all units)";
  parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of the fluid";

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "CHW design mass flow rate (all units)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CHW differential pressure setpoint"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal
    "HW design mass flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) HW differential pressure setpoint"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mConWatCon_flow_nominal(
    final min=0)
    "Design total CW mass flow rate through condenser barrels (all units)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.MassFlowRate mConWatEva_flow_nominal(
    final min=0)
    "Design total CW mass flow rate through evaporator barrels (all units)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal
    "Chiller CHW design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal
    "Chiller CW design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_nominal
    "HRC CHW design mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_min
    "HRC CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChiHea_flow_nominal
    "HRC CW design mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatChiHea_flow_min
    "Chiller HW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  parameter Modelica.Units.SI.PressureDifference dpEvaChi_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller evaporator design pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpValEvaChi_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller evaporator isolation valve design pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChiHea_nominal(
    final min=0,
    displayUnit="Pa")
    "Design chiller evaporator  pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpValEvaChiHea_nominal(
    final min=0,
    displayUnit="Pa")
    "HRC evaporator isolation valve design pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  parameter Modelica.Units.SI.PressureDifference dpConWatConSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CW condenser loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpConWatEvaSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CW evaporator loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));

  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Real fraUslTan(final unit="1", final min=0, final max=1)
    "Useless fraction of TES"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nTTan(final min=0)=0
    "Number of tank temperature points"
    annotation (Dialog(group="CW loop, TES tank and heat pumps", connectorSizing=true),HideResult=true);
  parameter Real ratFraChaTanLim[5](each final unit="1/h")=
    {-0.3, -0.2, -0.15, -0.10, -0.08}
    "Rate of change of tank charge fraction (over 10, 30, 120, 240, and 360') that triggers Charge Assist (<0)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));

  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_min
    "Minimum chiller lift at minimum load"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_nominal
    "Design chiller lift"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  parameter Modelica.Units.SI.TemperatureDifference dTHexCoo_nominal
    "Design heat exchanger approach"
    annotation (Dialog(group="Cooling tower loop"));

  parameter Modelica.Units.SI.Time riseTimePum=30
    "Pump rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (
      Dialog(
      tab="Dynamics",
      group="Filtered speed"));
  parameter Modelica.Units.SI.Time riseTimeVal=120
    "Pump rise time of the filter (time to reach 99.6 % of the opening)"
    annotation (
      Dialog(
      tab="Dynamics",
      group="Filtered opening"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-300,420},{-260,460}}),
        iconTransformation(extent={{-260,340},{-220,380}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-300,380},{-260,420}}),
        iconTransformation(extent={{-260,320},{-220,360}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC") "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-300,340},{-260,380}}),
        iconTransformation(extent={{-260,300},{-220,340}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC")
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-300,320},{-260,360}}),
        iconTransformation(extent={{-260,280},{-220,320}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChi[nChi]
    "Cooling-only chiller evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,320}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,270})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChi[nChi](
    each final unit="1")
    "Cooling-only chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,300}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,250})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,340}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,290})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat[nPumChiWat]
    "CHW pump Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,260}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,230})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWat(
    final unit="1")
    "CHW pump speed signal"
    annotation (Placement(
        transformation(extent={{260,220},{300,260}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,210})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChiHea[nChiHea](
    each final unit="1") "HRC evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HRC On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,160})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HRC cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,140})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](
    each final unit="1") "HRC condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,60})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat[nPumHeaWat]
    "HW pump Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWat(
    final unit="1")
    "HW pump speed signal"
    annotation (Placement(
        transformation(extent={{260,-60},{300,-20}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-40})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(
    final unit="1")
    "CHW minimum flow bypass valve control signal"
    annotation (Placement(
        transformation(extent={{260,180},{300,220}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,190})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(
    final unit="1") "HW minimum flow bypass valve control signal"
    annotation (Placement(
        transformation(extent={{260,-100},{300,-60}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-60})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon[nPumConWatCon]
    "CW pump serving condenser barrels Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-90})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatCon(
    final unit="1")
    "CW pump serving condenser barrels Speed command"
    annotation (Placement(
        transformation(extent={{260,-160},{300,-120}},rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-110})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva[nPumConWatEva]
    "CW pump serving evaporator barrels Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-130})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatEva(
    final unit="1")
    "CW pump serving evaporator barrels Speed command"
    annotation (Placement(
        transformation(extent={{260,-200},{300,-160}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-150})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaPum[nHeaPum]
    "Heat pump On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-180})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaPumSet(
    final unit="K", displayUnit="degC") "Heat pump supply temperature setpoint"
    annotation (Placement(
        transformation(extent={{260,-260},{300,-220}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-200})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValBypTan(
    final unit="1") "TES tank bypass valve commanded position"
    annotation (Placement(
        transformation(extent={{260,-300},{300,-260}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-320})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo[nCoo]
    "Cooling tower Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-360}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-270})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1") "Cooling tower fan speed command"
                                      annotation (Placement(transformation(
          extent={{260,-400},{300,-360}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-290})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCoo[
    nPumConWatCoo] "Cooling tower pump Start command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-230})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiHeaSet[nChiHea](
    each final unit="K", each displayUnit="degC")
    "HRC supply temperature setpoint"
    annotation (Placement(transformation(extent={{260,80},{300,120}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,100})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaCooChiHea[nChiHea]
    "HRC direct heat recovery switchover command: true for direct HR, false for cascading"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(final unit="Pa",
      final min=0) "CHW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-300,300},{-260,340}}),
        iconTransformation(extent={{-260,260},{-220,300}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatSet(final unit="Pa",
      final min=0)
    "HW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
        iconTransformation(extent={{-260,240},{-220,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(final unit="Pa")
    "CHW differential pressure (from local dp sensor)"
    annotation (Placement(transformation(extent={{-300,-360},{-260,-320}}),
        iconTransformation(extent={{-260,-320},{-220,-280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWat(final unit="Pa")
    "HW differential pressure (from local dp sensor)"
    annotation (Placement(transformation(extent={{-300,-380},{-260,-340}}),
        iconTransformation(extent={{-260,-340},{-220,-300}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mChiWatPri_flow(final unit=
        "kg/s") "Primary CHW mass flow rate"
    annotation (Placement(
        transformation(extent={{-300,-200},{-260,-160}}),
                                                       iconTransformation(
          extent={{-260,-200},{-220,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHeaWatPri_flow(final unit=
        "kg/s") "Primary HW mass flow rate" annotation (Placement(
        transformation(extent={{-300,-220},{-260,-180}}),
                                                      iconTransformation(extent={{-260,
            -220},{-220,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpConWatCon(final unit="Pa")
    "CW condenser loop differential pressure" annotation (Placement(
        transformation(extent={{-300,-400},{-260,-360}}), iconTransformation(
          extent={{-260,-360},{-220,-320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpConWatEva(final unit="Pa")
    "CW evaporator loop differential pressure" annotation (Placement(
        transformation(extent={{-300,-420},{-260,-380}}), iconTransformation(
          extent={{-260,-380},{-220,-340}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatCon_flow(final unit=
        "kg/s") "CW condenser loop mass flow rate" annotation (Placement(
        transformation(extent={{-300,-260},{-260,-220}}),
                                                     iconTransformation(extent={{-260,
            -240},{-220,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatEva_flow(final unit=
        "kg/s") "CW evaporator loop mass flow rate" annotation (Placement(
        transformation(extent={{-300,-280},{-260,-240}}),
                                                      iconTransformation(extent={{-260,
            -260},{-220,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(final unit="K",
      displayUnit="degC") "CHW supply temperature " annotation (
      Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-260,220},{-220,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(final unit="K",
      displayUnit="degC") "Primary CHW return temperature " annotation (
      Placement(transformation(extent={{-300,220},{-260,260}}),
        iconTransformation(extent={{-260,200},{-220,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(final unit="K",
      displayUnit="degC") "Primary HW return temperature " annotation (
      Placement(transformation(extent={{-300,60},{-260,100}}),
        iconTransformation(extent={{-260,40},{-220,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[nTTan](
    each final unit="K",
    each  displayUnit="degC")
    "TES tank temperature" annotation (Placement(
        transformation(extent={{-300,40},{-260,80}}),     iconTransformation(
          extent={{-260,20},{-220,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatHexCoo_flow(final unit
      ="kg/s") "CW mass flow rate through secondary (plant) side of HX"
    annotation (Placement(transformation(extent={{-300,-300},{-260,-260}}),
        iconTransformation(extent={{-260,-280},{-220,-240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatOutTan_flow(final unit
      ="kg/s")
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(extent={{-300,-320},{-260,-280}}),
        iconTransformation(extent={{-260,-300},{-220,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChi_flow[nChi](
    each final unit="kg/s")
    "Chiller evaporator barrel mass flow rate" annotation (Placement(
        transformation(extent={{-300,-120},{-260,-80}}),
                                                       iconTransformation(
          extent={{-260,-120},{-220,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChi_flow[nChi](
    each final unit="kg/s")
    "Chiller condenser barrel mass flow rate" annotation (Placement(
        transformation(extent={{-300,-140},{-260,-100}}),
                                                      iconTransformation(extent={{-260,
            -140},{-220,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC evaporator barrel mass flow rate" annotation (
      Placement(transformation(extent={{-300,-160},{-260,-120}}),
        iconTransformation(extent={{-260,-160},{-220,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC condenser barrel mass flow rate" annotation (
      Placement(transformation(extent={{-300,-180},{-260,-140}}),
        iconTransformation(extent={{-260,-180},{-220,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaSwiHea[nChiHea](
    each final unit="1")
    "HRC evaporator switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConSwiChiHea[nChiHea](
    each final unit="1")
    "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvgChiHea[nChiHea](
    each final unit="K", each displayUnit="degC")
    "HRC evaporator barrel leaving temperature"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
        iconTransformation(extent={{-260,100},{-220,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSup(
    final unit="K",
    displayUnit="degC") "HW supply temperature " annotation (Placement(
        transformation(extent={{-300,80},{-260,120}}),iconTransformation(extent={{-260,60},
            {-220,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatCoo
    "Cooling tower pump speed command" annotation (Placement(transformation(
          extent={{260,-360},{300,-320}}), iconTransformation(extent={{220,-270},
            {260,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiEnt(final unit=
        "K", displayUnit="degC") "Chiller and HRC entering CW temperature"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-260,0},{-220,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiLvg(final unit=
        "K", displayUnit="degC") "Chiller and HRC leaving CW temperature"
    annotation (Placement(transformation(extent={{-300,0},{-260,40}}),
        iconTransformation(extent={{-260,-20},{-220,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatCooSup(final unit="K",
      displayUnit="degC") "Cooling tower loop CW supply temperature"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
        iconTransformation(extent={{-260,-40},{-220,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatCooRet(final unit="K",
      displayUnit="degC") "Cooling tower loop CW return temperature"
    annotation (Placement(transformation(extent={{-300,-40},{-260,0}}),
        iconTransformation(extent={{-260,-60},{-220,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatHexCooEnt(final unit="K",
      displayUnit="degC")        "HX entering CW temperature" annotation (
      Placement(transformation(extent={{-300,-60},{-260,-20}}),
        iconTransformation(extent={{-260,-80},{-220,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatHexCooLvg(final unit="K",
      displayUnit="degC")        "HX leaving CW temperature" annotation (
      Placement(transformation(extent={{-300,-80},{-260,-40}}),
        iconTransformation(extent={{-260,-100},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEntChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC condenser barrel entering temperature" annotation (Placement(
        transformation(extent={{-300,160},{-260,200}}), iconTransformation(
          extent={{-260,140},{-220,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvgChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC condenser barrel leaving temperature" annotation (Placement(
        transformation(extent={{-300,140},{-260,180}}), iconTransformation(
          extent={{-260,120},{-220,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEvaEnt(final unit="K",
      displayUnit="degC") "HRC evaporator entering CW temperature " annotation (
     Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-260,160},{-220,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConWatEvaMix
    "HRC evaporator CW mixing valve commanded position" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConRet(final unit
      ="K", displayUnit="degC") "Condenser loop CW return temperature"
    annotation (Placement(transformation(extent={{-300,200},{-260,240}}),
        iconTransformation(extent={{-260,180},{-220,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvgChi[nChi](each final
      unit="K", each displayUnit="degC")
    "Chiller condenser barrel leaving temperature" annotation (Placement(
        transformation(extent={{-300,100},{-260,140}}), iconTransformation(
          extent={{-260,80},{-220,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConWatByp(final unit="1")
    "CW chiller bypass valve control signal" annotation (Placement(
        transformation(extent={{260,-440},{300,-400}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-360})));
  annotation (Diagram(coordinateSystem(extent={{-260,-460},{260,460}})), Icon(
        coordinateSystem(extent={{-220,-380},{220,380}}),
        graphics={                      Text(
        extent={{-150,430},{150,390}},
        textString="%name",
        textColor={0,0,255}),
        Rectangle(
          extent={{-220,-380},{220,380}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This block serves as an interface class for the plant controller.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialController;
