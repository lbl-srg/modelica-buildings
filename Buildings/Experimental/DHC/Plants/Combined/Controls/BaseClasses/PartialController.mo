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
  parameter Integer nChiCoo(final min=1, start=1)
    "Number of units that can be dispatched to cooling"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Integer nPumHeaWat(final min=1, start=1)
    "Number of HW pumps operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
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
        origin={220,278})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChi[nChi]
    "Cooling-only chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,200}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,258})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Cooling-only chiller On/Off command" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,240}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,298})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat[nPumChiWat]
    "CHW pump Start command (DO)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,228})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValEvaChiHea[nChiHea]
    "HR chiller condenser isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,108})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,148})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HR chiller in heating mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,128})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea]
    "HR chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,88})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat[nPumHeaWat]
    "HW pump Start command (DO)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp
    "CHW minimum flow bypass valve control signal (AO)" annotation (Placement(
        transformation(extent={{220,120},{260,160}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,178})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp
    "HW minimum flow bypass valve control signal (AO)" annotation (Placement(
        transformation(extent={{220,-120},{260,-80}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={220,12})));

  annotation (Diagram(coordinateSystem(extent={{-220,-260},{220,260}})), Icon(
        coordinateSystem(extent={{-200,-280},{200,320}}),
        graphics={                      Text(
        extent={{-150,370},{150,330}},
        textString="%name",
        textColor={0,0,255}),
        Rectangle(
          extent={{-200,-280},{200,320}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialController;
