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
  parameter Integer nPumConWatCon(final min=1, start=1)
    "Number of CW pumps serving condenser barrels at design conditions"
    annotation (Dialog(group="CW loop and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatEva(final min=1, start=1)
    "Number of CW pumps serving evaporator barrels at design conditions"
    annotation (Dialog(group="CW loop and heat pumps"),
      Evaluate=true);
  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValEvaChi[nChi]
    "Cooling-only chiller condenser isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,220}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,290})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChi[nChi]
    "Cooling-only chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,200}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,270})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,240}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,310})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat[nPumChiWat]
    "CHW pump Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,240})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValEvaChiHea[nChiHea]
    "HR chiller condenser isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,180})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HR chiller in heating mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,160})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea]
    "HR chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,120})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat[nPumHeaWat]
    "HW pump Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,0}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,90})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp
    "CHW minimum flow bypass valve control signal"
    annotation (Placement(
        transformation(extent={{220,120},{260,160}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,210})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp
    "HW minimum flow bypass valve control signal"
    annotation (Placement(
        transformation(extent={{220,-60},{260,-20}},  rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,60})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput valChiCooCon
    "Control signal for directional valve for direct heat recovery from CHW to HW"
    annotation (Placement(transformation(extent={{220,-220},{260,-180}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvtValChiCooCon
    "Convert DO to AO"
    annotation (Placement(transformation(extent={{190,-210},{210,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon[nPumConWatCon]
    "CW pump serving condenser barrels Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,30})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatCon
    "CW pump serving condenser barrels Speed command"
    annotation (Placement(
        transformation(extent={{220,-120},{260,-80}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,10})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva[nPumConWatEva]
    "CW pump serving evaporator barrels Start command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,-10})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumConWatEva
    "CW pump serving evaporator barrels Speed command"
    annotation (Placement(
        transformation(extent={{220,-160},{260,-120}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,-30})));
equation
  connect(cvtValChiCooCon.y, valChiCooCon)
    annotation (Line(points={{212,-200},{240,-200}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-220,-260},{220,260}})), Icon(
        coordinateSystem(extent={{-200,-280},{200,320}}),
        graphics={                      Text(
        extent={{-150,370},{150,330}},
        textString="%name",
        textColor={0,0,255})}));
end PartialController;
