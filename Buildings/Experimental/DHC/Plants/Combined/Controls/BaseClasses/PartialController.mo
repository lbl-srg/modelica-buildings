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

  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Integer nPumHeaWat(final min=1, start=1)
    "Number of HW pumps operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);

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
  parameter Modelica.Units.SI.Temperature TTanSet[3] = {25, 15, 5}
    "Tank temperature setpoints in decreasing order: 2 cycles with 1 common setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));

  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);
  parameter Integer nPumConWatCoo(final min=1, start=1)
    "Number of CW pumps serving cooling towers at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);


  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValEvaChi[nChi]
    "Cooling-only chiller condenser isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,260}),iconTransformation(
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
        origin={280,240}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,250})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,280}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,290})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat[nPumChiWat]
    "CHW pump Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,210})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWat(
    final unit="1")
    "CHW pump speed signal"
    annotation (Placement(
        transformation(extent={{260,180},{300,220}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,190})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValEvaChiHea[nChiHea]
    "HR chiller condenser isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HR chiller in heating mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,100})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](
    each final unit="1")
    "HR chiller condenser isolation valve commanded position"
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
        origin={280,20}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWat(
    final unit="1")
    "HW pump speed signal"
    annotation (Placement(
        transformation(extent={{260,-20},{300,20}},  rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,0})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(
    final unit="1")
    "CHW minimum flow bypass valve control signal"
    annotation (Placement(
        transformation(extent={{260,140},{300,180}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,160})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(
    final unit="1")
    "HW minimum flow bypass valve control signal"
    annotation (Placement(
        transformation(extent={{260,-60},{300,-20}},  rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-40})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon[nPumConWatCon]
    "CW pump serving condenser barrels Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatCon(
    final unit="1")
    "CW pump serving condenser barrels Speed command"
    annotation (Placement(
        transformation(extent={{260,-120},{300,-80}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-100})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva[nPumConWatEva]
    "CW pump serving evaporator barrels Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatEva(
    final unit="1")
    "CW pump serving evaporator barrels Speed command"
    annotation (Placement(
        transformation(extent={{260,-160},{300,-120}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaPum[nHeaPum]
    "Heat pump On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-170})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaPumSet(
    final unit="K", displayUnit="degC")
    "Heat pump supply temperature setpoint"
    annotation (Placement(
        transformation(extent={{260,-220},{300,-180}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-190})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValBypTan(
    final unit="1") "TES tank bypass valve"
    annotation (Placement(
        transformation(extent={{260,-260},{300,-220}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-220})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo[nCoo]
    "Cooling tower Start command" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-280}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-250})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(final unit="1")
    "Cooling tower fan speed command" annotation (Placement(transformation(
          extent={{260,-320},{300,-280}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-270})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCoo[
    nPumConWatCoo] "Cooling tower pump Start command" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={280,-320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-290})));
  annotation (Diagram(coordinateSystem(extent={{-260,-360},{260,360}})), Icon(
        coordinateSystem(extent={{-220,-300},{220,300}}),
        graphics={                      Text(
        extent={{-150,350},{150,310}},
        textString="%name",
        textColor={0,0,255})}));
end PartialController;
