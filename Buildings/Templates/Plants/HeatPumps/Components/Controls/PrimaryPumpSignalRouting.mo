within Buildings.Templates.Plants.HeatPumps.Components.Controls;
block PrimaryPumpSignalRouting
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typ
    "Type of primary pumps"
    annotation(Evaluate=true);
  parameter Buildings.Templates.Components.Types.PumpArrangement typArr
    "Type of primary pump arrangement"
    annotation(Evaluate=true);
  parameter Integer nPum
    "Number of primary pumps"
    annotation(Evaluate=true);
  parameter Integer nHp
    "Number of heat pumps"
    annotation(Evaluate=true);
  parameter Integer nPhp
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hdr_actual[nPum]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Pump status – Headered pumps"
    annotation(Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1DedHp_actual[nHp]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and nHp > 0
    "Pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1DedPhp_actual[nPhp]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and nPhp > 0
    "Pump status – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Hdr[nPum]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Pump start command – Headered pumps"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1DedHp[nHp]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and nHp > 0
    "Pump start command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1DedPhp[nPhp]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and nPhp > 0
    "Pump start command – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yHdr
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Headered
      and typ ==
        Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Pump speed command – Headered pumps"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yDedHp[nHp]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and typ ==
        Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      and nHp > 0
    "Pump speed command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yDedPhp[nPhp]
    if typArr == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and typ ==
        Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      and nPhp > 0
    "Pump speed command – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    "Main connector for all pumps"
    annotation(Placement(transformation(extent={{-20,80},{20,120}}),
      iconTransformation(extent={{-20,80},{20,120}})));
equation
  connect(y1Hdr, bus.y1)
    annotation(Line(points={{-120,80},{0,80},{0,100}},
      color={255,0,255}));
  connect(yHdr, bus.y)
    annotation (Line(points={{-120,60},{0,60},{0,100}}, color={0,0,127}));
  connect(y1Hdr_actual, bus.y1_actual)
    annotation(Line(points={{120,60},{0,60},{0,100}},
      color={255,0,255}));
  connect(y1DedHp, bus.y1[1:nHp])
    annotation(Line(points={{-120,0},{0,0},{0,100}},
      color={255,0,255}));
  connect(yDedHp, bus.y[1:nHp])
    annotation(Line(points={{-120,-20},{0,-20},{0,100}},
      color={0,0,127}));
  connect(y1DedHp_actual, bus.y1_actual[1:nHp])
    annotation(Line(points={{120,0},{0,0},{0,100}},
      color={255,0,255}));
  connect(y1DedPhp, bus.y1[nPum - nPhp + 1:nPum])
    annotation(Line(points={{-120,-60},{0,-60},{0,100}},
      color={255,0,255}));
  connect(yDedPhp, bus.y[nPum - nPhp + 1:nPum])
    annotation(Line(points={{-120,-80},{0,-80},{0,100}},
      color={0,0,127}));
  connect(y1DedPhp_actual, bus.y1_actual[nPum - nPhp + 1:nPum])
    annotation(Line(points={{120,-60},{0,-60},{0,100}},
      color={255,0,255}));

annotation(defaultComponentName="rouPumPri",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,-100},{100,100}},
      lineColor={0,0,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end PrimaryPumpSignalRouting;
